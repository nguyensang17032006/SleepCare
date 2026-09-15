import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:sleep_app_frontend/core/app/main_layout.dart';

import 'package:sleep_app_frontend/features/auth/presentation/views/login/login_screen.dart';

import 'package:sleep_app_frontend/features/onboarding/domain/entities/assessment_requirement.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/usecases/check_required_assessment.dart';
import 'package:sleep_app_frontend/features/onboarding/presentation/questionnaire_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({
    super.key,
  });

  @override
  State<AuthWrapper> createState() =>
      _AuthWrapperState();
}

class _AuthWrapperState
    extends State<AuthWrapper> {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  bool _isLoading = true;

  bool _isAuthenticated = false;

  String? _errorMessage;

  AssessmentRequirement? _requirement;

  @override
  void initState() {
    super.initState();

    _checkAuthenticationAndAssessment();
  }

  // =========================================================
  // CHECK AUTH + ASSESSMENT
  // =========================================================

  Future<void>
      _checkAuthenticationAndAssessment() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // =====================================================
      // 1. CHECK LOCAL SESSION
      // =====================================================

      final session =
          _supabase.auth.currentSession;

      final user =
          _supabase.auth.currentUser;

      debugPrint(
        'AUTH WRAPPER SESSION: '
        '${session != null}',
      );

      debugPrint(
        'AUTH WRAPPER USER: '
        '${user?.id}',
      );

      // Không có session / user
      if (session == null ||
          user == null) {
        debugPrint(
          'AUTH WRAPPER: '
          'NO AUTHENTICATED USER',
        );

        if (!mounted) return;

        setState(() {
          _isAuthenticated =
              false;

          _isLoading = false;

          _requirement = null;

          _errorMessage = null;
        });

        return;
      }

      // =====================================================
      // 2. USER ĐÃ LOGIN
      // =====================================================

      debugPrint(
        'AUTH WRAPPER: '
        'USER AUTHENTICATED',
      );

      if (!mounted) return;

      setState(() {
        _isAuthenticated = true;
      });

      // =====================================================
      // 3. CHECK QUESTIONNAIRE
      // =====================================================

      debugPrint(
        'AUTH WRAPPER: '
        'CHECKING ASSESSMENT...',
      );

      final useCase =
          context.read<
              CheckRequiredAssessment>();

      final result =
          await useCase().timeout(
        const Duration(
          seconds: 15,
        ),
      );

      if (!mounted) return;

      result.match(
        (failure) {
          debugPrint(
            'ASSESSMENT CHECK FAILED: '
            '${failure.message}',
          );

          setState(() {
            _isLoading = false;

            _errorMessage =
                failure.message;
          });
        },
        (requirement) {
          debugPrint(
            'ASSESSMENT REQUIREMENT: '
            '$requirement',
          );

          setState(() {
            _requirement =
                requirement;

            _isLoading = false;

            _errorMessage = null;
          });
        },
      );
    } on TimeoutException {
      debugPrint(
        'AUTH WRAPPER: '
        'ASSESSMENT CHECK TIMEOUT',
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;

        _errorMessage =
            'Không thể kiểm tra trạng thái khảo sát. '
            'Vui lòng thử lại.';
      });
    } on AuthException catch (e) {
      debugPrint(
        'AUTH WRAPPER AUTH ERROR: '
        '${e.message}',
      );

      await _clearInvalidSession();
    } catch (e, stackTrace) {
      debugPrint(
        'AUTH WRAPPER ERROR: $e',
      );

      debugPrint(
        'AUTH WRAPPER STACK: '
        '$stackTrace',
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;

        _errorMessage =
            'Đã xảy ra lỗi khi kiểm tra đăng nhập.';
      });
    }
  }

  // =========================================================
  // CLEAR INVALID SESSION
  // =========================================================

  Future<void>
      _clearInvalidSession() async {
    try {
      await _supabase.auth.signOut(
        scope: SignOutScope.local,
      );
    } catch (e) {
      debugPrint(
        'LOCAL SIGN OUT ERROR: $e',
      );
    }

    if (!mounted) return;

    setState(() {
      _isAuthenticated = false;

      _isLoading = false;

      _requirement = null;

      _errorMessage = null;
    });
  }

  // =========================================================
  // RETRY
  // =========================================================

  Future<void> _retry() async {
    await _checkAuthenticationAndAssessment();
  }

  // =========================================================
  // UI
  // =========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    // =======================================================
    // LOADING
    // =======================================================

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    // =======================================================
    // NOT LOGIN
    // =======================================================

    if (!_isAuthenticated) {
      return const LoginScreen();
    }

    // =======================================================
    // ERROR
    // =======================================================

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding:
                const EdgeInsets.all(
              24,
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color:
                      Colors.redAccent,
                  size: 48,
                ),

                const SizedBox(
                  height: 12,
                ),

                Text(
                  _errorMessage!,
                  textAlign:
                      TextAlign.center,
                ),

                const SizedBox(
                  height: 16,
                ),

                ElevatedButton(
                  onPressed: _retry,
                  child:
                      const Text(
                    'Thử lại',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // =======================================================
    // QUESTIONNAIRE ROUTING
    // =======================================================

    switch (_requirement) {
      // User cần làm questionnaire đầy đủ
      case AssessmentRequirement
            .baselineFull:
      case AssessmentRequirement
            .repeatFull:
        debugPrint(
          'AUTH WRAPPER → '
          'QUESTIONNAIRE',
        );

        return const QuestionnaireScreen();

      // User không cần questionnaire đầy đủ
      case AssessmentRequirement
            .dailyShort:
      case AssessmentRequirement.none:
        debugPrint(
          'AUTH WRAPPER → '
          'MAIN APP',
        );

        return const MainAppScreen();

      // Chưa xác định
      case null:
        return Scaffold(
          body: Center(
            child: Padding(
              padding:
                  const EdgeInsets.all(
                24,
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  const Text(
                    'Không xác định được '
                    'trạng thái khảo sát.',
                    textAlign:
                        TextAlign.center,
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  ElevatedButton(
                    onPressed:
                        _retry,
                    child:
                        const Text(
                      'Thử lại',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}