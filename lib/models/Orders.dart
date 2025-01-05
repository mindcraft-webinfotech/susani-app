class Orders {
  String? id;
  String? orderId;
  String? deliveryBoyId;
  String? deliveryStatus;
  String? requestStatus;
  String? assignedDate;

  Orders(
      {this.id,
      this.orderId,
      this.deliveryBoyId,
      this.deliveryStatus,
      this.requestStatus,
      this.assignedDate});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    deliveryBoyId = json['delivery_boy_id'];
    deliveryStatus = json['delivery_status'];
    requestStatus = json['request_status'];
    assignedDate = json['assigned_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['delivery_boy_id'] = this.deliveryBoyId;
    data['delivery_status'] = this.deliveryStatus;
    data['request_status'] = this.requestStatus;
    data['assigned_date'] = this.assignedDate;
    return data;
  }
}