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
import 'package:shared_preferences/shared_preferences.dart';

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
  bool get _isButtonEnabled =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
    _updateButtonState();
  }

  // Get local storage data
  Future<void> _loadSavedCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedEmail = prefs.getString('saved_email');
    final String? savedPassword = prefs.getString('saved_password');
    final bool? rememberMeStatus = prefs.getBool('remember_me');

    if (rememberMeStatus != null && rememberMeStatus) {
      setState(() {
        _emailController.text = savedEmail ?? '';
        _passwordController.text = savedPassword ?? '';
        _rememberMe = rememberMeStatus;
      });
    }
  }

  // Set local storage data
  Future<void> _saveCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('saved_email', _emailController.text);
      await prefs.setString('saved_password', _passwordController.text);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
      await prefs.setBool('remember_me', false);
    }
  }

  void _updateButtonState() {
    _emailController.addListener(() {
      setState(() {});
    });

    _passwordController.addListener(() {
      setState(() {});
    });
  }

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
    setState(() {
      _isLoading = true;
    });

    POST_API postApi = POST_API();
    Map<String, dynamic> response = await postApi.login(
      _emailController.text,
      _passwordController.text,
    );

    if (response['status'] == true) {
      await _saveCredentials();
      fetchLocation();
      print('Login Successful: ${response['user']}');
      // Set local storage data
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('SaveUserName', response['user']['emp_name']);
      await prefs.setString('SaveUserEmail', response['user']['emp_email']);
    } else {
      CustomToast.show(context, response['msg']);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.light,
    ));

    double screenHeight = MediaQuery.of(context).size.height;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    double imageHeight =
        keyboardHeight > 0 ? screenHeight * 0.15 : screenHeight * 0.2;

    double sizeboxHeight = keyboardHeight > 0
        ? MediaQuery.of(context).size.height * 0.045
        : MediaQuery.of(context).size.height * 0.0862;

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
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: imageHeight,
                  child: SvgPicture.asset(
                    'assets/images/login.svg',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: sizeboxHeight),

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

                const SizedBox(height: 10),
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
                          style: TextStyle(
                              color: AppColors.lightblue, fontSize: 13),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPassword(),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Text(
                          'Forgot Password ?',
                          style: TextStyle(
                            color: AppColors.lightblue,
                            fontSize: 13,
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
