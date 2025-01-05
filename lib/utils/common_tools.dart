import 'package:Susani/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class CommonTool {
  save(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("id", user.id.toString());
    prefs.setString("name", user.name.toString());
    prefs.setString("email", user.email.toString());
    prefs.setString("profile", user.profile.value.toString());
    prefs.setString("gender", user.gender.toString());
  }

  Future<User> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = new User();
    user.id = prefs.getString('id').toString();
    user.name = prefs.getString('name').toString();
    user.profile.value = prefs.getString('profile').toString();
    // user.lastname = prefs.getString('lastname').toString();
    user.email = prefs.getString('email').toString();
    // user.contact = prefs.getString('contact').toString();
    user.gender = prefs.getString('gender').toString();
    return user;
  }

  void showInSnackBar(String value, BuildContext context,
      {Color bgcolor = Colors.black45}) {
    final snackBar = SnackBar(
      backgroundColor: bgcolor,
      content: Text(value.toString()),
      action: SnackBarAction(
        label: 'ok',
        textColor: Colors.white,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<String> removeFromPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("id");
    prefs.remove("name");
    prefs.remove("email");
    prefs.remove("profile");
    // prefs.remove("selected_address_id");
    return "cleared";
  }
}
