import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrms/components/CustomButton.dart';
import 'package:hrms/components/CustomTextField.dart';
import 'package:hrms/utils/Screens/locationFillScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: Color.fromRGBO(8, 12, 17, 1),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: SvgPicture.asset(
                'assets/images/login.svg',
              ),
            ),
            const SizedBox(height: 70.0),

            // Email TextField
            CustomTextField(
              controller: _emailController,
              labelText: 'USER NAME',
              prefixIcon: Icons.person,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20.0),

            // Password TextField
            CustomTextField(
              controller: _passwordController,
              labelText: 'PASSWORD',
              prefixIcon: Icons.privacy_tip,
              isPassword: true,
            ),
            const SizedBox(height: 24.0),

            // Animated Login Button
            CustomButton(
              buttonText: 'LOGIN',
              onPressed: () async {
                try {
                  // Print the values of the text fields
                  print("Email: ${_emailController.text}");
                  print("Password: ${_passwordController.text}");

                  // Check and request location permission
                  LocationPermission permission =
                      await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                  }

                  if (permission == LocationPermission.deniedForever) {
                    print("Location permissions are permanently denied.");
                    return;
                  }

                  // Get the current position
                  Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high,
                  );

                  // Get the address from latitude and longitude
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                    position.latitude,
                    position.longitude,
                  );

                  if (placemarks.isNotEmpty) {
                    Placemark place = placemarks.first;
                    print('City is: ${place.locality}');
                    print('State is:  ${place.administrativeArea}');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Locationfillscreen(
                          city: place.locality ?? '',
                          state: place.administrativeArea ?? '',
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  print("Error fetching location: $e");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
