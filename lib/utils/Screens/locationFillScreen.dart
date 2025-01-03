import 'package:flutter/material.dart';
import 'package:hrms/Services/api_services.dart';
import 'package:hrms/components/showToast.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/components/CustomButton.dart';
import 'package:hrms/components/CustomTextField.dart';
import 'package:hrms/utils/Widget/bottamNavigationWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Locationfillscreen extends StatefulWidget {
  final String city;
  final String state;
  final latitude;
  final longitude;

  const Locationfillscreen(
      {super.key,
      required this.city,
      required this.state,
      required this.latitude,
      required this.longitude});

  @override
  State<Locationfillscreen> createState() => _LocationfillscreenState();
}

class _LocationfillscreenState extends State<Locationfillscreen> {
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  String Emp_Id = '';
  String _selectedState = '';
  String _selectedCity = '';
  String _selectedPincode = '';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Set the initial values of city and state in the respective controllers
    _cityController.text = widget.city;
    _stateController.text = widget.state;

    setState(() {
      _selectedState = widget.state;
      _selectedCity = widget.city;
    });

    _savedEmp_Id();
  }

  Future<void> _savedEmp_Id() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? Employee_Id = prefs.getString('Employee_Id');

    // print("Emp_Id:$Employee_Id");

    setState(() {
      Emp_Id = Employee_Id ?? '';
    });
  }

  Future<void> sendLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      POST_API postApi = POST_API();
      Map<String, dynamic> response = await postApi.location(
        Emp_Id,
        _selectedPincode,
        _selectedCity,
        _selectedState,
        widget.latitude.toString(),
        widget.longitude.toString(),
      );

      setState(() {
        _isLoading = false;
      });

      if (response['status'] == true) {
        CustomToast.show(context, 'Location saved successfully!');
      } else {
        // CustomToast.show(context, response['msg']);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      CustomToast.show(context, 'Error: $e');
    }
  }

  @override
  void dispose() {
    // Dispose controllers when widget is removed to avoid memory leaks
    _stateController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(8, 12, 17, 1),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 0, 50, 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 50),
              child: const Icon(
                size: 155,
                Icons.location_on,
                color: Color.fromRGBO(143, 181, 255, 0.5),
              ),
            ),

            // City TextField (replaced with CustomTextField)
            CustomTextField(
              controller: _cityController,
              labelText: 'CITY',
              prefixIcon: Icons.location_city,
            ),

            const SizedBox(height: 20.0),

            // State (Country) TextField (replaced with CustomTextField)
            CustomTextField(
              controller: _stateController,
              labelText: 'STATE',
              prefixIcon: Icons.flag,
            ),

            const SizedBox(height: 20.0),

            // Pincode TextField (replaced with CustomTextField)
            CustomTextField(
              controller: _pincodeController,
              labelText: 'PINCODE',
              prefixIcon: Icons.location_on,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 40.0),

            // Submit Button
            CustomButton(
              buttonText: 'SAVE',
              onPressed: () async {
                // Retrieve values from text controllers
                String city = _cityController.text.trim();
                String state = _stateController.text.trim();
                String pincode = _pincodeController.text.trim();

                // Validation for blank fields
                if (city.isEmpty || state.isEmpty || pincode.isEmpty) {
                  CustomToast.show(
                    context,
                    'Please fill in all the fields before proceeding.',
                  );
                  return; // Prevent further execution if validation fails
                }

                // If all fields are valid, proceed to save location
                setState(() {
                  _selectedPincode = pincode;
                });

                await sendLocation();

                // Show success toast
                CustomToast.show(
                  context,
                  'Location save successful!',
                );

                // Navigate to ActivityScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BottamnavigationBar(),
                  ),
                );
              },
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
    );
  }
}
