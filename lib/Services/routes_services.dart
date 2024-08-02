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
      binding: BindingsBuilder.put(() => AuthendicationController()),
    ),
    GetPage(
      name: Routes.home,
      page: () => Homepage(),
      binding: BindingsBuilder.put(() => HomeController()),
    ),

  ];
}
