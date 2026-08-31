import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // If .env is missing or cannot be loaded, fallback to default mock configuration
    }
  }

  static String get supabaseUrl => dotenv.get('SUPABASE_URL', fallback: 'https://saviours.supabase.co');
  static String get supabaseAnonKey => dotenv.get('SUPABASE_ANON_KEY', fallback: 'saviours-mock-anon-key');
  static String get googleMapsApiKey => dotenv.get('GOOGLE_MAPS_API_KEY', fallback: '');
  static String get geminiApiKey => dotenv.get('GEMINI_API_KEY', fallback: '');
  
  static bool get isMockMode {
    final mode = dotenv.get('APP_MODE', fallback: 'mock').toLowerCase();
    if (mode == 'mock') return true;
    return supabaseUrl.contains('saviours.supabase.co') || googleMapsApiKey.isEmpty;
  }

  static bool get hasValidMapsKey => googleMapsApiKey.isNotEmpty && !googleMapsApiKey.contains('mock');
  static bool get hasValidGeminiKey => geminiApiKey.isNotEmpty && !geminiApiKey.contains('mock');
  static bool get hasValidSupabaseKey => supabaseAnonKey.isNotEmpty && !supabaseAnonKey.contains('mock');
}
