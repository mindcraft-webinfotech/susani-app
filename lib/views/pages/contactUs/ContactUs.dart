import 'package:flutter/material.dart';
import 'package:contactus/contactus.dart';
import 'package:get/get.dart';

class ContactUsPage extends StatefulWidget {
  ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Container(
        padding: EdgeInsets.all(30),
        child: ContactUs(
          textColor: Colors.black.withOpacity(0.7),
          companyColor: Colors.black45,
          taglineColor: Colors.black38,
          cardColor: Colors.black.withOpacity(0.1),
          logo: AssetImage('assets/images/lsd.png'),
          email: 'info@susani.com',
          companyName: 'Susani',
          phoneNumber: '+9182103 38029',
          dividerThickness: 2,
          website: 'susani.in/',
          linkedinURL: 'https://www.linkedin.com/in/abhishek-doshi-520983199/',
          tagLine: 'Laundry And Ecommerce',
          avatarRadius: 40,
        ),
      ),
    );
  }
}
