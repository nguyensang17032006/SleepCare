import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep_app_frontend/core/app/main_layout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:sleep_app_frontend/features/auth/presentation/views/login/login_screen.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/entities/assessment_requirement.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/usecases/check_required_assessment.dart';
import 'package:sleep_app_frontend/features/onboarding/presentation/questionnaire_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  String? _errorMessage;
  AssessmentRequirement? _requirement;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthenticationAndAssessment();
    });
  }

  Future<void> _checkAuthenticationAndAssessment() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _requirement = null;
      });

      return;
    }

    final useCase = context.read<CheckRequiredAssessment>();
    final result = await useCase();

    if (!mounted) return;

    result.match(
      (failure) {
        setState(() {
          _isLoading = false;
          _errorMessage = failure.message;
        });
      },
      (requirement) {
        setState(() {
          _isLoading = false;
          _requirement = requirement;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      return const LoginScreen();
    }

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(_errorMessage!, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _checkAuthenticationAndAssessment,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    switch (_requirement) {
      case AssessmentRequirement.baselineFull:
      case AssessmentRequirement.repeatFull:
        return const QuestionnaireScreen();

      case AssessmentRequirement.dailyShort:
      case AssessmentRequirement.none:
        return const MainAppScreen();

      case null:
        return const Scaffold(
          body: Center(child: Text('Không xác định được trạng thái khảo sát')),
        );
    }
  }
}
