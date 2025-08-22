import 'package:flutter/material.dart';
import 'Pages/SignIn.dart';
import 'Pages/RegisterPage.dart';
import 'helpers/supabase_helper_private.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        //'/': (context) => const SplashScreen(),
        '/login': (context) => const SignIn(),
        '/register': (context) => const RegisterPage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Garage Management',
      home: const SignIn(),
    );
  }
}
