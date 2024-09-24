
import 'package:flutter/material.dart';

class ArcClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 46);
    path.quadraticBezierTo(size.width / 2, size.height + 46, size.width, size.height - 46);
    // path.addOval(Rect.fromPoints(Offset(0, size.height - 46), Offset(size.width, 0)));
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}