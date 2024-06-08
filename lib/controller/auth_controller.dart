import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:task_maids/model/model.dart';

import '../model/usermodel.dart';
import '../Screen/todoview.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var user = Rxn<UserModel>();

  Future<void> login(String username, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        user.value = LoginModel.fromJson(responseData) as UserModel?;
        Get.snackbar('Success', 'Login successful');
        Get.off(() => TodoViewScreen()); // Navigate to TodoViewScreen
      } else {
        final errorData = jsonDecode(response.body);
        errorMessage.value = errorData['message'] ?? 'Login failed';
        Get.snackbar('Error', errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String username, String password, String email) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/users/add'),
        body: jsonEncode({
          'username': username,
          'password': password,
          'email': email,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      print('Register response status: ${response.statusCode}');
      print('Register response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        user.value = UserModel.fromJson(responseData);
        Get.snackbar('Success', 'Registration successful');
        Get.off(() => TodoViewScreen()); // Navigate to TodoViewScreen
      } else {
        if (response.headers['content-type']?.contains('application/json') == true) {
          final errorData = jsonDecode(response.body);
          errorMessage.value = errorData['message'] ?? 'Registration failed';
        } else {
          errorMessage.value = 'Unexpected response format';
        }
        Get.snackbar('Error', errorMessage.value);
        print(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      Get.snackbar('Error', errorMessage.value);
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
