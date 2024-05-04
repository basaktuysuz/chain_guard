// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:realm/realm.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String fullname,email,password,role,url;
  int id,phoneNo;


  UserModel(
      {required this.fullname,
      required this.email,
        required this.password,
        required  this.role,
        required  this.url,
        required  this.id,
        required  this.phoneNo});


  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    fullname: json["fullname"],
    email: json["email"],
    password: json["password"],
    role: json["role"],
    id: json["id_number"],
    phoneNo: json["phoneNo"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "email": email,
        "password": password,
        "role": role,
        "id_number": id,
        "phoneNo": phoneNo,
        "url": url,
      };
}


