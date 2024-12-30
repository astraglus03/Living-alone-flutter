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
  final bool? isNotFirstScreen;
  final Color appbarBorderColor;
  final String? actionString;
  final Widget? actions;
  final double? height;

  const DefaultLayout({
    this.backgroundColor,
    this.appbarTitleBackgroundColor = WHITE100_COLOR,
    required this.child,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.title,
    this.isNotFirstScreen,
    super.key, this.appbarBorderColor=GRAY200_COLOR,
    this.actionString,
    this.actions,
    this.height,
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

  PreferredSize? renderAppBar(context) {
    if (title == null) {
      return null;
    } else {
      return  PreferredSize(
        preferredSize: Size.fromHeight(height ?? 48.h),
        child: AppBar(
          title: Text(title!),
          titleTextStyle: AppTextStyles.title.copyWith(color: GRAY800_COLOR),
          centerTitle: true,
          automaticallyImplyLeading: isNotFirstScreen ?? true,
          actions: [
            if(actions !=null)
              actions!,
            if(actionString != null)
            Padding(
              padding: const EdgeInsets.only(right: 24).r,
              child: Text('$actionString/4', style: AppTextStyles.caption2.copyWith(color: BLUE400_COLOR),),
            )
          ],
          scrolledUnderElevation: 0,
          backgroundColor: appbarTitleBackgroundColor,
          shape: Border(
            bottom: BorderSide(
              width: 1,
              color: appbarBorderColor,
            ),
          ),
        ),
      );
    }
  }
}
