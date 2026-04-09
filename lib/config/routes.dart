import 'package:flexiback/features/auth/presentation/pages/login_page.dart';
import 'package:flexiback/features/auth/presentation/pages/signup_page.dart';
import 'package:flexiback/features/zz/chat.dart';
import 'package:flexiback/features/zz/device.dart';
import 'package:flexiback/features/profile/presentation/pages/profile_page.dart';
import 'package:flexiback/features/zz/therapy.dart';
import 'package:flexiback/features/zz/trend.dart';
import 'package:flexiback/shared/navigation/shell/general_main_shell.dart';
import 'package:flutter/material.dart';

import '../features/profile/presentation/pages/general_edit.dart';

class AppRoutes {
  static const login = "/login";
  static const signup = "/signup";

  static const therapy = "/test";
  static const device = "/device";
  static const trend = "/trend";
  static const chat = "/chat";
  static const profile = "/profile";

  // edit
  static const generalEdit = "/generalEdit";


  // Shell
  static const generalMainShell = "/generalMainShell";


  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginPage(),
    signup: (context) => SignupPage(),
    
    therapy: (context) => TherapyPage(),
    device: (context) => DevicePage(),
    trend: (context) => TrendPage(),
    chat: (context) => ChatPage(),
    profile: (context) => ProfilePage(),

    generalEdit: (context) => GeneralEdit(),

    generalMainShell: (context) => GeneralMainShell(),
  };
}