import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:Susani/contollers/address_controller/address_controller.dart';
import 'package:Susani/contollers/checkout_controller/checkout_controller.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/models/Address.dart';
import '../../../contollers/cart_controller/cart_controller.dart';
import '../app_button.dart';

class AddressFormField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddressFormFieldState();
}

class _AddressFormFieldState extends State<AddressFormField> {
  final _formKey = GlobalKey<FormState>();
  final addressController = Get.find<AddressController>();
  final signinController = Get.put(SignInController());
  final checkoutController = Get.find<CheckoutController>();
  final cartController = Get.put(CartController());

  String name = "";
  String contact = "";
  String address = "";
  String city = "";
  String zip = "";
  String landmark = "";
  String state = "";
  final String addressType = "shipping"; // Hardcoded as shipping

  @override
  Widget build(BuildContext context) {
    final isEditMode = addressController.addressForEdit.value.id != null;
    final deliveryType = checkoutController.serviceType.value;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Delivery Type
            if (deliveryType.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  color: Colors.blue[50],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.local_shipping,
                            color: Colors.blue[700], size: 18),
                        const SizedBox(width: 8),
                        Text(
                          "Delivery Type: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                        Text(
                          deliveryType,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            _buildNameField(isEditMode),
            const SizedBox(height: 12),
            _buildPhoneField(isEditMode),
            const SizedBox(height: 12),
            _buildCityField(isEditMode),
            const SizedBox(height: 12),
            _buildZipField(isEditMode),
            const SizedBox(height: 12),
            _buildStateField(isEditMode),
            const SizedBox(height: 12),
            _buildLandmarkField(isEditMode),
            const SizedBox(height: 12),
            _buildAddressField(isEditMode),
            const SizedBox(height: 24),
            _buildActionButtons(isEditMode),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField(bool isEditMode) {
    return TextFormField(
      initialValue:
          isEditMode ? addressController.addressForEdit.value.name : null,
      decoration: _inputDecoration("Full Name", Icons.person_outline),
      onChanged: (value) => name = value,
      validator: (value) =>
          value?.isEmpty ?? true ? 'Please enter your name' : null,
    );
  }

  Widget _buildPhoneField(bool isEditMode) {
    return TextFormField(
      initialValue:
          isEditMode ? addressController.addressForEdit.value.contact : null,
      decoration:
          _inputDecoration("Phone Number", Icons.phone_android_outlined),
      keyboardType: TextInputType.phone,
      onChanged: (value) => contact = value,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Phone number is required';
        if (value!.length < 10) return 'Enter a valid phone number';
        return null;
      },
    );
  }

  Widget _buildCityField(bool isEditMode) {
    return TextFormField(
      initialValue:
          isEditMode ? addressController.addressForEdit.value.city : null,
      decoration:
          _inputDecoration("City/District", Icons.location_city_outlined),
      onChanged: (value) => city = value,
      validator: (value) => value?.isEmpty ?? true ? 'City is required' : null,
    );
  }

  Widget _buildZipField(bool isEditMode) {
    return TextFormField(
      initialValue:
          isEditMode ? addressController.addressForEdit.value.pincode : null,
      decoration: _inputDecoration("PIN Code", Icons.pin_drop_outlined),
      keyboardType: TextInputType.number,
      maxLength: 6,
      onChanged: (value) {
        zip = value;
        if (zip.length == 6) {
          checkoutController.getAllLandMarks(
            int.parse(signinController.id.value),
            zip,
          );
        }
      },
      validator: (value) {
        if (value?.isEmpty ?? true) return 'PIN code is required';
        if (value!.length != 6) return 'Enter 6-digit PIN code';
        return null;
      },
    );
  }

  Widget _buildStateField(bool isEditMode) {
    return TextFormField(
      initialValue:
          isEditMode ? addressController.addressForEdit.value.state : null,
      decoration: _inputDecoration("State", Icons.map_outlined),
      onChanged: (value) => state = value,
      validator: (value) => value?.isEmpty ?? true ? 'State is required' : null,
    );
  }

  Widget _buildLandmarkField(bool isEditMode) {
    if (cartController.cartItems.first.type != "ecom") {
      return Obx(() {
        // If in edit mode and no landmarks loaded yet, show loading
        if (isEditMode &&
            checkoutController.landmarknames.isEmpty &&
            addressController.addressForEdit.value.pincode?.length == 6) {
          return const LinearProgressIndicator();
        }

        // Show dropdown if we have landmarks
        if (checkoutController.landmarknames.isNotEmpty) {
          // Initialize dropdown value in edit mode
          if (isEditMode &&
              checkoutController.landmarkDropDownValue.value.isEmpty) {
            checkoutController.landmarkDropDownValue.value =
                addressController.addressForEdit.value.landmark ?? '';
          }

          return DropdownButtonFormField<String>(
            value: checkoutController.landmarkDropDownValue.value.isNotEmpty
                ? checkoutController.landmarkDropDownValue.value
                : checkoutController.landmarknames.isNotEmpty
                    ? checkoutController.landmarknames[0]
                    : null,
            decoration: _inputDecoration("Landmark", Icons.place_outlined),
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            items: checkoutController.landmarknames.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                checkoutController.landmarkDropDownValue.value = newValue!;
                landmark = newValue;
              });
            },
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please select a landmark' : null,
          );
        }

        // Fallback to text field
        return TextFormField(
          readOnly: true,
          initialValue: isEditMode
              ? addressController.addressForEdit.value.landmark
              : null,
          decoration: _inputDecoration("Landmark", Icons.place_outlined),
          onChanged: (value) => landmark = value,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Landmark is required' : null,
        );
      });
    }

    // For ecom items, always use text field
    return TextFormField(
      initialValue:
          isEditMode ? addressController.addressForEdit.value.landmark : null,
      decoration: _inputDecoration("Landmark", Icons.place_outlined),
      onChanged: (value) => landmark = value,
      validator: (value) =>
          value?.isEmpty ?? true ? 'Landmark is required' : null,
    );
  }

  Widget _buildAddressField(bool isEditMode) {
    return TextFormField(
      initialValue:
          isEditMode ? addressController.addressForEdit.value.address : null,
      decoration: _inputDecoration("Full Address", Icons.home_outlined),
      maxLines: 3,
      onChanged: (value) => address = value,
      validator: (value) =>
          value?.isEmpty ?? true ? 'Address is required' : null,
    );
  }

  Widget _buildActionButtons(bool isEditMode) {
    if (isEditMode) {
      return Row(
        children: [
          Expanded(
            child: _buildSaveButton(isEditMode),
          ),
          const SizedBox(width: 12),
          _buildDeleteButton(),
        ],
      );
    }

    return _buildSaveButton(isEditMode);
  }

  Widget _buildSaveButton(bool isEditMode) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: () => _handleSaveAction(isEditMode),
      child: Text(
        isEditMode ? "UPDATE ADDRESS" : "SAVE ADDRESS",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return SizedBox(
      width: 50,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.red[100],
        ),
        onPressed: _handleDeleteAction,
        child: Icon(FontAwesomeIcons.trash, color: Colors.red, size: 20),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      border: OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    );
  }

  void _handleSaveAction(bool isEditMode) async {
    if (!_formKey.currentState!.validate()) return;

    final address = Address()
      ..id = isEditMode ? addressController.addressForEdit.value.id : null
      ..name =
          name.isNotEmpty ? name : addressController.addressForEdit.value.name
      ..contact = contact.isNotEmpty
          ? contact
          : addressController.addressForEdit.value.contact
      ..landmark = landmark.isNotEmpty
          ? landmark
          : (checkoutController.landmarkDropDownValue.value.isNotEmpty
              ? checkoutController.landmarkDropDownValue.value
              : addressController.addressForEdit.value.landmark)
      ..state = state.isNotEmpty
          ? state
          : addressController.addressForEdit.value.state
      ..city =
          city.isNotEmpty ? city : addressController.addressForEdit.value.city
      ..pincode =
          zip.isNotEmpty ? zip : addressController.addressForEdit.value.pincode
      ..address = this.address.isNotEmpty
          ? this.address
          : addressController.addressForEdit.value.address
      ..addressType = addressType // Always set to shipping
      ..userId = signinController.id.toString();

    try {
      if (isEditMode) {
        await addressController.updateData(address);
        checkoutController.selectedAddress.value = address;
        checkoutController.selectedAddress.refresh();
        checkoutController.showNewAddressForm.value = false;
        _showSuccessDialog("Address updated successfully");
      } else {
        await addressController.saveData(address);
        checkoutController.showNewAddressForm.value = false;
        _showSuccessDialog("New address added successfully");
      }

      // Refresh addresses after save/update
      await addressController.loadAddress(signinController.user.value);
    } catch (e) {
      _showErrorDialog("Failed to save address: ${e.toString()}");
    }
  }

  void _handleDeleteAction() async {
    try {
      await addressController
          .deleteAddress(addressController.addressForEdit.value);
      checkoutController.selectedAddress.value = Address();
      checkoutController.showNewAddressForm.value = false;
      _showSuccessDialog("Address deleted successfully");

      // Refresh addresses after delete
      await addressController.loadAddress(signinController.user.value);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('${addressController.addressForEdit.value.name} deleted'),
        ),
      );
    } catch (e) {
      _showErrorDialog("Failed to delete address: ${e.toString()}");
    }
  }

  void _showSuccessDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text("Success"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              if (Get.currentRoute != "/checkoutPage") {
                Navigator.pop(context);
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("OK"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
