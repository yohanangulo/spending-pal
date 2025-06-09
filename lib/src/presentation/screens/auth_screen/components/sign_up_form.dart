import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/core/common/value_object/email_value_object.dart';
import 'package:spending_pal/src/core/common/value_object/password_value_object.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/common/widgets/app_button.dart';
import 'package:spending_pal/src/presentation/screens/auth_screen/cubit/sign_up/sign_up_cubit.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    required this.pageController,
    super.key,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final signUpCubit = context.read<SignUpCubit>();
    final formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: Dimens.p5, left: Dimens.p9),
            child: Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: Dimens.p2),
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimens.p5),
              topRight: Radius.circular(Dimens.p5),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: Dimens.p3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.all(Radius.circular(
                    Dimens.p5,
                  )),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.02),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.p5, vertical: Dimens.p6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Let's get you started",
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: Dimens.p5),
                      _EmailInput(),
                      SizedBox(height: Dimens.p5),
                      _PasswordInput(),
                      SizedBox(height: Dimens.p5),
                      _ConfirmPasswordInput(),
                      SizedBox(height: Dimens.p5),
                      _SubmitButton(onPressed: signUpCubit.signUpWithEmailAndPassword),
                      SizedBox(height: Dimens.p6),
                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: 'By selecting Agree and continue below, I agree to ',
                                children: [
                                  const TextSpan(text: ' '),
                                  TextSpan(
                                    text: 'Terms of Service and Privacy Policy',
                                    style: context.theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimens.p6),
                      Row(
                        spacing: Dimens.p1,
                        children: [
                          Text(
                            'Already have an account?',
                            style: context.theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              pageController.animateToPage(
                                0,
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeOutExpo,
                              );
                            },
                            child: Text(
                              'Log In',
                              style: context.theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
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
          ),
        ],
      ),
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
    final status = context.select((SignUpCubit cubit) => cubit.state.status);
    final isLoading = status == SignUpStatus.loading || status == SignUpStatus.success;

    return SizedBox(
      width: double.infinity,
      child: AppButton(
        isLoading: isLoading,
        onPressed: onPressed,
        child: Text('Agree and Continue'),
      ),
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  const _ConfirmPasswordInput();

  @override
  Widget build(BuildContext context) {
    final signUpCubit = context.read<SignUpCubit>();
    final confirmPassword = context.select((SignUpCubit cubit) => cubit.state.confirmPassword);
    final password = context.select((SignUpCubit cubit) => cubit.state.password);
    return TextFormField(
      decoration: InputDecoration(labelText: 'Confirm Password'),
      obscureText: true,
      initialValue: signUpCubit.state.confirmPassword,
      onChanged: signUpCubit.confirmPasswordChanged,
      validator: (_) {
        if (confirmPassword.isEmpty) {
          return 'Confirm password is required';
        }

        if (confirmPassword != password.value) {
          return 'Passwords do not match';
        }

        return null;
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    final signUpCubit = context.read<SignUpCubit>();
    final password = context.select((SignUpCubit cubit) => cubit.state.password);
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password'),
      obscureText: true,
      onChanged: (value) => signUpCubit.passwordChanged(Password(value)),
      validator: (_) {
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
    final signUpCubit = context.read<SignUpCubit>();
    final email = context.select((SignUpCubit cubit) => cubit.state.email);
    return TextFormField(
      autofillHints: [AutofillHints.email],
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      enableSuggestions: false,
      decoration: InputDecoration(labelText: 'Email'),
      onChanged: (value) => signUpCubit.emailChanged(Email(value)),
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
