import 'package:Susani/views/pages/WebView/MyWebView.dart';
import 'package:Susani/views/pages/contactUs/ContactUs.dart';
import 'package:Susani/views/widgets/check_out_widget/calender_page.dart';
import 'package:get/get.dart';
import 'package:Susani/binding/dashboard_binding/dashboard_binding.dart';
import 'package:Susani/binding/splash_binding/splash_bindin.dart';
import 'package:Susani/utils/routes_pages/pages_name.dart';
import 'package:Susani/views/pages/Login_Signup/SignIn.dart';
import 'package:Susani/views/pages/Login_Signup/Signup.dart';
import 'package:Susani/views/pages/OrderSuccess/OrderSuccess.dart';
import 'package:Susani/views/pages/checkout/checkout_page.dart';
import 'package:Susani/views/pages/dashboard/dashboard_page.dart';

import 'package:Susani/views/pages/editprofile/edit_profile_page.dart';
import 'package:Susani/views/pages/giftcards_vouchers/gift_card_page.dart';
import 'package:Susani/views/pages/myfavourites/my_favourite_page.dart';
import 'package:Susani/views/pages/myorders/my_orders_page.dart';

import 'package:Susani/views/pages/product/category_product.dart';
import 'package:Susani/views/pages/product/product_full_view_page.dart';
import 'package:Susani/views/pages/savedcards/saved_card_page.dart';
import 'package:Susani/views/pages/shippin_address/shipping_address_page.dart';
import 'package:Susani/views/pages/splashpage/splash_page.dart';
import 'package:upgrader/upgrader.dart';

// import '../../views/pages/ecom/screens/EcomCheckout.dart';

class MyPages {
  static List<GetPage> get list => [
        GetPage(
            name: MyPagesName.splashFile,
            page: () => SplashPage(),
            binding: SplashBinding()),
        GetPage(
            name: MyPagesName.dashBoard,
            page: () => DashboardPage(),
            binding: DashboardBinding()),
        GetPage(
          name: MyPagesName.myOrders,
          page: () => MyOrdersPage(),
        ),
        GetPage(
          name: MyPagesName.myFavourites,
          page: () => MyFavouritePage(),
        ),
        GetPage(
          name: MyPagesName.shippingAddress,
          page: () => ShippingAddressPage(),
        ),
        GetPage(
          name: MyPagesName.savedCards,
          page: () => SavedCardPage(),
        ),
        GetPage(
          name: MyPagesName.giftCards,
          page: () => GiftCardPage(),
        ),
        // hide given lines by kamlesh
        // GetPage(
        //   name: MyPagesName.dashBoard,
        //   page: () => DashboardPage(),
        // ),
        GetPage(
          name: MyPagesName.editProfile,
          page: () => EditProfilePage(),
        ),

        GetPage(
          name: MyPagesName.productFullView,
          page: () => ProductFullViewPage(),
        ),
        GetPage(
          name: MyPagesName.category_product,
          page: () => CategoryProduct(),
        ),
        GetPage(
          name: MyPagesName.checkoutPage,
          page: () => CheckoutPage(),
        ),
        // GetPage(
        //       name: MyPagesName.ecom_checkoutPage,
        //       page: () => EcomCheckoutPage(),
        //     ),
        GetPage(name: MyPagesName.SignUp, page: () => SignUp()),
        GetPage(name: MyPagesName.MyWebView, page: () => MyWebView()),
        GetPage(name: MyPagesName.SignIn, page: () => SignIn()),
        GetPage(name: MyPagesName.OrderSuccess, page: () => OrderSuccess()),

        GetPage(name: MyPagesName.CalenderPage, page: () => CalenderPage()),
        GetPage(name: MyPagesName.ContctUs, page: () => ContactUsPage())
      ];
}
