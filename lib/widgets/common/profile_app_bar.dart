// lib/widgets/common/profile_app_bar.dart

import 'package:crafts/core/storage/secure_storage.dart';
import 'package:crafts/screens/profile/my_profile_screen.dart';
import 'package:crafts/screens/welcome_back_screen.dart';
import 'package:crafts/widgets/common/notification_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/profile/profile_bloc.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String number;

  const ProfileAppBar({super.key, required this.number});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  /// OPEN PROFILE SCREEN
  void _openProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MyProfileScreen(number: number, otp: ""),
      ),
    );
  }

  /// LOGOUT LOGIC
  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await SecureStorage.clearAll();

    // CLEAR PROFILE BLOC
    context.read<ProfileBloc>().emit(ProfileLoading());

    // GO TO LOGIN / WELCOME SCREEN
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeBackScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF9C27B0),
      elevation: 0,

      title: InkWell(
        onTap: () => _openProfile(context),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            String name = "Guest User";
            String role = "Member";

            if (state is ProfileLoaded) {
              final user = state.user;

              name = "${user.firstName ?? ''} ${user.lastName ?? ''}".trim();
              if (name.isEmpty) name = "User";

              if (user.role != null && user.role!.isNotEmpty) {
                role = user.role![0].toUpperCase() + user.role!.substring(1);
              }
            }

            return Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage("assets/images/user_avatar.jpg"),
                ),
                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      role,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),

      actions: [
        const NotificationButton(),
        IconButton(
          onPressed: () => _logout(context),
          icon: const Icon(Icons.logout, color: Colors.white),
          tooltip: "Logout",
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
