import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String? gender;
  final String? department;
  final String? indiaState;

  const ProfileState({this.gender, this.department, this.indiaState});

  factory ProfileState.initial() => const ProfileState(
    gender: "Male",
    department: "Others",
    indiaState: "Delhi",
  );

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

  @override
  List<Object?> get props => [gender, department, indiaState];
}
