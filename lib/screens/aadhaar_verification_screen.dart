// lib/screens/aadhaar_verification_screen.dart
import 'package:crafts/widgets/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/input/app_input.dart';
import 'package:flutter/gestures.dart';

class AadhaarVerificationScreen extends StatefulWidget {
  final String phoneNumber; // Required phone number from previous screen

  const AadhaarVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<AadhaarVerificationScreen> createState() =>
      _AadhaarVerificationScreenState();
}

class _AadhaarVerificationScreenState extends State<AadhaarVerificationScreen> {
  final TextEditingController _aadhaarController = TextEditingController();
  bool _consentKyc = false;
  bool _consentTerms = false;
  bool _isLoading = false;

  bool get _isButtonEnabled =>
      _aadhaarController.text.trim().length == 12 &&
      _consentKyc &&
      _consentTerms;

  @override
  void initState() {
    super.initState();
    _aadhaarController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _aadhaarController.dispose();
    super.dispose();
  }

  void _verifyAadhaar() async {
    if (!_isButtonEnabled) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Navigate to Home after successful Aadhaar verification
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          initialIndex: 2,
          number: widget.phoneNumber, // Now correctly passed
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Aadhaar Verification",
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Purple Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: const BoxDecoration(
                color: Color(0xFF9C27B0),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.credit_card,
                          size: 40,
                          color: const Color(0xFF9C27B0),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "KYC Verification",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Step 2 of 2",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const LinearProgressIndicator(
                    value: 1.0,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E5F5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE1BEE7)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFF9C27B0),
                    child: const Icon(
                      Icons.info,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                        children: [
                          TextSpan(
                            text: "Aadhaar Information\n",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                "Enter your 12-digit Aadhaar number. We'll send an OTP to your registered mobile number for verification.",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Aadhaar Input
            AppInput(
              label: "Aadhaar Number",
              hint: "1234 5678 9012",
              controller: _aadhaarController,
              maxLength: 12,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              prefixIcon: const Icon(Icons.credit_card, color: Colors.grey),
              suffixIcon: const Icon(Icons.smartphone, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Enter your 12-digit Aadhaar number",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30),

            // Consent 1
            _buildConsentTile(
              value: _consentKyc,
              onChanged: (v) => setState(() => _consentKyc = v!),
              title:
                  "I hereby give my consent to fetch my KYC information from UIDAI for account verification.",
            ),
            const SizedBox(height: 16),

            // Consent 2 with link
            _buildConsentTile(
              value: _consentTerms,
              onChanged: (v) => setState(() => _consentTerms = v!),
              title: "I agree to the ",
              linkText: "Terms & Conditions and Privacy Policy",
              onTapLink: () {
                // TODO: Open Terms & Privacy Policy
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Opening Terms & Conditions..."),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),

            // Verify Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isButtonEnabled && !_isLoading
                    ? _verifyAadhaar
                    : null,
                icon: _isLoading
                    ? const SizedBox()
                    : const Icon(Icons.verified_user),
                label: _isLoading
                    ? const Text("Verifying...", style: TextStyle(fontSize: 18))
                    : const Text(
                        "Verify Aadhaar",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonEnabled
                      ? const Color(0xFF9C27B0)
                      : Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: _isButtonEnabled ? 8 : 0,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Security Badges
            Row(
              children: [
                Expanded(
                  child: _securityCard(
                    Icons.lock,
                    "256-bit SSL\nEncrypted",
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _securityCard(
                    Icons.verified,
                    "UIDAI Verified\nAuthentic",
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Help Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Need Help?",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.help_outline, color: Colors.grey.shade400),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _helpTile(Icons.phone, "Call Customer Support"),
                  const SizedBox(height: 16),
                  _helpTile(Icons.chat_bubble_outline, "Chat with Agent"),
                  const SizedBox(height: 16),
                  _helpTile(Icons.menu_book, "View FAQ"),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Footer
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text(
                  "Secured by 256-bit SSL encryption",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildConsentTile({
    required bool value,
    required Function(bool?) onChanged,
    required String title,
    String? linkText,
    VoidCallback? onTapLink,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF9C27B0),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                children: [
                  TextSpan(text: title),
                  if (linkText != null)
                    TextSpan(
                      text: linkText,
                      style: const TextStyle(
                        color: Color(0xFF9C27B0),
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = onTapLink,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _securityCard(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, size: 36, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _helpTile(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.black54),
        const SizedBox(width: 16),
        Text(title, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
