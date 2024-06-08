import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../config/api.dart';
import '../model/todomodel.dart';

class Controller extends GetxController {
  RxList<TodosModel> todos = <TodosModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    fetch();
    super.onInit();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final response = await http.get(Uri.parse(Config.fatching));
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey('todos')) { 
          final List<dynamic> jsonData = responseData['todos'];
          todos.assignAll(jsonData.map((json) => TodosModel.fromJson(json)).toList());
        } else {
          throw Exception('Invalid response structure: missing "todos" key');
        }
      } else {
        throw Exception('Failed to load todos: ${response.statusCode}');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> add(Map<String, dynamic> todosData) async {
    try {
      final response = await http.post(
        Uri.parse(Config.baseurl),
        body: jsonEncode(todosData),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        Get.showSnackbar(GetBar(
          message: 'Todos added successfully',
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
          isDismissible: true,
          onTap: (_) => fetch(),
        ));
      } else {
        throw Exception('Failed to add todos: ${response.statusCode}');
      }
    } catch (e) {
     
      Get.snackbar('Error', 'Failed to add todos: $e'); 
       print(e);
    }
  }

  Future<void> updatetodo(int todosId, Map<String, dynamic> todosData) async {
    try {
      final response = await http.put(
        Uri.parse('${Config.baseurl}/$todosId'),
        body: jsonEncode(todosData),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Todos updated successfully'); // Show success message
        fetch(); // Refresh the data after updating
      } else {
        throw Exception('Failed to update todos: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
      Get.snackbar('Error', 'Failed to update todos: $e'); // Show error message
    }
  }

  Future<void> delete(int? todosId) async {
    try {
      if (todosId == null) {
        throw Exception('Todos id is null');
      }

      final response = await http.delete(
        Uri.parse('${Config.baseurl}/$todosId'),
      );
      if (response.statusCode == 200) {
        todos.removeWhere((c) => c.id == todosId);
        Get.snackbar('Success', 'Todos deleted successfully'); // Show success message
        fetch(); // Refresh the data after deleting
      } else {
        throw Exception('Failed to delete todos');
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar('Error', 'Failed to delete todos: $e'); // Show error message
    }
  }
}
