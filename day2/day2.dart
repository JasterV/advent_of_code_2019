import 'dart:io';
import 'dart:async';
import 'dart:core';

Future main() async {
  File file = File('day2.txt');
  String input = await file.readAsString();
  List<int> code = getCode(input);
  part1(code);
  exit(0);
}

void part1(List<int> code) {
  code[1] = 12;
  code[2] = 2;
  try {
    runCode(0, code);
    print('${code}');
  } on FormatException catch (e) {
    print(e);
  }
}


List<int> getCode(String input) {
  return input.split(',').map((elem) => int.parse(elem)).toList();
}

void runCode(int index, List<int> code) {
  while (index < code.length - 3 && code[index] != 99) {
    try {
      operate(index, code);
    } on FormatException catch (e) {
      throw e;
    }
    index += 4;
  }
}

void operate(int index, List<int> code) {
  int opCode = code[index];
  if (opCode != 1 && opCode != 2)
    throw FormatException("Wrong opcode at index $index");
  else {
    int op1 = code[index + 1];
    int op2 = code[index + 2];
    int res = code[index + 3];
    if (opCode == 1)
      code[res] = code[op1] + code[op2];
    else
      code[res] = code[op1] * code[op2];
  }
}
