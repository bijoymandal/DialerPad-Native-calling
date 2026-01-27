import 'package:flutter/material.dart';

class SignUpFooter extends StatelessWidget {
  const SignUpFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpScree()));
      },
      child: const Text.rich(
        TextSpan(
          text: "Don't have an account? ",
          style: TextStyle(color: Colors.black54),
          children: [
            TextSpan(
              text: 'Sign up',
              style: TextStyle(
                color: Color(0xFF9C27B0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
