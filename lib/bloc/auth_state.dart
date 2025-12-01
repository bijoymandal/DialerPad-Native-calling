// lib/bloc/auth_state.dart
import 'package:equatable/equatable.dart';

enum AuthRole { artist, recruiter }

class AuthState extends Equatable {
  final AuthRole? selectedRole;
  final String phoneNumber;
  final bool isLoading;
  final bool otpSent;
  final String? errorMessage;
  final String? successMessage;
  final String? lastSentOtp;

  const AuthState({
    this.selectedRole,
    this.phoneNumber = "",
    this.isLoading = false,
    this.otpSent = false,
    this.errorMessage,
    this.successMessage,
    this.lastSentOtp,
  });

  AuthState copyWith({
    AuthRole? selectedRole,
    String? phoneNumber,
    bool? isLoading,
    bool? otpSent,
    String? errorMessage,
    String? successMessage,
    String? lastSentOtp,
    bool clearOtp = false,
  }) {
    return AuthState(
      selectedRole: selectedRole ?? this.selectedRole,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isLoading: isLoading ?? this.isLoading,
      otpSent: otpSent ?? this.otpSent,
      errorMessage: errorMessage,
      successMessage: successMessage,
      lastSentOtp: clearOtp ? null : (lastSentOtp ?? this.lastSentOtp),
    );
  }

  @override
  List<Object?> get props => [
    selectedRole,
    phoneNumber,
    isLoading,
    otpSent,
    errorMessage,
    successMessage,
    lastSentOtp,
  ];
}
