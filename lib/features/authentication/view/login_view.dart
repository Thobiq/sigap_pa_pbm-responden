import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../core/routing/app_router.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login Page'),
            const SizedBox(height: 20,),
            FloatingActionButton(
              onPressed: (){},
              child: Text('Login'),),
            const SizedBox(height: 20,),
            _buildRegisterLink(context),
          ],
        ),
      ),
    );
  }
}


Widget _buildRegisterLink(BuildContext context){
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
            ..onTap = (){
              Navigator.pushNamed(context, AppRouter.registerRoute);
            }
          )
      ]
    )
  );
}