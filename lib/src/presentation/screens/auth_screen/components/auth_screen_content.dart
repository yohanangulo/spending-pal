import 'package:flutter/material.dart';
import 'package:spending_pal/src/presentation/screens/auth_screen/components/sign_in_form.dart';
import 'package:spending_pal/src/presentation/screens/auth_screen/components/sign_up_form.dart';

class AuthScreenContent extends StatefulWidget {
  const AuthScreenContent({super.key});

  @override
  State<AuthScreenContent> createState() => _AuthScreenContentState();
}

class _AuthScreenContentState extends State<AuthScreenContent> {
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: [
        SignInForm(pageController: pageController),
        SignUpForm(pageController: pageController),
      ],
    );
  }
}
