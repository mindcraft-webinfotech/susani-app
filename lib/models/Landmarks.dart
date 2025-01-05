class Landmarks {
  int? id;
  String? name;
  int? userid;

  Landmarks({this.id, this.name, this.userid});
  Landmarks.fromJson(Map<String, dynamic> json) {
    id = json['id'] == "null" ? 0 : int.parse(json['id']);
    userid = json['userid'] == "null" ? 0 : int.parse(json['userid']);
    name = json["name"] == "null" ? "Select Landmark" : json["name"];
  }
  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "userid": userid.toString(),
        "name": name.toString()
      };
}
