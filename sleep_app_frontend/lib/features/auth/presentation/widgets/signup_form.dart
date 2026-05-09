import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:sleep_app_frontend/features/auth/presentation/viewmodels/checbox_privacy_viewmodel.dart";
import "package:sleep_app_frontend/features/auth/presentation/widgets/common/button_widget.dart";
import "package:sleep_app_frontend/features/auth/presentation/widgets/common/textfield_widget.dart";

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});
  @override
  Widget build(BuildContext context) {
    final checkboxVM = context.watch<CheckboxPrivacy>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Create Account",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        const TextFieldWidget(
          label: "Username",
          hintText: "Enter user name",
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: 20),
        const TextFieldWidget(
          label: "Email",
          hintText: "Enter your email",
          prefixIcon: Icons.email_outlined,
        ),
        const SizedBox(height: 20),
        const TextFieldWidget(
          label: "Password",
          hintText: "Enter your password",
          prefixIcon: Icons.lock_outline,
        ),
        const SizedBox(height: 20),
        const TextFieldWidget(
          label: "Confirm Password",
          hintText: "Confirm your password",
          prefixIcon: Icons.lock_outline,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: Checkbox(
                value: checkboxVM.isChecked,
                activeColor: const Color(0xFFB39DDB),
                side: const BorderSide(color: Colors.white54),
                onChanged: (value) {
                  checkboxVM.toggleCheckbox();
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: const TextSpan(
                  text: "I agree to the ",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  children: [
                    TextSpan(
                      text: "Terms of Service",
                      style: TextStyle(
                        color: Color(0xFFB39DDB),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(
                        color: Color(0xFFB39DDB),
                        fontWeight: FontWeight.bold,
                        
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ButtonWidget(
            text: "Sign Up",
            onPressed: checkboxVM.isChecked
                ? () {}
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please agree to the terms"),
                      ),
                    );
                  },
          ),
        ),
      ],
    );
  }
}
