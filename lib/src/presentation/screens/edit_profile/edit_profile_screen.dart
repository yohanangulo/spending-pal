import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spending_pal/src/config/extensions/extensions.dart';
import 'package:spending_pal/src/config/router/app_navigator.dart';
import 'package:spending_pal/src/config/service_locator/service_locator.dart';
import 'package:spending_pal/src/presentation/common/resources/app_colors.dart';
import 'package:spending_pal/src/presentation/common/resources/dimens.dart';
import 'package:spending_pal/src/presentation/common/widgets/app_button.dart';
import 'package:spending_pal/src/presentation/screens/edit_profile/bloc/edit_profile_cubit.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EditProfileCubit>(),
      child: _EditProfileScreenView(),
    );
  }
}

class _EditProfileScreenView extends StatelessWidget {
  _EditProfileScreenView();

  final _formKey = GlobalKey<FormState>();

  void _showImagePickerDialog(BuildContext context) {
    final cubit = context.read<EditProfileCubit>();
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(Dimens.p6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Image Source',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Dimens.p6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ImageSourceButton(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    AppNavigator.pop();
                    cubit.pickImage(ImageSource.camera);
                  },
                ),
                _ImageSourceButton(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () {
                    AppNavigator.pop();
                    cubit.pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            const SizedBox(height: Dimens.p4),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<EditProfileCubit>();
    await cubit.saveProfile();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.authBloc.state.user!;
    final cubit = context.read<EditProfileCubit>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocListener<EditProfileCubit, EditProfileState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status.isSuccess) {
              context.showSnackBar(
                SnackBar(
                  content: const Text('Profile updated successfully!'),
                  backgroundColor: context.colorScheme.primary,
                ),
              );
            }

            if (state.status.isFailure) {
              context.showSnackBar(
                SnackBar(
                  content: const Text('Failed to update profile. Please try again.'),
                  backgroundColor: context.colorScheme.error,
                ),
              );
            }

            if (state.status.isSuccess || state.status.isFailure) {
              AppNavigator.pop();
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Dimens.p4),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // ----- Profile Photo Section -----
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
                        // ----- Profile Photo -----
                        _ProfilePhoto(
                          onTap: () => _showImagePickerDialog(context),
                        ),
                        const SizedBox(height: Dimens.p4),
                        const Text(
                          'Tap to change photo',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: Dimens.p6),

                  // ----- Profile Information Section -----
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Profile Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: Dimens.p6),

                        // ----- Name Field -----
                        TextFormField(
                          initialValue: user.displayName,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          onChanged: cubit.nameChanged,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Name is required';
                            }
                            if (value.trim().length < 3) {
                              return 'Name must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: Dimens.p4),

                        // ----- Email Field -----
                        TextFormField(
                          initialValue: user.email,
                          enabled: false,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        const SizedBox(height: Dimens.p4),
                        Text(
                          'Email cannot be changed',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimens.p6),
                  _SaveButton(onPressed: () => _saveProfile(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfilePhoto extends StatelessWidget {
  const _ProfilePhoto({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final user = context.authBloc.state.user!;
    final image = context.select((EditProfileCubit cubit) => cubit.state.image);
    Widget buildImageContent() {
      if (image != null) {
        return Image.file(
          image,
          fit: BoxFit.cover,
        );
      }
      if (user.photoURL != null) {
        return CachedNetworkImage(
          imageUrl: user.photoURL!,
          fit: BoxFit.cover,
          placeholder: (context, url) {
            return const CircularProgressIndicator.adaptive();
          },
          errorWidget: (context, url, error) {
            return Container(
              color: Colors.grey[200],
              child: const Icon(
                Icons.person,
                size: 60,
                color: Colors.grey,
              ),
            );
          },
        );
      }
      return Container(
        color: Colors.grey[200],
        child: const Icon(
          Icons.person,
          size: 60,
          color: Colors.grey,
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Hero(
            tag: 'user-profile-picture',
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary,
                  width: 3,
                ),
              ),
              child: ClipOval(child: buildImageContent()),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: FadeIn(
              duration: const Duration(milliseconds: 300),
              delay: const Duration(milliseconds: 250),
              child: Container(
                padding: const EdgeInsets.all(Dimens.p2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageSourceButton extends StatelessWidget {
  const _ImageSourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Dimens.p6),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: Colors.grey,
            ),
            const SizedBox(height: Dimens.p2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<EditProfileCubit, bool>(
      (cubit) => cubit.state.status == EditProfileStatus.loading,
    );
    return AppButton(
      onPressed: onPressed,
      isLoading: isLoading,
      child: const Text('Save Changes'),
    );
  }
}
