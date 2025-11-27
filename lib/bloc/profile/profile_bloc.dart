// lib/bloc/profile/profile_bloc.dart
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

class ProfileError extends ProfileState {}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileLoading()) {
    on<LoadProfile>((event, emit) async {
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate API
      emit(ProfileLoaded(UserModel.dummy));
    });
  }
}
