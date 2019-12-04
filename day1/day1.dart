import 'dart:core';
import 'dart:io';

Future main() async {
  File file = File('day1.txt');
  List<String> contents = await file.readAsLines();
  part1(contents);
  part2(contents);
  exit(0);
}

void part1(List<String> contents){
  List<int> fuelReq;
  int sum;
  fuelReq = contents.map((elem) => (int.parse(elem)/3).floor() - 2).toList();
  sum = fuelReq.reduce((current, next) => current + next);
  print(sum);
}

void part2(List<String> contents){
  List<int> fuelReq;
  int sum;
  fuelReq = contents.map((elem) => calculateFuelReq(int.parse(elem))).toList();
  sum = fuelReq.reduce((current, next) => current + next);
  print(sum);
}

int calculateFuelReq(int value) {
  int initialFuel = (value / 3).floor() - 2;
  return calculateFuel(initialFuel);
}

int calculateFuel(int fuel) {
  if (fuel <= 0) {
    return 0;
  } else {
    return fuel + calculateFuel((fuel/3).floor() - 2);
  }
}
