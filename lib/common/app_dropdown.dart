import 'package:flutter/material.dart';
import 'package:visit_tracker/common/text_field.dart';

class MyMaterialDropdown extends StatefulWidget {
  MyMaterialDropdown({Key? key, required this.options, required this.onOptionSelected, this.initialOption}) : super(key: key);


  List<String> options;

  String?  initialOption;

  Function (String?) onOptionSelected;

  @override
  State<MyMaterialDropdown> createState() => _MyMaterialDropdownState();
}

class _MyMaterialDropdownState extends State<MyMaterialDropdown> {

  late String? dropdownValue = null;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialOption;
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: DropdownButtonFormField<String>(
        value: dropdownValue,
        icon: const Icon(Icons.expand_more_outlined),
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        isExpanded: true,
        decoration: const InputDecoration(
            border: InputBorder.none
        ),
        onChanged: (String? value) {
          setState(() {
            dropdownValue = value!;
            widget.onOptionSelected.call(value);
          });
        },
        items: widget.options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}