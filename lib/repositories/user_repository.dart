import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserRepository {
  List<User> _users = [];

  Future<void> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('users');
    if (usersJson != null) {
      final List<dynamic> decodedUsers = json.decode(usersJson);
      _users = decodedUsers.map((e) => User.fromMap(e)).toList();
    }
  }

  Future<void> saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = json.encode(_users.map((e) => e.toMap()).toList());
    await prefs.setString('users', usersJson);
  }

  List<User> get allUsers => _users;

  User? getUserById(String id) {
    return _users.firstWhere((user) => user.id == id, orElse: () => User());
  }

  void addUser(User user) {
    _users.add(user);
    saveUsers();
  }

  void updateUser(User user) {
    int index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
      saveUsers();
    }
  }

  void deleteUser(String id) {
    _users.removeWhere((user) => user.id == id);
    saveUsers();
  }
}
