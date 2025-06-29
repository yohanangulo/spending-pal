import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/config/service_locator/service_locator.dart';
import 'package:spending_pal/src/presentation/common/resources/generated/assets.gen.dart';
import 'package:spending_pal/src/presentation/screens/auth_screen/components/auth_screen_content.dart';
import 'package:spending_pal/src/presentation/screens/auth_screen/cubit/sign_in/sign_in_cubit.dart';
import 'package:spending_pal/src/presentation/screens/auth_screen/cubit/sign_up/sign_up_cubit.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = context.screenHeight;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<SignInCubit>()),
        BlocProvider(create: (context) => getIt<SignUpCubit>()),
      ],
      child: Scaffold(
        backgroundColor: Color(0xFF1a1617),
        body: Stack(
          children: [
            Positioned.fill(
              child: Assets.images.phoneFinance.image(
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.17),
                    SizedBox(
                      height: screenHeight * 0.83,
                      child: const AuthScreenContent(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
