import 'package:crafts/core/utils/app_notifications.dart';
import 'package:crafts/logic/cubit/profile/profile_cubit.dart';
import 'package:crafts/widgets/complete_profile_screen.dart';
import 'package:crafts/widgets/slider_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/network/api_service.dart';
import '../core/storage/secure_storage.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String number;

  const OtpVerificationScreen({super.key, required this.number});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isVerifying = false;

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final otp = _controllers.map((c) => c.text).join();

    if (otp.length != 6) {
      AppNotifications.showError(context, "Please enter complete 6-digit OTP");
      return;
    }

    setState(() => _isVerifying = true);

    try {
      final response = await ApiService.verifyOtp(
        number: widget.number,
        otp: otp,
      );

      print("OTP Verify Response: $response");

      // CASE 1: OTP Wrong
      if (response["success"] == false && response["isNewUser"] != true) {
        AppNotifications.showError(
          context,
          response["message"] ?? "Invalid OTP",
        );

        // Clear fields
        for (var c in _controllers) {
          c.clear();
        }
        _focusNodes[0].requestFocus();
        return;
      }

      // CASE 2: OTP Correct + New User (success: false, isNewUser: true)
      if (response["isNewUser"] == true) {
        AppNotifications.showSuccess(
          context,
          "OTP Verified! Please complete your profile",
        );

        await Future.delayed(const Duration(milliseconds: 1200));

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => ProfileCubit(),
              child: CompleteProfileScreen(
                phoneNumber: widget.number,
                otp: otp,
              ),
            ),
          ),
          (route) => false,
        );
        return;
      }

      // CASE 3: OTP Correct + Existing User (success: true)
      if (response["success"] == true) {
        final String token = response["access_token"] ?? response["token"];
        final Map<String, dynamic> userData = response["user"];
        final Map<String, dynamic> profileData = response["profile"];

        //save token
        if (token != null && token.isNotEmpty) {
          await SecureStorage.saveToken(token);
        }
        // Save Full User + Profile Data Locally (Critical!)
        await SecureStorage.saveUserData({
          "id": userData["id"],
          "phone": userData["phone"],
          "email": userData["email"] ?? "",
          "role": userData["role"],
          "firstName": userData["firstName"] ?? profileData["first_name"],
          "lastName": userData["lastName"] ?? profileData["last_name"],
          "profilePhotoUrl": profileData["profile_photo_url"],
          "isPremium": profileData["is_premium"] ?? false,
          "isNewUser": false,
        });

        AppNotifications.showSuccess(context, "Welcome back!");

        await Future.delayed(const Duration(milliseconds: 1000));

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => SliderScreen(phoneNumber: widget.number),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      print("OTP Verify Error: $e");

      AppNotifications.showError(
        context,
        "Network error. Please check internet and try again.",
      );
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Illustration
              Container(
                height: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9C27B0), Color(0xFF6A1B9A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.asset(
                    'assets/images/otp_verify.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(
                        Icons.verified_user,
                        size: 100,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
              const Text(
                'Verify OTP',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the 6-digit code sent to +91 ${widget.number}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              // OTP Input Fields
              Wrap(
                spacing: 12,
                alignment: WrapAlignment.center,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    height: 56,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: '0',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF9C27B0),
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 40),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isVerifying ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 8,
                    shadowColor: const Color(0xFF9C27B0).withOpacity(0.4),
                  ),
                  child: _isVerifying
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Verify OTP',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
