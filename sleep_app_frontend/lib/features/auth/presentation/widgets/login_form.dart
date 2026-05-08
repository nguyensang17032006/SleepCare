import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:sleep_app_frontend/features/auth/presentation/viewmodels/password_visibility_viewmodel.dart";
import "package:sleep_app_frontend/features/auth/presentation/widgets/common/button_widget.dart";
import "package:sleep_app_frontend/features/auth/presentation/widgets/common/textfield_widget.dart";
import "package:sleep_app_frontend/features/auth/presentation/views/signup_view.dart";

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<PasswordVisibility>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Welcome back!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),

        const Text(
          "Ready for you restoravtive journey?",
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),

        const SizedBox(height: 20),
        const TextFieldWidget(
          label: "Username",
          hintText: "Enter user name",
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: 20),

        TextFieldWidget(
          label: "Password",
          hintText: "Enter your password",
          prefixIcon: Icons.lock_outline,
          obscureText: authVM.isPasswordVisible,
          onSuffixIconPressed: () => authVM.togglePasswordVisibility(),
        ),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              "Forgot password?",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ),

        const SizedBox(height: 10),

        ButtonWidget(text: "Sign In", onPressed: () {}),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.white.withValues(alpha: 0.1),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "OR",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.white.withValues(alpha: 0.1),
                thickness: 1,
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        ButtonWidget(
          text: "Create account",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignupView()),
            );
          },
        ),
        const SizedBox(height: 15),
        ButtonWidget(
          text: "Sign in with Google",
          icon: Image.asset('assets/images/google.png', width: 20, height: 20),
          onPressed: () {},
        ),
        const SizedBox(height: 15),
        ButtonWidget(
          text: "Sign in with phone number",
          icon: const Icon(Icons.phone, color: Colors.white, size: 20),
          onPressed: () {},
        ),
      ],
    );
  }
}
