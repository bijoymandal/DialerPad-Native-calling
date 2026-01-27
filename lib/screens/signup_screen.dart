import 'package:crafts/logic/cubit/auth_cubit.dart';
import 'package:crafts/screens/welcome_back_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phone = TextEditingController();
  final otp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;

    return Scaffold(
      appBar: AppBar(title: const Text("Create Account"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // FIRST NAME
            TextField(
              controller: firstName,
              decoration: const InputDecoration(labelText: "First Name *"),
            ),
            const SizedBox(height: 15),

            // LAST NAME
            TextField(
              controller: lastName,
              decoration: const InputDecoration(labelText: "Last Name *"),
            ),
            const SizedBox(height: 25),

            // ROLE SELECTOR
            const Text(
              "Select Role",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const RoleSelector(),
            const SizedBox(height: 25),

            // PHONE
            TextField(
              controller: phone,
              maxLength: 10,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number *",
                counterText: "",
              ),
            ),
            const SizedBox(height: 10),

            // SEND OTP BUTTON
            if (!state.otpSent)
              // ElevatedButton(
              //   onPressed: state.loading
              //       ? null
              //       : () async {
              //           if (phone.text.length != 10) {
              //             _error("Enter valid 10-digit phone number");
              //             return;
              //           }
              //           await context.read<AuthCubit>().sendOtp(phone.text);
              //         },
              //   child: state.loading
              //       ? const CircularProgressIndicator(color: Colors.white)
              //       : const Text("Send OTP"),
              // ),
              // OTP FIELD
              if (state.otpSent) ...[
                const SizedBox(height: 20),
                TextField(
                  controller: otp,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Enter OTP",
                    counterText: "",
                  ),
                ),

                // VERIFY OTP
                // ElevatedButton(
                //   onPressed: state.loading
                //       ? null
                //       : () async {
                //           if (otp.text.length < 4) {
                //             _error("Enter valid OTP");
                //             return;
                //           }
                //           await context.read<AuthCubit>().verifyOtp(otp.text);
                //         },
                //   child: state.loading
                //       ? const CircularProgressIndicator(color: Colors.white)
                //       : const Text("Verify OTP"),
                // ),
              ],

            const SizedBox(height: 20),

            // SUBMIT BUTTON
            // ElevatedButton(
            //   onPressed: state.otpVerified ? _submit : null,
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.purple,
            //     padding: const EdgeInsets.symmetric(vertical: 14),
            //   ),
            //   child: const Text(
            //     "Complete Sign Up",
            //     style: TextStyle(color: Colors.white, fontSize: 16),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
