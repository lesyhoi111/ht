import 'package:flutter/material.dart';
import 'package:hiptech_app/model/user.dart';

import 'theme/themeColor.dart';

class MultiSelect extends StatefulWidget {
  final List<UserDetail> peopleSent;
  final List<UserDetail> selectPeopleSent;
  const MultiSelect(
      {Key? key, required this.peopleSent, required this.selectPeopleSent})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  late List<UserDetail> searchResult = [];
// This function is triggered when a checkbox is checked or unchecked
  void _CheckChange(UserDetail itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        widget.selectPeopleSent.add(itemValue);
      } else {
        widget.selectPeopleSent.remove(itemValue);
      }
    });
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, widget.selectPeopleSent);
  }

  void ChangeSearching(String searchString) {
    List<UserDetail> results = [];
    if (searchString.isEmpty) {
      results = widget.peopleSent;
    } else {
      results = widget.peopleSent
          .where((people) =>
              people.name!.toLowerCase().contains(searchString.toLowerCase()))
          .toList();
    }
    setState(() {
      searchResult = results;
    });
  }

  @override
  void initState() {
    searchResult = widget.peopleSent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.zero,
        scrollable: true,
        content: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
          height: 400,
          width: double.infinity - 100,
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Choose indivials",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryColor),
                  )
                ],
              ),
              TextFormField(
                // controller:
                //     searchPeopleController,
                maxLines: 1,
                style: const TextStyle(color: Colors.black, fontSize: 15),
                cursorColor: Colors.grey,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.search_rounded),
                  suffixIconColor: AppColors.primaryColor,
                  labelText: 'Enter name...',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.zero,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                ),
                onChanged: (value) => ChangeSearching(value),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                  child: SingleChildScrollView(
                      child: ListBody(
                children: searchResult
                    .map((item) => CheckboxListTile(
                          value: widget.selectPeopleSent.contains(item),
                          title: Text(item.name!),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (isChecked) =>
                              _CheckChange(item, isChecked!),
                        ))
                    .toList(),
              ))),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 40,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(0, 210, 255, 1),
                        Color.fromRGBO(58, 123, 213, 0.84),
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context, widget.selectPeopleSent);
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
