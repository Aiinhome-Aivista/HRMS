import 'dart:ui';
import 'package:flutter/material.dart';

class LogoutConfirmDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel; // 👈 ADD THIS

  const LogoutConfirmDialog(
      {super.key, required this.onConfirm, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Blur background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              // color: Colors.black.withOpacity(0.3),
            ),
          ),

          // Dialog content
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Are you sure you want to log out?",
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onCancel();
                        },
                        child: const Text("Cancel",
                            style: TextStyle(color: Colors.grey)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        onPressed: () {
                          Navigator.pop(context); // close dialog
                          onConfirm(); // trigger logout
                        },
                        child:  Text("Logout", style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
