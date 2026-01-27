import 'package:flutter_bloc/flutter_bloc.dart';

class AuthState {
  final bool loading;
  final bool otpSent;
  final bool otpVerified;

  final String firstName;
  final String lastName;
  final String role;
  final String phone;
  final String otp;

  const AuthState({
    this.loading = false,
    this.otpSent = false,
    this.otpVerified = false,
    this.firstName = "",
    this.lastName = "",
    this.role = "Artist",
    this.phone = "",
    this.otp = "",
  });

  AuthState copyWith({
    bool? loading,
    bool? otpSent,
    bool? otpVerified,
    String? firstName,
    String? lastName,
    String? role,
    String? phone,
    String? otp,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      otpSent: otpSent ?? this.otpSent,
      otpVerified: otpVerified ?? this.otpVerified,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      otp: otp ?? this.otp,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  // --------------------------
  // UPDATE BASIC FORM FIELDS
  // --------------------------

  void setFirstName(String value) {
    emit(state.copyWith(firstName: value));
  }

  void setLastName(String value) {
    emit(state.copyWith(lastName: value));
  }

  void setPhone(String value) {
    emit(state.copyWith(phone: value));
  }

  void setOtp(String value) {
    emit(state.copyWith(otp: value));
  }

  void setRole(String value) {
    emit(state.copyWith(role: value));
  }

  // --------------------------
  // SEND OTP
  // --------------------------

  Future<void> sendOtp() async {
    if (state.phone.length != 10) {
      print("Invalid phone number");
      return;
    }

    emit(state.copyWith(loading: true));

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(loading: false, otpSent: true));
  }

  // --------------------------
  // VERIFY OTP
  // --------------------------

  Future<void> verifyOtp() async {
    if (state.otp.length < 4) {
      print("Invalid OTP");
      return;
    }

    emit(state.copyWith(loading: true));

    // Simulated API request
    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(loading: false, otpVerified: true));
  }

  // --------------------------
  // FINAL SIGNUP SUBMISSION
  // --------------------------

  Future<bool> submitSignUp() async {
    if (state.firstName.isEmpty ||
        state.lastName.isEmpty ||
        state.phone.isEmpty ||
        !state.otpVerified) {
      return false;
    }

    emit(state.copyWith(loading: true));

    // Simulate API signup call
    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(loading: false));

    return true;
  }
}
