import 'package:neovision_flutter/service/models/role.dart';

class Client {
  int id;
  String login;
  String email;
  String avatar;
  Role role;

  Client({
    required this.id,
    required this.login,
    required this.email,
    required this.avatar,
    required this.role,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json["id"],
        login: json["login"],
        email: json["email"],
        role: roleFromString(json["role"]),
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": login,
        "email": email,
        "role": role,
        "avatar": avatar,
      };
}
