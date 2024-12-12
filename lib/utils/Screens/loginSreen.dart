import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hrms/utils/Screens/activityScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

            SizedBox(height: 70.0),
            // Email TextField
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'USER NAME',
                 labelStyle: const TextStyle(
                  color: Color.fromRGBO(143, 181, 255, 0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                prefixIcon: const Icon(
                  size: 25,
                  Icons.person,
                  color: Color.fromRGBO(143, 181, 255, 0.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0), // Adjusts the padding inside the field

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(143, 181, 255, 1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(143, 181, 255, 1),
                    width: 2.0,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.0),

            // Password TextField
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'PASSWORD',
                labelStyle: const TextStyle(
                  color: Color.fromRGBO(143, 181, 255, 0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),

                prefixIcon: const Icon(
                  size: 23,
                  Icons.privacy_tip,
                  color: Color.fromRGBO(143, 181, 255, 0.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0), // Adjusts the padding inside the field

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(143, 181, 255, 1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(143, 181, 255, 1),
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.0),

            // Login Button
            ElevatedButton(
              onPressed: () async {
                try {
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

                    String address = """
        ${place.name}, 
        ${place.locality}, 
        ${place.administrativeArea}, 
        ${place.country}""";

                    print(
                        "User's Location: $address, Latitude = ${position.latitude}, Longitude = ${position.longitude}");
                  }

                  // Navigate to the next page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Activityscreen()),
                  );
                } catch (e) {
                  print("Error fetching location: $e");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(143, 181, 255, 1),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text(
                'LOGIN',
                style: TextStyle(
                  color: Color.fromRGBO(8, 12, 17, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
