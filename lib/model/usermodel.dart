class LoginModel {
  final int id;
  final String username;
  final String email;
  // Add other fields as necessary

  LoginModel({
    required this.id,
    required this.username,
    required this.email,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      // Map other fields as necessary
    );
  }
}
