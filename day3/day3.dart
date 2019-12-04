import 'dart:io';
import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'segment.dart';

Future main() async {
  File file = File('day3.txt');
  List<String> input = await file.readAsLines();
  // get the operations
  List<String> fstWire = input[0].split(',');
  List<String> sndWire = input[1].split(',');
  // interpret the operations and build a segment list
  List<Segment> fstWireSeg = segFromPoints(readOp(fstWire));
  List<Segment> sndWireSeg = segFromPoints(readOp(sndWire));
  // Count all the steps
  part1(fstWireSeg, sndWireSeg);
  part2(fstWireSeg, sndWireSeg);
}

double manhattanDistance(Point p1, Point p2) {
  return (p1.x - p2.x).abs() + (p1.y - p2.y).abs();
}

void part1(List<Segment> fstWire, List<Segment> sndWire) {
  List<Point> intersections = Segment.intersections(fstWire, sndWire);
  // Calculate the minDistance
  double minDistance = double.infinity;
  for (Point p in intersections) {
    double distance = manhattanDistance(Point(0, 0), p);
    if (distance < minDistance) {
      minDistance = distance;
    }
  }
  print(minDistance.toInt());
}

void part2(List<Segment> fstWire, List<Segment> sndWire) {
  List<double> steps = Segment.stepsForIntersections(fstWire, sndWire);
  double minSteps = double.infinity;
  for (double combStep in steps) {
    if (combStep < minSteps) {
      minSteps = combStep;
    }
  }
  print(minSteps.toInt());
}

List<Point> readOp(List<String> data) {
  List<Point> points = List();
  double x = 0;
  double y = 0;
  points.add(Point(0.0, 0.0));
  for (String elem in data) {
    if (elem.startsWith('L')) {
      x -= double.parse(elem.substring(1));
    } else if (elem.startsWith('R')) {
      x += double.parse(elem.substring(1));
    } else if (elem.startsWith('U')) {
      y += double.parse(elem.substring(1));
    } else if (elem.startsWith('D')) {
      y -= double.parse(elem.substring(1));
    }
    points.add(Point(x, y));
  }
  return points;
}

List<Segment> segFromPoints(List<Point> points) {
  List<Segment> segments = List();
  for (int i = 0; i < points.length - 1; i++) {
    Point p1 = points[i];
    Point p2 = points[i + 1];
    segments.add(Segment(p1.x, p1.y, p2.x, p2.y));
  }
  return segments;
}


