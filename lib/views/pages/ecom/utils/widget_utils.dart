import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../consts/app_constraints.dart';

import 'Constant.dart';
import 'SizeConfig.dart';
import '../utils/color_data.dart';

double appbarPadding = getAppBarPadding();
double marginPopular = appbarPadding;
double getAppBarPadding() {
  double appbarPadding = Constant.getWidthPercentSize(4);
  return appbarPadding;
}
double getEditHeight() {
  return Constant.getHeightPercentSize(6);
}
Widget getSvgImage(IconData image, double size, {Color? color}) {
  return Icon(
    image,
    color: color,
    size:  size,
    // fit: BoxFit.fitHeight,
  );
}

Widget getSpace(double verSpace) {
  return SizedBox(
    height: verSpace,
  );
}

double getEdtIconSize() {
  double edtIconSize = Constant.getPercentSize(getEditHeight(), 45);
  return edtIconSize;
}

double getLoginTitleFontSize() {
  double edtIconSize = Constant.getHeightPercentSize(3.3);
  return edtIconSize;
}

double getEdtTextSize() {
  double edtIconSize = Constant.getPercentSize(getEditHeight(), 30);
  return edtIconSize;
}

Widget getHorSpace(double verSpace) {
  return SizedBox(
    width: verSpace,
  );
}

Widget getCustomText(String text, Color color, int maxLine, TextAlign textAlign,
    FontWeight fontWeight, double textSizes) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: textSizes,
        fontStyle: FontStyle.normal,
        color: color,
        fontFamily: Constant.assetImagePath,
        fontWeight: fontWeight),
    maxLines: maxLine,
    textAlign: textAlign,
  );
}

Widget getRupeeText(String text, Color color, int maxLine, TextAlign textAlign,
    FontWeight fontWeight, double textSizes) {
  return Text(
    "₹" + text,
    overflow: TextOverflow.ellipsis,

    style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: textSizes,
        fontStyle: FontStyle.normal,
        color: color,
        fontFamily: Constant.assetImagePath,
        fontWeight: fontWeight),
    maxLines: maxLine,
    textAlign: textAlign,
  );
}

double getCorners() {
  return Constant.getPercentSize(getEditHeight(), 25);
}

double getCornerSmoothing() {
  return 0.5;
}
getTitleWidget(double padding, String txt, Function function) {
  double screenHeight = SizeConfig.safeBlockVertical! * 100;
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: Constant.getPercentSize(screenHeight, 1.2)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getCustomText(txt, fontBlack, 1, TextAlign.start, FontWeight.w500,
            Constant.getPercentSize(screenHeight, 3)),
        InkWell(
          onTap: () {
            function();
          },
          child: getCustomText("View all", primaryColor, 1, TextAlign.start,
              FontWeight.w400, Constant.getPercentSize(screenHeight, 2.3)),
        )
      ],
    ),
  );

}

Widget getCustomTextWithStrike(String text, Color color, int maxLine,
    TextAlign textAlign, FontWeight fontWeight, double textSizes) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
        fontSize: textSizes,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.lineThrough,
        color: color,
        fontFamily: Constant.assetImagePath,
        fontWeight: fontWeight),
    maxLines: maxLine,
    textAlign: textAlign,
  );
}


Widget getCustomTextWithStrikeRupee(String text, Color color, int maxLine,
    TextAlign textAlign, FontWeight fontWeight, double textSizes) {
  return Text(
    "₹" + text,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
        fontSize: textSizes,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.lineThrough,
        color: color,
        fontFamily: Constant.assetImagePath,
        fontWeight: fontWeight),
    maxLines: maxLine,
    textAlign: textAlign,
  );
}



Widget getDefaultHeader(BuildContext context,
    String title,
    Function function,
    ValueChanged<String> funChange,
    {bool withFilter = false,
      Function? filterFun,
      bool isShowBack = true}) {
  double size = Constant.getHeightPercentSize(6);
  double appbarPadding = getAppBarPadding();
  double toolbarHeight = Constant.getToolbarHeight(context);
  return Container(
    color: primaryColor,
    child: Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
              top: Constant.getToolbarTopHeight(context),
              left: appbarPadding,
              right: appbarPadding),
          height: toolbarHeight,
          child: Stack(
            children: [
              Visibility(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: getLeadingIcon(context, function,Colors.white)),
                visible: isShowBack,
              ),
              Center(
                child: getCustomText(title, Colors.white, 1, TextAlign.center,
                    FontWeight.normal, Constant.getPercentSize(size, 50)),
              )
              // Image.asset(Constant.assetImagePath + "back11.png",
              //     height: Constant.getPercentSize(toolbarHeight, 90),
              //     fit: BoxFit.cover,
              //     width: Constant.getPercentSize(toolbarHeight, 90)))
              // getSvgImage(
              //     "back.svg", Constant.getPercentSize(toolbarHeight, 90)),)
            ],
          ),
        ),
      ],
    ),
  );
}

Widget getLeadingIcon(BuildContext context, Function function,Color color) {
  double toolbarHeight = Constant.getHeightPercentSize(4);
  // double toolbarHeight = Constant.getToolbarHeight(context);
  return InkWell(
      onTap: () {
        function();
      },
      child: Icon(
    Icons.arrow_back,
        size: toolbarHeight,
        color: color,
        // height: Constant.getPercentSize(toolbarHeight, 30),
       )

  );
}

