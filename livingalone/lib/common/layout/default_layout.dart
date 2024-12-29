import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Color appbarTitleBackgroundColor;
  final Widget child;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final String? title;
  final bool isFirstScreen;
  final Color appbarBorderColor;
  final String? actionString;

  const DefaultLayout({
    this.backgroundColor,
    this.appbarTitleBackgroundColor = WHITE100_COLOR,
    required this.child,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.title,
    this.isFirstScreen = false,
    super.key, this.appbarBorderColor=GRAY200_COLOR,
    this.actionString,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor ?? WHITE100_COLOR,
      body: child,
      appBar: renderAppBar(context),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }

  AppBar? renderAppBar(context) {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        title: Text(title!),
        titleTextStyle: AppTextStyles.title.copyWith(color: GRAY800_COLOR),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          if(actionString != null)
          Padding(
            padding: const EdgeInsets.only(right: 24).r,
            child: Text('$actionString/4', style: AppTextStyles.caption2.copyWith(color: BLUE400_COLOR),),
          )
        ],
        scrolledUnderElevation: 0,
        leading: isFirstScreen
            ? null
            : IconButton(
          icon: Image.asset('assets/image/left_24.png'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: appbarTitleBackgroundColor,
        shape: Border(
          bottom: BorderSide(
            width: 1,
            color: appbarBorderColor,
          ),
        ),
      );
    }
  }
}
