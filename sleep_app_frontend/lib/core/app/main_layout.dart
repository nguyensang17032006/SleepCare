import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/core/app/widget/app_bar.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleep_app_frontend/features/home/presentation/home_screen.dart';
import 'package:sleep_app_frontend/features/library/presentation/library_screen.dart';
import 'package:sleep_app_frontend/features/library/presentation/widget/mini_player.dart';
import 'package:sleep_app_frontend/features/report/presentation/report_screen.dart';
import 'package:sleep_app_frontend/features/setting/presentation/views/settings_screen.dart';
import 'package:sleep_app_frontend/features/sleep_session/presentation/bloc/SleepPrep/sleep_prep_bloc.dart';
import 'package:sleep_app_frontend/features/sleep_session/presentation/bloc/SleepPrep/sleep_prep_event.dart';
import 'package:sleep_app_frontend/features/sleep_session/presentation/sleep_prep_screen.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  late AnimationController _animationController;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _screens = [
      const HomeScreen(),
      const LibraryScreen(),

      SleepPrepScreen(
        onOpenLibrary: () {
          _onTabTapped(1);
        },
      ),

      ReportScreen(
        onOpenSleep: () {
          _onTabTapped(2);
        },
      ),

      const SettingsScreen(),
    ];

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == 2) {
      context.read<SleepPrepBloc>().add(const SleepPrepStarted());
    }

    if (_currentIndex == index) {
      return;
    }

    setState(() {
      _currentIndex = index;
    });

    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(onProfileTap: () => _onTabTapped(4)),

      body: FadeTransition(
        opacity: _animationController,
        child: IndexedStack(index: _currentIndex, children: _screens),
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mini player sẽ nằm ngay trên NavigationBar
          const MiniPlayer(),

          NavigationBar(
            height: 60,
            selectedIndex: _currentIndex,
            onDestinationSelected: _onTabTapped,
            backgroundColor: AppTheme.bgColor,
            indicatorColor: AppTheme.primaryColor.withValues(alpha: 0.2),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.nightlight_round),
                label: '',
              ),
              NavigationDestination(
                icon: Icon(Icons.library_music_outlined),
                selectedIcon: Icon(Icons.library_music),
                label: '',
              ),
              NavigationDestination(
                icon: Icon(Icons.bedtime_outlined),
                selectedIcon: Icon(Icons.bedtime),
                label: '',
              ),
              NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart),
                label: '',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: '',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
