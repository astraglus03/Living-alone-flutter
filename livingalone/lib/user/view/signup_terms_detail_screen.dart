import 'package:flutter/material.dart';
import 'package:livingalone/common/layout/default_layout.dart';

class SignupTermsDetailScreen extends StatelessWidget {
  static String get routeName => 'termsDetail';
  const SignupTermsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '이용약관',
      child: SingleChildScrollView(
        child: Text('이용약관 관련된 내용'),
      ),
    );
  }
}
