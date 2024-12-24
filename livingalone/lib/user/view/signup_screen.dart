import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';

class SignupScreen extends StatelessWidget {
  static String get routeName => 'signup';
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '회원가입',
      child: Column(
        children: [
          Text('학교'),

        ],
      ),
    );
  }
}
