import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/utils/Screens/loginSreen.dart';
import 'package:slider_button/slider_button.dart';

class Morewidget extends StatefulWidget {
  const Morewidget({super.key});

  @override
  State<Morewidget> createState() => _MorewidgetState();
}

class _MorewidgetState extends State<Morewidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SliderButton(
                action: () async {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false, // Removes all previous routes
                  );
                },
                label: const Text(
                  "Slide to log out",
                  style: TextStyle(
                    color: Color(0xff4a4a4a),
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                icon: const Center(
                  child: Icon(
                    CupertinoIcons.power,
                    color: Colors.redAccent,
                    size: 30.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                ),
                boxShadow: BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
