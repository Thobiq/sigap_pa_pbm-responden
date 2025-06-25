import 'package:flutter/material.dart';
import '../../features/authentication/view/login_view.dart';
import '../../features/authentication/view/register_view.dart';
import '../../features/home/view/home_view.dart';
import '../../features/profile/view/profile_view.dart';
import '../../features/splash/view/splash_screen.dart';
import '../../features/setting/view/setting_view.dart';
import '../../features/lanjutan/view/lanjutan_view.dart';


class AppRouter {
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';
  static const String settingRoute = '/setting';
  static const String lanjutanRoute = '/lanjutan';


  static Route<dynamic> onGenerateRoute(RouteSettings settings){
    switch (settings.name){
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case registerRoute:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case lanjutanRoute:
        return MaterialPageRoute(builder: (_) => const LanjutanView());
      case homeRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const HomeView();
          }
        );
      case profileRoute:
        return MaterialPageRoute(builder: (_) => const ProfileView());
      case settingRoute:
        return MaterialPageRoute(builder: (_) => const SettingView());
      default:
        return _errorRoute();

    }
  }
}

Route<dynamic> _errorRoute(){
  return MaterialPageRoute(builder: (_){
    return Scaffold(
      body: const Center(
        child: Text('Page not found'),
      ),
    );
  });
}