import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SupabaseHelperprivate {
  static const String projectUrl = 'https://niajwjjmknwlbeybndbq.supabase.co';
  static const String apiKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5pYWp3ampta253bGJleWJuZGJxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ2NTg4NjUsImV4cCI6MjA3MDIzNDg2NX0.t9S41O5wqv4Y6_L9YIPus3Rr1LW2HOQR5f2KrRH27U8';
  static Future init() async {
    await Supabase.initialize(url: projectUrl, anonKey: apiKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
