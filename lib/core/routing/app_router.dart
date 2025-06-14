import 'package:flutter/material.dart';
import '../../features/authentication/view/login_view.dart';
import '../../features/authentication/view/register_view.dart';

class AppRouter {
  static const String loginRoute = '/';
  static const String registerRoute = '/register';

  static Route<dynamic> onGenerateRoute(RouteSettings settings){
    switch (settings.name){
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case registerRoute:
        return MaterialPageRoute(builder: (_) => const RegisterView());
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