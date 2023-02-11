enum Day { today, tomorrow }

extension DayFns on Day {
  String label() {
    switch (this) {
      case Day.today:
        return 'Today';
      case Day.tomorrow:
        return 'Tomorrow';
    }
  }

  Day other() {
    return this == Day.tomorrow ? Day.today : Day.tomorrow;
  }
}
