import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'login_page.dart'; // Import LoginPage
import 'package:supabase_flutter/supabase_flutter.dart';

// Define App Colors (Consider moving to a separate theme file later)
class AppColors {
  static const Color primary = Color(0xFF4CAF50); // Green
  static const Color primaryLight = Color(0xFF81C784);
  static const Color primaryDark = Color(0xFF388E3C);
  static const Color accent = Color(0xFFFF9800); // Orange Accent
  static const Color background = Color(0xFFF5F5F5); // Light grey background
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);

}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://pmzgkxjnxjraguuslnkj.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBtemdreGpueGpyYWd1dXNsbmtqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM2MDk2ODcsImV4cCI6MjA1OTE4NTY4N30.zT8b3wfNDp9P6cJkt-1uEAqHvb4KhWctQspcpCR4z9o',
  );

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData.light(useMaterial3: true);


    return MaterialApp(
      title: 'Groficy Meal Planner', // Updated title
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          primary: AppColors.primary,
          secondary: AppColors.accent,
          background: AppColors.background,
          surface: AppColors.cardBackground, // Card color
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white, // Title/icon color
          elevation: 2.0,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme).copyWith(
          bodyLarge: GoogleFonts.poppins(color: AppColors.textPrimary),
          bodyMedium: GoogleFonts.poppins(color: AppColors.textSecondary),
          titleLarge: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          titleMedium: GoogleFonts.poppins(
              fontWeight: FontWeight.w500, color: AppColors.textPrimary),
          labelLarge: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: Colors.white), // For buttons
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.w600),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 2,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryDark,
            textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 15.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none, // No border by default
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
                color: Colors.grey.shade300), // Subtle border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
          ),
          labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
          prefixIconColor: AppColors.textSecondary,
        ),
        cardTheme: CardTheme(
          elevation: 2.0,
          color: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0)),
          margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        ),
        listTileTheme: ListTileThemeData(
          iconColor: AppColors.primary,
          titleTextStyle: GoogleFonts.poppins(
              fontSize: 16, color: AppColors.textPrimary),
          subtitleTextStyle: GoogleFonts.poppins(
              fontSize: 14, color: AppColors.textSecondary),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return null; // Default color
          }),
          checkColor: WidgetStateProperty.all(Colors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        dividerTheme: DividerThemeData(
          color: Colors.grey.shade300,
          thickness: 1,
          space: 30,
        ),
      ),
      home: const LoginPage(), // Start with LoginPage
    );
  }
}
