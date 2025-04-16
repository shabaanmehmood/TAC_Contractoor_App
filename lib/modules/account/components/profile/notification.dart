import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationSnoozeScreen extends StatefulWidget {
  const NotificationSnoozeScreen({super.key});

  @override
  State<NotificationSnoozeScreen> createState() =>
      _NotificationSnoozeScreenState();
}

class _NotificationSnoozeScreenState extends State<NotificationSnoozeScreen> {
  String? selectedDuration;

  final List<String> snoozeOptions = [
    '4 Hours',
    '8 Hours',
    'One Day',
    'One Week',
    'One Month',
    'Always',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2937),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2937),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text('Snooze Notifications',
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child:
                const Text('Done', style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ListView(
          children: [
            const SizedBox(height: 8),
            const Text(
              'Snooze for',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...snoozeOptions.map(
              (option) => Column(
                children: [
                  RadioListTile<String>(
                    value: option,
                    groupValue: selectedDuration,
                    onChanged: (val) {
                      setState(() {
                        selectedDuration = val;
                      });
                    },
                    title: Text(option,
                        style: const TextStyle(color: Colors.white)),
                    activeColor: Colors.cyanAccent,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const Divider(color: Colors.white10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
