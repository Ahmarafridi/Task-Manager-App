import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_maids/controller/todos_controller.dart';
import 'package:task_maids/model/todomodel.dart';

class TodoViewScreen extends StatefulWidget {
  @override
  _TodoViewScreenState createState() => _TodoViewScreenState();
}

class _TodoViewScreenState extends State<TodoViewScreen> {
  final Controller controller = Get.put(Controller());

  String userName = '';
  String role = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        actions: [
        
            IconButton(
              onPressed: () {
                _showAddDialog(context, controller);
              },
              icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerList();
        } else if (controller.hasError.value) {
          return Center(
            child: Text(
                'Error fetching todos: ${controller.errorMessage.value}'),
          );
        } else {
          return ListView.builder(
            itemCount: controller.todos.length,
            itemBuilder: (context, index) {
              final todo = controller.todos[index];
              return _buildTodoItem(todo);
            },
          );
        }
      }),
    );
  }

  Widget _buildTodoItem(TodosModel todo) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.orange, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              Text(
                'Todo: ${todo.todo}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              Text('Completed: ${todo.completed}'),
              const SizedBox(height: 4.0),
              Text('User ID: ${todo.userId}'),
              const SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showEditDialog(context, todo, controller);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      controller.delete(todo.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context, Controller controller) {
    final TextEditingController todoController = TextEditingController();
    final TextEditingController completedController = TextEditingController();
    final TextEditingController userIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Todo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: todoController,
                  decoration: InputDecoration(labelText: 'Todo'),
                ),
                TextField(
                  controller: completedController,
                  decoration: InputDecoration(labelText: 'Completed'),
                ),
                TextField(
                  controller: userIdController,
                  decoration: InputDecoration(labelText: 'User ID'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final todoData = {
                  'todo': todoController.text,
                  'completed': completedController.text.toLowerCase() == 'true',
                  'userId': int.parse(userIdController.text),
                };
                controller.add(todoData);
                Get.back();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, TodosModel todo, Controller controller) {
    final TextEditingController todoController = TextEditingController(text: todo.todo);
    final TextEditingController completedController = TextEditingController(text: todo.completed.toString());
    final TextEditingController userIdController = TextEditingController(text: todo.userId.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: todoController,
                decoration: InputDecoration(labelText: 'Todo'),
              ),
              TextField(
                controller: completedController,
                decoration: InputDecoration(labelText: 'Completed'),
              ),
              TextField(
                controller: userIdController,
                decoration: InputDecoration(labelText: 'User ID'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final todoData = {
                  'todo': todoController.text,
                  'completed': completedController.text.toLowerCase() == 'true',
                  'userId': int.parse(userIdController.text),
                };
                controller.updatetodo(todo.id, todoData);
                Get.back();
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 5, // Adjust the number of shimmer items as needed
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.orange, Colors.green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100.0,
                    height: 50.0,
                    color: Colors.white, // Shimmer effect for image
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 100.0,
                    height: 50.0,
                    color: Colors.white, // Shimmer effect for text
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
