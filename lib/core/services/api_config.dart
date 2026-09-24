import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // If .env is missing or cannot be loaded, fallback to default mock configuration
    }
  }

  static String get supabaseUrl {
    final nextUrl = dotenv.get('NEXT_PUBLIC_SUPABASE_URL', fallback: '');
    if (nextUrl.isNotEmpty) return nextUrl;
    return dotenv.get('SUPABASE_URL', fallback: 'https://uynrzazoidgibofmjfcf.supabase.co');
  }

  static String get supabaseAnonKey {
    final nextPub = dotenv.get('NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY', fallback: '');
    if (nextPub.isNotEmpty && !nextPub.contains('mock')) return nextPub;
    final nextAnon = dotenv.get('NEXT_PUBLIC_SUPABASE_ANON_KEY', fallback: '');
    if (nextAnon.isNotEmpty && !nextAnon.contains('mock')) return nextAnon;
    final anon = dotenv.get('SUPABASE_ANON_KEY', fallback: '');
    if (anon.isNotEmpty && !anon.contains('mock')) return anon;
    final pub = dotenv.get('SUPABASE_PUBLISHABLE_KEY', fallback: '');
    if (pub.isNotEmpty && !pub.contains('mock')) return pub;
    return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV5bnJ6YXpvaWRnaWJvZm1qZmNmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg3MTI2NjcsImV4cCI6MjEwNDI4ODY2N30.Y_gFs2CQ2BYyvKH-6kerlwLWvQ7xDUFUjHtM0G7oWTU';
  }

  static String get googleMapsApiKey => dotenv.get('GOOGLE_MAPS_API_KEY', fallback: '');
  static String get geminiApiKey => dotenv.get('GEMINI_API_KEY', fallback: '');
  
  static bool get isMockMode {
    final mode = dotenv.get('APP_MODE', fallback: 'online').toLowerCase();
    if (mode == 'mock') return true;
    return !hasValidSupabaseKey;
  }

  static bool get hasValidMapsKey => googleMapsApiKey.isNotEmpty && !googleMapsApiKey.contains('mock');
  static bool get hasValidGeminiKey => geminiApiKey.isNotEmpty && !geminiApiKey.contains('mock');
  static bool get hasValidSupabaseKey => supabaseAnonKey.isNotEmpty && !supabaseAnonKey.contains('mock') && !supabaseUrl.contains('saviours.supabase.co');
}

