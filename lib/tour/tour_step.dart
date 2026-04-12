import 'package:flutter/widgets.dart';

/// Describes a single coach-mark step in the guided tour.
class TourStep {
  /// Key used to look up this step's title and description in [TourL10n].
  final String stepId;

  /// The widget to highlight with a spotlight cutout.
  /// [null] = centred welcome modal with no spotlight.
  final GlobalKey? targetKey;

  /// Extra pixels inflated around the widget bounds before the spotlight is drawn.
  final double padding;

  /// When set, the spotlight height is capped at this value (measured from the
  /// top of the widget). Useful for tall list items where spotlighting the full
  /// height would leave no room for the tooltip below.
  final double? maxSpotHeight;

  /// Force the tooltip to appear below the spotlight regardless of available
  /// space. Combined with [maxSpotHeight] this ensures a consistent placement
  /// for items near the bottom of a scrollable list.
  final bool forceBelow;

  /// When true, [TourOverlayWidget] will call [Scrollable.ensureVisible] on
  /// [targetKey]'s context before computing the spotlight rect — ensuring the
  /// widget is in the viewport before we measure it.
  final bool scrollToTarget;

  const TourStep({
    required this.stepId,
    this.targetKey,
    this.padding = 14.0,
    this.maxSpotHeight,
    this.forceBelow = false,
    this.scrollToTarget = false,
  });

  bool get isWelcome => targetKey == null;
}
