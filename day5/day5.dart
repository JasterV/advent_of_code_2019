import 'dart:io';
import 'dart:async';
import 'dart:core';
import 'operations_mixin.dart';

Future main() async {
  File file = File('day5.txt');
  String input = await file.readAsString();
  List<int> program = input.split(',').map((elem) => int.parse(elem)).toList();
  try {
    runCode(program);
  } on FormatException catch (e) {
    print(e.message);
  }
}

void runCode(List<int> program) {
  bool halt = false;
  int index = 0;
  print("Enter the ID of the system: ");
  int id = int.parse(stdin.readLineSync());

  while (!halt) {
    int op = program[index] % 100;
    if (isValidOperation(op)) {
      int parameterModes = (program[index] / 100).floor();
      switch (op) {
        case ADD:
          {
            add(index, parameterModes, program);
            index += 4;
          }
          break;
        case MULT:
          {
            mult(index, parameterModes, program);
            index += 4;
          }
          break;
        case READ:
          {
            read(index, id, program);
            index += 2;
          }
          break;
        case SHOW:
          {
            show(index, parameterModes, program);
            index += 2;
          }
          break;
        default:
          halt = true;
      }
    } else {
      throw FormatException("Invalid operation");
    }
  }
}

bool isValidOperation(int op) {
  if (operations.contains(op)) {
    return true;
  }
  return false;
}

int parameterValue(List<int> program, {int parameterIndex, int mode}) {
  if (mode == POSITION) {
    return program[program[parameterIndex]];
  } else {
    return program[parameterIndex];
  }
}

void add(int index, int parameterModes, List<int> program) {
  int storeAddress = program[index + 3];

  program[storeAddress] = parameterValue(
        program,
        parameterIndex: index + 1,
        mode: parameterModes % 10,
      ) +
      parameterValue(
        program,
        parameterIndex: index + 2,
        mode: (parameterModes / 10).floor(),
      );
}

void mult(int index, int parameterModes, List<int> program) {
  int storeAddress = program[index + 3];

  program[storeAddress] = parameterValue(
        program,
        parameterIndex: index + 1,
        mode: parameterModes % 10,
      ) *
      parameterValue(
        program,
        parameterIndex: index + 2,
        mode: (parameterModes / 10).floor(),
      );
}

void read(int index, int input, List<int> program) {
  int storeAddress = program[index + 1];
  program[storeAddress] = input;
}

void show(int index, int mode, List<int> program) {
  int result = 0;
  if (mode == POSITION) {
    result = program[program[index + 1]];
  } else {
    result = program[index + 1];
  }
  if(program[index + 2] == HALT){
    print("-------------------------");
    print("Diagnostic code: $result");
    print("-------------------------");
  }else{
    print("-------------------------");
    print("Test result: $result");
  }
}
