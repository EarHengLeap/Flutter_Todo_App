import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      isEdit = true;
      final todo = widget.todo!;
      _titleController.text = todo['title'];
      _descriptionController.text = todo['description'];
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      );

  AppBar _buildAppBar() => AppBar(
        title: Text(
          isEdit ? 'Edit Todo' : 'Add Todo',
        ),
        centerTitle: true,
        elevation: 0,
      );

  Widget _buildBody() => ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Title',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              hintText: 'Description',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () => isEdit ? updateData() :  submitData(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                  isEdit ? 'Update' : 'Submit',
                ),
            ),
          ),
        ],
      );

   Future<void> updateData() async {
    //Get the data from form
    final todo = widget.todo;
    if (todo == null) {
      print('You cannot call updated without todo data');
      return;
    }

    final id  = todo['_id'];
    final isCompleted = todo['is_completed'];
    final title = _titleController.text;
    final description = _descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": isCompleted ,
    };

    //! Submit updated data to the server
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

       //! Show success or fail message based on status
    if (response.statusCode == 200) {
      showSucessMessage('Updation Success');
    } else {
      showErrorMessage('Upation Failed');
    }
  }

  Future<void> submitData() async {
    //! Get the data from "Form"
    final title = _titleController.text;
    final description = _descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    //! Submit data to the server
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    //! Show success or fail message based on status
    if (response.statusCode == 201) {
      _titleController.text = '';
      _descriptionController.text = '';
      showSucessMessage('Ceation Success');
    } else {
      showErrorMessage('Creation Failed');
    }
  }

  void showSucessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
