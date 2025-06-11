import 'package:flutter/material.dart';

class GenderPicker extends StatefulWidget {
  final Function(String) onChanged;
  final String selectedGender;

  const GenderPicker({super.key, required this.onChanged, required this.selectedGender});

  @override
  _GenderPickerState createState() => _GenderPickerState();
}

class _GenderPickerState extends State<GenderPicker> {
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.selectedGender;
  }

  void _onGenderChanged(String? value) {
    setState(() {
      _selectedGender = value!;
      widget.onChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gender",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Radio<String>(
              value: "Male",
              groupValue: _selectedGender,
              onChanged: _onGenderChanged,
            ),
            const Text("Male"),
            Radio<String>(
              value: "Female",
              groupValue: _selectedGender,
              onChanged: _onGenderChanged,
            ),
            const Text("Female"),
          ],
        ),
      ],
    );
  }
}
