import 'package:flutter/material.dart';
import 'Pages/Home.dart';
import 'helpers/supabase_helper_private.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseHelperprivate.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Garage Management',
      home: const FirstScreen(),
    );
  }
}
