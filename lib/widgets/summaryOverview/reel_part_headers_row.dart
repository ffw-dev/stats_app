import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReelPartHeadersRow extends StatelessWidget {
  const ReelPartHeadersRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        Text(
          'Date',
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
        Text(
          'Fin. time',
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
        Text(
          'Fin. parts',
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
        Text(
          'Exp. time',
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
        Text(
          'Exp. parts',
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
      ],
    );
  }
}
