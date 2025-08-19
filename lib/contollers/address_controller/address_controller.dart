import 'dart:convert';
import 'package:Susani/contollers/checkout_controller/checkout_controller.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:Susani/models/fast_available_pincodes.dart';
import 'package:Susani/models/Address.dart';
import 'package:Susani/models/User.dart';
import 'package:Susani/services/remote_servies.dart';
import 'package:intl/intl.dart';

class AddressController extends GetxController {
  SignInController signinController = Get.find<SignInController>();
  CheckoutController checkoutController = Get.find<CheckoutController>();

  Rx<TextEditingController> dateController = TextEditingController().obs;
  RxList<Pincode> availablePincodesList = <Pincode>[].obs;
  RxList<Address> addresses = <Address>[].obs;
  RxString status = "".obs;
  RxString loadAddresStatus = "".obs;
  RxString pincodeStatus = "".obs;
  Rx<Address> addressForEdit = Address().obs;
  RxString isPinAvailable = "no".obs;
  RxString selectedAddress = "".obs;
  RxString addressMessage = "".obs;
  RxBool addressStatus = false.obs;
  DateTime? _selectedDate;

  @override
  void onInit() {
    print(" address initialization ???????");
    super.onInit();
  }

  Future<void> loadAddress(User user) async {
    if (user.id!.isEmpty || user.id == "0" || user.id == "null") {
      loadAddresStatus.value = "Not logged in";
      return;
    }

    loadAddresStatus.value = "loading";
    try {
      final response = await MyApi.loadAddress(user);
      _handleAddressResponse(response);
    } catch (e) {
      loadAddresStatus.value = "Error loading addresses";
      _logError("loadAddress", e);
    }
  }

  void _handleAddressResponse(http.Response response) {
    if (response.statusCode == 200) {
      addresses.clear();
      print(response.body);
      final data = jsonDecode(response.body);
      if (data['res'] == "success") {
        loadAddresStatus.value = "done";
        checkoutController.selectedAddress.value = new Address();
        addresses.value = (data['data'] as List).map<Address>((e) {
          if (e["is_selected"] == '1') {
            checkoutController.selectedAddress.value = Address.fromJson(e);
          }
          return Address.fromJson(e);
        }).toList();

        if (addresses.isEmpty) {
          loadAddresStatus.value = "Address not found";
          checkoutController.showNewAddressForm.value = true;
        } else {
          selectedAddress.value =
              "${checkoutController.selectedAddress.value.name}, ${checkoutController.selectedAddress.value.city}, ${checkoutController.selectedAddress.value.pincode}";
        }
      } else {
        loadAddresStatus.value = data['msg'] ?? "Something went wrong";
      }
    } else {
      loadAddresStatus.value = "Server error";
    }
  }

  Future<void> saveData(Address address) async {
    if (address == null) return;

    addressMessage.value = "Saving...";
    try {
      final response = await MyApi.saveAddress(address);
      _handleSaveResponse(response);
    } catch (e) {
      addressStatus.value = false;
      addressMessage.value = "Failed to save address";
      _logError("saveData", e);
    }
  }

  void _handleSaveResponse(http.Response response) {
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      addressStatus.value = data['res'] == "success";
      addressMessage.value = data['msg'] ?? "Address saved";

      if (addressStatus.value) {
        addresses.value = (data['data'] as List)
            .map<Address>((e) => Address.fromJson(e))
            .toList();
      }
    } else {
      addressStatus.value = false;
      addressMessage.value = "Server error";
    }
  }

  Future<void> updateData(Address address) async {
    addressMessage.value = "Updating...";
    try {
      final response = await MyApi.updateAddress(address);
      _handleUpdateResponse(response);
    } catch (e) {
      addressStatus.value = false;
      addressMessage.value = "Failed to update address";
      _logError("updateData", e);
    }
  }

  void _handleUpdateResponse(http.Response response) {
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = jsonDecode(response.body);
      addressStatus.value = data['res'] == "success";
      addressMessage.value = data['msg'] ?? "Address updated";

      if (addressStatus.value) {
        addresses.value = (data['data'] as List)
            .map<Address>((e) => Address.fromJson(e))
            .toList();
      }
    } else {
      addressStatus.value = false;
      addressMessage.value = "Server error";
    }
  }

  Future<void> availablePincodes() async {
    pincodeStatus.value = "Loading...";
    try {
      final response = await MyApi.getAvailablePincodes();
      _handlePincodeResponse(response);
    } catch (e) {
      pincodeStatus.value = "Failed to load pincodes";
      _logError("availablePincodes", e);
    }
  }

  void _handlePincodeResponse(http.Response response) {
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['res'] == "success") {
        availablePincodesList.value = (data['data'] as List)
            .map<Pincode>((e) => Pincode.fromJson(e))
            .toList();
        pincodeStatus.value = "Done";
      } else {
        pincodeStatus.value = data['msg'] ?? "Failed to load pincodes";
      }
    } else {
      pincodeStatus.value = "Server error";
    }
  }

  Future<void> deleteAddress(Address address) async {
    try {
      final user = User()..id = signinController.id.toString();
      final response = await MyApi.deleteAddress(user, address);
      _handleDeleteResponse(response);
    } catch (e) {
      _logError("deleteAddress", e);
    }
  }

  void _handleDeleteResponse(http.Response response) {
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['res'] == "success") {
        addresses.value = (data['data'] as List)
            .map<Address>((e) => Address.fromJson(e))
            .toList();
      }
    }
  }

  Future<void> checkpinAvailability(String pincode) async {
    isPinAvailable.value = "Checking...";
    try {
      final response = await MyApi.checkpinAvailability(pincode);
      _handlePinCheckResponse(response);
    } catch (e) {
      isPinAvailable.value = "Failed to check pincode";
      _logError("checkpinAvailability", e);
    }
  }

  void _handlePinCheckResponse(http.Response response) {
    if (response.statusCode == 200) {
      print("---------<<>><<>>${response.body}");
      final data = jsonDecode(response.body);
      isPinAvailable.value = data["is_available"] == "yes" ? "yes" : "no";
    } else {
      isPinAvailable.value = "Failed";
    }
  }

  void showDatePickerDialog() {
    Get.dialog(
      Dialog(
        child: Container(
          height: 300,
          color: Colors.grey.shade900,
          child: Column(
            children: [
              _buildDialogHeader(),
              _buildDatePicker(),
              _buildDialogButtons(),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildDialogHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Pick Date",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 30, color: Colors.black),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return SizedBox(
      height: 150,
      child: DatePickerWidget(
        looping: false,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        dateFormat: "dd-MMMM-yyyy",
        onChange: (DateTime newDate, _) => _selectedDate = newDate,
        pickerTheme: DateTimePickerTheme(
          backgroundColor: Colors.grey.shade900,
          itemTextStyle: const TextStyle(color: Colors.white, fontSize: 19),
          dividerColor: Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget _buildDialogButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: _buildDialogButton("Cancel", () => Get.back()),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildDialogButton(
              "Confirm",
              () => _handleDateSelection(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: const Size.fromHeight(40),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }

  void _handleDateSelection() {
    if (_selectedDate != null) {
      Get.back();
      dateController.value.text =
          DateFormat('dd-MMM-yyyy').format(_selectedDate!);
    }
  }

  void _logError(String methodName, dynamic error) {
    print("Error in $methodName: $error");
    if (error is Error) {
      print("Stack trace: ${error.stackTrace}");
    }
  }
}
