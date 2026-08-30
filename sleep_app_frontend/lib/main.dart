import 'dart:async';
import 'package:sleep_app_frontend/core/services/audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:sleep_app_frontend/features/library/domain/repositories/library_repository_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:sleep_app_frontend/core/app/auth_wrapper.dart';
import 'package:sleep_app_frontend/core/app/locale_provider.dart';
import 'package:sleep_app_frontend/core/services/notification_service.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';

import 'package:sleep_app_frontend/features/auth/data/sources/auth_sources.dart';
import 'package:sleep_app_frontend/features/auth/presentation/viewmodels/auth_vm.dart';
import 'package:sleep_app_frontend/features/auth/presentation/views/login/login_screen.dart';
import 'package:sleep_app_frontend/features/auth/repository/auth_repository.dart';

import 'package:sleep_app_frontend/features/library/data/datasource/library_remote_datasource.dart';
import 'package:sleep_app_frontend/features/library/presentation/bloc/library_bloc.dart';
import 'package:sleep_app_frontend/features/library/presentation/bloc/library_event.dart';

import 'package:sleep_app_frontend/features/onboarding/viewmodels/daily_short_vm.dart';
import 'package:sleep_app_frontend/features/onboarding/viewmodels/questionnaire_vm.dart';

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
    // ignore: deprecated_member_use
    anonKey: '${dotenv.env['SUPABASE_ANON_KEY']}',
  );

  await NotificationService().init();

  runApp(
    MultiProvider(
      providers: [
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

        ChangeNotifierProvider(create: (_) => QuestionnaireViewModel()),

        ChangeNotifierProvider(create: (_) => DailyShortViewModel()),

        ChangeNotifierProvider(create: (_) => LocaleProvider()),

       BlocProvider<LibraryBloc>(
  create: (_) => LibraryBloc(
    repository:
        LibraryRepositoryImpl(
      remoteDatasource:
          LibraryRemoteDatasource(
        supabase:
            Supabase.instance.client,
      ),
    ),
  )..add(
      LoadLibrary(),
    ),
),
      ],
      child: const MyApp(),
    ),
  );
}

final supabaseClient = Supabase.instance.client;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<AuthState>? _authSubscription;

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    _authSubscription = supabaseClient.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;

      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.initialSession) {
        _navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => const AuthWrapper()),
        );
      }

      if (event == AuthChangeEvent.signedOut) {
        _navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final localeProvider = Provider.of<LocaleProvider>(context);

        return MaterialApp(
          navigatorKey: _navigatorKey,
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
          home: child,
        );
      },
      child: const AuthWrapper(),
    );
  }
}
