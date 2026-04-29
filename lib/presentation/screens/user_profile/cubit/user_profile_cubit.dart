import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/app/dependency_injection/configure_injectable.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_state.dart';

@injectable
class UserProfileCubit extends Cubit<UserProfileState> {
  static final _repository = getIt<Repository>();

  UserProfileCubit() : super(UserProfileInitial());

  Future<void> loadProfile() async {
    emit(UserProfileLoading());
    final result = await _repository.getProfile();
    result.fold(
      (failure) => emit(UserProfileError(message: failure.message)),
      (profile) => emit(UserProfileLoaded(profile: profile)),
    );
  }

  Future<void> updateFcmToken() async {
    await _repository.updateFcmToken();
  }

  Future<void> uploadAvatar(String filePath) async {
    final currentState = state;
    if (currentState is! UserProfileLoaded) return;

    // Emit uploading state to show indicator over current profile
    emit(UserProfileUploading(profile: currentState.profile));

    // 1. Check limit: max 5 avatars
    final currentAvatars = currentState.profile.avatars ?? [];
    if (currentAvatars.length >= 5) {
      // Delete the oldest one (The one with earliest uploadedAt)
      final sortedAvatars = List.from(currentAvatars);
      sortedAvatars.sort((a,b) => (a.uploadedAt ?? DateTime(0)).compareTo(b.uploadedAt ?? DateTime(0)));
      
      final oldestId = sortedAvatars.first.publicId;
      if (oldestId.isNotEmpty) {
        final deleteResult = await _repository.deleteAvatar(oldestId);
        
        bool deleteFailed = false;
        deleteResult.fold(
          (failure) {
            emit(UserProfileError(message: "Xóa ảnh cũ thất bại: ${failure.message}"));
            deleteFailed = true;
          },
          (_) => null,
        );
        if (deleteFailed) return;
      }
    }

    // 2. Upload new avatar
    final result = await _repository.uploadAvatar(filePath);
    result.fold(
      (failure) => emit(UserProfileLoaded(profile: currentState.profile)), // Maintain state on error
      (avatar) => loadProfile(), // Reload to get fresh list
    );
  }

  Future<void> deleteAvatarByIndex(int index) async {
    final currentState = state;
    if (currentState is! UserProfileLoaded) return;

    final avatars = currentState.profile.avatars;
    if (avatars == null || index >= avatars.length) return;

    emit(UserProfileLoading());
    final result = await _repository.deleteAvatar(avatars[index].publicId);
    result.fold(
      (failure) => emit(UserProfileError(message: failure.message)),
      (_) => loadProfile(),
    );
  }
}
