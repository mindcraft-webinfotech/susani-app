import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/models/Address.dart';
import 'package:Susani/models/CartItem.dart';
import 'package:Susani/models/Coupon.dart';
import 'package:Susani/models/User.dart';
import 'package:Susani/models/product.dart';

class MyApi {
  static Future<http.Response> getNewsFeed() async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url, body: {"flag": "GetNews"});
  }

  static Future<http.Response> getSlider() async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url, body: {"flag": "slider"});
  }

  static Future<http.Response> getproduct(int startpoint, int pagesize , String type, String vendor_id) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    print("getproduct ${url}");
    print({ "flag": "get_product",
      "startpoint": startpoint.toString(),
      "pagesize": pagesize.toString(),
      "type":type,
      "user_id":vendor_id});
    return await http.post(url, body: {
      "flag": "get_product",
      "startpoint": startpoint.toString(),
      "pagesize": pagesize.toString(),
      "type": type,
      "user_id":vendor_id
    });
  }

  // static Future<http.Response> searchproduct(int startpoint, int pagesize, String key ,String type,String venderid) async {
  //   var url = Uri.parse(AppConstraints.DATA_URL);
  //   print(url);
  //   print({  "flag": "search_product",
  //     "startpoint": startpoint.toString(),
  //     "pagesize": pagesize.toString(),
  //     "key": key.toString() ,"type": type,"user_id": venderid});
  //   return await http.post(url, body: {
  //     "flag": "search_product",
  //     "startpoint": startpoint.toString(),
  //     "pagesize": pagesize.toString(),
  //     "key": key.toString()
  //     ,"type": type,"user_id": venderid
  //
  //
  //   });
  // }
  static Future<http.Response> searchproduct(int startpoint, int pagesize, String key ,String type,String venderid) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    print(url);
    print({
      "flag": "get_product",
      "startpoint": startpoint.toString(),
      "pagesize": pagesize.toString(),
      "search": key.toString(),
      "type": type,
      "user_id": venderid
    });


    return await http.post(url, body: {
      "flag": "get_product",
      "startpoint": startpoint.toString(),
      "pagesize": pagesize.toString(),
      "search": key.toString(),
      "type": type,
      "user_id": venderid
    });
  }

  static Future<http.Response> getProductBycategory(int categoryId ,String type,String venderid) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    print("getProductBycategory ${url}") ;
    print({"flag": "get_product", "category_id": categoryId.toString(),"type": type,"user_id": venderid});
    return await http.post(url,
        body: {"flag": "get_product", "category_id": categoryId.toString(),"type": type,"user_id": venderid});
  }


  static Future<http.Response> getProductBycategoryVendor(int categoryId,String type,String venderid) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    print(url) ;
    print({"flag": "get_product", "category_id": categoryId.toString(),"type": type,"user_id": venderid});
    return await http.post(url,
        body: {"flag": "get_product", "category_id": categoryId.toString(),"type": type,"user_id": venderid});
  }

  static Future<http.Response> getCategory(String type) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    print("getCategory ${url}");
    print({"flag": "get_category", "type": type});
    return await http.post(url, body : {"flag": "get_category", "type": type} );
  }


  static Future<http.Response> getVendorCategory(String type,String search) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    print(url);
    print({"flag": "get_category", "type": type,"search": search});

    // type = [laundry, school, ecom]

    return await http.post(url, body: {"flag": "get_category","type": type,"search": search
    });
  }



  static Future<http.Response> getProductDetails(String productId) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    print(url);
    print({"product_id": productId, "flag": "product_details"});
    return await http
        .post(url, body: {"product_id": productId, "flag": "product_details"});
  }

  static Future<http.Response> saveAddress(Address address) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url, body: {
      "flag": "add_address",
      "user_id": address.user_id,
      "name": address.name,
      "contact": address.contact,
      "address": address.address,
      "state": address.state,
      "landmark": address.landmark,
      "address_type": address.address_type,
      "city": address.city,
      "pincode": address.pincode
    });
  }

  static Future<http.Response> updateAddress(Address address) async {
    var url = Uri.parse(AppConstraints.DATA_URL);

    return await http.post(url, body: {
      "flag": "update_address",
      "user_id": address.user_id,
      "address_id": address.id,
      "name": address.name,
      "contact": address.contact,
      "state": address.state,
      "landmark": address.landmark,
      "address": address.address,
      "address_type": address.address_type,
      "city": address.city,
      "pincode": address.pincode
    });
  }

  static Future<http.Response> loadAddress(User user) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url, body: {
      "flag": "show_all_user_addresses",
      "user_id": user.id.toString()
    });
  }

  static Future<http.Response> checkpinAvailability(String pin) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    print("pincode" + pin);
    return await http
        .post(url, body: {"flag": "pincode_availablity", "pincode": pin});
  }

  static Future<http.Response> deleteAddress(User user, Address address) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    // print("Url data: ");
    // print(user.id);
    // print(address.id);
    return await http.post(url, body: {
      "flag": "delete_address",
      "user_id": user.id.toString(),
      "id": address.id
    });
  }

  static Future<http.Response> signup(User user) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url, body: {
      "flag": "add_new_user",
      "name": user.name,
      "email": user.email,
      "mobile": user.contact,
      "password": user.password,
      "terms_condition": user.terms_condition.toString()
    });
  }

  static Future<http.Response> sendOtp(String mobile, String type) async {
    var url = Uri.parse(AppConstraints.OTP_URL);
    print(type);
    print("$url $mobile");
    return await http.post(url, body: {
      "type": type,
      "mobile": mobile,
    });
  }

  static Future<http.Response> mobileOrEmailExist(
      String mobile, String email) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url, body: {
      "flag": "verifyMobileOrEmail",
      "email": email,
      "mobile": mobile,
    });
  }

  static Future<http.Response> signIn(User user, String signInType) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    print(url);
    return await http.post(url, body: {
      "flag": "login",
      "email": user.email,
      "password": "",
      "signInType": signInType
    });
  }

  static Future<http.Response> forgotPassword(String email) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url, body: {
      "flag": "forgot_password",
      "email": email,
    });
  }

  static Future<http.Response> update_password_by_mobile(String mobile) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url, body: {
      "flag": "forgot_password_mobile",
      "mobile": mobile,
    });
  }

  static Future<StreamedResponse> editProfile(User user,
      {oldpic = "", newpic = ""}) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    var request = http.MultipartRequest("POST", url);
    if (newpic != "") {
      print("path for new pic starts here");
      print(newpic);
      request.files.add(await http.MultipartFile.fromPath('profile', newpic));
    }

    request.fields["flag"] = "update_profile";
    request.fields["name"] = user.name.toString();
    request.fields["lastname"] = user.last_name.toString();
    request.fields["email"] = user.email.toString();
    request.fields["mobile"] = user.contact.toString();
    request.fields["gender"] = user.gender.toString();
    // request.fields["city"] = user.city.toString();
    // request.fields["zip"] = user.zip.toString();
    // request.fields["address"] = user.address.toString();
    request.fields["old_image"] = oldpic;
    request.fields["address_id"] = user.selected_address_id.toString();

    return await request.send();
  }

  static Future<http.Response> getAppConfig() async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url, body: {"flag": "app_config"});
  }

