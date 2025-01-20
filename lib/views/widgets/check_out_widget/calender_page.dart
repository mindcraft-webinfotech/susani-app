import 'package:Susani/consts/app_color.dart';
import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/contollers/address_controller/address_controller.dart';
import 'package:Susani/contollers/booked_date/booked_date_controller.dart';
import 'package:Susani/contollers/checkout_controller/checkout_controller.dart';
import 'package:Susani/views/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../contollers/cart_controller/cart_controller.dart';

class CalenderPage extends StatefulWidget {
  CalenderPage({Key? key}) : super(key: key);

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  DateTime? _selectedDay;
  DateTime? _focusedDay;
  var isMched = true.obs;
  var date = new DateTime.now();

  Set<String>? unselectableDates;
  static var controller = Get.put(CheckoutController());
  var bookeddate_controller = Get.put(booked_date_controller());
  var addressController = Get.put((AddressController()));
  var cartController = Get.put(CartController());
  String? _character = controller.serviceType.value == ""
      ? AppConstraints.type.keys.last
      : controller.serviceType.value;
  var firstdate = new DateTime.now().obs;
  var lastDate = new DateTime.now().obs;

  @override
  void initState() {
    // controller.serviceType.value =
    //     AppConstraints.type_for_pin_unavailable.values.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 52.0,
            width: double.maxFinite,
            decoration: BoxDecoration(
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(20.0))),
            child: Container(
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () async {
                        if (controller.serviceType.value == "Urgent Service") {
                          date = new DateTime.now();
                          var i = 0;
                          var check = true;
                          String pdate;

                          while (check) {
                            if (bookeddate_controller.bookdeList.length > 0) {
                              bookeddate_controller.bookdeList
                                  .forEach((element) {
                                pdate = DateFormat('yyyy-MM-dd')
                                    .format(date.add(Duration(days: i)));
                                print(element.date.toString());
                                if (element.date == pdate) {
                                  i++;
                                  pdate = DateFormat('yyyy-MM-dd')
                                      .format(date.add(Duration(days: i)));
                                  check = false;
                                } else {
                                  check = false;
                                }
                              });
                            } else {
                              check = false;
                            }
                          }

                          firstdate.value = date.add(Duration(days: i));
                          // firstdate.value = date.add(Duration(days: 0));
                          lastDate.value = date.add(Duration(days: 364));
                        } else if (controller.serviceType.value ==
                            "Semi Urgent Service") {
                          date = new DateTime.now();
                          var i = 1;
                          var check = true;
                          String pdate;
                          while (check) {
                            if (bookeddate_controller.bookdeList.length > 0) {
                              bookeddate_controller.bookdeList
                                  .forEach((element) {
                                pdate = DateFormat('yyyy-MM-dd')
                                    .format(date.add(Duration(days: i)));

                                if (element.date == pdate) {
                                  i++;
                                  pdate = DateFormat('yyyy-MM-dd')
                                      .format(date.add(Duration(days: i)));
                                  check = true;
                                } else {
                                  check = false;
                                }
                              });
                            } else {
                              check = false;
                            }
                          }
                          firstdate.value = date.add(Duration(days: i));
                          lastDate.value = date.add(Duration(days: 364));
                        } else if (controller.serviceType.value ==
                            "General Service") {
                          date = new DateTime.now();
                          var i = 4;
                          var check = true;
                          String pdate;
                          while (check) {
                            if (bookeddate_controller.bookdeList.length > 0) {
                              bookeddate_controller.bookdeList
                                  .forEach((element) {
                                pdate = DateFormat('yyyy-MM-dd')
                                    .format(date.add(Duration(days: i)));

                                if (element.date == pdate) {
                                  i++;
                                  pdate = DateFormat('yyyy-MM-dd')
                                      .format(date.add(Duration(days: i)));
                                  check = true;
                                } else {
                                  check = false;
                                }
                              });
                            } else {
                              check = false;
                            }
                          }
                          firstdate.value = date.add(Duration(days: i));

                          // firstdate.value = date.add(Duration(days: 4));
                          lastDate.value = date.add(Duration(days: 364));
                        } else {
                          print("object---" + controller.serviceType.value);
                        }
                        final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: firstdate.value,
                            firstDate: firstdate.value,
                            selectableDayPredicate: (day) {
                              bool b = true;
                              String pdate =
                              DateFormat('yyyy-MM-dd').format(day);

                              for (var element
                              in bookeddate_controller.bookdeList) {
                                if (pdate == element.date.toString()) {
                                  b = false;
                                  break;
                                } else {
                                  b = true;
                                }
                              }

                              return b;
                            },
                            lastDate: lastDate.value,
                            builder: (context, picker) {
                              return Theme(
                                data: ThemeData.dark().copyWith(
                                    colorScheme: ColorScheme.dark(
                                      primary: Colors.white,
                                      onPrimary: Colors.black,
                                      surface: AppColor.bottomitemColor1,
                                      onSurface: Colors.white,
                                    ),
                                    dialogBackgroundColor: AppColor.greyColor,
                                    disabledColor: Colors.red),
                                child: picker!,
                              );
                            }).then((selectedDate) {
                          if (selectedDate != null) {
                            controller.dateTime.value = selectedDate;
                            Get.back();
                            controller.continued();
                          }
                        });
                      },
                      child: AppButton(buttonTitle: "Save").myButton),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "Urgent And Semi Urgent Services Are Available On These Pincodes Only"
                                      .toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 10),
                          child: Container(
                            height: 40,
                            child: Obx(
                                  () =>
                              addressController.pincode_status.value ==
                                  "Loading"
                                  ? Container(
                                child: LinearProgressIndicator(),
                              )
                                  : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  // physics: NeverScrollableScrollPhysics(),
                                  itemCount: addressController
                                      .available_Pincodes.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                            padding: EdgeInsets.all(5),
                                            margin: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    5),
                                                color:
                                                Colors.pink.shade100),
                                            child: Text(
                                                "${addressController
                                                    .available_Pincodes[index]
                                                    .pincode}")));
                                  }),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ],
                  //         ),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Text(
                          "Select Delivery Type",
                          style: TextStyle(fontSize: 23),
                        ),
                        Column(
                          children: <Widget>[
                            Obx(
                                  () =>
                              addressController.isPinAvailable.value ==
                                  "Loading"
                                  ? Container(
                                child:
                                Text("Checking pincode availability"),
                              )
                                  : addressController.isPinAvailable.value ==
                                  "yes"
                                  ? ListView.builder(
                                  padding: EdgeInsets.only(top: 1),
                                  physics:
                                  NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: AppConstraints.type.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      shadowColor: Colors.black,
                                      elevation: 5,
                                      child: ListTile(
                                        title: Text(AppConstraints.type[
                                        AppConstraints.type.keys
                                            .elementAt(index)]
                                            .toString()),
                                        leading: Radio<String>(
                                          value: AppConstraints
                                              .type.keys
                                              .elementAt(index),
                                          groupValue: _character,
                                          onChanged:
                                              (String? value) async {
                                            setState(() {
                                              _character = value;
                                              controller.serviceType
                                                  .value = _character!;
                                              cartController
                                                  .createSubtotal();
                                              cartController
                                                  .createTotal();

                                              if (_character ==
                                                  "Urgent Service") {
                                                date =
                                                new DateTime.now();
                                                firstdate.value =
                                                    date.add(Duration(
                                                        days: 0));
                                                lastDate.value =
                                                    date.add(Duration(
                                                        days: 364));
                                              } else if (_character ==
                                                  "Semi Urgent Service") {
                                                date =
                                                new DateTime.now();
                                                firstdate.value =
                                                    date.add(Duration(
                                                        days: 1));
                                                lastDate.value =
                                                    date.add(Duration(
                                                        days: 364));
                                              } else if (_character ==
                                                  "General Service") {
                                                date =
                                                new DateTime.now();
                                                firstdate.value =
                                                    date.add(Duration(
                                                        days: 4));
                                                lastDate.value =
                                                    date.add(Duration(
                                                        days: 364));
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  })
                                  : ListView.builder(
                                  padding: EdgeInsets.only(top: 1),
                                  physics:
                                  NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: AppConstraints
                                      .type_for_pin_unavailable.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      shadowColor: Colors.black,
                                      elevation: 5,
                                      child: ListTile(
                                        title: Text(AppConstraints
                                            .type_for_pin_unavailable[
                                        AppConstraints
                                            .type_for_pin_unavailable
                                            .keys
                                            .elementAt(index)]
                                            .toString()),
                                        leading: Radio<String>(
                                          value: AppConstraints
                                              .type_for_pin_unavailable
                                              .keys
                                              .elementAt(index),
                                          groupValue: _character,
                                          onChanged:
                                              (String? value) async {
                                            setState(() {
                                              _character = value;
                                              controller.serviceType
                                                  .value = _character!;
                                              cartController
                                                  .createTotal();
                                              if (_character ==
                                                  AppConstraints
                                                      .type_for_pin_unavailable
                                                      .keys
                                                      .first) {
                                                addressController
                                                    .availablePincodes();
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }
}
