import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../core/routing/app_router.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: const EdgeInsets.all(24),
      child:
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo_sigap_pbm.png', width: 250,),
              const SizedBox(height: 24,),
              Text('Register Page', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 224, 35, 35))),
              const SizedBox(height: 20,),
              TextField(
                decoration: InputDecoration(
                  labelText: 'email',
                  hintText: 'masukkan email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 65, 65, 65),
                      width: 1.5,
                    )
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 65, 65, 65),
                      width: 2,
                    )
                  )),
                ),
              const SizedBox(height: 24,),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'password',
                  hintText: 'masukkan password',
                  prefixIcon: const Icon(Icons.key),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 65, 65, 65),
                      width: 1.5,
                    )
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 65, 65, 65),
                      width: 2,
                    )
                  )),
                ),
              const SizedBox(height: 24,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Color.fromARGB(255, 224, 35, 35),
                  minimumSize: const Size.fromHeight(55),
                ),
                onPressed: (){}, 
                child: const Text('Daftar', style: TextStyle(color: Colors.white, fontSize: 20),)
                ),

              // FloatingActionButton(
              //   onPressed: (){},
              //   child: Text('Login'),
              // ),
              const SizedBox(height: 20,),
              _buildRegisterLink(context),
            ],
          ),
        ),
      ) 
    );
  }
}


Widget _buildRegisterLink(BuildContext context){
  return RichText(
    text: TextSpan(
      style: const TextStyle(color: Color.fromARGB(255, 95, 95, 95), fontSize: 20),
      children: <TextSpan>[
        const TextSpan(text: 'Sudah punya akun ? '),
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