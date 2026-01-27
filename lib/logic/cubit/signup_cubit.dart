// import 'package:crafts/core/network/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupState {
  final bool loading;
  final String? error;
  final bool success;

  SignupState({this.loading = false, this.error, this.success = false});

  SignupState copyWith({bool? loading, String? error, bool? success}) {
    return SignupState(
      loading: loading ?? this.loading,
      error: error,
      success: success ?? this.success,
    );
  }
}

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupState());

  Future<void> signup(Map<String, dynamic> data) async {
    emit(state.copyWith(loading: true));

    //   try {
    //     final response = await ApiService.completeSignup(data);

    //     if (response['success'] == true) {
    //       emit(state.copyWith(loading: false, success: true));
    //     } else {
    //       emit(state.copyWith(loading: false, error: response['message']));
    //     }
    //   } catch (e) {
    //     emit(state.copyWith(loading: false, error: e.toString()));
    //   }
    // }
  }
}
