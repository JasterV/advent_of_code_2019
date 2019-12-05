import 'dart:math';

import 'segment.dart';

class Path {
  List<Segment> _segments = List();

  Path.fromSegmentList(this._segments);

  List<Point> intersectionsBetween(Path other) {
    List<Point> points = List();
    for (Segment s1 in this._segments) {
      for (Segment s2 in other._segments) {
        Point res = s1.intersection(s2);
        if (res != null) {
          points.add(res);
        }
      }
    }
    return points;
  }

  List<double> intersectionSteps(Path other) {
    List<double> steps = List();
    double stepsW1 = 0;
    double stepsW2 = 0;
    for (Segment s1 in this._segments) {
      stepsW1 += s1.steps();
      for (Segment s2 in other._segments) {
        stepsW2 += s2.steps();
        Point interPoint = s1.intersection(s2);
        if (interPoint != null) {
          steps.add(_substractRedundantSteps(stepsW1, interPoint, s1) +
              _substractRedundantSteps(stepsW2, interPoint, s2));
        }
      }
      stepsW2 = 0;
    }
    return steps;
  }

  double _substractRedundantSteps(double stepsW, Point interPoint, Segment seg) {
    if (seg.orientation() == Orientation.VERTICAL) {
      return stepsW - (seg.y2 - interPoint.y).abs();
    } else {
      return stepsW - (seg.x2 - interPoint.x).abs();
    }
  }
}
