import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/core/auth/domain/auth_failure.dart';
import 'package:spending_pal/src/core/common/value_object/email_value_object.dart';
import 'package:spending_pal/src/core/common/value_object/password_value_object.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/corners.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/common/resources/generated/assets.gen.dart';
import 'package:spending_pal/src/presentation/common/widgets/app_button.dart';
import 'package:spending_pal/src/presentation/common/widgets/password_input.dart';
import 'package:spending_pal/src/presentation/screens/auth_screen/cubit/sign_in/sign_in_cubit.dart';

class SignInForm extends StatelessWidget {
  SignInForm({
    required this.pageController,
    super.key,
  });

  final PageController pageController;
  final formKey = GlobalKey<FormState>();

  void _onSubmit(BuildContext context) {
    context.read<SignInCubit>().clearFailures();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (formKey.currentState!.validate()) {
        FocusScope.of(context).unfocus();
        context.read<SignInCubit>().signInWithEmailAndPassword();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInCubit, SignInState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        state.failure.fold(
          () => null,
          (AuthFailure failure) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              formKey.currentState!.validate();
            });

            switch (failure) {
              case AuthFailureUnexpected():
                context.showSnackBar(
                  SnackBar(
                    content: const Text('An unexpected error ocurred'),
                    backgroundColor: context.colorScheme.error,
                  ),
                );
              case AuthFailureTooManyRequests():
                context.showSnackBar(
                  SnackBar(
                    content: const Text('Too many requests'),
                    backgroundColor: context.colorScheme.error,
                  ),
                );
              default:
            }
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: Dimens.p5,
              left: Dimens.p9,
            ),
            child: Text(
              'Log In',
              style: TextStyle(
                color: context.theme.brightness.isDark ? Colors.white : Colors.black,
                fontSize: 34,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: Dimens.p2),
          Container(
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.symmetric(horizontal: Dimens.p3),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.05),
              borderRadius: Corners.circular20,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.p5,
                  vertical: Dimens.p6,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _EmailInput(),
                      const SizedBox(height: Dimens.p5),
                      const _PasswordInput(),
                      const SizedBox(height: Dimens.p5),
                      _SubmitButton(
                        onPressed: () => _onSubmit(context),
                      ),
                      const SizedBox(height: Dimens.p6),
                      const Center(
                        child: Text(
                          'or',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimens.p6),
                      const _SocialMediaButtons(),
                      const SizedBox(height: Dimens.p6),
                      _DontHaveAnAccount(pageController: pageController),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DontHaveAnAccount extends StatelessWidget {
  const _DontHaveAnAccount({
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Dimens.p1,
      children: [
        Text(
          "Don't have an account?",
          style: context.theme.textTheme.bodyMedium?.copyWith(
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: () {
            pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutExpo,
            );
          },
          child: Text(
            'Sign up',
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialMediaButtons extends StatelessWidget {
  const _SocialMediaButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SocialMediaButton(
          icon: Assets.icons.google.image(width: 20),
          label: 'Continue with Google',
          onPress: () {},
        ),
        const SizedBox(height: Dimens.p6),
        _SocialMediaButton(
          icon: Assets.icons.appleLogo.image(width: 20),
          label: 'Continue with Apple',
          onPress: () {
            SharedPreferences.getInstance().then((prefs) {
              prefs.clear();
            });
          },
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final status = context.select((SignInCubit cubit) => cubit.state.status);

    final isLoading = status == SignInStatus.loading || status == SignInStatus.success;

    return AppButton(
      isLoading: isLoading,
      onPressed: onPressed,
      child: const Text('Continue'),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    final password = context.select((SignInCubit cubit) => cubit.state.password);
    final failure = context.select((SignInCubit cubit) => cubit.state.failure);
    return PasswordInput(
      initialValue: password.value,
      onChanged: (value) => context.read<SignInCubit>().passwordChanged(Password(value)),
      validator: (_) {
        if (failure.isSome()) {
          final f = failure.getOrElse(AuthFailureUnexpected.new);

          if (f is AuthFailureInvalidCredentials) {
            return 'Invalid credentials';
          }
        }

        if (password.value.isEmpty) {
          return 'Password is required';
        }

        if (!password.isValid) {
          return 'Password must be at least 6 characters';
        }

        return null;
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    final email = context.select((SignInCubit cubit) => cubit.state.email);
    return TextFormField(
      autofillHints: [AutofillHints.email],
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      enableSuggestions: false,
      decoration: const InputDecoration(labelText: 'Email'),
      initialValue: email.value,
      onChanged: (value) => context.read<SignInCubit>().emailChanged(Email(value)),
      validator: (_) {
        if (email.value.isEmpty) {
          return 'Email is required';
        }

        if (!email.isValid) {
          return 'Invalid email';
        }

        return null;
      },
    );
  }
}

class _SocialMediaButton extends StatelessWidget {
  const _SocialMediaButton({
    required this.onPress,
    required this.label,
    required this.icon,
  });

  final VoidCallback onPress;
  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.p5, vertical: Dimens.p5),
        backgroundColor: const Color(0xFFe5f9f2),
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      child: Row(
        children: [
          icon,
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.secondary,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: Dimens.p5),
        ],
      ),
    );
  }
}
