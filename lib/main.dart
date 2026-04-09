import 'package:flexiback/config/routes.dart';
import 'package:flexiback/features/auth/presentation/controller/auth_provider.dart';
import 'package:flexiback/features/profile/presentation/controller/profile_provider.dart' show ProfileProvider;
import 'package:flexiback/shared/navigation/shell/general_main_shell.dart';
import 'package:flexiback/shared/theme/app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env["API_KEY"]!,
    anonKey: dotenv.env["API_PUB"]!
  );

  runApp(
    MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => AuthProvider()
        ),

        ChangeNotifierProvider(
          create: (_) => ProfileProvider()
        )

      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.routes,

      initialRoute: AppRoutes.login,
      // home: GeneralMainShell(),
    );
  }
}
