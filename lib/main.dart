import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const TodaiApp());
}

class TodaiApp extends StatelessWidget {
  const TodaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(backgroundColor: Colors.white),
      home: const TodaiScreen(),
    );
  }
}

class TodaiScreen extends StatelessWidget {
  const TodaiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      body: Stack(
        children: const [
          Positioned(top: 0, bottom: 0, left: 0, child: DayView()),
          Boomerang(),
        ],
      ),
    );
  }
}

class Boomerang extends StatelessWidget {
  final double height = 70;

  const Boomerang({super.key});

  @override
  Widget build(BuildContext context) {
    final windowHeight = MediaQuery.of(context).size.height;
    return Positioned(
        top: windowHeight / 2 - height / 2,
        right: 10,
        child: SvgPicture.asset("assets/boomerang.svg",
            height: height,
            color: Colors.black,
            fit: BoxFit.contain));
  }
}

class DayView extends StatelessWidget {
  const DayView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      child: Column(
        children: const [
          DayHeader(),
          TodoList(),
          TodoInput(),
        ],
      ),
    );
  }
}

class DayHeader extends StatelessWidget {
  const DayHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(left: 20, bottom: 10),
            child: Text("Today", style: TextStyle(fontSize: 46)),
          ),
          Container(
            constraints: const BoxConstraints.expand(height: 1),
            color: Colors.black,
          )
        ],
      ),
    );
  }
}

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Spacer();
  }
}

class TodoInput extends StatelessWidget {
  const TodoInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, bottom: 20),
      child: Container(
          constraints: const BoxConstraints.expand(height: 70),
          color: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: const [
              Text('Add a todo',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ],
          )),
    );
  }
}
