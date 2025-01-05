class Slider {
  String? id;
  String? image;
  String? delStatus;
  String? title;
  String? description;
  String? userName;
  String? date;

  Slider(
      {this.id,
      this.image,
      this.delStatus,
      this.date,
      this.title,
      this.description,
      this.userName});

  Slider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    delStatus = json['del_status'];
    date = json['date'];
    title = json['title'];
    description = json['description'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['del_status'] = this.delStatus;
    data['date'] = this.date;
    return data;
  }
}
