import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum BackgroundMode { dark, light }

class TodaiBackground extends ChangeNotifier {
  BackgroundMode mode = BackgroundMode.light;

  static TodaiBackground of(BuildContext context, {bool listen = false}) {
    return Provider.of<TodaiBackground>(context, listen: listen);
  }

  void dark() {
    update(BackgroundMode.dark);
  }

  void light() {
    update(BackgroundMode.light);
  }

  void update(BackgroundMode mode) {
    if (this.mode != mode) {
      this.mode = mode;
      notifyListeners();
    }
  }
}

class TodaiAppBackground extends StatelessWidget {
  final Widget child;

  const TodaiAppBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mode = TodaiBackground.of(context, listen: true).mode;
    return _AdaptiveBackground(mode: mode, child: child);
  }
}

class _AdaptiveBackground extends StatefulWidget {
  final Widget child;
  final BackgroundMode mode;

  const _AdaptiveBackground({required this.child, required this.mode});

  @override
  State<_AdaptiveBackground> createState() => _AdaptiveBackgroundState();
}

class _AdaptiveBackgroundState extends State<_AdaptiveBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _color;
  Brightness brightness = Brightness.dark;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _color = ColorTween(begin: Colors.white, end: Colors.black).animate(
      CurvedAnimation(
        curve: const Interval(.4, .6, curve: Curves.ease),
        parent: _controller,
      ),
    );
  }

  @override
  void didUpdateWidget(_AdaptiveBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mode == BackgroundMode.dark) {
      _controller.animateTo(1);
      brightness = Brightness.light;
    } else {
      _controller.animateTo(0);
      brightness = Brightness.dark;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: brightness,
    ));
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(color: _color.value, child: child);
        },
        child: widget.child,
      ),
    );
  }
}
