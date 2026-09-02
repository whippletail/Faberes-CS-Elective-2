
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

void main() => runApp(const DashboardApp());


class AppColors {
  static const background = Color(0xFFF7F8FA);
  static const sidebarBackground = Color(0xFFFFFFFF);
  static const divider = Color(0xFFE3E5E9);

  static const unselected = Color(0xFF8A94A6); // muted slate grey
  static const selected = Color(0xFF3E4C59); // darker slate
  static const selectedPillBg = Color(0xFFE8F0FE); // pastel highlight

  static const tileDark = Color(0xFFB4B7BC); // top grid boxes
  static const tileLight = Color(0xFFEAEBEE); // list rows
}

// ---------------------------------------------------------------------------
// App root
// ---------------------------------------------------------------------------

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive & Adaptive Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3E4C59)),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.selected,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

// ---------------------------------------------------------------------------

enum DeviceType { mobile, tablet, desktop }

DeviceType deviceTypeOf(double width) {
  if (width < 600) return DeviceType.mobile;
  if (width < 1024) return DeviceType.tablet;
  return DeviceType.desktop;
}


enum AppPlatform { android, ios, web }

AppPlatform currentPlatform() {
  if (kIsWeb) return AppPlatform.web;
  if (Platform.isIOS) return AppPlatform.ios;
  return AppPlatform.android;
}

// ---------------------------------------------------------------------------

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

const _navItems = [
  _NavItem(icon: Icons.dashboard_outlined, label: 'Dashboard'),
  _NavItem(icon: Icons.settings_outlined, label: 'Settings'),
  _NavItem(icon: Icons.info_outline, label: 'About'),
  _NavItem(icon: Icons.logout, label: 'Logout'),
];

// ---------------------------------------------------------------------------

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onSelect(int index) {
    setState(() => _selectedIndex = index);
    Navigator.of(context).maybePop(); 
  }

  @override
  Widget build(BuildContext context) {
    final platform = currentPlatform();

    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = deviceTypeOf(constraints.maxWidth);

        if (deviceType == DeviceType.desktop) {
          return _DesktopLayout(
            selectedIndex: _selectedIndex,
            onSelect: _onSelect,
            platform: platform,
          );
        }

        final crossAxisCount = deviceType == DeviceType.mobile ? 2 : 4;

        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(platform == AppPlatform.ios
                    ? CupertinoIcons.bars
                    : Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          drawer: _NavDrawer(
            selectedIndex: _selectedIndex,
            onSelect: _onSelect,
          ),
          body: SafeArea(
            child: _DashboardBody(crossAxisCount: crossAxisCount),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------

class _NavDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _NavDrawer({required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.sidebarBackground,
      width: 260,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: _SidebarContent(
            selectedIndex: selectedIndex,
            onSelect: onSelect,
            extended: true,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _DesktopLayout extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final AppPlatform platform;

  const _DesktopLayout({
    required this.selectedIndex,
    required this.onSelect,
    required this.platform,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: 220,
              color: AppColors.sidebarBackground,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: _SidebarContent(
                selectedIndex: selectedIndex,
                onSelect: onSelect,
                extended: true,
              ),
            ),
            const VerticalDivider(width: 1, color: AppColors.divider),
            Expanded(
              flex: 5,
              child: _DashboardBody(crossAxisCount: 4),
            ),
            const VerticalDivider(width: 1, color: AppColors.divider),
            Expanded(
              flex: 2,
              child: _SidePanel(platform: platform),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _SidebarContent extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final bool extended;

  const _SidebarContent({
    required this.selectedIndex,
    required this.onSelect,
    required this.extended,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.favorite, size: 32, color: AppColors.selected),
        const SizedBox(height: 16),
        const Divider(color: AppColors.divider, height: 1),
        const SizedBox(height: 20),
        for (var i = 0; i < _navItems.length; i++) ...[
          _SidebarTile(
            item: _navItems[i],
            selected: i == selectedIndex,
            onTap: () => onSelect(i),
          ),
          const SizedBox(height: 6),
        ],
      ],
    );
  }
}

class _SidebarTile extends StatelessWidget {
  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.selected : AppColors.unselected;

    return Material(
      color: selected ? AppColors.selectedPillBg : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(item.icon, size: 18, color: color),
              const SizedBox(width: 14),
              Text(
                item.label.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _DashboardBody extends StatelessWidget {
  final int crossAxisCount;

  const _DashboardBody({required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4, 

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) => const _WireframeBox(
            height: 100,
            color: AppColors.tileDark,
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < 4; i++) ...[
          const _WireframeBox(height: 56, color: AppColors.tileLight),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _WireframeBox extends StatelessWidget {
  final double height;
  final Color color;
  const _WireframeBox({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _SidePanel extends StatelessWidget {
  final AppPlatform platform;
  const _SidePanel({required this.platform});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(
            child: _WireframeBox(height: double.infinity, color: AppColors.tileDark),
          ),
          const SizedBox(height: 12),
          const _WireframeBox(height: 140, color: AppColors.tileLight),
          const SizedBox(height: 12),
          AdaptiveButton(
            label: 'Continue',
            onPressed: () {},
            platform: platform,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class AdaptiveButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final AppPlatform platform;

  const AdaptiveButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.platform,
  });

  @override
  Widget build(BuildContext context) {
    if (platform == AppPlatform.ios) {
      return CupertinoButton.filled(
        onPressed: onPressed,
        child: Text(label),
      );
    }
    return FilledButton.tonal(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: Text(label),
    );
  }
}