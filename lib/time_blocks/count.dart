enum TimeBlockCount {
  four,
  five;
}

extension ToIntegerFn on TimeBlockCount {
  int toInt() {
    switch (this) {
      case TimeBlockCount.four:
        return 4;
      case TimeBlockCount.five:
        return 5;
    }
  }
}
