part of 'edit_profile_cubit.dart';

enum EditProfileStatus {
  initial,
  loading,
  success,
  failure;

  bool get isSuccess => this == EditProfileStatus.success;
  bool get isFailure => this == EditProfileStatus.failure;
}

class EditProfileState extends Equatable {
  const EditProfileState({
    this.status = EditProfileStatus.initial,
    this.name = '',
    this.image,
  });

  final EditProfileStatus status;
  final File? image;
  final String name;

  @override
  List<Object?> get props => [status, image, name];

  EditProfileState copyWith({
    EditProfileStatus? status,
    File? image,
    String? name,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      image: image ?? this.image,
      name: name ?? this.name,
    );
  }
}
