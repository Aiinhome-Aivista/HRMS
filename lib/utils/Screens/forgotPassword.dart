import 'package:flutter/material.dart';
import 'package:hrms/components/CustomButton.dart';
import 'package:hrms/components/CustomTextField.dart';
import 'package:hrms/components/loading_spinner.dart';
import 'package:hrms/components/showToast.dart';
import 'package:hrms/styleColor.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  void sendPasswordResetRequest() async {
    if (_emailController.text.isEmpty) {
      CustomToast.show(context, 'Email is required');
    } else {
      setState(() {
        _isLoading = true;
      });

      try {
        await Future.delayed(const Duration(seconds: 2));
        CustomToast.show(context, 'Password reset link sent to your email');
      } catch (e) {
        CustomToast.show(context, 'Failed to send reset link');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(8, 12, 17, 1),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Forgot Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28.0,
                    color: AppColors.lightblue,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30.0),

                // Email Input Field
                CustomTextField(
                  controller: _emailController,
                  labelText: 'EMAIL',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 30.0),

                // Reset Password Button
                CustomButton(
                  buttonText: 'RESET PASSWORD',
                  onPressed: sendPasswordResetRequest,
                  backgroundColor: AppColors.lightblue,
                ),
                const SizedBox(height: 20.0),

                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Back to Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.lightblue,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading) const LoadingSpinner()
        ],
      ),
    );
  }
}
