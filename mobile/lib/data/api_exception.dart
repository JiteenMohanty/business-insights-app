/// A user-friendly error surfaced by [ApiClient].
///
/// Its [message] is safe to show directly in the UI (it's either the backend's
/// `message` field or a friendly network/parse fallback).
class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
