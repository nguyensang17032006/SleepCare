import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:sleep_app_frontend/features/auth/presentation/viewmodels/checbox_privacy_viewmodel.dart";
import "package:sleep_app_frontend/features/auth/presentation/widgets/common/floatframe_widget.dart";
import "package:sleep_app_frontend/features/auth/presentation/widgets/common/title_widget.dart";
import "package:sleep_app_frontend/features/auth/presentation/widgets/signup_form.dart";

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CheckboxPrivacy(),
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
                const SizedBox(height: 20),
                const FloatFrameWidget(child: SignupForm()),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 153, 255),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
