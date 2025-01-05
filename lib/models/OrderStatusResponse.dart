class OrderStatusResponse {
  String? id;
  String? orderId;
  String? deliveryBoyId;
  String? requestStatus;
  String? assignedDate;
  String? assigningFor;
  String? name;
  String? lastname;
  String? profile;
  String? gender;
  String? mobile;
  String? factoryStatus;

  OrderStatusResponse(
      {this.id,
      this.orderId,
      this.deliveryBoyId,
      this.requestStatus,
      this.factoryStatus,
      this.assignedDate,
      this.assigningFor,
      this.name,
      this.lastname,
      this.profile,
      this.gender,
      this.mobile});

  OrderStatusResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    deliveryBoyId = json['delivery_boy_id'];
    requestStatus = json['request_status'];
    factoryStatus = json['factory_request_status'];
    assignedDate = json['assigned_date'];
    assigningFor = json['assigning_for'];
    name = json['name'];
    lastname = json['lastname'];
    profile = json['profile'];
    gender = json['gender'];
    mobile = json['mobile'];
  }
}
