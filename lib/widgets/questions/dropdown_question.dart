import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/constants/color_constants.dart';

class DropdownQuestion extends StatefulWidget {
  final List items;
  final String selectedItem;
  final ValueChanged<String> parentAction;
  const DropdownQuestion(
      {Key? key,
      required this.items,
      required this.selectedItem,
      required this.parentAction})
      : super(key: key);

  @override
  _DropdownQuestionState createState() => _DropdownQuestionState();
}

class _DropdownQuestionState extends State<DropdownQuestion> {
  String _dropdownValue = '';
  final List<String> _dropdownItems = [];

  @override
  void initState() {
    super.initState();
    initializeDropdown();
  }

  void initializeDropdown() {
    for (var item in widget.items) {
      _dropdownItems.add(item['value']);
    }
    setState(() {
      _dropdownValue =
          widget.selectedItem != '' ? widget.selectedItem : _dropdownItems[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.black16),
        ),
        child: DropdownButton<String>(
          value: _dropdownValue.isNotEmpty ? _dropdownValue : null,
          icon: const Icon(Icons.arrow_drop_down_outlined),
          iconSize: 26,
          elevation: 16,
          isExpanded: true,
          style: const TextStyle(color: AppColors.black87),
          underline: Container(
            // height: 2,
            color: AppColors.black08,
          ),
          selectedItemBuilder: (BuildContext context) {
            return _dropdownItems.map<Widget>((String item) {
              return Row(
                children: [
                  Text(
                    _dropdownValue,
                    style: GoogleFonts.lato(
                      color: AppColors.black87,
                      fontSize: 14.0,
                      letterSpacing: 0.25,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              );
            }).toList();
          },
          onChanged: (newValue) {
            setState(() {
              _dropdownValue = newValue.toString();
              widget.parentAction(newValue.toString());
            });
          },
          items: _dropdownItems.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: GoogleFonts.lato(
                  color: AppColors.black87,
                  fontSize: 13.0,
                  letterSpacing: 0.25,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          }).toList(),
        ));
  }
}
