import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


  ThemeData darkTheme = ThemeData.dark().copyWith(
    useMaterial3: true,
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: Colors.blue.shade700,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    ),
  );


  ThemeData lightTheme = ThemeData.light().copyWith(
    useMaterial3: true,


    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: Colors.blue
    ),

    tabBarTheme: const TabBarTheme(
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
       padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.all(Colors.black54),

        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ),
    appBarTheme:  const AppBarTheme(
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
  );

