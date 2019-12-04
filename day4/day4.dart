import 'dart:core';

void main() {
  int lowBound = 193651;
  int upBound = 649729;
  int counterPart1 = 0;
  int counterPart2 = 0;
  for (int i = lowBound; i < upBound; i++) {
    if (isValidPart1(i)) {
      counterPart1++;
    }
    if(isValidPart2(i)){
      counterPart2++;
    }
  }
  print(counterPart1);
  print(counterPart2);
}

bool isValidPart1(int n){
  String number = n.toString();
  bool adjacent = false;
  for (int i = 0; i < number.length - 1; ++i) {
    if (number.codeUnitAt(i) > number.codeUnitAt(i + 1)) {
      return false;
    }
    if(number.codeUnitAt(i) == number.codeUnitAt(i+1)){
      adjacent = true;
    }
  }
  return adjacent;
}

bool isValidPart2(int n) {
  String number = n.toString();
  for (int i = 0; i < number.length - 1; ++i) {
    if (number.codeUnitAt(i) > number.codeUnitAt(i + 1)) {
      return false;
    }
  }
  for(int i = 0; i < 10; ++i){
    int matches = i.toString().allMatches(number).length;
      if(matches == 2){
        return true;
      }
  }
  return false;
}
