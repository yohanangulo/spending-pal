import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/service_locator/service_locator.dart';
import 'package:spending_pal/src/presentation/common/resources/generated/assets.gen.dart';
import 'package:spending_pal/src/presentation/screens/auth_screen/components/auth_screen_content.dart';
import 'package:spending_pal/src/presentation/screens/auth_screen/cubit/sign_in/sign_in_cubit.dart';
import 'package:spending_pal/src/presentation/screens/auth_screen/cubit/sign_up/sign_up_cubit.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<SignInCubit>()),
        BlocProvider(create: (context) => getIt<SignUpCubit>()),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Assets.lottie.line.lottie(),
            ),
            const Positioned.fill(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 650,
                        child: AuthScreenContent(),
                      ),
                    ],
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
