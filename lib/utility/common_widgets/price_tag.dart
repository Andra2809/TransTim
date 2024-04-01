import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/dimens_constants.dart';

class PriceTag extends StatelessWidget {
  const PriceTag({super.key, required this.priceText});

  final String priceText;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PriceTagPaint(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: DimenConstants.mixPadding,
          horizontal: DimenConstants.contentPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              priceText,
              style: TextStyle(fontSize: Get.textTheme.titleSmall?.fontSize),
            ),
            const SizedBox(width: DimenConstants.contentPadding),
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber, width: 2.5),
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PriceTagPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint strokePaint = Paint()
      ..color = Colors.amber
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    Path path = Path();

    path
      ..moveTo(size.width, size.height * .5)
      ..lineTo(size.width * .87, 0)
      ..lineTo(0, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width * .87, size.height)
      ..lineTo(size.width, size.height * .5)
      ..close();

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
