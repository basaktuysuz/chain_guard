import 'dart:convert';
import 'package:chain_guard/src/common_widgets/toast.dart';
import 'package:chain_guard/src/view/screen/driver_homepage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart'; // Navigator'ı kullanabilmek için gerekli

import 'package:chain_guard/src/view/screen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
//http://localhost:3000/

  //"https://chainguard-api.onrender.com/authenticate"
  final url = Uri.parse( "https://chainguard-api.onrender.com/authenticate"); // login rotası
  final url2 = Uri.parse("https://chainguard-api.onrender.com/adduser"); // addUser rotası (örnek olarak)
Dio dio = new Dio();
  Future<void> login(BuildContext context, String email, String password, String collectionName) async {
    try {
      final response = await http.post(
        url,
        body: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200) {

        if (collectionName == 'Driver') {
          // Redirect to driver home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DriverHomePage()),
          );
        } else if  (collectionName == 'User'){
          // if users enters go to user home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
      }} else {
        // Hatalı cevap
        showToast(message: 'Failed to login');
        throw Exception('Failed to login');
      }
    } catch (e) {
      // Hata durumunda
      print(e.toString());
    }
  }

  Future<void> addUser(
      String email,
      String password,
      String fullname,
      String phoneNo,
      String role,
      String id,

      ) async {
    try {
      final response = await http.post(
        url2, // url2 doğru bir şekilde belirlenmiş olmalıdır
        body: {
          "email": email,
          "password": password,
          "fullname": fullname,
          "phoneNo": phoneNo,
          "role": role,
          "userId": id,

        },
      );

      if (response.statusCode == 200) {
        // Başarılı cevap
        showToast(message: "user succesfully created");
        return json.decode(response.body);
      } else {
        // Hatalı cevap
        throw Exception('Failed to add user');
      }
    } catch (e) {
      // Hata durumunda
      print(e.toString());
    }
  }


  Future<void> getInfo(token) async {
    try {
      // JWT tokeni
      String token = "buraya_jwt_tokeni_gelir";

      // API endpointi
      String url = "http://10.0.2.2:3000/getusers";

      // HTTP isteği oluştur
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token", // JWT tokeni Bearer belirteciyle eklenir
        },
      );

      // Yanıtın durumunu kontrol et
      if (response.statusCode == 200) {
        // Başarılı cevap, JSON yanıtını işle
        var responseData = json.decode(response.body);
        print(responseData['msg']); // Örneğin, sunucudan gelen 'msg' değerini yazdır
      } else {
        // Hatalı cevap
        throw Exception('Failed to get info');
      }
    } catch (e) {
      // Hata durumunda
      print(e.toString());
    }
  }
  
  
  
  getinfo(token) async{
    dio.options.headers['Authorization']='Bearer $token';
    return await dio.get("http://localhost:3000/getinfo");
  }

}

