import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // Tetap pertahankan jika dipakai
import 'package:provider/provider.dart'; // Import Provider
import 'package:sigap_pa_pbm/core/routing/app_router.dart'; // Untuk navigasi
import 'package:sigap_pa_pbm/features/authentication/viewmodel/auth_viewmodel.dart'; // Import AuthViewModel

class LoginView extends StatefulWidget { // Ubah menjadi StatefulWidget
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Tambahkan TextEditingController untuk input email dan password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cek status login saat layar dimulai (opsional, bisa juga di main.dart atau splash screen)
    _checkLoginStatus();
  }

  // Fungsi untuk mengecek apakah user sudah memiliki JWT kustom dari backend
  Future<void> _checkLoginStatus() async {
    // AuthViewModel.checkLoginStatus() adalah static method di ViewModel
    if (await AuthViewModel.checkLoginStatus()) {
      Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute);
    }
  }

  // Helper untuk menampilkan SnackBar pesan error
  void _showErrorSnackBar(BuildContext context, String message) {
    if (message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan Consumer untuk mendengarkan perubahan pada AuthViewModel
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        // Tampilkan SnackBar jika ada error baru dari ViewModel
        if (authViewModel.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showErrorSnackBar(context, authViewModel.errorMessage!);
            authViewModel.clearError(); // Bersihkan error setelah ditampilkan
          });
        }

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: SingleChildScrollView( // Tambahkan SingleChildScrollView agar keyboard tidak overflow
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
                      controller: _emailController, // Hubungkan dengan Controller
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'email',
                        hintText: 'masukkan email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        // Style border sudah diatur di ThemeData di main.dart
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _passwordController, // Hubungkan dengan Controller
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'password',
                        hintText: 'masukkan password',
                        prefixIcon: const Icon(Icons.key),
                        // Style border sudah diatur di ThemeData di main.dart
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Tombol Login
                    authViewModel.isLoading // Tampilkan loading indicator
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              // Style sudah diatur di ThemeData di main.dart
                              minimumSize: const Size.fromHeight(55),
                            ),
                            onPressed: () async {
                              // Panggil metode login dari ViewModel
                              final response = await authViewModel.signInWithEmailAndPassword(
                                _emailController.text,
                                _passwordController.text,
                              );
                              if (response != null && response.success) {
                                // Jika login berhasil, arahkan ke Home Screen
                                Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute);
                              }
                              // Error akan ditangani oleh SnackBar via ViewModel
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                    const SizedBox(height: 20),
                    // Tautan ke Register
                    _buildRegisterLink(context),
                    const SizedBox(height: 20), // Tambahkan sedikit spasi di bawah
                    // Tombol Google Sign-In (Tambahan Opsional jika ingin di LoginView)
                    authViewModel.isLoading
                        ? const SizedBox.shrink() // Sembunyikan jika ada loading utama
                        : ElevatedButton.icon(
                            onPressed: () async {
                              final response = await authViewModel.signInWithGoogle();
                              if (response != null && response.success) {
                                // Cek apakah profil perlu dilengkapi (nomor HP null/kosong)
                                if (response.user?.phoneNumber?.isEmpty ?? true) {
                                  Navigator.of(context).pushReplacementNamed(AppRouter.profileRoute);
                                } else {
                                  Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute);
                                }
                              }
                            },
                            icon: Image.asset(
                              'assets/google_logo.png', // Pastikan Anda punya gambar ini
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

  // Widget untuk tautan Register
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
                Navigator.pushNamed(context, AppRouter.registerRoute); // Navigasi ke RegisterView
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