// -----------------wishlist----------
  static Future<http.Response> addWishlist(User user, Product product) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url, body: {
      "flag": "add_to_wishlist",
      "p_id": product.id.toString(),
      "user_id": user.id.toString()
    });
  }

  static Future<http.Response> removeWishlist(
      User user, Product product) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url, body: {
      "flag": "remove_from_wishlist",
      "p_id": product.id.toString(),
      "user_id": user.id.toString()
    });
  }

  static Future<http.Response> allWishlist(User user) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url,
        body: {"flag": "show_user_wish_lists", "user_id": user.id.toString()});
  }

  // ------------------------------coupons----------------------
  static Future<http.Response> getCouponByCoupon(Coupon coupon) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url, body: {
      "flag": "coupon_data",
      "coupon_code": coupon.coupon_code.toString(),
    });
  }

  static Future<http.Response> AllCoupon() async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url, body: {"flag": "all_coupon_data"});
  }

  // ----------------------Search---------------------
  static Future<http.Response> searchCategory(String categoryname) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url,
        body: {"flag": "search_category", "categoryname": categoryname});
  }

  static Future<http.Response> searchProduct(String key) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url, body: {"flag": "search_product", "key": key});
  }

  // ----------------------Order---------------------
  static Future<http.Response> makeOrder(Map<String, dynamic> data) async {
    var url = Uri.parse(AppConstraints.ORDER_URL);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    print(AppConstraints.ORDER_URL);
    print(data.toString());
    print(data['cart_items']);
    return await post(url, headers: headers, body: jsonEncode(data));
  }

