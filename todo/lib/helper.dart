import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/pages/home.dart';
import 'package:todo/pages/login.dart';

class helperPage {
  static Future<void> signUp(fullname, phone, email, password) async {
    final response = await http.post(
      Uri.parse('https://ali-izadi.ir/ToDo/public/api/register'),
      body: {
        'name': fullname,
        'phone': phone,
        'email': email,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      var token = 'Bearer ' + jsonDecode(response.body)['token'];
      saveToken(token);
    }
  }

  static Future<void> logIn(email, password) async {
    final response = await http.post(
      Uri.parse('https://ali-izadi.ir/ToDo/public/api/login'),
      body: {
        'email': email,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      var token = 'Bearer ' + jsonDecode(response.body)['token'];
      saveToken(token);
    }
  }

  static Future<bool> isAuthenticated() async {
    SharedPreferences sharepref = await SharedPreferences.getInstance();
    String? token = sharepref.getString('token');
    return token != null;
  }

  static Future<void> saveToken(token) async {
    final saveToken = await SharedPreferences.getInstance();
    await saveToken.setString('token', token as String);
    Get.offAll(homePage());
  }

  static Future<void> removeToken() async {
    final saveToken = await SharedPreferences.getInstance();
    await saveToken.remove('token');
  }

  static Future<Widget> handle() async {
    bool isAuth = await helperPage.isAuthenticated();
    return isAuth ? homePage() : loginPage();
  }

  static sendData() async {
    SharedPreferences sharepref = await SharedPreferences.getInstance();
    String? token = sharepref.getString('token');
    var data = {
      'Authorization': '$token',
    };
    var response = await http.get(
        Uri.parse('https://ali-izadi.ir/ToDo/public/api/user'),
        headers: data);
    return jsonDecode(response.body)['id'];
  }
}
