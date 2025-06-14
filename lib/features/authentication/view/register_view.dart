import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../core/routing/app_router.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Register Page'),
            const SizedBox(height: 20,),
            FloatingActionButton(
              onPressed: (){},
              child: Text('Daftar'),
            ),
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
        const TextSpan(text: 'Sudah punya akun? '),
        TextSpan(
          text: 'Login',
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = (){
              Navigator.pushNamed(context, AppRouter.loginRoute);
            }
          )
      ]
    )
  );
}