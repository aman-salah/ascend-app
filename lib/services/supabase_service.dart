import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://jldkftglbolwixbxyolj.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpsZGtmdGdsYm9sd2l4Ynh5b2xqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg1MjYyMjUsImV4cCI6MjA5NDEwMjIyNX0.3ftQqHaxjc7caIIL4GeCYe7HHq0qlFOXTho9m5vQ2P8';

  static SupabaseClient get client => Supabase.instance.client;
}
