import 'package:flutter/material.dart';

import '../utils/colors.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  List<String> dropDownList = ['제목', '내용'];
  String selected = '제목';
  final _searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.2,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: main_color),
          ),
          child: Align(
            alignment: Alignment.center,
            child: DropdownButton(
                isExpanded: true,
                value: selected,
                items: dropDownList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Center(child: Text(value)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selected = value!;
                  });
                },
                icon: const Icon(Icons.arrow_drop_down_rounded,
                    size: 20),
                style: const TextStyle(
                    fontSize: 20, color: Colors.black),
                underline: Container()),
          ),
        ),
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.6,
          decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 2, color: main_color),
                right: BorderSide(width: 2, color: main_color),
                top: BorderSide(width: 2, color: main_color)),
          ),
          child: Align(
            alignment: Alignment.center,
            child: TextField(
                controller: _searchTextController,
                onChanged: (value) {
                  setState(() {
                    _searchTextController.text = value;
                  });
                },
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                        borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.only(left: 10))
            ),
          ),
        ),
      ],
    );
  }
}
