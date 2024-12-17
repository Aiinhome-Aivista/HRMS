import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrms/Services/api_services.dart';
import 'package:hrms/components/CustomButton.dart';
import 'package:hrms/components/CustomTextField.dart';
import 'package:hrms/components/loading_spinner.dart';
import 'package:hrms/components/showToast.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/utils/Screens/forgotPassword.dart';
import 'package:hrms/utils/Screens/locationFillScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _updateButtonState();
  }

  void _updateButtonState() {
    _emailController.addListener(() {
      setState(() {});
    });

    _passwordController.addListener(() {
      setState(() {});
    });
  }

  bool get _isButtonEnabled =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  Future<void> fetchLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        print("Location permissions are permanently denied.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      CustomToast.show(context, 'Successfully login');
      setState(() {
        _isLoading = false;
      });

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String city = place.locality ?? 'Unknown';
        String state = place.administrativeArea ?? 'Unknown';

        print('City is: $city');
        print('State is: $state');
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
      setState(() {
        _isLoading = false;
      });
    }
  }

  void loginUser() async {
    if (_emailController.text.isEmpty && _passwordController.text.isEmpty) {
      CustomToast.show(
        context,
        'User name and Password is required',
      );
    } else {
      setState(() {
        _isLoading = true;
      });
      POST_API postApi = POST_API();
      Map<String, dynamic> response = await postApi.login(
        _emailController.text,
        _passwordController.text,
      );

      if (response['status'] == true) {
        fetchLocation();
        print('Login Successful: ${response['user']}');
      } else {
        print('Login Failed: ${response['msg']}');
        CustomToast.show(context, response['msg']);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: const Color.fromRGBO(8, 12, 17, 1),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(45.0),
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
                  prefixIcon: Icons.lock,
                  isPassword: true,
                ),

                const SizedBox(height: 20),
                // Row for Remember Me Checkbox and Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (bool? value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor: AppColors.lightblue,
                        ),
                        const Text(
                          'Remember Me',
                          style: TextStyle(color: AppColors.lightblue),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPassword(),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: AppColors.lightblue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),

                // Login Button
                CustomButton(
                  buttonText: 'LOGIN',
                  onPressed: _isButtonEnabled ? loginUser : () {},
                  backgroundColor: _isButtonEnabled
                      ? AppColors.lightblue
                      : AppColors.greyShade2,
                )
              ],
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: LoadingSpinner(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
