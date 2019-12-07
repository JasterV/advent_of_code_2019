import 'dart:io';
import 'dart:async';
import 'dart:core';

Future main() async {
  File file = File('day6.txt');
  List<String> inputData = await file.readAsLines();
  part1(inputData);
  part2(inputData);
}

/* -----------------PART 1----------------- */

void part1(List inputData) {
  Map<String, List<String>> orbits = getOrbitMap(inputData);
  int directOrbits = inputData.length;
  int indirectOrbits = computeIndirectOrbits(orbits);
  int totalOrbits = directOrbits + indirectOrbits;
  print('${totalOrbits}');
}

Map getOrbitMap(data) {
  Map<String, List<String>> orbits = Map();
  for (String item in data) {
    String hasOrbit = item.split(')')[0];
    String isOrbiting = item.split(')')[1];
    (orbits.containsKey(hasOrbit))
        ? orbits[hasOrbit].add(isOrbiting)
        : orbits[hasOrbit] = [isOrbiting];
  }
  return orbits;
}

int computeIndirectOrbits(Map<String, dynamic> orbits) {
  String key = 'COM';
  int distanceToCOM = 0;
  return indirectOrbits(distanceToCOM + 1, key, orbits);
}

int indirectOrbits(int distanceToCOM, String key, Map<String, dynamic> orbits) {
  int counter = 0;
  if (orbits.containsKey(key)) {
    for (String item in orbits[key]) {
      key = item;
      counter +=
          distanceToCOM - 1 + indirectOrbits(distanceToCOM + 1, key, orbits);
    }
  }
  return counter;
}

/* --------------PART 2------------------ */

List<String> locationsVisited = List();
final String start = 'YOU';
final String end = 'SAN';

void part2(List<String> inputData) {
  Map<String, String> orbits = getOrbitMap2(inputData);
  int orbitalTransfers = computeOrbitalTransfers(orbits);
  print('$orbitalTransfers');
}

Map getOrbitMap2(List<String> data){
  Map<String, String> orbits = Map();
  for (String item in data) {
    String hasOrbit = item.split(')')[0];
    String isOrbiting = item.split(')')[1];
    orbits[isOrbiting] = hasOrbit;
  }
  return orbits;
}

List<String> getOrbitPathFromKey(String key, Map<String, String> orbits){
  List<String> path = List();
  while(orbits.containsKey(key)){
    String value = orbits[key];
    path.add(value);
    key = value;
  }
  return path;
}

int computeOrbitalTransfers(Map<String, String> orbits) {
    List<String> youPath = getOrbitPathFromKey(start, orbits);
    List<String> sanPath = getOrbitPathFromKey(end, orbits);
    String youValue = youPath[youPath.length - 1];
    String sanValue = sanPath[sanPath.length - 1];
    while(youValue == sanValue){
      youPath.removeLast();
      sanPath.removeLast();
      youValue = youPath[youPath.length - 1];
      sanValue = sanPath[sanPath.length - 1];
    }
    return youPath.length + sanPath.length;
}