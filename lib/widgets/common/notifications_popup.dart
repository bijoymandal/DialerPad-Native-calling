// lib/widgets/common/notifications_popup.dart
import 'package:flutter/material.dart';

class NotificationsPopup extends StatelessWidget {
  const NotificationsPopup({super.key});

  final List<Map<String, dynamic>> notifications = const [
    {
      "title": "New Job Application",
      "message": "Your application for 'Spirit' has been shortlisted!",
      "time": "2 min ago",
      "icon": Icons.work,
      "color": Colors.green,
    },
    {
      "title": "Schedule Updated",
      "message": "Script review moved to 11:00 AM tomorrow",
      "time": "15 min ago",
      "icon": Icons.schedule,
      "color": Colors.blue,
    },
    {
      "title": "New Message",
      "message": "Director Rajamouli sent you a message",
      "time": "1 hour ago",
      "icon": Icons.message,
      "color": Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF9C27B0),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    "Notifications",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Notification List
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  itemBuilder: (ctx, i) {
                    final notif = notifications[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: notif["color"].withOpacity(0.2),
                          child: Icon(notif["icon"], color: notif["color"]),
                        ),
                        title: Text(
                          notif["title"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(notif["message"]),
                        trailing: Text(
                          notif["time"],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () {
                          // Optional: Open detail
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Opened: ${notif["title"]}"),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
