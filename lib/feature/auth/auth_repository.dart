import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> sendPhoneOTP(String phone) async {
    final response = await _dio.post(
      "https://24-krafts-backend.vercel.app/api/auth/send-otp",
      data: {"phone": phone},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> verifyOTP(String phone, String otp) async {
    final response = await _dio.post(
      "https://24-krafts-backend.vercel.app/api/auth/verify-otp",
      data: {"phone": phone, "otp": otp},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> completeSignup({
    required String phone,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    final response = await _dio.post(
      "https://24-krafts-backend.vercel.app/api/auth/sign-up",
      data: {
        "phone": phone,
        "firstName": firstName,
        "lastName": lastName,
        "role": role,
      },
    );
    return response.data;
  }
}
