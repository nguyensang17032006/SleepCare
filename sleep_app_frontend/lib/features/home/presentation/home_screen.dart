import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/features/home/presentation/widget/home_header.dart';
import 'package:sleep_app_frontend/features/home/presentation/widget/home_recommended_track.dart';
import 'package:sleep_app_frontend/features/home/presentation/widget/home_sleep_timer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFF00142B),
          child: Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Column(
              children: [
                HeaderWidget(),

                SizedBox(height: 20),

                SleepTimer(size: size),

                SizedBox(height: 20),

                RecommendedTrack(size: size),

                SizedBox(height: size.height * 0.13),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
