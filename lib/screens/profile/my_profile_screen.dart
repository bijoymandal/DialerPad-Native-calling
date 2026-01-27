import 'package:crafts/widgets/complete_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../models/user_model.dart';

class MyProfileScreen extends StatelessWidget {
  final String number;
  final String otp;
  final UserModel? existingUser;
  const MyProfileScreen({
    super.key,
    required this.number,
    required this.otp,
    this.existingUser,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc()..add(LoadProfile()),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text("My Profile"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProfileLoaded) {
              return _buildContent(context, state.user);
            }
            return const Center(child: Text("Failed to load profile"));
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, UserModel user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: user.profilePhotoUrl.isNotEmpty
                    ? NetworkImage(user.profilePhotoUrl)
                    : null,
                child: user.profilePhotoUrl.isEmpty
                    ? const Icon(Icons.person, size: 70, color: Colors.grey)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user.firstName,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          Text(user.email, style: const TextStyle(color: Colors.grey)),
          Text(user.phone, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, color: Colors.green, size: 20),
                SizedBox(width: 6),
                Text(
                  "KYC Verified",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            "Your KYC has been successfully verified.",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Full Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          // _detailRow("Aadhar Number", "**** **** "),
          _detailRow("Phone Number", user.phone),
          _detailRow("Role", user.role),
          // _detailRow("MAA Association", user.maaAssociation),
          // _detailRow("Gender", user.gender),
          // _detailRow("Department", user.department),
          // _detailRow("Company Name", user.companyName),
          // _detailRow("facebook", user.socialLinks.map()),
          // _detailRow("Company Phone", user.companyPhone),
          // _detailRow("Address", user.address, isLast: true),
          _buildPremiumToggle(context, user),
          const SizedBox(height: 40),
          // Social Links
          if (user.socialLinks.isNotEmpty) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Social Links",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ...user.socialLinks.map(
              (link) => ListTile(
                leading: _getPlatformIcon(link.platform),
                title: Text(link.platform.capitalize()),
                // subtitle: Text(link.url),
                // trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // launchUrlString(link.url);
                },
              ),
            ),
          ],
          // EDIT PROFILE BUTTON – SMOOTH ANIMATED
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  pageBuilder: (_, __, ___) => CompleteProfileScreen(
                    phoneNumber: number,
                    otp: "",
                    existingUser: user,
                  ),
                  transitionsBuilder: (_, animation, __, child) {
                    return SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: child,
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text(
              "Edit Profile",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9C27B0),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 10,
            ),
          ),

          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download, color: Colors.green),
            label: const Text(
              "Download KYC PDF",
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.green, width: 2),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isLast ? Colors.transparent : Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return const Icon(Icons.camera_alt, color: Colors.pink);
      case 'facebook':
        return const Icon(Icons.facebook, color: Colors.blue);
      case 'twitter':
      case 'x':
        return const Icon(Icons.chat, color: Colors.black);
      case 'youtube':
        return const Icon(Icons.play_circle_fill, color: Colors.red);
      case 'website':
        return const Icon(Icons.language, color: Colors.purple);
      default:
        return const Icon(Icons.link, color: Colors.grey);
    }
  }
}

class TogglePremiumStatus extends ProfileEvent {
  final bool isPremium;
  TogglePremiumStatus({required this.isPremium});
}

Widget _buildPremiumToggle(BuildContext context, UserModel user) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
    ),
    child: Row(
      children: [
        const SizedBox(
          width: 130,
          child: Text(
            "Premium",
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                user.isPremium ? "Active" : "Inactive",
                style: TextStyle(
                  color: user.isPremium ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 12),

              Switch(
                value: user.isPremium,
                activeColor: Colors.white,
                activeTrackColor: Colors.green,
                inactiveThumbColor: Colors.grey.shade300,
                inactiveTrackColor: Colors.grey.shade400,
                onChanged: (value) {
                  context.read<ProfileBloc>().add(
                    TogglePremiumStatus(isPremium: value),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
