import 'package:Susani/consts/app_constraints.dart';

class Category {
  String? id;
  String? categoryname;
  String? image;
  String? delStatus;
  String? date;

  Category({this.id, this.categoryname, this.image, this.delStatus, this.date});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryname = AppConstraints.capitalize(json['categoryname']);
    image = json['image'];
    delStatus = json['del_status'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryname'] = this.categoryname;
    data['image'] = this.image;
    data['del_status'] = this.delStatus;
    data['date'] = this.date;
    return data;
  }
}
