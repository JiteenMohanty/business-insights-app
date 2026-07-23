/// Engagement insights returned by `GET /insights`.
class Insights {
  const Insights({
    required this.profileViews,
    required this.searchViews,
    required this.websiteClicks,
    required this.phoneCalls,
    required this.directionRequests,
  });

  final int profileViews;
  final int searchViews;
  final int websiteClicks;
  final int phoneCalls;
  final int directionRequests;

  factory Insights.fromJson(Map<String, dynamic> json) {
    int read(String key) => (json[key] as num?)?.toInt() ?? 0;
    return Insights(
      profileViews: read('profile_views'),
      searchViews: read('search_views'),
      websiteClicks: read('website_clicks'),
      phoneCalls: read('phone_calls'),
      directionRequests: read('direction_requests'),
    );
  }

  /// The five metric values in display order. Kept in sync with [fullLabels]
  /// and [shortLabels] so cards and the chart never drift apart.
  List<int> get orderedValues => [
        profileViews,
        searchViews,
        websiteClicks,
        phoneCalls,
        directionRequests,
      ];

  /// Full labels for the metric cards.
  static const List<String> fullLabels = [
    'Profile Views',
    'Search Views',
    'Website Clicks',
    'Phone Calls',
    'Direction Requests',
  ];

  /// Short labels for the chart's x-axis (limited horizontal space).
  static const List<String> shortLabels = [
    'Profile',
    'Search',
    'Clicks',
    'Calls',
    'Directions',
  ];
}
