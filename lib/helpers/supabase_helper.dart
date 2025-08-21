import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SupabaseHelper {
  static const String projectUrl = 'YoUR_SUPABASE_PROJECT_URL';
  // Replace with your actual Supabase project URL
  static const String apiKey = 'YoUR_SUPABASE_ANON_KEY';
  // Replace with your actual Supabase anon key
  static Future init() async {
    await Supabase.initialize(url: projectUrl, anonKey: apiKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
