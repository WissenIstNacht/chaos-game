import 'dart:html';

import 'sketch.dart';

void main() {
  Sketch().run();
}

double map(double value, double from_a, double from_b, double to_a, double to_b) {
  var centered_value = value - from_a;
  var from_delta = from_b - from_a;
  var to_delta = to_b - to_a;
  var ratio = to_delta * centered_value / from_delta;
  return ratio + to_a;
}
