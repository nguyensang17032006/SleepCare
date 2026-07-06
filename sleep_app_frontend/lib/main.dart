import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sleep_app_frontend/features/auth/data/sources/auth_sources.dart';
import 'package:sleep_app_frontend/features/auth/repository/auth_repository.dart';
import 'package:sleep_app_frontend/features/auth/presentation/viewmodels/auth_vm.dart';
import 'package:sleep_app_frontend/features/auth/presentation/views/login/login_screen.dart';
import 'package:sleep_app_frontend/features/setting/data/sources/logout_sources.dart';
import 'package:sleep_app_frontend/features/setting/data/sources/profile_sources.dart';
import 'package:sleep_app_frontend/features/setting/presentation/viewmodels/profile_vm.dart';
import 'package:sleep_app_frontend/features/setting/repository/logout_repository.dart';
import 'package:sleep_app_frontend/features/setting/presentation/viewmodels/logout_vm.dart';
import 'package:sleep_app_frontend/features/onboarding/questionnaire_screen.dart';
import 'package:sleep_app_frontend/features/setting/repository/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: '${dotenv.env['SUPABASE_URL']}',
    // ignore: deprecated_member_use
    anonKey: '${dotenv.env['SUPABASE_ANON_KEY']}',
  );

  runApp(
    MultiProvider(
      providers: [
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
      ],
      child: const MyApp(),
    ),
  );
}

final supabaseClient = Supabase.instance.client;

//  Chuyển MyApp thành StatefulWidget để lắng nghe Auth State toàn cục
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<AuthState>? _authSubscription;
  final _navigatorKey =
      GlobalKey<
        NavigatorState
      >(); // Key để điều hướng từ bên ngoài Context nếu cần

  @override
  void initState() {
    super.initState();

    // Lắng nghe sự kiện thay đổi trạng thái Auth từ Supabase
    _authSubscription = supabaseClient.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      // Chỉ chuyển màn hình khi có sự kiện SIGNED_IN thực sự hoàn tất (kể cả từ Google OAuth)
      if (event == AuthChangeEvent.signedIn && session != null) {
        _navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => const QuestionnaireScreen()),
        );
      }

      // Nếu user đăng xuất, có thể đưa họ về lại màn Login
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
      designSize: const Size(
        360,
        690,
      ), // Kích thước màn hình Figma gốc bạn chọn cho Mobile
      minTextAdapt: true, // Đảm bảo chữ tự động thích ứng thông minh
      splitScreenMode:
          true, // Hỗ trợ tốt khi dùng tính năng chia đôi màn hình/Màn hình Tablet lớn
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: _navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'SleepCare',
          theme: AppTheme.darkTheme,
          home: const LoginScreen(),
        );
      },
    );
  }
}
