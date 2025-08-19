import 'dart:io';

import 'package:Susani/consts/app_color.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/contollers/address_controller/address_controller.dart';
import 'package:Susani/contollers/checkout_controller/checkout_controller.dart';
import 'package:Susani/contollers/dashboard_controller/dashboard_controller.dart';
import 'package:Susani/contollers/edit_profile_controller/edit_profile_controller.dart';
import 'package:Susani/contollers/signin/SignInController.dart';
import 'package:Susani/models/Address.dart';
import 'package:Susani/models/User.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';
import 'package:Susani/views/widgets/address_card_design.dart';
import 'package:Susani/views/widgets/app_button.dart';
import 'package:Susani/views/widgets/check_out_widget/AddressFormFields.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EditProfilePage();
}

class _EditProfilePage extends State<EditProfilePage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController last_name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController zip = TextEditingController();
  final TextEditingController address = TextEditingController();
  var _selectedGender = "".obs;
  final TextEditingController contact = TextEditingController();
  final addressController = Get.find<AddressController>();
  var newPath = "".obs;
  final SignInController signInController = Get.put(SignInController());
  final CheckoutController checkoutController = Get.find<CheckoutController>();
  final EditProfileController editProfileController =
      Get.put(EditProfileController());
  var filepath = "";
  var networImageUrl = "";
  _EditProfilePage({Key? key}) {
    User user = signInController.user.value;
    name.text = user.name.toString() == "null" ? "" : user.name.toString();
    last_name.text =
        user.last_name.toString() == "null" ? "" : user.last_name.toString();
    email.text = user.email.toString();
    city.text = user.city.toString();
    zip.text = user.zip.toString();
    address.text = user.address.toString();
    contact.text =
        user.contact.toString() == "null" ? "" : user.contact.toString();
    // print("------------------" + user.gender!);
    if (user.gender!.toLowerCase() == AppConstraints.Gender[0].toLowerCase()) {
      _selectedGender.value = AppConstraints.Gender[0];
    } else if (user.gender!.toLowerCase() ==
        AppConstraints.Gender[1].toLowerCase()) {
      _selectedGender.value = AppConstraints.Gender[1];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            )),
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    child: Stack(children: [
                      Obx(
                        () => newPath.value == ""
                            ? CircleAvatar(
                                radius: 80.0,
                                backgroundImage: NetworkImage(
                                    // " "+
                                    signInController.user.value.image
                                        .toString()),
                              )
                            : CircleAvatar(
                                radius: 80.0,
                                backgroundImage: FileImage(File(newPath.value)),
                              ),
                      ),
                      InkWell(
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(type: FileType.image);
                          if (result != null) {
                            filepath = result.paths[0]!;
                            print(filepath);
                          } else {
                            print("User cancelled the operation");
                          }

                          // File? croppedFile = await ImageCropper.cropImage(
                          //     sourcePath: filepath,
                          //     aspectRatioPresets: [
                          //       CropAspectRatioPreset.square,
                          //       CropAspectRatioPreset.ratio3x2,
                          //       CropAspectRatioPreset.original,
                          //       CropAspectRatioPreset.ratio4x3,
                          //       CropAspectRatioPreset.ratio16x9
                          //     ],
                          //     androidUiSettings: AndroidUiSettings(
                          //         toolbarTitle: 'Cropper',
                          //         toolbarColor: Colors.deepOrange,
                          //         toolbarWidgetColor: Colors.white,
                          //         initAspectRatio:
                          //             CropAspectRatioPreset.original,
                          //         lockAspectRatio: false),
                          //     iosUiSettings: IOSUiSettings(
                          //       minimumAspectRatio: 1.0,
                          //     ));

                          // filepath = croppedFile!.path;
                          newPath.value = filepath;
                          print(filepath);
                        },
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: () async {},
                            child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: Card(
                                  color: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Container(
                                      width: 35,
                                      height: 35,
                                      child: const Icon(
                                        Icons.photo,
                                        color: Colors.white,
                                      )),
                                )),
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text("User Information",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: name,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                            labelText: "First Name",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 12)),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: last_name,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                            labelText: "Last Name",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 12)),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),

                TextField(
                  readOnly: false,
                  controller: email,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                      labelText: "Email Address",
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 12)),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Obx(
                //   () =>
                Row(
                  children: [
                    // Expanded(
                    //     child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   children: [
                    //     Column(
                    //       children: [
                    //         Radio<String>(
                    //           value: AppConstraints.Gender[0],
                    //           groupValue: _selectedGender.value,
                    //           onChanged: (String? value) {
                    //             _selectedGender.value = value!;
                    //           },
                    //         ),
                    //         Text(AppConstraints.Gender[0].toString()),
                    //       ],
                    //     ),
                    //     Column(
                    //       children: [
                    //         Radio<String>(
                    //           value: AppConstraints.Gender[1],
                    //           groupValue: _selectedGender.value,
                    //           onChanged: (String? value) {
                    //             _selectedGender.value = value!;
                    //           },
                    //         ),
                    //         Text(AppConstraints.Gender[1].toString()),
                    //       ],
                    //     ),
                    //   ],
                    // )),
                    // SizedBox(
                    //   width: 20,
                    // ),
                    Expanded(
                      child: TextField(
                        controller: contact,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                            labelText: "Phone ",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 12)),
                      ),
                    ),
                  ],
                ),
                // )
                const SizedBox(
                  height: 20,
                ),
                // Row(
                //   children: [
                //     Expanded(
                //         child: TextField(
                //       controller: city,
                //       decoration: InputDecoration(
                //           labelText: "City ",
                //           labelStyle: TextStyle(
                //               fontWeight: FontWeight.w700,
                //               color: Colors.black,
                //               fontSize: 12)),
                //     )),
                //     SizedBox(
                //       width: 20,
                //     ),
                //     Expanded(
                //       child: TextField(
                //         controller: zip,
                //         decoration: InputDecoration(
                //             labelText: "ZIP ",
                //             labelStyle: TextStyle(
                //                 fontWeight: FontWeight.w700,
                //                 color: Colors.black,
                //                 fontSize: 12)),
                //       ),
                //     ),
                //   ],
                // ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: TextField(
                //         controller: address,
                //         decoration: InputDecoration(
                //             labelText: "Address ",
                //             labelStyle: TextStyle(
                //                 fontWeight: FontWeight.w700,
                //                 color: Colors.black,
                //                 fontSize: 12)),
                //       ),
                //     ),
                //   ],
                // ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Text(
                            addressController.addresses.length.toString() != "0"
                                ? "Addresses : " +
                                    addressController.addresses.length
                                        .toString()
                                : "Addresses ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                AppColor.bottomitemColor2)),
                        onPressed: () {
                          addressController.addressForEdit.value =
                              new Address();
                          modal(context);
                        },
                        child: Text("SHIPPING ADDRESS +",
                            style: TextStyle(
                                color: AppColor.backgroundColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => ListView.builder(
                      itemCount: addressController.addresses.length == 0
                          ? 1
                          : addressController.addresses.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          addressController.addresses.length > 0
                              ? AddressCardDesign(
                                  context: context,
                                  index: index,
                                  callback: (address) {
                                    addressController.addressForEdit.value =
                                        address;
                                    modal(context);
                                  }).addressCardDesign
                              : Container(
                                  child: Center(
                                    child: Text(addressController.status.value),
                                  ),
                                )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                      onTap: () {
                        User user = signInController.user.value;
                        user.name = name.text.toString();
                        user.last_name = last_name.text.toString();
                        user.contact = contact.text.toString();
                        user.email = email.text.toString();
                        // bool emailValid = RegExp(
                        //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        //     .hasMatch(user.email!);
                        // user.city = city.text.toString();
                        // user.zip = zip.text.toString();
                        //  user.address = address.text.toString();
                        // if (emailValid) {
                        user.gender = _selectedGender.value;
                        user.selected_address_id = int.parse(
                            checkoutController.selectedAddress.value.id!);
                        var oldpic = "";
                        if (user.image != "" || user.image != "null") {
                          oldpic = user.image.toString();
                        }

                        // print(user.name.toString() +
                        // ":" +
                        // user.last_name.toString() +
                        // "" +
                        // user.contact.toString() +
                        // ":" +
                        // user.email.toString() +
                        // ":" +
                        // user.gender.toString() +
                        // ":" +
                        // user.selected_address_id.toString());

                        editProfileController.editProfile(user,
                            oldPic: oldpic, newpic: filepath);
                        // } else {
                        //   Get.snackbar("Alert", "Please enter valid email",
                        //       icon: Icon(Icons.person, color: Colors.white),
                        //       snackPosition: SnackPosition.BOTTOM,
                        //       colorText: Colors.white,
                        //       backgroundColor: Colors.black);
                        // }
                      },
                      child: Obx(
                        () => AppButton(
                                buttonTitle:
                                    editProfileController.message.value ==
                                            "running"
                                        ? "Saving data.."
                                        : "Save")
                            .myButton,
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  modal(BuildContext context, {Address? data}) {
    if (data != null) {
      showModalBottomSheet(
          elevation: 15,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          context: context,
          builder: (context) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: new Container(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text("New Shipping Address",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 20)),
                          )
                        ],
                      ),
                      AddressFormField(),
                    ],
                  ),
                ),
              ),
            );
          });
    } else {
      showModalBottomSheet(
          enableDrag: true,
          isScrollControlled: true,
          elevation: 15,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          context: context,
          builder: (context) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: new Container(
                height: Get.height - 100,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                                addressController.addressForEdit.value.id ==
                                        null
                                    ? "New Shipping Address"
                                    : "Update Shipping Address",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 20)),
                          )
                        ],
                      ),
                      AddressFormField(),
                    ],
                  ),
                ),
              ),
            );
          });
    }
  }
}
