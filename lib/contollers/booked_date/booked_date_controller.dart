import 'dart:convert';
import 'package:Susani/models/BookedDate.dart';
import 'package:get/get.dart';
import 'package:Susani/services/remote_servies.dart';
import 'package:http/http.dart' as http;

class booked_date_controller extends GetxController {
  BookedDate bookedDate = BookedDate();
  var bookdeList = <BookedDate>[].obs;
  var status = "".obs;
  @override
  void onInit() {
    getAllBookedDate();
    super.onInit();
  }

  void getAllBookedDate() {
    status.value = "Loading";
    Future.delayed(Duration(seconds: 1), () async {
      http.Response response = await MyApi.getBookedDate();
      // print("----------------------------->>>");
      // print(response.body);
      // print("----------------------------->>>");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String res = data['res'];
        String msg = data['msg'];
        if (res == "success") {
          var re = data['data'] as List;
          status.value = "Done";
          bookdeList.value =
              re.map<BookedDate>((e) => BookedDate.fromJson(e)).toList();
        } else {
          status.value = "Failed: " + msg;
        }
      } else {
        status.value = "Failed with exception";
      }
    });
  }
}
