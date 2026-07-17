import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = 'https://azrilrbycrfsacqexfid.supabase.co';
  static const String anonKey =
      'sb_publishable__p6DNM1L1H4g8qzH57Ixrw_jJBr1PIb';

  static Future<void> initialize() async {
    await Supabase.initialize(url: url, anonKey: anonKey);
  }
}

final supabase = Supabase.instance.client;
