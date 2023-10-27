import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  Map? todo;
  AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            isEdit ? 'Edit Todo' : 'Add Todo',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description...'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isEdit ? handleUpdateData : handleSubmitData,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                isEdit ? 'Update' : 'Create',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> handleUpdateData() async {
    // Get the data from form

    final todo = widget.todo;
    if (todo == null) {
      print('You can not call update without todo data!');
      return;
    }

    final id = todo['_id'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    // submit update data to the server

    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    // show success or fail message based on status
    if (response.statusCode == 200) {
      print('\n Updation Success! \n');
      ShowSuccessMessage('Updation Success!');
    } else {
      print('\n Updation Failed! \n');
      ShowErrorMessage('Updation Failed!');
      print(response.body);
    }
  }

  Future<void> handleSubmitData() async {
    // Get the data from form

    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    // submit data to the server

    final url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    // show success or fail message based on status
    if (response.statusCode == 201) {
      print('\n Creation Success! \n');
      titleController.text = "";
      descriptionController.text = "";
      ShowSuccessMessage('Creation Success!');
    } else {
      print('\n Creation Failed! \n');
      ShowErrorMessage('Creation Failed!');
      print(response.body);
    }
  }

// ShowSuccessMessage
  void ShowSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

// ShowErrorMessage
  void ShowErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
