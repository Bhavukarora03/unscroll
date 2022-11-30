

import 'package:flutter/material.dart';

class ThemeMode{
  static const int LIGHT = 0;
  static const int DARK = 1;
  static const int SYSTEM = 2;



  appTheme(int themeMode){
    switch(themeMode){
      case LIGHT:
        return ThemeData.light();
      case DARK:
        return ThemeData.dark();
      case SYSTEM:
        return ThemeData.light();
      default:
        return ThemeData.light();
    }
  }
  


}