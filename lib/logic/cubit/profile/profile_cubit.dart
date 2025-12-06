import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileState {
  final String? gender;
  final String? department;
  final String? indiaState;

  ProfileState({this.gender, this.department, this.indiaState});

  ProfileState copyWith({
    String? gender,
    String? department,
    String? indiaState,
  }) {
    return ProfileState(
      gender: gender ?? this.gender,
      department: department ?? this.department,
      indiaState: indiaState ?? this.indiaState,
    );
  }

  // void setAll({String? gender, String? department, String? indiaState}) {
  //   emit(
  //     state.copyWith(
  //       gender: gender ?? state.gender,
  //       department: department ?? state.department,
  //       indiaState: indiaState ?? state.indiaState,
  //     ),
  //   );
  // }
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());

  void setGender(String? value) => emit(state.copyWith(gender: value));
  void setDepartment(String? value) => emit(state.copyWith(department: value));
  void setIndiaState(String? value) => emit(state.copyWith(indiaState: value));
}
