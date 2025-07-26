import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/core/auth/auth_bloc.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.authBloc.state.user;
    final displayName = user?.userDisplayName.split(' ').first;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi 👋 $displayName!',
              style: context.textTheme.headlineSmall?.copyWith(
                color: context.theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Dimens.p1),
            Text(
              'Control your spending today',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ).fadeInLeft(
          from: 30,
          delay: const Duration(milliseconds: 100),
          duration: const Duration(milliseconds: 1000),
        ),
        const _UserAvatar(),
      ],
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar();

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

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary,
          width: 3,
        ),
      ),
      child: ClipOval(
        child: ColoredBox(
          color: context.theme.colorScheme.surface,
          child: child,
        ),
      ),
    );
  }
}
