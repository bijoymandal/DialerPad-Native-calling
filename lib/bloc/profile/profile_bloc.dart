// lib/bloc/profile/profile_bloc.dart
import 'package:crafts/core/network/api_service.dart';
import 'package:crafts/core/storage/secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  ProfileLoaded(this.user);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final response = await ApiService.getProfile();

      // Save basic user data
      await SecureStorage.saveUserData({
        "id": response["user"]["id"],
        "phone": response["user"]["phone"],
        "email": response["user"]["email"] ?? "",
        "firstName": response["profile"]["first_name"] ?? "",
        "lastName": response["profile"]["last_name"] ?? "",
        "profilePhotoUrl": response["profile"]["profile_photo_url"],
        "role": response["profile"]["role"],
        "isPremium": response["profile"]["is_premium"] ?? false,
      });

      final user = UserModel.fromAuthResponse(response);
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
