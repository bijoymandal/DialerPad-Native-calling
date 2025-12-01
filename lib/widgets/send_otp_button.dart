// lib/widgets/send_otp_button.dart
import 'package:crafts/core/utils/app_notifications.dart';
import 'package:crafts/screens/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class SendOtpButton extends StatefulWidget {
  const SendOtpButton({super.key});

  @override
  State<SendOtpButton> createState() => _SendOtpButtonState();
}

class _SendOtpButtonState extends State<SendOtpButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rippleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Start ripple only when button is enabled
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<AuthBloc>().state;
      if (_canSend(state)) _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _canSend(AuthState state) {
    return state.selectedRole != null && state.phoneNumber.length >= 10;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Control ripple animation based on button state
        if (_canSend(state) && !_controller.isAnimating) {
          _controller.repeat();
        } else if (!_canSend(state) || state.isLoading) {
          _controller.stop();
          _controller.reset();
        }

        // Show API error message
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(state.errorMessage!),
            //     backgroundColor: Colors.red,
            //     behavior: SnackBarBehavior.floating,
            //   ),
            // );
            AppNotifications.showError(context, state.errorMessage!);
            context.read<AuthBloc>().clearMessages();
            return;
            /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    OtpVerificationScreen(number: state.phoneNumber),
              ),
            );
            //Clear success message so OTP screen doesn't show it again
            context.read<AuthBloc>().clearMessages();*/
          });
        }

        //show success message when OTP is sent
        if (state.successMessage != null && state.successMessage!.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AppNotifications.showSuccess(context, state.successMessage!);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    OtpVerificationScreen(number: state.phoneNumber),
              ),
            );

            context.read<AuthBloc>().clearMessages();
          });
        }
      },
      builder: (context, state) {
        final canSend = _canSend(state);

        // Auto-start ripple when enabled
        if (canSend && !_controller.isAnimating && !state.isLoading) {
          _controller.repeat();
        }

        return SizedBox(
          width: double.infinity,
          height: 56,
          child: Stack(
            children: [
              // Main Gradient Button
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: canSend
                        ? [const Color(0xFFB388FF), const Color(0xFF9C27B0)]
                        : [Colors.grey.shade400, Colors.grey.shade500],
                  ),
                  boxShadow: canSend
                      ? [
                          BoxShadow(
                            color: const Color(0xFF9C27B0).withOpacity(0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(28),
                    onTap: (canSend && !state.isLoading)
                        ? () => context.read<AuthBloc>().sendOtp()
                        : null,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (state.isLoading) ...[
                            const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Sending...",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ] else ...[
                            const Text(
                              'Send OTP',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            AnimatedScale(
                              scale: canSend ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.elasticOut,
                              child: const Icon(
                                Icons.touch_app,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Pulsing Ripple Effect (Only when enabled & not loading)
              if (canSend && !state.isLoading)
                Positioned(
                  right: 16,
                  top: 0,
                  bottom: 0,
                  child: AnimatedBuilder(
                    animation: _rippleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _rippleAnimation.value,
                        child: Opacity(
                          opacity: (1.8 - _rippleAnimation.value).clamp(
                            0.0,
                            0.3,
                          ),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
