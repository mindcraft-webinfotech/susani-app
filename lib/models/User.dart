import 'package:get/get.dart';

class User {
  String? id;
  String? name;
  String? last_name;
  String? email;
  String? gender;
  String? password;
  String? contact;
  String? city;
  String? zip;
  String? address;
  String? terms_condition;
  var profile = "".obs;
  var image = "".obs;
  int? selected_address_id;

  User({
    this.id,
    this.name,
    this.last_name,
    this.email,
    this.gender,
    this.contact,
    this.city,
    this.zip,
    this.address,
    this.password,
    this.selected_address_id,
    this.terms_condition,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    last_name = json.containsKey('lastname') ? json['lastname'] : "";
    gender = json.containsKey('gender') ? json['gender'] : "";
    image.value = json.containsKey('profile') ? json['profile'] : "";
    contact = json['mobile'];
    email = json['email'];
    city = json['city'].toString();
    zip = json['zip'].toString();
    address = json['address'].toString();
    terms_condition = json['terms_condition'].toString();
    selected_address_id = int.parse(json.containsKey('address_id')
        ? json['address_id'] != null
            ? json['address_id']
            : 0.toString()
        : 0.toString());
  }
}
