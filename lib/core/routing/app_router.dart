import 'package:flutter/material.dart';
import '../../features/authentication/view/login_view.dart';
import '../../features/authentication/view/register_view.dart';
import '../../features/home/view/home_view.dart';
import '../../features/profile/view/profile_view.dart';


class AppRouter {
  static const String loginRoute = '/';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';




  static Route<dynamic> onGenerateRoute(RouteSettings settings){
    switch (settings.name){
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case registerRoute:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case profileRoute:
        return MaterialPageRoute(builder: (_) => const ProfileView());
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