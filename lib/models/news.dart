class News {
  String? id;
  String? title;
  String? image;
  String? discription;
  String? userName;
  String? dataTime;

  News(
      {this.id,
      this.title,
      this.image,
      this.discription,
      this.userName,
      this.dataTime});

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    discription = json['discription'];
    userName = json['user_name'];
    dataTime = json['date_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['discription'] = this.discription;
    return data;
  }
}
