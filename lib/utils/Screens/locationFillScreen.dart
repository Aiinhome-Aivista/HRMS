import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms/styleColor.dart';
import 'package:hrms/components/CustomButton.dart';
import 'package:hrms/components/CustomTextField.dart';
import 'package:hrms/utils/Widget/bottamNavigationWidget.dart';

class Locationfillscreen extends StatefulWidget {
  final String city;
  final String state;

  const Locationfillscreen({Key? key, required this.city, required this.state})
      : super(key: key);

  @override
  State<Locationfillscreen> createState() => _LocationfillscreenState();
}

class _LocationfillscreenState extends State<Locationfillscreen> {
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set the initial values of city and state in the respective controllers
    _cityController.text = widget.city;
    _stateController.text = widget.state;
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
      // appBar: AppBar(
      //   backgroundColor: const Color.fromRGBO(8, 12, 17, 1),
      //   leading: IconButton(
      //     icon: const Icon(
      //       Icons.arrow_back,
      //       color: AppColors.lightblue,
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context); // Navigate back to the previous screen
      //     },
      //   ),
      //   title: const Text(
      //     'Select location',
      //     style: TextStyle(
      //       color: AppColors.lightblue,
      //       fontWeight: FontWeight.w600,
      //       fontSize: 20,
      //     ),
      //   ),
      //   titleSpacing: 0,
      // ),
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
                // Handle form submission logic here
                String city = _cityController.text;
                String state = _stateController.text;
                String pincode = _pincodeController.text;

                print("state: $state, City: $city, pincode: $pincode");

                // Navigate to ActivityScreen after saving
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BottamnavigationBar()),
                  //Activityscreen()),
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
