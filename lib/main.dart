import 'package:flutter/material.dart';
import 'package:todo_list/screens/todo_list.dart';

void main() {
  runApp(TodoList());
}
class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: TodoListPage(),
    );
  }
}