/// Cairo Metro fare calculation (2024 rates).
/// Single source of truth — replaces the duplicate logic in routecontroller.dart.
abstract final class FareCalculator {
  // Fare brackets: max stations (inclusive) → EGP price
  static const List<(int, int)> _brackets = [
    (9, 8),
    (16, 10),
    (23, 15),
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
