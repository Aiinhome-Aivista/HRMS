import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hrms/styleColor.dart';

class AddSkillsPage extends StatefulWidget {
  @override
  _AddSkillsPageState createState() => _AddSkillsPageState();
}

class _AddSkillsPageState extends State<AddSkillsPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> skills = [];

  void _addSkill() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        skills.add(_controller.text);
        _controller.clear(); // Clear the input field
      });
    }
    Navigator.pop(context); // Close the modal
  }

  // Function to show the bottom modal where the skill is added
  void _showAddSkillModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allows the modal to take the entire height if needed
      backgroundColor: AppColors.lightblue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Your Skill',
                style: TextStyle(
                  color: AppColors.backgroundColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 40.0,
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Enter your skill',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.unselectedNavBarColor,
                  minimumSize: Size(40, 30),
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                ),
                onPressed: _addSkill,
                child: const Text(
                  'Add Skill',
                  style: TextStyle(
                    color: AppColors.lightblue,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/setting.svg',
                width: 16.0,
                height: 16.0,
              ),
              const SizedBox(width: 7),
              const Text(
                'Skills',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.lightblue,
                  fontFamily: 'Khula',
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          SizedBox(
            width: 70,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.unselectedNavBarColor,
                minimumSize: Size(40, 30),
                padding: EdgeInsets.zero,
              ),
              onPressed: _showAddSkillModal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/images/add.svg',
                    width: 14.0,
                    height: 14.0,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightblue,
                      fontFamily: 'Khula',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
