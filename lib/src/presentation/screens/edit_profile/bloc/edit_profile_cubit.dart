import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/core/user/domain.dart';

part 'edit_profile_state.dart';

@injectable
class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(
    this._imagePicker,
    this._userRepository,
  ) : super(const EditProfileState());

  final ImagePicker _imagePicker;
  final UserRepository _userRepository;

  Future<void> pickImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );

    if (image == null) return;

    emit(
      state.copyWith(
        image: File(image.path),
      ),
    );
  }

  void nameChanged(String name) {
    emit(
      state.copyWith(
        name: name,
      ),
    );
  }

  void imageChanged(File image) {
    emit(
      state.copyWith(
        image: image,
      ),
    );
  }

  Future<void> saveProfile() async {
    emit(state.copyWith(status: EditProfileStatus.loading));

    // Update display name if provided
    if (state.name.isNotEmpty) {
      final nameResult = await _userRepository.updateUserDisplayName(state.name);
      if (nameResult.isLeft()) {
        emit(state.copyWith(status: EditProfileStatus.failure));
        return;
      }
    }

    // Update profile image if selected
    if (state.image != null) {
      final imageResult = await _userRepository.updateUserProfileImage(state.image!);
      if (imageResult.isLeft()) {
        emit(state.copyWith(status: EditProfileStatus.failure));
        return;
      }
    }

    emit(state.copyWith(status: EditProfileStatus.success));
  }
}
