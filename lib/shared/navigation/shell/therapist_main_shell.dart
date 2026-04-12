import 'package:flexiback/features/zz/chat.dart';
import 'package:flexiback/features/zz/device.dart';
import 'package:flexiback/features/profile/presentation/pages/profile_page.dart';
import 'package:flexiback/features/zz/therapy.dart';
import 'package:flexiback/features/zz/trend.dart';
import 'package:flexiback/shared/theme/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';

import '../../../features/profile/presentation/controller/profile_provider.dart';
class TherapistMainShell extends StatefulWidget {
  const TherapistMainShell({super.key});

  @override
  State<TherapistMainShell> createState() => _TherapistMainShellState();
}

class _TherapistMainShellState extends State<TherapistMainShell> {
  int _currentindex = 0;

  final List<Widget> _pages = [
    ChatPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : IndexedStack(
        index: _currentindex,
        children: _pages
      ),
      extendBody: true,
      bottomNavigationBar: ResponsiveNavigationBar(
        selectedIndex: _currentindex,
        onTabChange: (int v) => setState(() {
          _currentindex = v;
        }),
        border: Border(
          top: BorderSide(
            color: AppColor.grey2,
            width: 1.5
          )
        ),

        // decorate
        backgroundColor: AppColor.base1,
        backgroundOpacity: 1,
        backgroundBlur: 0,
        borderRadius: 0,
        buttonBorderRadius: 20,

        outerPadding: EdgeInsets.zero,
        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),

        buttonSpacing: 10,

        activeButtonFlexFactor: 1,
        inactiveButtonsFlexFactor: 1,

        animationDuration: Duration(milliseconds: 0),
        
        iconSize: 24,
        activeIconColor: AppColor.base1,
        inactiveIconColor: AppColor.grey3,

        navigationBarButtons: <NavigationBarButton>[
          NavigationBarButton(
            icon: LucideIcons.messageCircleMore,
            backgroundColor: AppColor.main2
          ),

          NavigationBarButton(
            icon: LucideIcons.user,
            backgroundColor: AppColor.main2
          ),
        ],
      )
    );
  }
}