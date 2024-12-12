import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms/utils/Screens/activityScreen.dart';

class Locationfillscreen extends StatefulWidget {
  const Locationfillscreen({super.key});

  @override
  State<Locationfillscreen> createState() => _LocationfillscreenState();
}

class _LocationfillscreenState extends State<Locationfillscreen> {
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(8, 12, 17, 1),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(143, 181, 255, 1),
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: const Text(
          'Select location',
          style: TextStyle(
            color: Color.fromRGBO(143, 181, 255, 1),
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        titleSpacing: 0,
      ),
      backgroundColor: Color.fromRGBO(8, 12, 17, 1),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // City TextField
            TextField(
              controller: _cityController,
              style: const TextStyle(
                color: Color.fromRGBO(143, 181, 255, 1),
              ),
              decoration: InputDecoration(
                labelText: 'CITY',
                labelStyle: const TextStyle(
                  color: Color.fromRGBO(143, 181, 255, 0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                prefixIcon: const Icon(
                  size: 25,
                  Icons.location_city,
                  color: Color.fromRGBO(143, 181, 255, 0.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
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

            // State (Country) TextField
            TextField(
              controller: _stateController,
              style: const TextStyle(
                color: Color.fromRGBO(143, 181, 255, 1),
              ),
              decoration: InputDecoration(
                labelText: 'STATE',
                labelStyle: const TextStyle(
                  color: Color.fromRGBO(143, 181, 255, 0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                prefixIcon: const Icon(
                  size: 25,
                  Icons.flag,
                  color: Color.fromRGBO(143, 181, 255, 0.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
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

            // Pincode TextField
            TextField(
              controller: _pincodeController,
              style: const TextStyle(
                color: Color.fromRGBO(143, 181, 255, 1),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: 'PINCODE',
                labelStyle: const TextStyle(
                  color: Color.fromRGBO(143, 181, 255, 0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                prefixIcon: const Icon(
                  size: 25,
                  Icons.location_on,
                  color: Color.fromRGBO(143, 181, 255, 0.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
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

            // Submit Button
            ElevatedButton(
              onPressed: () {
                // You can handle form submission logic here
                String city = _cityController.text;
                String state = _stateController.text;
                String pincode = _pincodeController.text;

                print("state: $state, City: $city, pincode: $pincode");

                // Navigate to ActivityScreen after saving
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Activityscreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(143, 181, 255, 1),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text(
                'SAVE',
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
