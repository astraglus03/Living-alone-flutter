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
  final bool showBackButton;
  final Color appbarBorderColor;
  final Widget? actions;
  final double? height;
  final PreferredSizeWidget? bottom;
  final bool? showCloseButton;
  final VoidCallback? onClosePressed;
  final int? currentStep;
  final int? totalSteps;
  final bool? appbarBorder;

  const DefaultLayout({
    this.backgroundColor,
    this.appbarTitleBackgroundColor = WHITE100_COLOR,
    required this.child,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.title,
    this.showBackButton = true,
    this.appbarBorderColor = GRAY200_COLOR,
    this.actions,
    this.height,
    this.bottom,
    this.showCloseButton,
    this.onClosePressed,
    this.currentStep,
    this.totalSteps,
    this.appbarBorder = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'SUIT',
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor ?? WHITE100_COLOR,
        body: child,
        appBar: renderAppBar(context),
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      ),
    );
  }

  PreferredSize? renderAppBar(BuildContext context) {
    if (title == null) {
      return null;
    }

    return PreferredSize(
      preferredSize: Size.fromHeight((height ?? 48.h) + (bottom?.preferredSize.height ?? 0)),
      child: AppBar(
        title: Text(title!),
        titleTextStyle: AppTextStyles.title.copyWith(color: GRAY800_COLOR),
        centerTitle: true,
        leading: showCloseButton == true
            ? IconButton(
                icon: const Icon(Icons.close),
                splashColor: Colors.transparent,
                disabledColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: onClosePressed ?? () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              )
            : showBackButton
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios_sharp),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                : null,
        actions: [
          if (actions != null) actions!,
          if (currentStep != null && totalSteps != null)
            Padding(
              padding: const EdgeInsets.only(right: 24).r,
              child: Text(
                '$currentStep/$totalSteps',
                style: AppTextStyles.caption2.copyWith(color: BLUE400_COLOR),
              ),
            ),
        ],
        scrolledUnderElevation: 0,
        backgroundColor: appbarTitleBackgroundColor,
        shape: appbarBorder! ?Border(
          bottom: BorderSide(
            width: 1,
            color: appbarBorderColor,
          ),
        ):null,
        bottom: bottom,
      ),
    );
  }
}
