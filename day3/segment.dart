
import 'dart:math';

class Segment {
  double x1;
  double y1;
  double x2;
  double y2;

  Segment(this.x1, this.y1, this.x2, this.y2);

  static Point intersection(Segment s1, Segment s2) {
    if (s1.x1 == s1.x2 && s2.y1 == s2.y2) {
      if ((s1.x1 >= min(s2.x1, s2.x2) && s1.x1 <= max(s2.x1, s2.x2)) &&
          (s2.y1 >= min(s1.y1, s1.y2) && s2.y1 <= max(s1.y1, s1.y2))) {
        if (s1.x1 != 0 && s2.y1 != 0) {
          return Point(s1.x1, s2.y1);
        }
      }
    } else if (s1.y1 == s1.y2 && s2.x1 == s2.x2) {
      if ((s2.x1 >= min(s1.x1, s1.x2) && s2.x1 <= max(s1.x1, s1.x2)) &&
          (s1.y1 >= min(s2.y1, s2.y2) && s1.y1 <= max(s2.y1, s2.y2))) {
        if (s2.x1 != 0 && s1.y1 != 0) {
          return Point(s2.x1, s1.y1);
        }
      }
    }
    return null;
  }

  static List<Point> intersections(List<Segment> l1, List<Segment> l2) {
    List<Point> points = List();
    for (Segment s1 in l1) {
      for (Segment s2 in l2) {
        Point res = intersection(s1, s2);
        if (res != null) {
          points.add(res);
        }
      }
    }
    return points;
  }


  static List<double> stepsForIntersections(
      List<Segment> l1, List<Segment> l2) {
    List<double> steps = List();
    double stepsW1 = 0;
    double stepsW2 = 0;
    for (Segment s1 in l1) {
      stepsW1 += _stepsXSegment(s1);
      for (Segment s2 in l2) {
        stepsW2 += _stepsXSegment(s2);
        Point interPoint = intersection(s1, s2);
        if (interPoint != null) {
          steps.add(calculateFinalSteps(stepsW1, interPoint, s1) +
              calculateFinalSteps(stepsW2, interPoint, s2));
        }
      }
      stepsW2 = 0;
    }
    return steps;
  }

  static double _stepsXSegment(Segment seg) {
    if (seg.x1 == seg.x2) {
      return (seg.y1 - seg.y2).abs();
    } else {
      return (seg.x1 - seg.x2).abs();
    }
  }

  static double calculateFinalSteps(
      double stepsW, Point interPoint, Segment seg) {
    if (seg.x1 == seg.x2) {
      return stepsW - (seg.y2 - interPoint.y).abs();
    } else if (seg.y1 == seg.y2) {
      return stepsW - (seg.x2 - interPoint.x).abs();
    }
  }

  @override
  String toString() {
    return '[(x1: $x1, y1: $y1), (x2: $x2, y2: $y2)]';
  }
}
