import 'package:flutter/material.dart';

class OdoTrackLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const OdoTrackLogo({
    super.key,
    this.size = 130,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Emblem Container
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5B50E5).withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(size * 0.08),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEFF6FF), // soft light blue
                border: Border.all(
                  color: const Color(0xFFDBEAFE),
                  width: 1.5,
                ),
              ),
              child: CustomPaint(
                painter: _OdoTrackLogoPainter(),
              ),
            ),
          ),
        ),

        if (showText) ...[
          SizedBox(height: size * 0.12),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Odo',
                  style: TextStyle(
                    fontSize: size * 0.22,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
                TextSpan(
                  text: 'Track',
                  style: TextStyle(
                    fontSize: size * 0.22,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF5B50E5),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _OdoTrackLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    final brandDark = const Color(0xFF1E3A8A); // deep navy
    final brandPrimary = const Color(0xFF5B50E5); // purple
    final brandAccent = const Color(0xFF3B82F6); // bright blue

    // 1. Draw outer speedometer circular arc (top-right side)
    final arcPaint = Paint()
      ..color = brandDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.045
      ..strokeCap = StrokeCap.round;

    final arcRect = Rect.fromCircle(center: center, radius: w * 0.38);
    // Draw segmented gauge
    canvas.drawArc(arcRect, 3.8, 4.2, false, arcPaint);

    // Gauge tick dots
    final dotPaint = Paint()..color = brandAccent;
    canvas.drawCircle(Offset(w * 0.82, h * 0.32), w * 0.025, dotPaint);
    canvas.drawCircle(Offset(w * 0.86, h * 0.44), w * 0.022, dotPaint);

    // 2. Draw Location Map Pin (placed at top center)
    final pinCenter = Offset(w * 0.50, h * 0.27);
    final pinRadius = w * 0.11;

    final pinPaint = Paint()
      ..color = brandDark
      ..style = PaintingStyle.fill;

    // Pin shape
    final pinPath = Path();
    pinPath.addArc(
      Rect.fromCircle(center: pinCenter, radius: pinRadius),
      3.14 * 0.8,
      3.14 * 1.4,
    );
    pinPath.lineTo(w * 0.50, h * 0.44);
    pinPath.close();
    canvas.drawPath(pinPath, pinPaint);

    // Pin center white dot
    final pinDotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pinCenter, pinRadius * 0.42, pinDotPaint);

    // 3. Draw Scooter / Motorcycle silhouette
    final bikePaint = Paint()
      ..color = brandDark
      ..style = PaintingStyle.fill;

    // Rear Wheel
    final rearWheel = Offset(w * 0.33, h * 0.68);
    final wheelRadius = w * 0.11;
    final wheelStroke = Paint()
      ..color = brandDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.045;
    canvas.drawCircle(rearWheel, wheelRadius, wheelStroke);

    // Front Wheel
    final frontWheel = Offset(w * 0.69, h * 0.68);
    canvas.drawCircle(frontWheel, wheelRadius, wheelStroke);

    // Inner wheel hubs
    canvas.drawCircle(rearWheel, w * 0.03, bikePaint);
    canvas.drawCircle(frontWheel, w * 0.03, bikePaint);

    // Scooter Body & Seat Path
    final bodyPaint = Paint()
      ..color = brandDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.05
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final bodyPath = Path();
    // From rear wheel to floorboard
    bodyPath.moveTo(rearWheel.dx, rearWheel.dy - wheelRadius * 0.8);
    bodyPath.lineTo(w * 0.44, h * 0.68);
    // Floorboard to front neck
    bodyPath.lineTo(w * 0.57, h * 0.68);
    bodyPath.lineTo(w * 0.64, h * 0.48); // handle neck
    bodyPath.lineTo(w * 0.59, h * 0.46); // handlebar
    canvas.drawPath(bodyPath, bodyPaint);

    // Seat
    final seatPaint = Paint()
      ..color = brandPrimary
      ..style = PaintingStyle.fill;
    final seatPath = Path();
    seatPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.32, h * 0.52, w * 0.20, h * 0.075),
      Radius.circular(w * 0.03),
    ));
    canvas.drawPath(seatPath, seatPaint);

    // Front Cowl / Shield
    final cowlPaint = Paint()
      ..color = brandDark
      ..style = PaintingStyle.fill;
    final cowlPath = Path();
    cowlPath.moveTo(w * 0.64, h * 0.48);
    cowlPath.lineTo(w * 0.70, h * 0.54);
    cowlPath.lineTo(w * 0.62, h * 0.64);
    cowlPath.close();
    canvas.drawPath(cowlPath, cowlPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
