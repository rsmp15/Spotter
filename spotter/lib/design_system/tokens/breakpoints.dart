/// Responsive breakpoints for Spotter layouts.
class DSBreakpoints {
  DSBreakpoints._();

  static const double compact = 0;
  static const double medium = 600;
  static const double expanded = 840;
  static const double large = 1200;
  static const double foldableHingeSafeMin = 720;

  static bool isCompact(double width) => width < medium;
  static bool isMedium(double width) => width >= medium && width < expanded;
  static bool isExpanded(double width) => width >= expanded;
  static bool isLarge(double width) => width >= large;
}

