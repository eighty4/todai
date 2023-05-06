import 'dart:async';

class TimeBlockEvent {
  static const initialState = TimeBlockEvent(display: true);

  const TimeBlockEvent({this.editing, required this.display});

  final int? editing;
  final bool display;
}

class TheTimeBlockController {
  final StreamController<TimeBlockEvent> _streamController =
      StreamController.broadcast();

  Stream<TimeBlockEvent> get stream => _streamController.stream;

  void focusEditing(int index) {
    _streamController.add(TimeBlockEvent(display: true, editing: index));
  }

  void blurEditing() {
    _streamController.add(TimeBlockEvent.initialState);
  }

  Future close() {
    return _streamController.close();
  }
}
