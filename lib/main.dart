import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/routing/app_router.dart';

import 'features/authentication/viewmodel/auth_viewmodel.dart';
// import 'features/';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        // ChangeNotifierProvider(create: (_) => HomeViewModel()),
        // ChangeNotifierProvider(create: (_) => ProfileViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => Object())
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.loginRoute,
      ),
    );
  }
}
