import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SortDropdown extends StatelessWidget {
  final String selectedValue;
  final ValueChanged<String?> onChanged;
  final List<String> options;

  const SortDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          isExpanded: true,
          icon: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.arrow_drop_down),
          ),
          onChanged: onChanged,
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                child: Text(value, style: TextStyle(color: Colors.black)),
              ),
            );
          }).toList(),
          style: TextStyle(color: Colors.black),
          dropdownColor: Colors.white,
        ),
      ),
    );
  }
}