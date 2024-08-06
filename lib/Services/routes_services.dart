import 'package:admin_app/Activity/DoctorDetails.dart';
import 'package:admin_app/Activity/view_image.dart';
import 'package:get/get.dart';
import '../Activity/signin.dart';
import '../Activity/splash.dart';
import '../Activity/homepage.dart';
import '../Controllers/authendication_controller.dart';
import '../Controllers/home_controller.dart';

class Routes {
  static dynamic initial = '/';
  static dynamic signin = '/signin';
  static dynamic home = '/homepage';
  static dynamic doctordetails = '/doctordetails';
}

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.initial,
      page: () => Splash(),
    ),
    GetPage(
      name: Routes.signin,
      page: () => SigninView(),
    ),
    GetPage(
      name: Routes.home,
      page: () => Homepage(),
    ),
     GetPage(
       transitionDuration: Duration(seconds: 1),
          name: Routes.doctordetails,
          page: () => DoctorDetails(),
        ),

  ];
}
