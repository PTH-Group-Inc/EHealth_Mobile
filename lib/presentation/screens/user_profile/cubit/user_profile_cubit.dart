import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/repository.dart';
import '../../../../app/dependency_injection/configure_injectable.dart';
import 'user_profile_state.dart';

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
}
