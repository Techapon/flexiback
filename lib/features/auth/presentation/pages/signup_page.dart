import 'package:flexiback/features/auth/presentation/controller/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:flexiback/shared/theme/colors/app_color.dart';

import '../../../../config/routes.dart';
import '../../../../shared/widgets/dialog/error/dialog_error.dart';
import '../../../../shared/widgets/dialog/success/dialog_success.dart';
import '../widgets/authbtn.dart';
import '../widgets/textfeid.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final confirmPasswordC = TextEditingController();

  @override
  void dispose() {
    emailC.dispose();
    passwordC.dispose();
    confirmPasswordC.dispose();
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
      backgroundColor: AppColor.base1,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Green header with back button and illustration
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 16,
                left: 16,
                // right: 36,
                // bottom: 36,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColor.main1,
                    AppColor.cream2,
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(36),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          Container(
                            height:26,
                            child: Image.asset(
                              'assets/emoji/fox.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                  
                      SizedBox(height: 16),
                  
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ceate New Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.paytoneOne().fontFamily,
                                    letterSpacing: 1.25
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Please fill in the information below to register",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: 14,
                                  ),
                                ),
                              SizedBox(height: 36)
                              ],
                            ),
                        
                        ),
                      ),
                  
                    ],
                  ),
                ),
              ),
            ),
      
            // Form content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 36, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
      
                  // Email field
                  Text(
                    "email",
                    style: TextStyle(
                      color: AppColor.main1,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Custom_Textfeild(
                    hint: 'email here..',
                    type: TextInputType.emailAddress,
                    obscureText: false,
                    controller: emailC,
                    errorText: authProvider.errorEmail,
                    icon: Icons.email,
                  ),
      
                  SizedBox(height: 24),
      
                  // Password field
                  Text(
                    "password",
                    style: TextStyle(
                      color: AppColor.main2,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Custom_Textfeild(
                    hint: 'password here..',
                    type: TextInputType.text,
                    obscureText: true,
                    controller: passwordC,
                    errorText: authProvider.errorPassword,
                    icon: Icons.lock_outline_rounded,
                  ),
      
                  SizedBox(height: 24),
      
                  // Confirm password field
                  Text(
                    "confirm password",
                    style: TextStyle(
                      color: AppColor.cream3,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Custom_Textfeild(
                    hint: 'password again..',
                    type: TextInputType.text,
                    obscureText: true,
                    controller: confirmPasswordC,
                    errorText: authProvider.errorConfirmPassword,
                    icon: Icons.check_rounded,
                  ),
      
                  SizedBox(height: 24),
      
                  // Sign up button
                  Auth_Btn(
                    text: 'Sign up',
                    isLoading: authProvider.isLoading,
                    onTap: () {
                      if (authProvider.isLoading) return;
                      authProvider.signup(
                        emailC.text.trim(),
                        passwordC.text.trim(),
                        confirmPasswordC.text.trim(),
                      );

                      if (authProvider.error == null) {
                        showSuccessDialog(
                          context: context,
                          message: "Welcome to FlexiBack, Please comfirm your email🦊",
                        );
                        emailC.clear();
                        passwordC.clear();
                        confirmPasswordC.clear();
                      }
                    },
                  ),
      
                  SizedBox(height: 12),
      
                  // Navigate to login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Alerady have an Account?",
                        style: TextStyle(
                          color: AppColor.grey3,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (authProvider.isLoading) return;
                          Navigator.pop(context);
                          authProvider.clearError();
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: AppColor.cream3,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}