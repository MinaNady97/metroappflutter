/// Cairo Metro fare calculation (2024 rates).
/// Single source of truth — replaces the duplicate logic in routecontroller.dart.
abstract final class FareCalculator {
  // Fare brackets: max hops (inclusive) → EGP price.
  // Stations visited = hops + 1; brackets: 1–9 stations (≤8 hops) → 8 EGP,
  // 10–16 stations (≤15 hops) → 10 EGP, 17–23 stations (≤22 hops) → 15 EGP, 24+ → 20 EGP.
  static const List<(int, int)> _brackets = [
    (8, 8),
    (15, 10),
    (22, 15),
  ];
  static const int _maxFare = 20;

  /// Base fare based on number of station hops (not counting the boarding station).
  static int baseFare(int stationHops) {
    for (final (maxHops, price) in _brackets) {
      if (stationHops <= maxHops) return price;
    }
    return _maxFare;
  }

  /// Returns the fare in EGP for a journey with [stationHops] hops.
  /// Transfers within the Cairo Metro network do not add extra cost —
  /// a single ticket covers the entire journey.
  static int calculate(int stationHops) => baseFare(stationHops);

  /// Applies a user-type discount and returns the discounted fare.
  static int applyDiscount(int fare, UserType userType) {
    return switch (userType) {
      UserType.student  => (fare * 0.5).round(),
      UserType.senior   => (fare * 0.5).round(),
      UserType.disabled => 0,
      UserType.regular  => fare,
    };
  }

  /// Formats fare as a localised string.
  static String format(int fare) => '$fare EGP';
}

enum UserType { regular, student, senior, disabled }