// paymentresponse...

  static Future<http.Response> paymentresponse(data) async {
    var url = Uri.parse(AppConstraints.PAYMENT_SUCCESS);

    return await post(url, body: {"id": data});
  }

  // ----------------------Order History---------------------
  static Future<http.Response> orderHistory(User user) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    print({"flag": "order_history", "user_id": user.id});
    return await http
        .post(url, body: {"flag": "order_history", "user_id": user.id});
  }

  static Future<http.Response> orderStatus(String orderid) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http
        .post(url, body: {"flag": "check_order_status", "order_id": orderid});
  }

  // ----------------------Order cancel---------------------
  static Future<http.Response> cancelOrder(String user_id, String id) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    print(url);
    print(user_id);
    print(id);
    return await http.post(url,
        body: {"flag": "cancel_order", "user_id": user_id, "order_id": id});
  }

// --------------------------cart item -------
  static Future<http.Response> saveToCart(
      CartItem cartItem, String user_id) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    print({
      "flag": "add_to_cart",
      "product_id": cartItem.product!.id.toString(),
      "user_id": user_id,
      "total": cartItem.total.toString(),
      "quantity": cartItem.quantity.toString(),
      "size": cartItem.size.toString(),
      "type": cartItem.type.toString(),
      "color": cartItem.quantity.toString(),
      cartItem.clear_cart.toString() == "true" ? "clear_cart": "_cart": cartItem.clear_cart.toString()

    });
    return await http.post(url, body: {
      "flag": "add_to_cart",
      "product_id": cartItem.product!.id.toString(),
      "user_id": user_id,
      "total": cartItem.total.toString(),
      "quantity": cartItem.quantity.toString(),
      "size": cartItem.size.toString(),
      "type": cartItem.type.toString(),
      "color": cartItem.quantity.toString(),
      cartItem.clear_cart.toString() == "true" ? "clear_cart": "_cart": cartItem.clear_cart.toString()
    });
  }

  static Future<http.Response> getCartItems(String user_id) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url, body: {
      "flag": "cart_items",
      "user_id": user_id,
    });
  }

  static Future<http.Response> addQuantity(
      String userid, product_id, int quantity, String type) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    print({
      "flag": "add_quantity",
      "user_id": userid.toString(),
      "product_id": product_id.toString(),
      "quantity_val": quantity.toString(),
      "type": type,
    });
    return await http.post(url, body: {
      "flag": "add_quantity",
      "user_id": userid.toString(),
      "product_id": product_id.toString(),
      "quantity_val": quantity.toString(),
      "type": type,
    });
  }

  static Future<http.Response> deleteCartItem(int id) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url, body: {
      "flag": "delete_item",
      "id": id.toString(),
    });
  }

  static Future<http.Response> deleteAllCartItem(String userid) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url, body: {
      "flag": "delete_allitem",
      "id": userid,
    });
  }

  // -------------------------landmarks---------
  static Future<http.Response> allLandmarks(int userid, String zip) async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url,
        body: {"flag": "landmarks", "userid": userid.toString(), "zip": zip});
  }

  // ----------------------booked date -----------------
  static Future<http.Response> getBookedDate() async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url, body: {"flag": "booked_date"});
  }

  // ----------------------booked date -----------------
  static Future<http.Response> getAvailablePincodes() async {
    var url = Uri.parse(AppConstraints.DATA_URL);
    return await http.post(url, body: {"flag": "urgent_service_pincode"});
  }
}
