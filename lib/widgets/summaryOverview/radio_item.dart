import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RadioItem extends StatelessWidget {
  final void Function(dynamic)  onChangedHandler;
  final String value;

  const RadioItem({Key? key, required this.onChangedHandler, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Radio(
              value: value,
              groupValue: 'null',
              onChanged: onChangedHandler,
              activeColor: Colors.white,
            )),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        )
      ],
    );
  }
}
