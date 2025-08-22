import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'GarageHomePage.dart';

class UserLoaderPage extends StatefulWidget {
  const UserLoaderPage({super.key});

  @override
  State<UserLoaderPage> createState() => _UserLoaderPageState();
}

class _UserLoaderPageState extends State<UserLoaderPage> {
  String? displayName;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser!;

      final response = await supabase
          .from('profiles')
          .select('first_name')
          .eq('id', user.id)
          .maybeSingle();

      print("✅ User loaded: $response" + " for user ID: ${user.id}"); // Debug log
      setState(() {
        if (response != null && response['first_name'] != null) {
          displayName = response['first_name'];
        } else {
          displayName = "Guest";
        }
        loading = false;
      });
    } catch (e) {
      print("❌ Error loading user: $e");
      setState(() {
        displayName = "Guest";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return GarageHomePage(userName: displayName ?? "Guest");
  }
}
