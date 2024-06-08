import 'package:get/get.dart';
import 'package:task_maids/Screen/loginscreen.dart';
import 'package:task_maids/Screen/signupuser.dart';
import 'package:task_maids/Screen/todoview.dart';
import 'routesname.dart';

class AppRoutes {
  static Set<GetPage> appRoutes() {
    return {
      GetPage(
        name: Routesname.loginScreen,
        page: () => LoginScreen(),
      ),
      GetPage(
        name: Routesname.signup,
        page: () => RegistrationScreen(),
      ),
      GetPage(
        name: Routesname.homeScreen,
        page: () => TodoViewScreen(),
      ),
    };
  }
}
