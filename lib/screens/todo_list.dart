import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/screens/add_page.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/utils/snackbar_helper.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    handleFechData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Todo List'),
        ),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: handleFechData,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'No Todo Item',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == 'edit') {
                          // Open Edit page
                          navigateToEditPage(item);
                        } else if (value == 'delete') {
                          // Delete and remove the item
                          handleDeleteDataById(id);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: Text('Edit'),
                            value: 'edit',
                          ),
                          PopupMenuItem(
                            child: Text('Delete'),
                            value: 'delete',
                          ),
                        ];
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        hoverColor: Colors.red,
        onPressed: navigateToAddPage,
        label: const Text(
          'Add Todo',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    handleFechData();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
      handleFechData();
    });
  }

  Future<void> handleDeleteDataById(String id) async {
    final isSuccess = await TodoService.handleDeleteDataById(id);
    if (isSuccess) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
      ShowSuccessMessage('Delete Success!');
    } else {
      ShowErrorMessage(context, message: 'Delete Failed!');
    }
  }

  Future<void> handleFechData() async {
    final response = await TodoService.handleFechData();

    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      ShowErrorMessage(context, message: "Something went wrong!");
    }

    setState(() {
      isLoading = false;
    });
  }

// ShowSuccessMessage
  void ShowSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
