import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigap_pa_pbm/core/routing/app_router.dart';
import 'package:sigap_pa_pbm/features/authentication/viewmodel/auth_viewmodel.dart';
import 'package:sigap_pa_pbm/features/home/viewmodel/home_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToNextScreen();
    });
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 1)); 

    final bool isLoggedIn = await AuthViewModel.checkLoginStatus();

    if (isLoggedIn) {
      try {
        await Provider.of<HomeViewModel>(context, listen: false).loadUserDataAndToken();
        Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute);
      } catch (e) {
        print('Error loading HomeViewModel in SplashScreen: $e');
        Navigator.of(context).pushReplacementNamed(AppRouter.loginRoute);
      }
    } else {
      Navigator.of(context).pushReplacementNamed(AppRouter.loginRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Memuat Aplikasi...',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}