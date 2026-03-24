import 'package:flutter/material.dart';
import 'app_color.dart';
import 'app_font.dart';

class AppThemes {
  AppThemes._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,

    // Colors
    primaryColor: AppColors.primaryMain,
    scaffoldBackgroundColor: AppColors.backgroundScreen,

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundScreen,
      foregroundColor: AppColors.neutral100,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.neutral100,),
    ),

    // Text Theme
    textTheme: TextTheme(
      displayLarge: AppFonts.title1,
      displayMedium: AppFonts.heading1, 
      displaySmall: AppFonts.heading2, 

      headlineLarge: AppFonts.heading1, 
      headlineMedium: AppFonts.heading2, 
      headlineSmall: AppFonts.heading3, 
    
      titleLarge: AppFonts.heading3, 
      titleMedium: AppFonts.title2, 
      titleSmall: AppFonts.caption12, 
   
      bodyLarge: AppFonts.heading3, 
      bodyMedium: AppFonts.body, 
      bodySmall: AppFonts.caption12, 
     
      labelLarge: AppFonts.body, 
      labelMedium: AppFonts.caption12, 
      labelSmall: AppFonts.caption11, 
    ),
    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.neutral1,
        textStyle: AppFonts.heading3.copyWith(color: AppColors.neutral1),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFE6EAEE), // TODO: màu set cứng
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: AppColors.neutral50),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: AppColors.primaryMain),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: AppColors.neutral50),
      ),
      hintStyle: TextStyle(color: Color(0xFFEBE7E7)), // TODO: 
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryMain,
        textStyle: AppFonts.heading3,
      ),
    ),

    tabBarTheme: TabBarThemeData(
      indicatorColor: AppColors.primaryMain,
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: AppColors.primaryMain,
      unselectedLabelColor: AppColors.neutral100,
      labelStyle: AppFonts.heading3.copyWith(fontWeight: FontWeight.bold),
      unselectedLabelStyle: AppFonts.heading3.copyWith(
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
