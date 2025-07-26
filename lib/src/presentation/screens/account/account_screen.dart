import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/config/router/app_navigator.dart';
import 'package:spending_pal/src/config/service_locator/service_locator.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/core/auth/auth_bloc.dart';
import 'package:spending_pal/src/presentation/screens/account/bloc/account_bloc.dart';

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
                  const _UserProfilePicture(),
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
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: context.theme.brightness == Brightness.dark ? const Color(0xff212121) : Colors.white,
                borderRadius: BorderRadius.circular(Dimens.p4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  _AccountOption(
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: AppNavigator.navigateToSettings,
                  ),
                  _Divider(),
                  _AccountOption(
                    icon: Icons.security,
                    title: 'Privacy and Security',
                    onTap: AppNavigator.navigateToPrivacyAndSecurity,
                  ),
                  _Divider(),
                  _AccountOption(
                    icon: Icons.help,
                    title: 'Help and Support',
                    onTap: AppNavigator.navigateToHelpAndSupport,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserProfilePicture extends StatelessWidget {
  const _UserProfilePicture();

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);

    if (user == null) {
      return const Icon(
        Icons.person,
        size: 50,
        color: Colors.grey,
      );
    }

    final photoUrl = user.photoURL;

    Widget child = const Icon(
      Icons.person,
      size: 50,
      color: Colors.grey,
    );

    if (photoUrl != null) {
      child = CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: photoUrl,
        placeholder: (context, url) => const CircularProgressIndicator.adaptive(),
        errorWidget: (context, url, error) => const Icon(
          Icons.person,
          size: 50,
          color: Colors.grey,
        ),
      );
    }

    return Hero(
      tag: 'user-profile-picture',
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary,
            width: 3,
          ),
        ),
        child: ClipOval(
          child: Container(
            color: Colors.grey[200],
            child: child,
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Colors.grey[200],
      indent: 56,
    );
  }
}

class _AccountOption extends StatelessWidget {
  const _AccountOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.primary,
        ),
        title: Text(
          title,
          style: const TextStyle(
            // color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }
}
