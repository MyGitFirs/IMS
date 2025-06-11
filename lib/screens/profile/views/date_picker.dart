import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateOfBirthPicker extends StatefulWidget {
  final TextEditingController controller;

  const DateOfBirthPicker({super.key, required this.controller});

  @override
  _DateOfBirthPickerState createState() => _DateOfBirthPickerState();
}

class _DateOfBirthPickerState extends State<DateOfBirthPicker> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: "Date of Birth",
        prefixIcon: Icon(Icons.calendar_today_outlined),
        border: OutlineInputBorder(),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          setState(() {
            widget.controller.text = formattedDate;
          });
        }
      },
    );
  }
}
