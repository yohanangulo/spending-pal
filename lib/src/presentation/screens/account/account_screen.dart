import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/config/service_locator/service_locator.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/core/auth/auth_bloc.dart';
import 'package:spending_pal/src/presentation/screens/account/bloc/account_bloc.dart';
import 'package:spending_pal/src/presentation/screens/account/components/general_section.dart';
import 'package:spending_pal/src/presentation/screens/account/components/settings_section.dart';
import 'package:spending_pal/src/presentation/screens/account/components/user_profile_picture.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AccountBloc>()..add(AccountSubscriptionRequested()),
      child: const _AccountScreenView(),
    );
  }
}

class _AccountScreenView extends StatelessWidget {
  const _AccountScreenView();

  @override
  Widget build(BuildContext context) {
    final user = context.authBloc.state.user!;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimens.p4),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimens.p6),
              decoration: BoxDecoration(
                color: context.theme.brightness == Brightness.dark ? const Color(0xff212121) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const UserProfilePicture(),
                  const SizedBox(height: 16),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return Text(
                        state.user?.displayName ?? 'User',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimens.p6),
            const GeneralSection(),
            const SizedBox(height: Dimens.p6),
            const SettingsSection(),
          ],
        ),
      ),
    );
  }
}
