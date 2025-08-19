import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/models/Address.dart';
import 'package:Susani/models/CartItem.dart';
import 'package:Susani/models/Coupon.dart';
import 'package:Susani/models/User.dart';
import 'package:Susani/models/product.dart';
import 'package:http/io_client.dart';

class MyApi {
  // Enhanced debug logging
  static void _logDebug(String message, {String? functionName, dynamic data}) {
    if (kDebugMode) {
      final buffer = StringBuffer();
      buffer
          .writeln('🐛 DEBUG ${functionName != null ? '[$functionName]' : ''}');
      buffer.writeln('├─ Message: $message');
      if (data != null) {
        buffer.writeln('└─ Data: ${data.toString()}');
      }
      debugPrint(buffer.toString());
    }
  }

  // Error logging with stack traces
  static void _logError(
    String message, {
    required String functionName,
    dynamic error,
    StackTrace? stackTrace,
    http.Response? response,
  }) {
    if (kDebugMode) {
      final buffer = StringBuffer();
      buffer.writeln('⛔ ERROR [$functionName]');
      buffer.writeln('├─ Message: $message');

      if (error != null) {
        buffer.writeln('├─ Error: $error');
      }

      if (stackTrace != null) {
        buffer.writeln('├─ Stack trace:');
        stackTrace.toString().split('\n').take(3).forEach((line) {
          buffer.writeln('│  $line');
        });
      }

      if (response != null) {
        buffer.writeln('├─ Status: ${response.statusCode}');
        buffer.writeln('└─ Response: ${response.body}');
      }

      debugPrint(buffer.toString());
    }
  }

  // Request handler with debug logging

  static Future<http.Response> _handleRequest(
    Future<http.Response> request, {
    required String functionName,
    Map<String, dynamic>? requestBody,
  }) async {
    int retryCount = 0;
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 2);

    // Last error and stack for logging if all retries fail
    Object? lastError;
    StackTrace? lastStack;

    while (retryCount < maxRetries) {
      try {
        if (kDebugMode && requestBody != null) {
          _logDebug(
              'Making request${retryCount > 0 ? ' (retry $retryCount)' : ''}',
              functionName: functionName,
              data: requestBody);
        }

        final response = await request.timeout(const Duration(seconds: 10));

        if (response.statusCode != 200) {
          _logError(
            'Server error',
            functionName: functionName,
            response: response,
          );

          // If it's a server error (5xx), we should retry
          if (response.statusCode >= 500 && response.statusCode < 600) {
            throw http.ClientException(
              'Server error ${response.statusCode}',
              Uri.parse(AppConstraints.DATA_URL),
            );
          }

          return response;
        }

        return response;
      } on TimeoutException catch (e, stack) {
        lastError = e;
        lastStack = stack;
        _logError(
          'Request timed out${retryCount < maxRetries - 1 ? ', retrying...' : ''}',
          functionName: functionName,
          error: e,
          stackTrace: stack,
        );
      } on SocketException catch (e, stack) {
        lastError = e;
        lastStack = stack;
        _logError(
          'Connection error${retryCount < maxRetries - 1 ? ', retrying...' : ''}',
          functionName: functionName,
          error: e,
          stackTrace: stack,
        );
      } on http.ClientException catch (e, stack) {
        lastError = e;
        lastStack = stack;
        _logError(
          'Client error${retryCount < maxRetries - 1 ? ', retrying...' : ''}',
          functionName: functionName,
          error: e,
          stackTrace: stack,
        );
      } catch (e, stack) {
        lastError = e;
        lastStack = stack;
        _logError(
          'Request failed${retryCount < maxRetries - 1 ? ', retrying...' : ''}',
          functionName: functionName,
          error: e,
          stackTrace: stack,
        );

        // For unexpected errors, don't retry
        break;
      }

      retryCount++;
      if (retryCount < maxRetries) {
        await Future.delayed(retryDelay);
        // Recreate the request since the previous one was consumed
        if (functionName == 'get_ecom_products') {
          // Special handling for get_ecom_products which has custom request creation
          // You might need to pass the original parameters here
          // This is a limitation of the current architecture
          request = http.post(
            Uri.parse(AppConstraints.EcomBanner_Url),
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: requestBody?.entries
                .map((e) => '${e.key}=${e.value}')
                .join('&'),
          );
        } else {
          request = http.post(
            Uri.parse(functionName == 'sendOtp'
                ? AppConstraints.OTP_URL
                : functionName == 'popupLogin'
                    ? AppConstraints.VENDOR_API
                    : functionName == 'makeOrder'
                        ? AppConstraints.ORDER_URL
                        : functionName == 'paymentresponse'
                            ? AppConstraints.PAYMENT_SUCCESS
                            : functionName.startsWith('getEcom') ||
                                    functionName.startsWith('get_') ||
                                    functionName == 'get_filters'
                                ? AppConstraints.EcomBanner_Url
                                : AppConstraints.DATA_URL),
            body: requestBody,
          );
        }
      }
    }

