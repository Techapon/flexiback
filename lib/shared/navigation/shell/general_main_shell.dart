import 'package:flexiback/core/mappers/get_role.dart';
import 'package:flexiback/features/device/presentation/pages/device_page.dart';
import 'package:flexiback/features/relation/presentation/controller/relation_provider.dart';
import 'package:flexiback/features/relation/presentation/pages/chat_page.dart';
import 'package:flexiback/features/profile/presentation/pages/profile_page.dart';
import 'package:flexiback/features/zz/therapy.dart';
import 'package:flexiback/features/trend/presentation/pages/trend_page.dart';
import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';

import '../../../features/profile/presentation/controller/profile_provider.dart';
import '../items/geneeral_items.dart';
class GeneralMainShell extends StatefulWidget {
  final String? userId;
  const GeneralMainShell({
    super.key,
    this.userId
  });

  @override
  State<GeneralMainShell> createState() => _GeneralMainShellState();
}

class _GeneralMainShellState extends State<GeneralMainShell> {
  int _currentindex = 2;

  List<Widget> get _pages => [
    TherapyPage(),
    DevicePage(
      setCurrent: (GeneralMainTap newCurrent) {
        setState(() {
          _currentindex = newCurrent.index;
        });
      },
      userId: widget.userId,
    ),
    TrendPage(
      userId: widget.userId,
    ),
    ChatPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final _profileProvider = context.read<ProfileProvider>();
      await _profileProvider.getProfile();
      context.read<RelationProvider>().getRelations(getOppositeRole(_profileProvider.role.entity));
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

        animationDuration: Duration.zero,
        
        iconSize: 24,
        activeIconColor: AppColor.base1,
        inactiveIconColor: AppColor.grey3,

        navigationBarButtons: <NavigationBarButton>[
          NavigationBarButton(
            icon: LucideIcons.personStanding,
            backgroundColor: AppColor.main2
          ),

          NavigationBarButton(
            icon: LucideIcons.rows3,
            backgroundColor: AppColor.main2
          ),

          NavigationBarButton(
            icon: LucideIcons.chartColumnBig,
            backgroundColor: AppColor.main2
          ),

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