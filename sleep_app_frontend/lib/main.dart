import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:sleep_app_frontend/core/services/audio_player_service.dart';
import 'package:sleep_app_frontend/core/services/notification_service.dart';
import 'package:sleep_app_frontend/core/app/auth_wrapper.dart';
import 'package:sleep_app_frontend/core/app/locale_provider.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';

import 'package:sleep_app_frontend/features/auth/data/sources/auth_sources.dart';
import 'package:sleep_app_frontend/features/auth/presentation/viewmodels/auth_vm.dart';
import 'package:sleep_app_frontend/features/auth/presentation/views/login/login_screen.dart';
import 'package:sleep_app_frontend/features/auth/repository/auth_repository.dart';

import 'package:sleep_app_frontend/features/library/domain/repositories/library_repository_impl.dart';
import 'package:sleep_app_frontend/features/library/data/datasource/library_remote_datasource.dart';
import 'package:sleep_app_frontend/features/library/presentation/bloc/library_bloc.dart';
import 'package:sleep_app_frontend/features/library/presentation/bloc/library_event.dart';

import 'package:sleep_app_frontend/features/onboarding/data/datasources/onboarding_remote_datasource.dart';
import 'package:sleep_app_frontend/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/services/sleep_scoring_service.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/usecases/check_required_assessment.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/usecases/get_active_question.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/usecases/get_daily_sleep_scores.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/usecases/submit_sleep_assessment.dart';
import 'package:sleep_app_frontend/features/onboarding/presentation/bloc/daily_short/daily_short_bloc.dart';
import 'package:sleep_app_frontend/features/onboarding/presentation/bloc/questionnaire/questionnaire_bloc.dart';

import 'package:sleep_app_frontend/features/report/data/datasources/report_remote_datasource.dart';
import 'package:sleep_app_frontend/features/report/data/repositories/report_repository_impl.dart';
import 'package:sleep_app_frontend/features/report/presentation/bloc/report_bloc.dart';

import 'package:sleep_app_frontend/features/setting/data/sources/logout_sources.dart';
import 'package:sleep_app_frontend/features/setting/data/sources/profile_sources.dart';
import 'package:sleep_app_frontend/features/setting/presentation/viewmodels/logout_vm.dart';
import 'package:sleep_app_frontend/features/setting/presentation/viewmodels/profile_vm.dart';
import 'package:sleep_app_frontend/features/setting/repository/logout_repository.dart';
import 'package:sleep_app_frontend/features/setting/repository/profile_repository.dart';

import 'package:sleep_app_frontend/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: '${dotenv.env['SUPABASE_URL']}',
    anonKey: '${dotenv.env['SUPABASE_ANON_KEY']}',
  );

  await NotificationService().init();

  runApp(
    MultiProvider(
      providers: [
        Provider<SleepScoringService>(
          create: (_) => const SleepScoringService(),
        ),

        Provider<AudioPlayerService>(
          create: (_) => AudioPlayerService(),
          dispose: (_, service) {
            service.dispose();
          },
        ),

        ChangeNotifierProvider(
          create: (_) => AuthViewModel(AuthRepository(AuthRemoteSource())),
        ),

        ChangeNotifierProvider(
          create: (_) =>
              LogoutViewModel(LogoutRepository(LogoutRemoteDataSource())),
        ),

        ChangeNotifierProvider(
          create: (_) =>
              ProfileViewModel(ProfileRepository(ProfileRemoteDataSource())),
        ),

        ChangeNotifierProvider(create: (_) => LocaleProvider()),

        Provider<OnboardingRemoteDataSource>(
          create: (_) => OnboardingRemoteDataSourceImpl(
            supabaseClient: Supabase.instance.client,
          ),
        ),

        Provider<OnboardingRepository>(
          create: (context) => OnboardingRepositoryImpl(
            remoteDataSource: context.read<OnboardingRemoteDataSource>(),
          ),
        ),

        Provider<CheckRequiredAssessment>(
          create: (context) =>
              CheckRequiredAssessment(context.read<OnboardingRepository>()),
        ),

        Provider<GetActiveQuestions>(
          create: (context) =>
              GetActiveQuestions(context.read<OnboardingRepository>()),
        ),

        Provider<GetDailySleepScores>(
          create: (context) =>
              GetDailySleepScores(context.read<OnboardingRepository>()),
        ),

        Provider<SubmitSleepAssessment>(
          create: (context) =>
              SubmitSleepAssessment(context.read<OnboardingRepository>()),
        ),

        BlocProvider<DailyShortBloc>(
          create: (context) => DailyShortBloc(
            getActiveQuestions: context.read<GetActiveQuestions>(),
            submitSleepAssessment: context.read<SubmitSleepAssessment>(),
          ),
        ),

        BlocProvider<QuestionnaireBloc>(
          create: (context) => QuestionnaireBloc(
            checkRequiredAssessment: context.read<CheckRequiredAssessment>(),
            getActiveQuestions: context.read<GetActiveQuestions>(),
            submitSleepAssessment: context.read<SubmitSleepAssessment>(),
            scoringService: context.read<SleepScoringService>(),
          ),
        ),

        BlocProvider<LibraryBloc>(
          create: (_) => LibraryBloc(
            repository: LibraryRepositoryImpl(
              remoteDatasource: LibraryRemoteDatasource(
                supabase: Supabase.instance.client,
              ),
            ),
          )..add(LoadLibrary()),
        ),

        BlocProvider<ReportBloc>(
          create: (_) => ReportBloc(
            repository: ReportRepositoryImpl(
              remoteDataSource: ReportRemoteDataSourceImpl(
                supabaseClient: Supabase.instance.client,
              ),
            ),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

final supabaseClient = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          title: 'SleepCare',

          theme: AppTheme.darkTheme,

          locale: localeProvider.locale,

          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          supportedLocales: const [Locale('en'), Locale('vi')],

          // ==========================================
          // AUTH ROOT
          // ==========================================
          home: const _AuthRoot(),
        );
      },
    );
  }
}

// =============================================================
// AUTH ROOT
// =============================================================

class _AuthRoot extends StatefulWidget {
  const _AuthRoot();

  @override
  State<_AuthRoot> createState() => _AuthRootState();
}

class _AuthRootState extends State<_AuthRoot> {
  late final SupabaseClient _supabase;

  AuthChangeEvent? _lastEvent;

  @override
  void initState() {
    super.initState();

    _supabase = Supabase.instance.client;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: _supabase.auth.onAuthStateChange,

      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final authState = snapshot.data!;

          _lastEvent = authState.event;

          debugPrint(
            'AUTH ROOT EVENT: '
            '${authState.event}',
          );

          debugPrint(
            'AUTH ROOT SESSION: '
            '${authState.session != null}',
          );
        }

        final session = _supabase.auth.currentSession;

        final user = _supabase.auth.currentUser;

        debugPrint(
          'AUTH ROOT CURRENT SESSION: '
          '${session != null}',
        );

        debugPrint(
          'AUTH ROOT CURRENT USER: '
          '${user?.id}',
        );

        // ==========================================
        // PASSWORD RECOVERY
        // ==========================================
        //
        // Recovery tạo session tạm.
        // Không được coi session recovery như login
        // bình thường để nhảy vào Home.
        // ==========================================

        if (_lastEvent == AuthChangeEvent.passwordRecovery) {
          return const LoginScreen();
        }

        // ==========================================
        // NOT LOGGED IN
        // ==========================================

        if (session == null || user == null) {
          return const LoginScreen();
        }

        // ==========================================
        // LOGGED IN
        // ==========================================

        return const AuthWrapper();
      },
    );
  }
}
