/// Static timetable simulation for Cairo Metro and LRT.
///
/// Uses published first/last train times and typical headways to estimate
/// minutes until the next train — without requiring real-time data.
class TimetableService {
  TimetableService._();
  static final TimetableService instance = TimetableService._();

  // ── Schedule definitions ──────────────────────────────────────────────────
  // Minutes from midnight for first/last train; headways in minutes.

  static const _schedules = <String, _Schedule>{
    'L1': _Schedule(
      firstMinute: 5 * 60,       // 05:00
      lastMinute: 24 * 60,       // 00:00 next day
      peakHeadway: 3,
      offPeakHeadway: 7,
    ),
    'L2': _Schedule(
      firstMinute: 5 * 60 + 30,  // 05:30
      lastMinute: 23 * 60 + 30,  // 23:30
      peakHeadway: 4,
      offPeakHeadway: 8,
    ),
    'L3': _Schedule(
      firstMinute: 5 * 60,       // 05:00
      lastMinute: 23 * 60,       // 23:00
      peakHeadway: 4,
      offPeakHeadway: 8,
    ),
    'L3A': _Schedule(
      firstMinute: 5 * 60,
      lastMinute: 23 * 60,
      peakHeadway: 6,
      offPeakHeadway: 12,
    ),
    'L3B': _Schedule(
      firstMinute: 5 * 60,
      lastMinute: 23 * 60,
      peakHeadway: 6,
      offPeakHeadway: 12,
    ),
    'LRT_MAIN': _Schedule(
      firstMinute: 6 * 60,       // 06:00
      lastMinute: 22 * 60,       // 22:00
      peakHeadway: 10,
      offPeakHeadway: 20,
    ),
    'LRT_BRANCH_NAC': _Schedule(
      firstMinute: 6 * 60,
      lastMinute: 22 * 60,
      peakHeadway: 15,
      offPeakHeadway: 25,
    ),
    'LRT_BRANCH_10TH': _Schedule(
      firstMinute: 6 * 60,
      lastMinute: 22 * 60,
      peakHeadway: 15,
      offPeakHeadway: 25,
    ),
  };

  // ── Cairo peak hours ──────────────────────────────────────────────────────
  // Morning rush: 07:00–09:30
  // Afternoon: 14:00–16:00
  // Evening rush: 17:30–20:00

  static bool _isPeak(int minuteOfDay) =>
      (minuteOfDay >= 7 * 60 && minuteOfDay <= 9 * 60 + 30) ||
      (minuteOfDay >= 14 * 60 && minuteOfDay <= 16 * 60) ||
      (minuteOfDay >= 17 * 60 + 30 && minuteOfDay <= 20 * 60);

  // ── Public API ────────────────────────────────────────────────────────────

  /// Minutes until the next train on [lineId] at [now].
  ///
  /// Returns `null` when the line is outside service hours.
  int? nextTrainMinutes(String lineId, {DateTime? now}) {
    final schedule = _schedules[lineId];
    if (schedule == null) return null;

    final dt = now ?? DateTime.now();
    final minuteOfDay = dt.hour * 60 + dt.minute;

    // Outside service hours?
    if (minuteOfDay < schedule.firstMinute ||
        minuteOfDay >= schedule.lastMinute) {
      return null;
    }

    final headway =
        _isPeak(minuteOfDay) ? schedule.peakHeadway : schedule.offPeakHeadway;

    // How many minutes since last train departed?
    final minutesSinceFirst = minuteOfDay - schedule.firstMinute;
    final minutesSinceLast = minutesSinceFirst % headway;
    final minutesUntilNext = headway - minutesSinceLast;

    // Return 0 if the train is "now" (within 30 seconds)
    return minutesUntilNext >= headway ? 0 : minutesUntilNext;
  }

  /// Human-readable headway description for [lineId] at [now].
  ///
  /// e.g. "Every 3–4 min" or "Every 10–15 min"
  String headwayLabel(String lineId, {DateTime? now}) {
    final schedule = _schedules[lineId];
    if (schedule == null) return '';
    final dt = now ?? DateTime.now();
    final m = dt.hour * 60 + dt.minute;
    if (_isPeak(m)) {
      return 'Every ~${schedule.peakHeadway} min';
    }
    return 'Every ~${schedule.offPeakHeadway} min';
  }

  /// Whether [lineId] is currently in service.
  bool isInService(String lineId, {DateTime? now}) {
    final schedule = _schedules[lineId];
    if (schedule == null) return false;
    final dt = now ?? DateTime.now();
    final m = dt.hour * 60 + dt.minute;
    return m >= schedule.firstMinute && m < schedule.lastMinute;
  }

  // ── Line ID normalizer ────────────────────────────────────────────────────

  /// Map a RouteService lineId to the timetable key (same as _schedules keys).
  static String normalizeLineId(String lineId) => lineId;
}

// ── Internal data class ───────────────────────────────────────────────────────

class _Schedule {
  final int firstMinute;   // minutes from midnight
  final int lastMinute;    // minutes from midnight (use 24*60 for midnight+)
  final int peakHeadway;   // minutes between trains during peak
  final int offPeakHeadway;

  const _Schedule({
    required this.firstMinute,
    required this.lastMinute,
    required this.peakHeadway,
    required this.offPeakHeadway,
  });
}
