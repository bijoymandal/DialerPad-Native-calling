// lib/widgets/common/notification_button.dart
import 'package:crafts/widgets/common/notifications_popup.dart';
import 'package:flutter/material.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {
            // OPEN FULL-SCREEN NOTIFICATIONS POPUP WITH SMOOTH ANIMATION
            showGeneralDialog(
              context: context,
              barrierLabel: "Notifications",
              barrierDismissible: true,
              barrierColor: Colors.black.withOpacity(0.6),
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (_, __, ___) => const NotificationsPopup(),
              transitionBuilder: (_, animation, __, child) {
                return SlideTransition(
                  position:
                      Tween<Offset>(
                        begin: const Offset(0, -1),
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
            );
          },
        ),
        const Positioned(
          right: 8,
          top: 8,
          child: CircleAvatar(
            radius: 9,
            backgroundColor: Colors.red,
            child: Text(
              "3",
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
