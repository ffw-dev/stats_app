import 'package:flutter/material.dart';

class AppMainBar extends StatefulWidget implements PreferredSizeWidget {
  String title;

  AppMainBar(this.title, {Key? key}) : super(key: key);

  @override
  State<AppMainBar> createState() => _AppMainBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppMainBarState extends State<AppMainBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.red,
      title: Text(widget.title),
      actions: [
        IconButton(onPressed: () {
      Navigator.of(context)
          .pushNamed('/preferences');
    }, icon: const Icon(Icons.account_circle_outlined, color: Colors.white,))
      ],
    );
  }
}
