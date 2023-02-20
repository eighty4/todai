enum BlockCount {
  four,
  five;
}

extension ToIntegerFn on BlockCount {
  int toInt() {
    switch (this) {
      case BlockCount.four:
        return 4;
      case BlockCount.five:
        return 5;
    }
  }
}
