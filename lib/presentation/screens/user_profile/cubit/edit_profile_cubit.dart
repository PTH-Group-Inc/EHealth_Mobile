import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:e_health/app/dependency_injection/configure_injectable.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/edit_profile_state.dart';

@injectable
class EditProfileCubit extends Cubit<EditProfileState> {
  static final _repository = getIt<Repository>();

  EditProfileCubit() : super(const EditProfileState());

  void resetState() {
    emit(const EditProfileState());
  }

  Future<void> updateProfile({
    required String fullName,
    required String dob,
    required String gender,
    required String address,
    required String identityCard,
  }) async {
    emit(state.copyWith(status: EditProfileStatus.loading));

    final data = {
      'full_name': fullName,
      'dob': dob,
      'gender': gender,
      'address': address,
      'identity_card_number': identityCard,
    };

    final result = await _repository.updateProfile(data);

    result.fold(
      (failure) => emit(state.copyWith(
        status: EditProfileStatus.failure,
        errorMessage: failure.message,
      )),
      (profile) => emit(state.copyWith(
        status: EditProfileStatus.success,
        profile: profile,
      )),
    );
  }
}
