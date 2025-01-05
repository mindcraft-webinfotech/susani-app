class AppConstraints {
  static const FIX_NUM = 2022;
  static const String BASE_URL = "https://susani.in/";
  // static const String BASE_URL = "https://susani.in/testing/";

  static const String DATA_URL = "${BASE_URL}API/V1/GetData.php";
  static const String VENDOR_URL = "${BASE_URL}API/V1/vendor-api.php";

  static const String DONATION = "${BASE_URL}API/V1/donation.php";

  static const String IMAGE_URL = "${BASE_URL}uploads/news/";

  static const String CAT_IMAGE_URL = "${BASE_URL}uploads/category/";

  static const String BANNER_URL = "${BASE_URL}uploads/banner/";

  static const String PROFILE_URL = "https://susani.in/";

  static const String PRODUCT_URL = "${BASE_URL}uploads/product/";

  static const String ORDER_URL = "${BASE_URL}API/V1/order.php";

  static const String PAYMENT_SUCCESS = "${BASE_URL}capture_payment.php";
  static const String OTP_URL = "${BASE_URL}API/V1/sendOtp.php";

  static const String DEFAULIMAGE =
      "https://assets.onlinelabels.com/images/clip-art/Firkin/Faceless%20man-297004_thumb.png";
  static const paymentMethods = ["CASH", "CREDIT CARD", "ONLINE"];

  static const paymentMethodsImage = [
    "assets/icon/cash.png",
    "assets/icon/credit-card.png",
    "assets/icon/payment-method.png"
  ];

  static var Gender = ["Male", "Female"];
  static var filterList = [
    "Sort by latest",
    "Sort by name: A-Z",
    "Sort by name: Z-A",
    "Sort by price: low to high",
    "Sort by price: high to low"
  ];
  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  static Map<String, String> type = {
    "Urgent Service": "Delivery within 8 hours (Double Charge)",
    "Semi Urgent Service": "Delivery on second or third day (No discount)",
    "General Service": "Delivery between 4 to 10 days (20% to 50% discount )"
  };
  static Map<String, String> type_for_pin_unavailable = {
    "General Service": "Delivery between 4 to 10 days (20% to 50% discount )"
  };
}
