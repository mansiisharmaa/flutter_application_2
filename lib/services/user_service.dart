import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class UserService extends ChangeNotifier {
  static final UserService instance = UserService._internal();
  UserService._internal();

  final List<UserModel> _directory = [
    UserModel(
      id: 'sarah_johnson',
      name: 'Sarah Johnson',
      email: 'sarah@example.com',
      isOnline: true,
      avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=Sarah',
    ),
    UserModel(
      id: 'john_smith',
      name: 'John Smith',
      email: 'john@example.com',
      isOnline: false,
      avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=John',
    ),
    UserModel(
      id: 'alex_wilson',
      name: 'Alex Wilson',
      email: 'alex@example.com',
      isOnline: true,
      avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=Alex',
    ),
  ];

  List<UserModel> getUsers(String currentUserId) {
    return _directory.where((u) => u.id != currentUserId).toList();
  }

  List<UserModel> searchUsers(String query, String currentUserId) {
    return _directory
        .where((u) =>
            u.id != currentUserId &&
            u.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void toggleBlockUser(String userId) {
    final user = _directory.firstWhere((u) => u.id == userId);
    user.isBlocked = !user.isBlocked;
    notifyListeners();
  }
}