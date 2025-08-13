import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/core/auth/auth_bloc.dart';

class UserProfilePicture extends StatelessWidget {
  const UserProfilePicture({super.key});

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
