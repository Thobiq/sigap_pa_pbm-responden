import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:sigap_pa_pbm/core/routing/app_router.dart';
import 'package:sigap_pa_pbm/features/authentication/model/auth_response_model.dart';
import 'package:sigap_pa_pbm/features/authentication/viewmodel/auth_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    if (await AuthViewModel.checkLoginStatus()) {
      Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute);
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    if (message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  void _handleAuthResponseNavigation(AuthViewModel authViewModel, AuthResponse? response) {
    if (response != null && response.success) {
      debugPrint('Auth successful. Raw backend user data: ${response.user?.toJson()}');

      if (response.user != null) {
        SharedPreferences.getInstance().then((prefs) async {
          try {
            final userJson = response.user!.toJson();
            final userJsonString = json.encode(userJson);

            await prefs.setString('current_user_data', userJsonString);
            debugPrint('User data SAVED to SharedPreferences: $userJsonString');
            
            if (response.user!.phoneNumber?.isEmpty ?? true) {
              Navigator.of(context).pushReplacementNamed(AppRouter.profileRoute);
            } else {
              Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute);
            }

          } catch (e) {
            debugPrint('ERROR: Failed to save user data to SharedPreferences: $e');
            _showErrorSnackBar(context, 'Gagal menyimpan data pengguna lokal. Coba lagi.');
            Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute);
          }
        }).catchError((e) {
          debugPrint('ERROR: Failed to get SharedPreferences instance: $e');
          _showErrorSnackBar(context, 'Akses penyimpanan lokal gagal.');
          Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute);
        });

      } else {
        _showErrorSnackBar(context, 'Data pengguna tidak lengkap dari backend (objek user null).');
        Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute);
      }
    } else {
      _showErrorSnackBar(context, response?.message ?? authViewModel.errorMessage ?? 'Gagal login. Coba lagi.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        if (authViewModel.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showErrorSnackBar(context, authViewModel.errorMessage!);
            authViewModel.clearError();
          });
        }

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/logo_sigap_pbm.png', width: 250),
                    const SizedBox(height: 24),
                    Text(
                      'Login Page',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 224, 35, 35)),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'email',
                        hintText: 'masukkan email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'password',
                        hintText: 'masukkan password',
                        prefixIcon: Icon(Icons.key),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Tombol Login (Email/Password)
                    authViewModel.isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(55),
                            ),
                            onPressed: () async {
                              final response = await authViewModel.signInWithEmailAndPassword(
                                _emailController.text,
                                _passwordController.text,
                              );
                              _handleAuthResponseNavigation(authViewModel, response);
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                    const SizedBox(height: 20),
                    _buildRegisterLink(context),
                    const SizedBox(height: 20),
                    // Tombol Google Sign-In
                    authViewModel.isLoading
                        ? const SizedBox.shrink()
                        : ElevatedButton.icon(
                            onPressed: () async {
                              final response = await authViewModel.signInWithGoogle();
                              _handleAuthResponseNavigation(authViewModel, response);
                            },
                            icon: Image.asset(
                              'assets/google_logo.png',
                              height: 24,
                            ),
                            label: const Text(
                              'Login dengan Google',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(55),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Color.fromARGB(255, 95, 95, 95), fontSize: 20),
        children: <TextSpan>[
          const TextSpan(text: 'Belum punya akun? '),
          TextSpan(
            text: 'Daftar',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamed(context, AppRouter.registerRoute);
              },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}