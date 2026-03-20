import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'components/top_app_bar.dart';
import 'components/bottom_nav_bar.dart';
import 'components/side_drawer.dart';
import 'providers/app_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/system_selection_screen.dart';
import 'screens/vedic_view_screen.dart';
import 'screens/western_view_screen.dart';
import 'screens/tarot_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ObsidianAstroApp());
}

class ObsidianAstroApp extends StatelessWidget {
  const ObsidianAstroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider()..initialize(),
      child: MaterialApp(
        title: 'Obsidian Astro',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainLayout(),
      ),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    SystemSelectionScreen(),
    WesternViewScreen(),
    VedicViewScreen(),
    TarotScreen(),
    OnboardingScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen title based on current index
    String title = 'Obsidian Astro';
    if (_currentIndex == 1) title = 'Western Chart';
    else if (_currentIndex == 2) title = 'Vedic Mode';
    else if (_currentIndex == 3) title = 'Tarot Suite';
    else if (_currentIndex == 4) title = 'Onboarding';

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      drawer: const SideDrawer(),
      appBar: TopAppBar(
        onMenuPressed: _openDrawer,
        title: title,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
