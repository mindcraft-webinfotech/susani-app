class Address {
  String? id;
  String? user_id;
  String? name;
  String? contact;
  String? city;
  String? address;
  String? state;
  String? landmark;
  String? pincode;
  String? address_type;
  String? added_on;

  Address(
      {this.id,
      this.name,
      this.contact,
      this.city,
      this.address,
      this.pincode,
      this.state,
      this.landmark,
      this.address_type,
      this.added_on});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user_id = json['user_id'];
    name = json['name'];
    contact = json['contact'];
    city = json['city'];
    address = json['address'];
    state = json['state'];
    landmark = json['landmark'];
    pincode = json['pincode'];
    address_type = json['address_type'];
    added_on = json['added_on'];
  }
  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "user_id": user_id.toString(),
        "name": name.toString(),
        "contact": contact.toString(),
        "city": city.toString(),
        "landmark": landmark.toString(),
        "state": state.toString(),
        "address": address.toString(),
        "pincode": pincode.toString().toString(),
        "address_type": address_type.toString(),
        "added_on": added_on.toString(),
      };
}
