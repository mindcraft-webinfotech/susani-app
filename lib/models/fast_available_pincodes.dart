class Pincode {
  int? id;
  String? pincode;

  Pincode({
    this.pincode,
  });
  Pincode.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    pincode = json['pincode'];
  }
}
