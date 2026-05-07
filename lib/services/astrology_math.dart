import 'dart:math' as math;

double radians(double degrees) => degrees * math.pi / 180.0;
double degrees(double radians) => radians * 180.0 / math.pi;
