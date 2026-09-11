import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_mint/core/extensions/edge_insets_extension.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../feed/view/feed_view.dart';
import '../../profile/view/profile_view.dart';
import '../../search/view/search_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 1; // Default selected tab: Home (Index 1)

  void _selectTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final navBgColor = isDark ? AppColors.bottomNavBackgroundDark : AppColors.bottomNavBackgroundLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    final List<Widget> pages = [
      SearchView(onSelectTab: _selectTab),
      const FeedView(),
      const ProfileView(),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        // height: AppConstants.bottomNavHeight,
        decoration: BoxDecoration(
          color: navBgColor,
          border: Border(
            top: BorderSide(color: borderColor, width: 1),
          ),
        ),
        child: Padding(
          padding: edge.v10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: CupertinoIcons.search,
                selectedIcon: CupertinoIcons.search,
                label: AppStrings.tabSearch,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
              _buildNavItem(
                index: 1,
                icon: CupertinoIcons.home,
                selectedIcon: CupertinoIcons.house_fill,
                label: AppStrings.tabHome,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
              _buildNavItem(
                index: 2,
                icon: CupertinoIcons.person,
                selectedIcon: CupertinoIcons.person_fill,
                label: AppStrings.tabProfile,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => _selectTab(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 24,
            ),
            // const SizedBox(height: 2),
            // Text(
            //   label,
            //   style: isSelected
            //       ? poppins.get11.bold.textColor(activeColor)
            //       : poppins.get11.medium.textColor(inactiveColor),
            // ),
          ],
        ),
      ),
    );
  }
}
