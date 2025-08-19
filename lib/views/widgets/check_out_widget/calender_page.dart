import 'package:Susani/consts/app_color.dart';
import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/contollers/address_controller/address_controller.dart';
import 'package:Susani/contollers/booked_date/booked_date_controller.dart';
import 'package:Susani/contollers/cart_controller/cart_controller.dart';
import 'package:Susani/contollers/checkout_controller/checkout_controller.dart';
import 'package:Susani/views/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({Key? key}) : super(key: key);

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  final checkoutController = Get.find<CheckoutController>();
  final bookedDateController = Get.put(booked_date_controller());
  final addressController = Get.find<AddressController>();
  final cartController = Get.put(CartController());

  String? _selectedServiceType;
  DateTime _firstAvailableDate = DateTime.now();
  DateTime _lastAvailableDate = DateTime.now().add(const Duration(days: 364));

  @override
  void initState() {
    super.initState();
    _initializeServiceType();
  }

  void _initializeServiceType() {
    _selectedServiceType = checkoutController.serviceType.value.isEmpty
        ? AppConstraints.type.keys.last
        : checkoutController.serviceType.value;
    _calculateInitialDates();
  }

  void _calculateInitialDates() {
    final now = DateTime.now();
    int daysToAdd = 0;

    switch (_selectedServiceType) {
      case "Urgent Service":
        daysToAdd = 0;
        break;
      case "Semi Urgent Service":
        daysToAdd = 1;
        break;
      case "General Service":
        daysToAdd = 4;
        break;
      default:
        daysToAdd = 4;
    }

    _firstAvailableDate = now.add(Duration(days: daysToAdd));
    _lastAvailableDate = now.add(const Duration(days: 364));
  }

  Future<void> _selectDate() async {
    DateTime initialDate = _firstAvailableDate;
    // Find the next available date if the initial is not available
    while (!_isDateAvailable(initialDate) &&
        initialDate.isBefore(_lastAvailableDate)) {
      initialDate = initialDate.add(const Duration(days: 1));
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: _firstAvailableDate,
      lastDate: _lastAvailableDate,
      selectableDayPredicate: (day) => _isDateAvailable(day),
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
            disabledColor: Colors.red,
          ),
          child: picker!,
        );
      },
    );

    if (pickedDate != null) {
      checkoutController.dateTime.value = pickedDate;
      checkoutController.isDateSelected.value = true;
      Get.back();
    }
  }

  bool _isDateAvailable(DateTime day) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(day);
    return !bookedDateController.bookdeList.any(
      (element) => element.date == formattedDate,
    );
  }

  void _handleServiceTypeChange(String? value) {
    setState(() {
      _selectedServiceType = value;
      checkoutController.serviceType.value = value!;
      cartController.createSubtotal();
      cartController.createTotal();
      _calculateInitialDates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 32.0), // Added space before body start
        child: Column(
          children: [
            _buildPincodeInfoSection(),
            _buildServiceTypeSelection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildSaveButton(),
    );
  }

  Widget _buildPincodeInfoSection() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Urgent And Semi Urgent Services Are Available On These Pincodes Only",
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
          child: SizedBox(
            height: 40,
            child: Obx(() {
              if (addressController.pincodeStatus.value == "Loading") {
                return const LinearProgressIndicator();
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: addressController.availablePincodesList.length,
                itemBuilder: (context, index) => Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.pink.shade100,
                  ),
                  child: Text(
                    addressController.availablePincodesList[index].pincode!,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceTypeSelection() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Select Delivery Type",
              style: TextStyle(fontSize: 23),
            ),
            Obx(() {
              if (addressController.isPinAvailable.value == "Loading") {
                return const Text("Checking pincode availability");
              }

              final serviceTypes =
                  addressController.isPinAvailable.value == "yes"
                      ? AppConstraints.type
                      : AppConstraints.type_for_pin_unavailable;

              return ListView.builder(
                padding: const EdgeInsets.only(top: 1),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: serviceTypes.length,
                itemBuilder: (context, index) {
                  final key = serviceTypes.keys.elementAt(index);
                  return Card(
                    shadowColor: Colors.black,
                    elevation: 5,
                    child: ListTile(
                      title: Text(serviceTypes[key].toString()),
                      leading: Radio<String>(
                        value: key,
                        groupValue: _selectedServiceType,
                        onChanged: _handleServiceTypeChange,
                      ),
                      onTap: () => _handleServiceTypeChange(key),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return BottomAppBar(
      child: Container(
        height: 52.0,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: GestureDetector(
          onTap: _selectDate,
          child: AppButton(buttonTitle: "Save").myButton,
        ),
      ),
    );
  }
}
