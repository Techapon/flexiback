import 'package:flexiback/shared/theme/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/routes.dart';
import '../controller/auth_provider.dart';
import '../widgets/authbtn.dart';
import '../../../../shared/widgets/dialog/error/dialog_error.dart';
import '../widgets/textfeid.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  @override
  void dispose() {
    emailC.dispose();
    passwordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    // Dialog
    if (authProvider.error != null) {
      final errorMsg = authProvider.error!;
      authProvider.error = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showErrorDialog(
          context: context,
          message: errorMsg,
        );
      });
    }

    return Scaffold(
      backgroundColor: AppColor.cream2,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 125,
            left: 48,
            right: 48
          ),
          child: SingleChildScrollView(
            child: Column(
              spacing: 24,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            
                CircleAvatar(
                  backgroundColor: AppColor.base1,
                  radius: 83,
                  child: CircleAvatar(
                    backgroundColor: AppColor.cream1,
                    radius: 78,
                    child: CircleAvatar(
                      backgroundColor: AppColor.base1,
                      radius: 73,
                      child: CircleAvatar(
                        backgroundColor: AppColor.grey2,
                        radius: 63,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage("assets/brand/app_icon.png"),
                        ),
                      ),
                    ),
                  ),
                ),
            
                Column(
                  spacing: 12,
                  children: [
                    Custom_Textfeild(
                      hint: "email",
                      type: TextInputType.text,
                      obscureText: false,
                      controller: emailC,
                      icon: Icons.email_outlined,
                    ),
            
                    Custom_Textfeild(
                      hint: "password",
                      type: TextInputType.text,
                      obscureText: true,
                      controller: passwordC,
                      icon: Icons.lock_outline_rounded,
                    ),
                  ],
                ),

                Column(
                  children: [

                    Auth_Btn(
                      text: "Login",
                      onTap: () async {
                        if (authProvider.isLoading) return;
                        await authProvider.login(
                          emailC.text.trim(),
                          passwordC.text.trim(),
                        );

                        if (authProvider.isLoggedIn) {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.generalMainShell,
                          );
                        }
                      },
                      isLoading: authProvider.isLoading,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: AppColor.cream3,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.signup);
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: AppColor.cream4,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),

            
            
              ],
            ),
          ),
        )
      ),
    );
  }
}