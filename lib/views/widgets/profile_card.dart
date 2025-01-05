import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ProfileCard {
  BuildContext context;
  String title;

  ProfileCard({required this.context, required this.title});

  Widget get profileCard => Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${title}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 19)
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(
              height: 2,
              thickness: 1,
            ),
          ],
        ),
      );
}
