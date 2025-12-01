// lib/bloc/auth_bloc.dart
import 'package:flutter/foundation.dart'; // ← ADD THIS
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import '../core/network/api_service.dart';

class AuthBloc extends Cubit<AuthState> {
  AuthBloc() : super(const AuthState(selectedRole: AuthRole.artist));

  // Select Role
  void selectRole(AuthRole role) {
    emit(state.copyWith(selectedRole: role));
  }

  // Update Phone Number (from PhoneInput widget)
  void updatePhoneNumber(String number) {
    final cleaned = number.replaceAll(RegExp(r'\D'), '');
    emit(state.copyWith(phoneNumber: cleaned));
  }

  // SEND OTP – FINAL FIXED VERSION
  Future<void> sendOtp() async {
    // Validation
    if (state.phoneNumber.length < 10) {
      _showError("Please enter a valid 10-digit phone number");
      return;
    }
    if (state.selectedRole == null) {
      _showError("Please select your role");
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final response = await ApiService.sendOtp(
        number: state.phoneNumber,
        // role: state.selectedRole == AuthRole.artist ? "artist" : "recruiter", // Uncomment if backend needs it
      );

      print("OTP API Response: $response");

      if (response["success"] == true) {
        final String? otpFromApi = response["otp"]?.toString();

        emit(
          state.copyWith(
            isLoading: false,
            otpSent: true,
            phoneNumber: state.phoneNumber, // Ensure phone is saved
            lastSentOtp: kDebugMode
                ? otpFromApi
                : null, // Only save OTP in debug
            errorMessage: null,
          ),
        );
      } else {
        _showError(response["message"] ?? "Failed to send OTP");
      }
    } catch (e) {
      print("OTP Send Error: $e");
      _showError("Network error. Please check your connection.");
    }
  }

  // Show error and auto-clear after 4 seconds
  void _showError(String message) {
    emit(state.copyWith(isLoading: false, errorMessage: message));

    Future.delayed(const Duration(seconds: 4), () {
      if (!isClosed) {
        emit(state.copyWith(errorMessage: null));
      }
    });
  }

  // Optional: Reset state (useful when coming back)
  void reset() {
    emit(
      state.copyWith(
        isLoading: false,
        otpSent: false,
        errorMessage: null,
        lastSentOtp: null,
      ),
    );
  }

  // Clear messages (if you still use successMessage elsewhere)
  void clearMessages() {
    emit(state.copyWith(errorMessage: null));
  }
}
