import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/web.dart';

class AppTheme {
  static void setStatusBarLightOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  static void setStatusBarDarkOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  static void setSystemUIOverlayStyle(BuildContext context) {
    final currentBrightness = Theme.of(context).brightness;
    Logger().i(
      '[APP Theme] setSystemUIOverlayStyle based on current brightness: $currentBrightness',
    );
    if (currentBrightness == Brightness.light) {
      setStatusBarLightOverlayStyle();
    } else {
      setStatusBarDarkOverlayStyle();
    }
  }

  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF00B4D8), Color(0xFF0077B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Light Theme Specific Colors & Styles ---
  static const Color _lightPrimaryColor = Color(0xFF0077B6);
  static const Color _lightSecondaryColor = Color(0xFFADADAD);
  static const Color _lightDividerColor = Color(0xFFADADAD);
  static const Color _lightTertiaryColor = Color(0xFFADADAD);
  static const Color _lightScaffoldBackgroundColor = Color(0xFFF7F7F7);
  static const Color _lightBackgroundColor = Color(0xFFFFFFFF);
  static const Color _lightErrorColor = Color(0xFFAC0000);
  static const IconThemeData _lightIconTheme = IconThemeData(
    color: Color(0xFF262626),
  );
  static const Color _lightShadowColor = Color(0x15000000);
  static final OutlinedButtonThemeData _lightOutlinedButtonTheme =
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF262626),
          side: const BorderSide(color: Color(0xFF262626)),
        ),
      );
  static const TextStyle _lightAppBarTitleTextStyle = TextStyle(
    color: Color(0xFF262626),
    fontSize: 36,
  );
  static final TextStyle _lightHeadlineMediumTextStyle = GoogleFonts.interTight(
    color: const Color(0xFF00B4D8),
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle _lightTitleLargeTextStyle = GoogleFonts.interTight(
    color: const Color(0xFF262626),
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle _lightTitleMediumTextStyle = GoogleFonts.interTight(
    color: const Color(0xFF00B4D8),
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle _lightTitleSmallTextStyle = GoogleFonts.interTight(
    color: const Color(0xFF262626),
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle _lightBodyMediumTextStyle = GoogleFonts.inter(
    color: const Color(0xFF262626),
    fontSize: 16,
  );
  static final TextStyle _lightBodySmallTextStyle = GoogleFonts.inter(
    color: const Color(0xFFADADAD),
    fontSize: 12,
  );
  static const Color _lightOnSurfaceColor = Color(0xFFADADAD);

  // --- Dark Theme Specific Colors & Styles ---
  static const Color _darkPrimaryColor = Color(0xFF0077B6);
  static const Color _darkSecondaryColor = Color(0xFF6D6D6D);
  static const Color _darkDividerColor = Color(0xFF6D6D6D);
  static const Color _darkTertiaryColor = Color(0xFF2C2C2C);
  static const Color _darkScaffoldBackgroundColor = Color(0xFF1A1A1A);
  static const Color _darkBackgroundColor = Color(0xFF2C2C2C);
  static const Color _darkErrorColor = Color(0xFFAC0000);
  static const IconThemeData _darkIconTheme = IconThemeData(
    color: Color(0xFFADADAD),
  );
  static const Color _darkShadowColor = Color(0x15FFFFFF);
  static final OutlinedButtonThemeData _darkOutlinedButtonTheme =
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFADADAD),
          side: const BorderSide(color: Color(0xFFADADAD)),
        ),
      );
  static const TextStyle _darkAppBarTitleTextStyle = TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 36,
  );
  static final TextStyle _darkHeadlineMediumTextStyle = GoogleFonts.interTight(
    color: const Color(0xFF00B4D8),
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle _darkTitleLargeTextStyle = GoogleFonts.interTight(
    color: const Color(0xFFFFFFFF),
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle _darkTitleMediumTextStyle = GoogleFonts.interTight(
    color: const Color(0xFF00B4D8),
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle _darkTitleSmallTextStyle = GoogleFonts.interTight(
    color: const Color(0xFFFFFFFF),
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle _darkBodyMediumTextStyle = GoogleFonts.inter(
    color: const Color(0xFFFFFFFF),
    fontSize: 16,
  );
  static final TextStyle _darkBodySmallTextStyle = GoogleFonts.inter(
    color: const Color(0xFF6D6D6D),
    fontSize: 12,
  );
  static const Color _darkOnSurfaceColor = Color(0xFF6D6D6D);

  ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: _lightPrimaryColor,
      scaffoldBackgroundColor: _lightScaffoldBackgroundColor,
      dividerColor: _lightDividerColor,
      appBarTheme: AppBarTheme(
        backgroundColor: _lightBackgroundColor,
        iconTheme: _lightIconTheme,
        titleTextStyle: _lightAppBarTitleTextStyle,
      ),
      textTheme: TextTheme(
        bodySmall: _lightBodySmallTextStyle,
        bodyLarge: _lightAppBarTitleTextStyle,
        bodyMedium: _lightBodyMediumTextStyle,
        titleLarge: _lightTitleLargeTextStyle,
        titleMedium: _lightTitleMediumTextStyle,
        titleSmall: _lightTitleSmallTextStyle,
        headlineMedium: _lightHeadlineMediumTextStyle,
      ),
      colorScheme: ColorScheme.light(
        primary: _lightPrimaryColor,
        surface: _lightBackgroundColor,
        error: _lightErrorColor,
        onPrimary: Colors.white,
        onSurface: _lightOnSurfaceColor,
        secondary: _lightSecondaryColor,
        tertiary: _lightTertiaryColor,
        shadow: _lightShadowColor,
      ),
      iconTheme: _lightIconTheme,
      outlinedButtonTheme: _lightOutlinedButtonTheme,
    );
  }

  ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: _darkPrimaryColor,
      scaffoldBackgroundColor: _darkScaffoldBackgroundColor,
      dividerColor: _darkDividerColor,
      appBarTheme: AppBarTheme(
        backgroundColor: _darkBackgroundColor,
        iconTheme: _darkIconTheme,
        titleTextStyle: _darkAppBarTitleTextStyle,
      ),
      textTheme: TextTheme(
        bodySmall: _darkBodySmallTextStyle,
        bodyLarge: _darkAppBarTitleTextStyle,
        bodyMedium: _darkBodyMediumTextStyle,
        titleLarge: _darkTitleLargeTextStyle,
        titleMedium: _darkTitleMediumTextStyle,
        titleSmall: _darkTitleSmallTextStyle,
        headlineMedium: _darkHeadlineMediumTextStyle,
      ),
      colorScheme: ColorScheme.dark(
        primary: _darkPrimaryColor,
        surface: _darkBackgroundColor,
        error: _darkErrorColor,
        onPrimary: Colors.white,
        onSurface: _darkOnSurfaceColor,
        secondary: _darkSecondaryColor,
        tertiary: _darkTertiaryColor,
        shadow: _darkShadowColor,
      ),
      iconTheme: _darkIconTheme,
      outlinedButtonTheme: _darkOutlinedButtonTheme,
    );
  }
}
