import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAgreeButton extends StatelessWidget {
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final double strokeWidth;

  const CustomAgreeButton({
    Key? key,
    required this.isActive,
    this.activeColor = const Color(0xFFD1D9E2),
    this.inactiveColor = const Color(0xFFE0E0E0),
    this.strokeWidth = 2.0, // 체크 굵기
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.w,
      height: 24.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? activeColor : inactiveColor,
      ),
      child: Center(
        child: CustomPaint(
          size: const Size(16, 16),
          painter: CheckPainter(strokeWidth: strokeWidth),
        ),
      ),
    );
  }
}

class CheckPainter extends CustomPainter {
  final double strokeWidth;

  CheckPainter({this.strokeWidth = 2.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.5)
      ..lineTo(size.width * 0.4, size.height * 0.7)
      ..lineTo(size.width * 0.8, size.height * 0.3);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
