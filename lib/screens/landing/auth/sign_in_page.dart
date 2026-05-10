import 'package:flutter/material.dart';

import 'auth_choice_page.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthChoicePage(
      modeLabel: "SIGN IN",
      title: "Quezel's",
      subtitle: "Fresh treats, fast ordering, cozy comfort.",
      alternateText: "New here? ",
      alternateActionText: "Create an account",
      alternateRoute: "/auth/sign-up",
    );
  }
}
