import 'package:flutter/material.dart';

void main() {
  runApp(const TodaiApp());
}

class TodaiApp extends StatelessWidget {
  const TodaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todai',
      theme: ThemeData(),
      home: const TodaiScreen(),
    );
  }
}

class TodaiScreen extends StatelessWidget {
  const TodaiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * .2),
        child: Column(
          children: const [
            DayHeader(),
            TodoList(),
            TodoInput(),
          ],
        ),
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
