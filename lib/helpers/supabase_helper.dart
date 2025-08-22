import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SupabaseHelper {
  // Project Configuration
  static const String projectUrl = 'https://niajwjjmknwlbeybndbq.supabase.co';
  static const String apiKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5pYWp3ampta253bGJleWJuZGJxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ2NTg4NjUsImV4cCI6MjA3MDIzNDg2NX0.t9S41O5wqv4Y6_L9YIPus3Rr1LW2HOQR5f2KrRH27U8';

  // Initialize Supabase
  static Future init() async {
    await Supabase.initialize(url: projectUrl, anonKey: apiKey);
  }

// Get Supabase Client
  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> registerWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': firstName,
          'last_name': lastName,
        },
      );

      final user = response.user;
      if (user == null) {
        throw Exception("Registration failed. Please try again.");
      }

      await createUserProfile(
        uid: user.id,
        firstName: firstName,
        lastName: lastName,
      );

      // Update display_name in auth.users
      await client.auth.updateUser(UserAttributes(
        data: {'display_name': firstName},
      ));

      print("Registration successful & profile created");
    } on AuthException catch (e) {
      print("Auth Error: ${e.message}");
      rethrow;
    } catch (e) {
      print("Unexpected Error: $e");
      rethrow;
    }
  }





  // Create user profile in profiles table
  static Future<void> createUserProfile({
    required String uid,
    required String firstName,
    required String lastName,
  }) async {
    try {
      await client.from('profiles').insert({
        'id': uid,
        'first_name': firstName,
        'last_name': lastName,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Get user profile from profiles table
  static Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final response = await client
          .from('profiles')
          .select()
          .eq('id', uid)
          .maybeSingle();
      return response;
    } catch (e) {
      return null;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  // Get current user
  static User? get currentUser => client.auth.currentUser;
}


