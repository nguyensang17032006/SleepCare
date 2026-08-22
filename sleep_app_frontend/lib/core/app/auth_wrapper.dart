import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../main.dart'; // supabaseClient
import '../../../features/auth/presentation/views/login/login_screen.dart';
import '../../../features/onboarding/questionnaire_screen.dart';
import '../../../core/app/main_layout.dart';
import '../../../features/setting/presentation/viewmodels/profile_vm.dart';
import '../../../core/theme/theme.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    final session = supabaseClient.auth.currentSession;
    
    if (session == null) {
      // Not logged in -> Login Screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
      return;
    }

    // Logged in -> Fetch profile to check onboarding status
    try {
      final profileVm = context.read<ProfileViewModel>();
      await profileVm.loadProfile(session.user.id);
      
      if (mounted) {
        if (profileVm.user != null && profileVm.user!.onboardingCompleted) {
          // Check if it's been 30 days since the last full PSQI
          bool needsRepeat = false;
          try {
            final lastAssessment = await supabaseClient
                .from('sleep_assessments')
                .select('created_at')
                .inFilter('assessment_type', ['baseline_full', 'repeat_full'])
                .eq('user_id', session.user.id)
                .order('created_at', ascending: false)
                .limit(1)
                .maybeSingle();

            if (lastAssessment != null) {
              final lastDate = DateTime.parse(lastAssessment['created_at']);
              if (DateTime.now().difference(lastDate).inDays >= 30) {
                needsRepeat = true;
              }
            }
          } catch (e) {
            // Ignore error and proceed to Main App
          }

          if (needsRepeat && mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const QuestionnaireScreen()),
            );
          } else if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainAppScreen()),
            );
          }
        } else {
          // Onboarding NOT completed -> Questionnaire
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const QuestionnaireScreen()),
          );
        }
      }
    } catch (e) {
      // If error fetching profile, fallback to login or retry
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while checking auth and fetching profile
    return const Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
        ),
      ),
    );
  }
}
