import 'package:flutter/material.dart';

class AppMainBar extends StatefulWidget implements PreferredSizeWidget {
  String title;
  Function goToPreferences;
  Function goToOverview;

  AppMainBar(this.title, this.goToPreferences, this.goToOverview,{Key? key}) : super(key: key);

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
        TextButton(child: const Text('overview', style: TextStyle(color: Colors.white),),
            onPressed: () {
              widget.goToOverview();
            },),
        IconButton(
            onPressed: () {
              widget.goToPreferences();
            },
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Colors.white,
            )),
      ],
    );
  }
}
