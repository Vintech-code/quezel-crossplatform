import 'package:flutter/material.dart';

import 'auth_choice_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthChoicePage(
      modeLabel: "SIGN UP",
      title: "Quezel's",
      subtitle: "Create your account and start ordering.",
      alternateText: "Already have an account? ",
      alternateActionText: "Sign in",
      alternateRoute: "/auth/sign-in",
    );
  }
}
