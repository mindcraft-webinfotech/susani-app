class AppConfig {
  int? id;
  double? shipping_fee;
  double? common_tax;
  String? token = "";
  int? autoLogin;
  String? secret;
  int? urgent_service_charge_percent;
  int? no_shipping_charge_criteria_amount = 0;

  AppConfig(
      {this.shipping_fee,
      this.common_tax,
      this.urgent_service_charge_percent,
      this.no_shipping_charge_criteria_amount,
      this.autoLogin});
  AppConfig.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    autoLogin = int.parse(json['auto_login']);
    shipping_fee = double.parse(json['shipping_charge']);
    common_tax = double.parse(json['common_tax_percent']);
    urgent_service_charge_percent =
        int.parse(json['urgent_service_charge_percent']);
    no_shipping_charge_criteria_amount =
        int.parse(json['no_shipping_charge_criteria']);
  }
}
