// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_food_app/utils/uicolors.dart';

Container c_header1(IconData icon, String text,
    {required BuildContext context}) {
  return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 5),
      child: Row(
        children: [
          const SizedBox(height: 20),
          Icon(
            icon,
            color: blue11,
            size: 35,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .headline6, // TextStyle(color: Colors.grey[500], fontSize: 18)
          ),
        ],
      ));
}
