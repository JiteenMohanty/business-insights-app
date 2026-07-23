/// Business profile returned by `GET /business`.
class Business {
  const Business({
    required this.name,
    required this.category,
    required this.address,
    required this.phone,
    required this.rating,
    required this.totalReviews,
  });

  final String name;
  final String category;
  final String address;
  final String phone;
  final double rating;
  final int totalReviews;

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      address: json['address'] as String? ?? '',
      phone: json['phone']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
    );
  }
}
