import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:iwallet_case_study/src/domain/photo.dart';
import 'package:iwallet_case_study/src/domain/user.dart';

final userProvider = StateNotifierProvider<UserNotifier, List<User>>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<List<User>> {
  UserNotifier() : super([]) {
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if (response.statusCode == 200) {
      List<User> users = (json.decode(response.body) as List)
          .map((data) => User.fromJson(data))
          .toList();

      for (var user in users) {
        await _fetchPhotoForUser(user);
      }

      state = users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> _fetchPhotoForUser(User user) async {
    if (user.id == null) return;

    final response =
        await http.get(Uri.parse('https://picsum.photos/id/${user.id}/info'));

    if (response.statusCode == 200) {
      user.photo = Photo.fromJson(json.decode(response.body));
    }
  }
}
