import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final AppBar? appBar;

  const DefaultLayout({this.backgroundColor, required this.child, this.bottomNavigationBar, this.floatingActionButton, super.key, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      body: child,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}

