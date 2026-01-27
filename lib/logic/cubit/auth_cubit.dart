import 'package:crafts/feature/auth/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthState {
  final bool loading;
  final bool otpSent;
  final bool verified;
  final String? role;

  AuthState({
    this.loading = false,
    this.otpSent = false,
    this.verified = false,
    this.role,
  });

  AuthState copyWith({
    bool? loading,
    bool? otpSent,
    bool? verified,
    String? role,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      otpSent: otpSent ?? this.otpSent,
      verified: verified ?? this.verified,
      role: role ?? this.role,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repo;

  AuthCubit(this.repo) : super(AuthState());

  void setRole(String r) => emit(state.copyWith(role: r));

  Future<void> sendOTP(String phone) async {
    emit(state.copyWith(loading: true));

    final result = await repo.sendPhoneOTP(phone);

    emit(state.copyWith(loading: false, otpSent: result["success"] == true));
  }

  Future<bool> verifyOTP(String phone, String otp) async {
    emit(state.copyWith(loading: true));

    final result = await repo.verifyOTP(phone, otp);

    emit(state.copyWith(loading: false, verified: result["success"] == true));

    return result["success"] == true;
  }

  Future<bool> completeSignup({
    required String phone,
    required String first,
    required String last,
  }) async {
    emit(state.copyWith(loading: true));

    final result = await repo.completeSignup(
      phone: phone,
      firstName: first,
      lastName: last,
      role: state.role ?? "Artist",
    );

    emit(state.copyWith(loading: false));

    return result["success"] == true;
  }
}
