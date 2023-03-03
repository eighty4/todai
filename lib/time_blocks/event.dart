class TimeBlockEvent {
  static const initialState = TimeBlockEvent(display: true);

  const TimeBlockEvent({this.editing, required this.display});

  final int? editing;
  final bool display;
}
