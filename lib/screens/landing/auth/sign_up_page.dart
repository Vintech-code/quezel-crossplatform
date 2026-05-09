import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? errorMessage;

  static const warmBeige = Color(0xFFE8F9FD);
  static const creamWhite = Color(0xFFE8F9FD);
  static const darkEspresso = Color(0xFF000000);
  static const coffeeBrown = Color(0xFFFF1E00);
  static const softGold = Color(0xFF59CE8F);
  static const mutedForeground = Color(0xFF4B5563);
  static const borderColor = Color(0xFF59CE8F);

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void handleSignUp() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    setState(() => errorMessage = null);

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() => errorMessage = "Please fill in all fields.");
      return;
    }

    if (password != confirmPassword) {
      setState(() => errorMessage = "Passwords do not match.");
      return;
    }

    Navigator.pushReplacementNamed(context, "/auth/sign-in");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warmBeige,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              onBackHome: () {
                Navigator.pushReplacementNamed(context, "/");
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 512),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: creamWhite.withOpacity(0.90),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: softGold.withOpacity(0.60),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 32,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Join Quezel",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              letterSpacing: 3.6,
                              color: coffeeBrown,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Create Account",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Righteous",
                              fontSize: 30,
                              color: darkEspresso,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Start ordering your favorites",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Righteous",
                              fontSize: 20,
                              color: darkEspresso,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              const Text(
                                "Already have an account? ",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  color: mutedForeground,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    "/auth/sign-in",
                                  );
                                },
                                child: const Text(
                                  "Sign in",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: coffeeBrown,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _InputField(
                            controller: nameController,
                            hintText: "Full name",
                            obscureText: false,
                          ),
                          const SizedBox(height: 12),
                          _InputField(
                            controller: emailController,
                            hintText: "Email address",
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                          ),
                          const SizedBox(height: 12),
                          _InputField(
                            controller: passwordController,
                            hintText: "Password",
                            obscureText: true,
                          ),
                          const SizedBox(height: 12),
                          _InputField(
                            controller: confirmPasswordController,
                            hintText: "Confirm password",
                            obscureText: true,
                          ),
                          if (errorMessage != null) ...[
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                errorMessage!,
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: handleSignUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: coffeeBrown,
                                foregroundColor: creamWhite,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                              child: const Text(
                                "CREATE ACCOUNT",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Row(
                            children: [
                              Expanded(child: Divider(color: borderColor)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 10,
                                    letterSpacing: 3,
                                    color: mutedForeground,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(color: borderColor)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Row(
                            children: [
                              Expanded(
                                child: _SocialButton(
                                  label: "Google",
                                  iconText: "G",
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _SocialButton(
                                  label: "Facebook",
                                  iconText: "f",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onBackHome;

  const _Header({required this.onBackHome});

  static const warmBeige = Color(0xFFE8F9FD);
  static const darkEspresso = Color(0xFF000000);
  static const coffeeBrown = Color(0xFFFF1E00);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: warmBeige,
        border: Border(
          bottom: BorderSide(
            color: darkEspresso.withOpacity(0.12),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1152),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      "assets/images/logo3.png",
                      height: 44,
                      width: 44,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Quezel's Cafe",
                        style: TextStyle(
                          fontFamily: "Righteous",
                          fontSize: 18,
                          color: darkEspresso,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "SIGN UP",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12,
                          letterSpacing: 3.6,
                          color: coffeeBrown,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: onBackHome,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: coffeeBrown, width: 1),
                  ),
                  child: const Text(
                    "BACK TO HOME",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: darkEspresso,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;

  const _InputField({
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.keyboardType,
  });

  static const darkEspresso = Color(0xFF000000);
  static const borderColor = Color(0xFF59CE8F);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontFamily: "Poppins",
        fontSize: 14,
        color: darkEspresso,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: "Poppins",
          fontSize: 14,
          color: darkEspresso.withOpacity(0.45),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: borderColor.withOpacity(0.45),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: borderColor,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final String iconText;

  const _SocialButton({
    required this.label,
    required this.iconText,
  });

  static const darkEspresso = Color(0xFF000000);
  static const borderColor = Color(0xFF59CE8F);

  @override
  Widget build(BuildContext context) {
    final isFacebook = label.toLowerCase() == "facebook";

    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.80),
        foregroundColor: darkEspresso,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        side: BorderSide(
          color: borderColor.withOpacity(0.45),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            iconText,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isFacebook ? const Color(0xFF1877F2) : Colors.red,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: darkEspresso,
            ),
          ),
        ],
      ),
    );
  }
}