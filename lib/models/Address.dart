class Address {
  String? id;
  String? userId;
  String? name;
  String? contact;
  String? city;
  String? address;
  String? state;
  String? landmark;
  String? pincode;
  String? addressType;
  String? addedOn;
  bool? isSelected;

  Address({
    this.id,
    this.userId,
    this.name,
    this.contact,
    this.city,
    this.address,
    this.pincode,
    this.state,
    this.landmark,
    this.addressType,
    this.addedOn,
    this.isSelected = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString(),
      name: json['name']?.toString(),
      contact: json['contact']?.toString(),
      city: json['city']?.toString(),
      address: json['address']?.toString(),
      state: json['state']?.toString(),
      landmark: json['landmark']?.toString(),
      pincode: json['pincode']?.toString(),
      addressType: json['address_type']?.toString(),
      addedOn: json['added_on']?.toString(),
      isSelected: json['is_selected'] == 1 || json['is_selected'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'contact': contact,
      'city': city,
      'address': address,
      'state': state,
      'landmark': landmark,
      'pincode': pincode,
      'address_type': addressType,
      'added_on': addedOn,
      'is_selected': isSelected == true ? 1 : 0,
    };
  }

  // Validation method
  static List<String> validateAddress(Address address) {
    final errors = <String>[];

    if (address.name == null || address.name!.isEmpty) {
      errors.add('Name is required');
    }

    if (address.contact == null || address.contact!.isEmpty) {
      errors.add('Contact number is required');
    } else if (!RegExp(r'^[0-9]{10,15}$').hasMatch(address.contact!)) {
      errors.add('Enter a valid contact number');
    }

    if (address.city == null || address.city!.isEmpty) {
      errors.add('City is required');
    }

    if (address.address == null || address.address!.isEmpty) {
      errors.add('Address is required');
    }

    if (address.state == null || address.state!.isEmpty) {
      errors.add('State is required');
    }

    if (address.pincode == null || address.pincode!.isEmpty) {
      errors.add('Pincode is required');
    } else if (!RegExp(r'^[0-9]{6}$').hasMatch(address.pincode!)) {
      errors.add('Enter a valid 6-digit pincode');
    }

    return errors;
  }

  // Copy with method for immutability
  Address copyWith({
    String? id,
    String? userId,
    String? name,
    String? contact,
    String? city,
    String? address,
    String? state,
    String? landmark,
    String? pincode,
    String? addressType,
    String? addedOn,
    bool? isSelected,
  }) {
    return Address(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      city: city ?? this.city,
      address: address ?? this.address,
      state: state ?? this.state,
      landmark: landmark ?? this.landmark,
      pincode: pincode ?? this.pincode,
      addressType: addressType ?? this.addressType,
      addedOn: addedOn ?? this.addedOn,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
