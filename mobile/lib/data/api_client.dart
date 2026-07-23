import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import 'api_exception.dart';
import 'models/business.dart';
import 'models/insights.dart';
import 'models/review.dart';

/// Single service that wraps the four backend endpoints.
///
/// Every method returns typed data on success or throws an [ApiException] with
/// a user-friendly message on failure (bad credentials, network error, server
/// error, or a malformed response).
class ApiClient {
  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? AppConfig.baseUrl;

  final http.Client _client;
  final String _baseUrl;

  static const Duration _timeout = Duration(seconds: 15);
  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
  };

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  /// Decodes the shared `{ success, data, message }` envelope. Throws an
  /// [ApiException] when `success` is false (surfacing the backend's message)
  /// or when the body isn't the expected shape.
  Map<String, dynamic> _decodeEnvelope(http.Response response) {
    Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw const ApiException('Unexpected response from the server.');
    }

    if (body['success'] != true) {
      final message = body['message'] as String? ?? 'Request failed.';
      throw ApiException(message);
    }
    return body;
  }

  /// Runs [request] and normalizes transport-level failures into friendly
  /// [ApiException]s (timeouts, no connection, etc.). Existing [ApiException]s
  /// pass through unchanged.
  Future<T> _guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException(
        'The request timed out. Check your connection and the API URL.',
      );
    } catch (_) {
      throw const ApiException(
        'Could not reach the server. Make sure the backend is running and the '
        'API URL is correct.',
      );
    }
  }

  /// `POST /login` — returns the logged-in user's email on success.
  Future<String> login(String email, String password) {
    return _guard(() async {
      final response = await _client
          .post(
            _uri('/login'),
            headers: _jsonHeaders,
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(_timeout);

      final body = _decodeEnvelope(response);
      final data = body['data'] as Map<String, dynamic>?;
      return data?['email'] as String? ?? email;
    });
  }

  /// `GET /business` — the single business profile.
  Future<Business> getBusiness() {
    return _guard(() async {
      final response = await _client.get(_uri('/business')).timeout(_timeout);
      final body = _decodeEnvelope(response);
      return Business.fromJson(body['data'] as Map<String, dynamic>);
    });
  }

  /// `GET /insights` — the single insights snapshot.
  Future<Insights> getInsights() {
    return _guard(() async {
      final response = await _client.get(_uri('/insights')).timeout(_timeout);
      final body = _decodeEnvelope(response);
      return Insights.fromJson(body['data'] as Map<String, dynamic>);
    });
  }

  /// `GET /reviews` — the list of reviews (may be empty).
  Future<List<Review>> getReviews() {
    return _guard(() async {
      final response = await _client.get(_uri('/reviews')).timeout(_timeout);
      final body = _decodeEnvelope(response);
      final data = body['data'] as List<dynamic>? ?? const [];
      return data
          .map((item) => Review.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }
}
