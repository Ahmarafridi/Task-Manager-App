
class TodosModel {
  final int id;
  final String todo;
  final bool completed;
  final int userId;

  TodosModel({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  factory TodosModel.fromJson(Map<String, dynamic> json) {
    return TodosModel(
      id: json['id'],
      todo: json['todo'],
      completed: json['completed'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todo': todo,
      'completed': completed,
      'userId': userId,
    };
  }
}
