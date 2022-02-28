import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/constants/app_constants.dart';
import 'package:smf_mobile/constants/color_constants.dart';

class RadioQuestion extends StatefulWidget {
  final List items;
  final String fieldType;
  final String selectedItem;
  final ValueChanged<String> parentAction;

  const RadioQuestion(
      {Key? key,
      required this.items,
      required this.fieldType,
      required this.selectedItem,
      required this.parentAction})
      : super(key: key);
  @override
  _RadioQuestionState createState() => _RadioQuestionState();
}

class _RadioQuestionState extends State<RadioQuestion> {
  int _radioValue = 0;
  List<String> _radioItems = [];

  @override
  void initState() {
    super.initState();
    initializeDropdown();
  }

  void initializeDropdown() {
    if (widget.fieldType == FieldType.boolean) {
      _radioItems = ['True', 'False'];
    } else {
      for (var item in widget.items) {
        _radioItems.add(item['value']);
      }
    }
    setState(() {
      _radioValue = widget.selectedItem != ''
          ? widget.items.indexOf(widget.selectedItem)
          : 0;
    });
    // if (widget.selectedItem.isEmpty) {
    //   widget.parentAction(_radioItems[_radioValue]);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _radioItems.length,
        itemBuilder: (context, index) {
          return Container(
              width: MediaQuery.of(context).size.width,
              // padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: _radioValue == index
                    ? const Color.fromRGBO(0, 116, 182, 0.05)
                    : Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                border: Border.all(
                    color: _radioValue == index
                        ? AppColors.primaryBlue
                        : AppColors.black16),
              ),
              child: RadioListTile(
                groupValue: _radioValue,
                title: Text(
                  _radioItems[index],
                  style: GoogleFonts.lato(
                    color: AppColors.black87,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                value: index,
                onChanged: (value) {
                  int selectedIndex = int.parse(value.toString());
                  setState(() {
                    _radioValue = selectedIndex;
                  });
                  // print(value);
                  widget.parentAction(_radioItems[selectedIndex]);
                },
              ));
        },
      ),
    );
  }
}
