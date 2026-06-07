import 'dart:math' as math;

double radians(double degrees) {
  return degrees * math.pi / 180;
}

double degrees(double radians) {
  return radians * 180 / math.pi;
}
