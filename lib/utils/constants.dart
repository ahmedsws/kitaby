import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/authentication/data/models/user_model.dart';

class Constants {
  static const Color mainFontColor = Color(0xFF06070D);
  static final Color secondrayFontColor =
      const Color.fromARGB(255, 146, 148, 161).withOpacity(.8);

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final String? result = prefs.getString('user');

    if (result != null) {
      final value = jsonDecode(result);

      return UserModel.fromJson(value);
    } else {
      return null;
    }
  }
}
