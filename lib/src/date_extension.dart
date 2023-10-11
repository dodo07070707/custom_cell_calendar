/// Initial index for pageView of calendar
///
/// User can get back to maximum 100 year and 1 month.
const int initialPageIndex = 1200;

/// Extension to show accurate date in the calendar by current index of pageView
extension DateExtension on int {
  int get fromInitialIndex {
    return this - initialPageIndex;
  }

  Duration get daysDuration {
    return Duration(days: (this == 7) ? 0 : -this);
  }

  /// MonthName for the number of month
  String get monthName {
    final monthNameList = [
      "1월",
      "2월",
      "3월",
      "4월",
      "5월",
      "6월",
      "7월",
      "8월",
      "9월",
      "10월",
      "11월",
      "12월"
    ];
    return monthNameList[this - 1];
  }

  /// Return year and month to be shown by the currentIndex of pageView
  DateTime get visibleDateTime {
    final monthDif = this - initialPageIndex;
    final visibleYear = _visibleYear(monthDif);
    final visibleMonth = _visibleMonth(monthDif);
    return DateTime(visibleYear, visibleMonth);
  }

  int _visibleYear(int monthDif) {
    final currentMonth = DateTime.now().month;
    final currentYear = DateTime.now().year;
    final visibleMonth = currentMonth + monthDif;

    /// When visible month is in the current year or future year
    if (visibleMonth > 0) {
      return currentYear + (visibleMonth ~/ 12);

      /// When visible month is in the past year
    } else {
      return currentYear + ((visibleMonth ~/ 12) - 1);
    }
  }

  int _visibleMonth(int monthDif) {
    final initialMonth = DateTime.now().month;
    final currentMonth = initialMonth + monthDif;

    /// When visible month is in the current year or future year
    if (currentMonth > 0) {
      return currentMonth % 12;

      /// When visible month is in the past year
    } else {
      return 12 - (-currentMonth % 12);
    }
  }
}
