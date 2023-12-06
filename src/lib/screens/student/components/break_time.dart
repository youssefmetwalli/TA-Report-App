import 'package:flutter/material.dart';

class BreakTimePicker extends StatefulWidget {
  final TextEditingController controller;

  const BreakTimePicker({Key? key, required this.controller}) : super(key: key);

  @override
  _BreakTimePickerState createState() => _BreakTimePickerState();
}

class _BreakTimePickerState extends State<BreakTimePicker> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Break Time',
      ),
      controller: widget.controller,
      onTap: () {},
    );
  }
}
