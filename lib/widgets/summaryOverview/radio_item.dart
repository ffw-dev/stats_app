import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stats_app/screens/collaborator_overview_screen.dart';

class RadioItem extends StatelessWidget {
  final void Function(dynamic)  onChangedHandler;
  final Period value;
  final Period period;

  final String text;

  const RadioItem({Key? key, required this.onChangedHandler, required this.value, required this.period, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Radio(
              value: value,
              groupValue: period,
              onChanged: onChangedHandler,
              activeColor: Colors.white,
            )),
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        )
      ],
    );
  }
}
