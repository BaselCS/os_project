// Create a Fork widget to represent the forks
import 'package:flutter/material.dart';

class Fork extends StatelessWidget {
  final String id;
  final bool isInUse;
  final bool isTested;
  final double forkSize;

  const Fork({super.key, required this.id, required this.isInUse, required this.forkSize, this.isTested = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: forkSize,
      height: forkSize * 3, // Fork length
      child: CustomPaint(painter: ForkPainter(isInUse: isInUse, isTested: isTested)),
    );
  }
}

// Custom painter for drawing the fork
class ForkPainter extends CustomPainter {
  final bool isInUse;
  final bool isTested;
  ForkPainter({required this.isInUse, required this.isTested});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint;
    paint =
        Paint()
          ..color =
              isTested
                  ? Colors.blue.shade200
                  : isInUse
                  ? Colors.brown.shade700
                  : Colors.grey.shade400
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    // Draw fork handle
    canvas.drawLine(Offset(size.width / 2, size.height * 0.3), Offset(size.width / 2, size.height), paint..strokeWidth = 3);

    // Draw fork prongs
    canvas.drawLine(Offset(size.width / 2, size.height * 0.3), Offset(size.width * 0.2, 0), paint..strokeWidth = 2);

    canvas.drawLine(Offset(size.width / 2, size.height * 0.3), Offset(size.width / 2, 0), paint..strokeWidth = 2);

    canvas.drawLine(Offset(size.width / 2, size.height * 0.3), Offset(size.width * 0.8, 0), paint..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
