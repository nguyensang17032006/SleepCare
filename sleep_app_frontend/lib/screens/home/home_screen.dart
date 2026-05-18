import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/glass_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppTheme.textLight),
          onPressed: () {},
        ),
        title: const Text('The Sanctuary', style: TextStyle(color: AppTheme.textLight, fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: AppTheme.cardLightColor,
              radius: 16,
              child: Image.asset('assets/images/logo.png', width: 20, height: 20, errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 16)),
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primaryColor.withOpacity(0.5), width: 2),
                    boxShadow: [
                      BoxShadow(color: AppTheme.primaryColor.withOpacity(0.15), spreadRadius: 10, blurRadius: 40),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('07:45', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 48, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        const Text('TIME REMAINING', style: TextStyle(color: AppTheme.textMuted, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatusChip(Icons.bed, 'Bedtime', 'Excellent'),
                  const SizedBox(width: 16),
                  _buildStatusChip(Icons.thermostat, 'Room', '22.5°C'),
                ],
              ),
              const SizedBox(height: 40),
              const Text('SOOTHING MELODY SELECTION', style: TextStyle(color: AppTheme.primaryColor, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Choose music to your preference', style: TextStyle(color: AppTheme.textLight, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E2646), Color(0xFF0F1528)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/forest_moon.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Midnight Ballad', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('Deep Relaxation • 45m', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.water_drop, color: AppTheme.primaryColor, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('ACTIVE SESSION', style: TextStyle(color: AppTheme.textMuted, fontSize: 10, letterSpacing: 1.0)),
                          SizedBox(height: 4),
                          Text('Ocean Waves & Rain', style: TextStyle(color: AppTheme.textLight, fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const Icon(Icons.equalizer, color: AppTheme.primaryColor),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardLightColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 16),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: AppTheme.textMuted, fontSize: 10)),
              Text(value, style: const TextStyle(color: AppTheme.textLight, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
