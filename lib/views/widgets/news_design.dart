import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Susani/consts/app_color.dart';
import 'package:Susani/consts/app_constraints.dart';
import 'package:Susani/models/news.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';

class NewsDesign {
  BuildContext context;
  News news;
  NewsDesign({required this.context, required this.news});
  Padding get newsCard => Padding(
        padding: EdgeInsets.only(top: 5),
        child: Container(
          //padding: EdgeInsets.all(5),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Get.toNamed(MyPagesName.newsfullpage,
                      arguments: <dynamic>[news.id, news.title]);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 100,
                      height: 90,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: FadeInImage.assetNetwork(
                          placeholder: "assets/icon/icon.png",
                          image: AppConstraints.IMAGE_URL + news.image!,
                          fit: BoxFit.fill,
                        ),
                      ),
                      decoration: BoxDecoration(
                          /*       boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade400,
                                spreadRadius: 2,
                                blurRadius: 4)
                          ], */

                          /*         image: DecorationImage(
                            image: NetworkImage(
                                AppConstraints.IMAGE_URL + news.image!),
                            fit: BoxFit.fill,
                          ), */
                          borderRadius: BorderRadius.circular(0)),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${news.title}",
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.account_circle,
                                color: AppColor.iconColor2,
                                size: 23,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: Text(
                                  "${news.userName}. ${news.dataTime}",
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                height: 2,
                thickness: 1,
              ),
            ],
          ),
        ),
      );
}
