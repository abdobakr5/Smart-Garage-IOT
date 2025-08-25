import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<Map<String, dynamic>?> fetchLatestReading({
  required String table,
  required String valueColumn,
  required String timeColumn,
}) async {
  final response = await supabase
      .from(table)
      .select('$valueColumn, $timeColumn')
      .order('id', ascending: false)
      .limit(1)
      .maybeSingle();

  return response;
}

