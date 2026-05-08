import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:sleep_app_frontend/features/auth/presentation/viewmodels/password_visibility_viewmodel.dart"; 
import "package:sleep_app_frontend/features/auth/presentation/widgets/common/title_widget.dart";
import "package:sleep_app_frontend/features/auth/presentation/widgets/login_form.dart";
import "package:sleep_app_frontend/features/auth/presentation/widgets/common/floatframe_widget.dart";

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PasswordVisibility(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const TitleWidget(),
                const SizedBox(height: 40),
                const FloatFrameWidget(child: LoginForm()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
