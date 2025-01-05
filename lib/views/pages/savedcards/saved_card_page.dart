import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedCardPage extends StatelessWidget {
  const SavedCardPage({Key? key}) : super(key: key);

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
          "Saved Cards ",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Center(
        child: Text(
          "Comming soon",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