Widget getEmptyWidget(String image, String title, String description,
    String btnTxt, Function function,
    {bool withButton = true}) {
  double screenHeight = SizeConfig.safeBlockVertical! * 100;
  double width = Constant.getWidthPercentSize(45);
  double height = Constant.getPercentSize(screenHeight, 8.2);
  return Container(
    width: double.infinity,
    color: backgroundColor,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        getSvgImage(Icons.add_business_rounded, Constant.getPercentSize(screenHeight, 25),color: primaryColor),
        SizedBox(
          height: Constant.getPercentSize(screenHeight, 3.2),
        ),
        getCustomTextWithoutMaxLine(title, primaryColor, TextAlign.center,
            FontWeight.bold, Constant.getPercentSize(screenHeight, 3.4)),
        getSpace(Constant.getPercentSize(screenHeight, 1.2)),
        getCustomTextWithoutMaxLine(
          description,
          primaryColor,
          TextAlign.center,
          FontWeight.w400,
          Constant.getPercentSize(screenHeight, 2.4),
        ),
        getSpace(Constant.getPercentSize(screenHeight, 3)),
        (withButton)
            ? InkWell(
          onTap: () {
            function();

          },
          child: Container(
              margin: EdgeInsets.only(
                  top: Constant.getPercentSize(height, 4)),
              width: width,
              height: height,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: primaryColor, width: 1.5),
                  borderRadius: BorderRadius.circular(Constant.getPercentSize(height, 25)),
                ),
              ),
              child: Center(
                child: getCustomTextWithoutMaxLine(
                    btnTxt,
                    primaryColor,
                    TextAlign.center,
                    FontWeight.w700,
                    Constant.getPercentSize(width,9)),
              )),
        )
            : getSpace(0)
      ],
    ),
  );
}


Widget getCustomTextWithoutMaxLine(String text, Color color,
    TextAlign textAlign, FontWeight fontWeight, double textSizes,
    {txtHeight = 1.5}) {
  return Text(
    text,
    style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: textSizes,
        fontStyle: FontStyle.normal,
        color: color,
        fontFamily: Constant.assetImagePath,
        height: txtHeight,
        fontWeight: fontWeight),
    textAlign: textAlign,
  );
}

Widget getProductListCardGrid(String images, String title,  String price,
    String oldPrice, int index, double popularWidth, double popularHeight ,double carousalHeight ) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
          Radius.circular(
              Constant.getPercentSize(
                  carousalHeight, 8))),
    ),
    height: popularHeight,
    width: popularWidth,
    padding: EdgeInsets.all(
        Constant.getPercentSize(
            popularHeight, 3.3)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment
          .start,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            height: double.infinity,

            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(
                      Radius.circular(
                          Constant.getPercentSize(
                              popularHeight, 5))),
                  child:

                  ImageWithShimmer(
                      imageUrl: AppConstraints.PRODUCT_URL + images!,
                      height: double.infinity,
                      width: double.infinity,
                      Fit: BoxFit.cover,),
                ),
                // Align(
                //   alignment: Alignment.topRight,
                //   child: getFavWidget(
                //       popularHeight,
                //       index == 0,
                //       EdgeInsets.all(
                //           Constant.getPercentSize(
                //               popularWidth, 3))),
                // )
                 ],
            ),
          ),
          flex: 1,
        ),
        getSpace(
            Constant.getPercentSize(
                popularHeight, 4)),
        getCustomText(
            title?? "",
            fontBlack,
            2,
            TextAlign.start,
            FontWeight.bold,
            Constant.getPercentSize(
                popularHeight, 4)),
        getSpace(
            Constant.getPercentSize(
                popularHeight, 2.5)),
        Row(
          children: [
            getRupeeText(
                price ?? "",
                fontBlack,
                1,
                TextAlign.start,
                FontWeight.w400,
                Constant.getPercentSize(
                    popularHeight, 5.5)),
          Spacer(),
            ((oldPrice
                .toString() ?? "").isNotEmpty)
                ? getCustomTextWithStrikeRupee(
                    oldPrice ?? "",
                    Colors.red,
                    1,
                    TextAlign.start,
                    FontWeight.w500,
                    Constant.getPercentSize(
                        popularHeight, 4))
                : Container()
          ],
        ),
      ],
    ),
  );
}





Widget buildShimmerEffect(BuildContext context) {
  SizeConfig().init(context);
  double screenHeight = SizeConfig.safeBlockVertical! * 100;
  double screenWidth = SizeConfig.safeBlockHorizontal! * 100;


  int crossAxisCountPopular = 2;
  double popularWidth = (screenWidth - ((crossAxisCountPopular - 1) * marginPopular)) / crossAxisCountPopular;

  return Container(
    color: Colors.grey.shade100,
    width: double.infinity,
    height: double.infinity,
    child: GridView.builder(
      padding: EdgeInsets.all(marginPopular),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCountPopular,
        crossAxisSpacing: marginPopular,
        mainAxisSpacing: marginPopular,
        childAspectRatio: popularWidth /  Constant.getPercentSize(screenHeight, 42),
      ),
      itemCount: 10, // You can adjust the number of shimmer items
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.all(8),
          ),
        );
      },
    ),
  );
}

class ImageWithShimmer extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BoxFit Fit;

  const ImageWithShimmer({
    Key? key,
    required this.imageUrl,
    required this.height,
    required this.width,
    required this.Fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      fit: Fit,
      imageUrl: imageUrl,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: width,
          height: height,
          color: Colors.grey[300],
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child:  Image.asset("assets/images/noImg.png")
      ),
    );
  }
}


