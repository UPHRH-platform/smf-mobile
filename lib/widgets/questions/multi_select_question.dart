import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/constants/color_constants.dart';

class MultiSelectQuestion extends StatefulWidget {
  final List items;
  final String selectedItems;
  final ValueChanged<String> parentAction;

  const MultiSelectQuestion(
      {Key? key,
      required this.items,
      required this.selectedItems,
      required this.parentAction})
      : super(key: key);
  @override
  _MultiSelectQuestionQuestionState createState() =>
      _MultiSelectQuestionQuestionState();
}

class _MultiSelectQuestionQuestionState extends State<MultiSelectQuestion> {
  final Map _isChecked = {};
  List _selectedOptions = [];
  final List _checkboxItems = [];

  @override
  void initState() {
    super.initState();
    initializeDropdown();
  }

  void initializeDropdown() {
    _selectedOptions = widget.selectedItems.split(",");
    for (int i = 0; i < widget.items.length; i++) {
      _checkboxItems.add(widget.items[i]['value']);
      _isChecked[i] =
          _selectedOptions.contains(widget.items[i]['value']) ? true : false;
    }
    List temp = [];
    for (int i = 0; i < _selectedOptions.length; i++) {
      if (_checkboxItems.contains(_selectedOptions[i])) {
        temp.add(_selectedOptions[i]);
      }
    }
    _selectedOptions = temp;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _checkboxItems.length,
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width,
            // padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: _isChecked[index]
                  ? const Color.fromRGBO(0, 116, 182, 0.05)
                  : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              border: Border.all(
                color: _isChecked[index]
                    ? AppColors.primaryBlue
                    : AppColors.black16,
              ),
            ),
            child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: AppColors.primaryBlue,
                dense: true,
                title: Text(
                  _checkboxItems[index],
                  style: GoogleFonts.lato(
                    color: AppColors.black87,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                value: _isChecked[index],
                onChanged: (value) {
                  setState(() {
                    _isChecked[index] = value;

                    if (_isChecked[index]) {
                      _selectedOptions.add(_checkboxItems[index]);
                    } else {
                      int keyIndex =
                          _selectedOptions.indexOf(_checkboxItems[index]);
                      if (keyIndex >= 0) {
                        _selectedOptions.removeAt(keyIndex);
                      }
                    }
                  });
                  // print(_selectedOptions);
                  widget.parentAction(_selectedOptions.join(","));
                }),
          );
        },
      ),
    );
  }
}
