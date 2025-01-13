import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hrms/styleColor.dart';

class AddSkillsPage extends StatefulWidget {
  @override
  _AddSkillsPageState createState() => _AddSkillsPageState();
}

class _AddSkillsPageState extends State<AddSkillsPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> skills = [
    'Flutter',
    'React',
    'Angular',
    'Dart',
    'Firebase',
  ];

  // Function to add a skill
  void _addSkill() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        skills.add(_controller.text);
        _controller.clear();
      });
    }
    Navigator.pop(context);
  }

  // Function to show the bottom modal where the skill is added
  void _showAddSkillModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 40.0,
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Enter your skill',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.leaveCardColor),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.unselectedNavBarColor,
                  minimumSize: const Size(40, 30),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          // Header Row with Settings Icon and Title
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

          // Add Button
          SizedBox(
            width: 70,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.unselectedNavBarColor,
                minimumSize: const Size(40, 30),
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
          const SizedBox(height: 10),

          // Displaying Added Skills
          skills.isEmpty
              ? const Center(
                  child: Text(
                    'No skills added yet.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.lightblue,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              : Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: skills
                      .map(
                        (skill) => Chip(
                          label: Text(skill),
                          backgroundColor: AppColors.leaveCardColor,
                          labelStyle: const TextStyle(
                            fontSize: 12,
                            color: AppColors.unselectedNavBarColor,
                          ),
                          deleteIcon: const Icon(
                            Icons.close,
                            size: 16.0,
                            color: AppColors.unselectedNavBarColor,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 0.0),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          onDeleted: () {
                            setState(() {
                              skills.remove(skill);
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
        ],
      ),
    );
  }
}