    // All retries failed
    _logError(
      'Request failed after $maxRetries attempts',
      functionName: functionName,
      error: lastError,
      stackTrace: lastStack,
    );

    if (lastError is TimeoutException) {
      return http.Response('Timeout', 408);
    } else if (lastError is SocketException ||
        lastError is http.ClientException) {
      return http.Response('Connection Error', 503);
    }
    return http.Response('Error', 500);
  }
  // ========== API METHODS ========== //

  static Future<http.Response> getNewsFeed() async {
    final body = {"flag": "GetNews"};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'getNewsFeed',
      requestBody: body,
    );
  }

  static Future<http.Response> getSlider() async {
    final body = {"flag": "slider"};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'getSlider',
      requestBody: body,
    );
  }

  static Future<http.Response> getproduct(
      int startpoint, int pagesize, String type, String vendor_id) async {
    final body = {
      "flag": "get_product",
      "startpoint": startpoint.toString(),
      "pagesize": pagesize.toString(),
      "type": type,
      "user_id": vendor_id
    };
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'getproduct',
      requestBody: body,
    );
  }

  static Future<http.Response> searchproduct(int startpoint, int pagesize,
      String key, String type, String venderid) async {
    final body = {
      "flag": "get_product",
      "startpoint": startpoint.toString(),
      "pagesize": pagesize.toString(),
      "search": key.toString(),
      "type": type,
      "user_id": venderid
    };
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'searchproduct',
      requestBody: body,
    );
  }

  static Future<http.Response> getProductBycategory(
      int categoryId, String type, String venderid) async {
    final body = {
      "flag": "get_product",
      "category_id": categoryId.toString(),
      "type": type,
      "user_id": venderid
    };
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'getProductBycategory',
      requestBody: body,
    );
  }

  static Future<http.Response> getProductBycategoryVendor(
      int categoryId, String type, String venderid) async {
    final body = {
      "flag": "get_product",
      "category_id": categoryId.toString(),
      "type": type,
      "user_id": venderid
    };
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'getProductBycategoryVendor',
      requestBody: body,
    );
  }

  static Future<http.Response> getCategory(String type) async {
    final body = {"flag": "get_category", "type": type};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'getCategory',
      requestBody: body,
    );
  }

  static Future<http.Response> getVendorCategory(
      String type, String search) async {
    final body = {"flag": "get_category", "type": type, "search": search};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'getVendorCategory',
      requestBody: body,
    );
  }

  static Future<http.Response> getProductDetails(String productId) async {
    final body = {"product_id": productId, "flag": "product_details"};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'getProductDetails',
      requestBody: body,
    );
  }

  static Future<http.Response> saveAddress(Address address) async {
    final body = {
      "flag": "add_address",
      "user_id": address.userId,
      "name": address.name ?? '',
      "contact": address.contact,
      "address": address.address ?? '',
      "state": address.state ?? '',
      "landmark": address.landmark,
      "address_type": address.addressType ?? '',
      "city": address.city ?? '',
      "pincode": address.pincode ?? ''
    };
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'saveAddress',
      requestBody: body,
    );
  }

  static Future<http.Response> updateAddress(Address address) async {
    final body = {
      "flag": "update_address",
      "user_id": address.userId,
      "address_id": address.id,
      "name": address.name,
      "contact": address.contact,
      "state": address.state,
      "landmark": address.landmark,
      "address": address.address,
      "address_type": address.addressType,
      "city": address.city,
      "pincode": address.pincode
    };

    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'updateAddress',
      requestBody: body,
    );
  }

  static Future<http.Response> loadAddress(User user) async {
    final body = {
      "flag": "show_all_user_addresses",
      "user_id": user.id.toString()
    };
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'loadAddress',
      requestBody: body,
    );
  }

  static Future<http.Response> checkpinAvailability(String pin) async {
    final body = {"flag": "pincode_availablity", "pincode": pin};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'checkpinAvailability',
      requestBody: body,
    );
  }

  static Future<http.Response> deleteAddress(User user, Address address) async {
    final body = {
      "flag": "delete_address",
      "user_id": user.id.toString(),
      "id": address.id
    };
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'deleteAddress',
      requestBody: body,
    );
  }

  static Future<http.Response> signup(User user) async {
    final body = {
      "flag": "add_new_user",
      "name": user.name,
      "email": user.email,
      "mobile": user.contact,
      "password": user.password,
      "terms_condition": user.terms_condition.toString()
    };
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'signup',
      requestBody: body,
    );
  }

  static Future<http.Response> sendOtp(String mobile, String type) async {
    final body = {"type": type, "mobile": mobile};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.OTP_URL), body: body),
      functionName: 'sendOtp',
      requestBody: body,
    );
  }

  static Future<http.Response> popupLogin(
      String username, String password, var id, var school_id) async {
    final body = {
      "flag": "school_login",
      "username": username,
      "password": password,
      "school_id": school_id,
      "user_id": id
    };
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.VENDOR_API), body: body),
      functionName: 'popupLogin',
      requestBody: body,
    );
  }

  static Future<http.Response> mobileOrEmailExist(
      String mobile, String email) async {
    final body = {
      "flag": "verifyMobileOrEmail",
      "email": email,
      "mobile": mobile,
    };
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'mobileOrEmailExist',
      requestBody: body,
    );
  }

  static Future<http.Response> signIn(User user, String signInType) async {
    final body = {
      "flag": "login",
      "email": user.email,
      "password": "",
      "signInType": signInType
    };
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'signIn',
      requestBody: body,
    );
  }

  static Future<http.Response> forgotPassword(String email) async {
    final body = {"flag": "forgot_password", "email": email};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'forgotPassword',
      requestBody: body,
    );
  }

  static Future<http.Response> update_password_by_mobile(String mobile) async {
    final body = {"flag": "forgot_password_mobile", "mobile": mobile};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'update_password_by_mobile',
      requestBody: body,
    );
  }

  static Future<StreamedResponse> editProfile(User user,
      {oldpic = "", newpic = ""}) async {
    try {
      final url = Uri.parse(AppConstraints.DATA_URL);
      final request = http.MultipartRequest("POST", url);

      if (newpic != "") {
        request.files.add(await http.MultipartFile.fromPath('profile', newpic));
        _logDebug('Adding profile image',
            functionName: 'editProfile', data: newpic);
      }

      final fields = {
        "flag": "update_profile",
        "name": user.name.toString(),
        "lastname": user.last_name.toString(),
        "email": user.email.toString(),
        "mobile": user.contact.toString(),
        "gender": user.gender.toString(),
        "old_image": oldpic.toString(),
        "address_id": user.selected_address_id.toString()
      };

      request.fields.addAll(fields);
      _logDebug('Updating profile', functionName: 'editProfile', data: fields);

      final response =
          await request.send().timeout(const Duration(seconds: 10));
      final respStr = await response.stream.bytesToString();

      if (response.statusCode != 200) {
        _logError(
          'Profile update failed',
          functionName: 'editProfile',
          response: http.Response(respStr, response.statusCode),
        );
      }

      return http.StreamedResponse(
        Stream.value(utf8.encode(respStr)),
        response.statusCode,
        headers: response.headers,
        request: response.request,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    } catch (e, stack) {
      _logError(
        'Profile update error',
        functionName: 'editProfile',
        error: e,
        stackTrace: stack,
      );
      return http.StreamedResponse(Stream.empty(), 500);
    }
  }

  static Future<http.Response> getAppConfig() async {
    final body = {"flag": "app_config"};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'getAppConfig',
      requestBody: body,
    );
  }

  static Future<http.Response> addWishlist(User user, Product product) async {
    final body = {
      "flag": "add_to_wishlist",
      "p_id": product.id.toString(),
      "user_id": user.id.toString()
    };
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'addWishlist',
      requestBody: body,
    );
  }

  static Future<http.Response> removeWishlist(
      User user, Product product) async {
    final body = {
      "flag": "remove_from_wishlist",
      "p_id": product.id.toString(),
      "user_id": user.id.toString()
    };
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'removeWishlist',
      requestBody: body,
    );
  }

  static Future<http.Response> allWishlist(User user) async {
    final body = {
      "flag": "show_user_wish_lists",
      "user_id": user.id.toString()
    };
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'allWishlist',
      requestBody: body,
    );
  }

  static Future<http.Response> getCouponByCoupon(Coupon coupon) async {
    final body = {
      "flag": "coupon_data",
      "coupon_code": coupon.coupon_code.toString()
    };
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'getCouponByCoupon',
      requestBody: body,
    );
  }

  static Future<http.Response> AllCoupon() async {
    final body = {"flag": "all_coupon_data"};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'AllCoupon',
      requestBody: body,
    );
  }

  static Future<http.Response> searchCategory(String categoryname) async {
    final body = {"flag": "search_category", "categoryname": categoryname};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'searchCategory',
      requestBody: body,
    );
  }

  static Future<http.Response> searchProduct(String key) async {
    final body = {"flag": "search_product", "key": key, "type": "laundry"};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'searchProduct',
      requestBody: body,
    );
  }

  static Future<http.Response> makeOrder(Map<String, dynamic> data) async {
    try {
      _logDebug('Making order', functionName: 'makeOrder', data: data);

      final response = await http
          .post(
            Uri.parse(AppConstraints.ORDER_URL),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        _logError(
          'Order failed',
          functionName: 'makeOrder',
          response: response,
        );
      }
      return response;
    } on TimeoutException catch (e, stack) {
      _logError(
        'Order timed out',
        functionName: 'makeOrder',
        error: e,
        stackTrace: stack,
      );
      return http.Response('Timeout', 408);
    } catch (e, stack) {
      _logError(
        'Order error',
        functionName: 'makeOrder',
        error: e,
        stackTrace: stack,
      );
      return http.Response('Error', 500);
    }
  }

  static Future<http.Response> paymentresponse(data) async {
    final body = {"id": data};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.PAYMENT_SUCCESS), body: body),
      functionName: 'paymentresponse',
      requestBody: body,
    );
  }

  static Future<http.Response> orderHistory(User user) async {
    final body = {"flag": "order_history", "user_id": user.id};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'orderHistory',
      requestBody: body,
    );
  }

  static Future<http.Response> orderStatus(String orderid) async {
    final body = {"flag": "check_order_status", "order_id": orderid};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'orderStatus',
      requestBody: body,
    );
  }

  static Future<http.Response> cancelOrder(String user_id, String id) async {
    final body = {"flag": "cancel_order", "user_id": user_id, "order_id": id};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'cancelOrder',
      requestBody: body,
    );
  }

  static Future<http.Response> saveToCart(
      CartItem cartItem, String user_id) async {
    final body_data = {
      "flag": "add_to_cart",
      "product_id": cartItem.product!.id.toString(),
      "user_id": user_id,
      "total": cartItem.total.toString(),
      "quantity": cartItem.quantity.toString(),
      "size": cartItem.size.toString(),
      "type": cartItem.type.toString(),
      "color": cartItem.quantity.toString(),
      cartItem.clear_cart.toString() == "true" ? "clear_cart" : "_cart":
          cartItem.clear_cart.toString()
    };

    String dataString = cartItem.selectedCombination.toString();
    if (dataString.contains('{') && dataString.contains('}')) {
      dataString = dataString.replaceAll(RegExp(r'[\{\}]'), '');
      List<String> pairs = dataString.split(', ');

      Map<int, int> data = {};
      for (String pair in pairs) {
        List<String> keyValue = pair.split(':');
        int key = int.parse(keyValue[0].trim());
        int value = int.parse(keyValue[1].trim());
        data[key] = value;
      }

      data.forEach((key, value) {
        body_data.addAll({"combination[][${key}]": value.toString()});
      });
    }

    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body_data),
      functionName: 'saveToCart',
      requestBody: body_data,
    );
  }

  static Future<http.Response> getCartItems(String user_id) async {
    final body = {"flag": "cart_items", "user_id": user_id};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'getCartItems',
      requestBody: body,
    );
  }

  static Future<http.Response> addQuantity(String userid, product_id,
      int quantity, String type, String cart_id) async {
    final body = {
      "flag": "add_quantity",
      "user_id": userid.toString(),
      "product_id": product_id.toString(),
      "quantity_val": quantity.toString(),
      "type": type,
      "cart_id": cart_id,
    };
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'addQuantity',
      requestBody: body,
    );
  }

  static Future<http.Response> deleteCartItem(int id) async {
    final body = {"flag": "delete_item", "id": id.toString()};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'deleteCartItem',
      requestBody: body,
    );
  }

  static Future<http.Response> deleteAllCartItem(String userid) async {
    final body = {"flag": "delete_allitem", "id": userid};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'deleteAllCartItem',
      requestBody: body,
    );
  }

  static Future<http.Response> allLandmarks(
      int userid, String zip, addressId) async {
    final body = {
      "flag": "landmarks",
      "userid": userid.toString(),
      "zip": zip,
      "address_id": addressId.toString()
    };
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'allLandmarks',
      requestBody: body,
    );
  }

  static Future<http.Response> getBookedDate() async {
    final body = {"flag": "booked_date"};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'getBookedDate',
      requestBody: body,
    );
  }

  static Future<http.Response> getAvailablePincodes() async {
    final body = {"flag": "urgent_service_pincode"};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.DATA_URL), body: body),
      functionName: 'getAvailablePincodes',
      requestBody: body,
    );
  }

  static Future<http.Response> getEcomBanner() async {
    final body = {"flag": "get_slider"};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.EcomBanner_Url), body: body),
      functionName: 'getEcomBanner',
      requestBody: body,
    );
  }

  static Future<http.Response> getEcomNewArrival() async {
    final body = {"flag": "new_arrival_product"};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.EcomBanner_Url), body: body),
      functionName: 'getEcomNewArrival',
      requestBody: body,
    );
  }

  static Future<http.Response> getEcomBannerProducts() async {
    final body = {"flag": "new_arrival_product"};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.EcomBanner_Url), body: body),
      functionName: 'getEcomBannerProducts',
      requestBody: body,
    );
  }

  static Future<http.Response> get_categories_of_product() async {
    final body = {"flag": "categories_of_product"};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.EcomBanner_Url), body: body),
      functionName: 'get_categories_of_product',
      requestBody: body,
    );
  }

  static Future<http.Response> get_filters() async {
    final body = {"flag": "get_filters"};
    return _handleRequest(
      http.post(Uri.parse(AppConstraints.EcomBanner_Url), body: body),
      functionName: 'get_filters',
      requestBody: body,
    );
  }

  static Future<http.Response> get_ecom_product_details(
      String productid, String selectedCombination) async {
    final body_data = {"flag": "product_details", "product_id": productid};

    if (selectedCombination.contains('{') &&
        selectedCombination.contains('}')) {
      selectedCombination =
          selectedCombination.replaceAll(RegExp(r'[\{\}]'), '');
      List<String> pairs = selectedCombination.split(', ');

      Map<int, int> data = {};
      for (String pair in pairs) {
        List<String> keyValue = pair.split(':');
        int key = int.parse(keyValue[0].trim());
        int value = int.parse(keyValue[1].trim());
        data[key] = value;
      }

      data.forEach((key, value) {
        body_data.addAll({"combination[][${key}]": value.toString()});
      });
    }

    return _handleRequest(
      http.post(Uri.parse(AppConstraints.EcomBanner_Url), body: body_data),
      functionName: 'get_ecom_product_details',
      requestBody: body_data,
    );
  }

  static Future<http.Response> get_ecom_products(
      String slider_id,
      String sort_order,
      String sortBy,
      String current_page,
      String per_page,
      RxList<String> category_id_array,
      RxList<String> filter_val_id_array,
      RxList<String> attribute_val_id,
      String pmin,
      String pmax,
      String search) async {
    final bodyParts = [
      "flag=get_product_list",
      "slider_id=$slider_id",
      "sort_order=$sort_order",
      "sortBy=$sortBy",
      "current_page=$current_page",
      "per_page=$per_page",
      "prices[min]=$pmin",
      "prices[max]=$pmax",
      "search=$search"
    ];

    if (category_id_array.isNotEmpty) {
      for (var categoryId in category_id_array) {
        bodyParts.add("category_id[]=$categoryId");
      }
    }

    if (filter_val_id_array.isNotEmpty) {
      for (var filterId in filter_val_id_array) {
        bodyParts.add("filter_val_id[]=$filterId");
      }
    }

    if (attribute_val_id.isNotEmpty) {
      for (var attribute_val_id in attribute_val_id) {
        bodyParts.add("attribute_val_id[]=$attribute_val_id");
      }
    }

    final bodyString = bodyParts.join('&');
    _logDebug('Fetching ecom products',
        functionName: 'get_ecom_products', data: bodyString);

    try {
      final response = await http
          .post(
            Uri.parse(AppConstraints.EcomBanner_Url),
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: bodyString,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        _logError(
          'Failed to fetch products',
          functionName: 'get_ecom_products',
          response: response,
        );
      }
      return response;
    } on TimeoutException catch (e, stack) {
      _logError(
        'Request timed out',
        functionName: 'get_ecom_products',
        error: e,
        stackTrace: stack,
      );
      return http.Response('Timeout', 408);
    } catch (e, stack) {
      _logError(
        'Request failed',
        functionName: 'get_ecom_products',
        error: e,
        stackTrace: stack,
      );
      return http.Response('Error', 500);
    }
  }
}
