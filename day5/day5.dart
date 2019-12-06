import 'dart:io';
import 'dart:async';
import 'dart:core';
import 'operations_mixin.dart';

Future main() async {
  try {
    File file = File('day5.txt');
    String input = await file.readAsString();
    List<int> program =
        input.split(',').map((elem) => int.parse(elem)).toList();
    print("Enter the ID of the system: ");
    int id = int.parse(stdin.readLineSync());
    runCode(id, program);
  } on FormatException catch (e) {
    print(e.message);
  } on IOException {
    print("Error reading/writing");
  }
}

void runCode(int id, List<int> program) {
  bool halt = false;
  int index = 0;
  while (!halt) {
    int op = program[index] % 100;
    if (isValidOperation(op)) {
      int parameterModes = (program[index] / 100).floor();
      int fstMode = parameterModes % 10;
      int sndMode = (parameterModes / 10).floor();
      switch (op) {
        case ADD:
          {
            add(index, fstMode, sndMode, program);
            index += 4;
          }
          break;
        case MULT:
          {
            mult(index, fstMode, sndMode, program);
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
            show(index, fstMode, program);
            index += 2;
          }
          break;
        case JUMP_IF_TRUE:
          {
            index = jumpIfTrue(index, fstMode, sndMode, program);
          }
          break;
        case JUMP_IF_FALSE:
          {
            index = jumpIfFalse(index, fstMode, sndMode, program);
          }
          break;
        case LESS_THAN:
          {
            lessThan(index, fstMode, sndMode, program);
            index += 4;
          }
          break;
        case EQUAL_TO:
          {
            equalTo(index, fstMode, sndMode, program);
            index += 4;
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
  return operations.contains(op);
}

int parameterValue(List<int> program, {int parameterIndex, int mode}) {
  if (mode == POSITION)
    return program[program[parameterIndex]];
  else
    return program[parameterIndex];
}

void add(int index, int fstMode, int sndMode, List<int> program) {
  int storeAddress = program[index + 3];
  program[storeAddress] = parameterValue(
        program,
        parameterIndex: index + 1,
        mode: fstMode,
      ) +
      parameterValue(
        program,
        parameterIndex: index + 2,
        mode: sndMode,
      );
}

void mult(int index, int fstMode, int sndMode, List<int> program) {
  int storeAddress = program[index + 3];
  program[storeAddress] = parameterValue(
        program,
        parameterIndex: index + 1,
        mode: fstMode,
      ) *
      parameterValue(
        program,
        parameterIndex: index + 2,
        mode: sndMode,
      );
}

void read(int index, int input, List<int> program) {
  int storeAddress = program[index + 1];
  program[storeAddress] = input;
}

void show(int index, int mode, List<int> program) {
  int result = parameterValue(program, parameterIndex: index + 1, mode: mode);
  if (program[index + 2] == HALT) {
    print("-------------------------");
    print("Diagnostic code: $result");
    print("-------------------------");
  } else {
    print("-------------------------");
    print("Test result: $result");
  }
}

int jumpIfTrue(index, fstMode, sndMode, program) {
  int fstParameter =
      parameterValue(program, parameterIndex: index + 1, mode: fstMode);
  int sndParameter =
      parameterValue(program, parameterIndex: index + 2, mode: sndMode);
  if (fstParameter != 0)
    return sndParameter;
  else
    return index + 3;
}

int jumpIfFalse(index, fstMode, sndMode, program) {
  int fstParameter =
      parameterValue(program, parameterIndex: index + 1, mode: fstMode);
  int sndParameter =
      parameterValue(program, parameterIndex: index + 2, mode: sndMode);
  if (fstParameter == 0)
    return sndParameter;
  else
    return index + 3;
}

void lessThan(index, fstMode, sndMode, program) {
  int fstParameter =
      parameterValue(program, parameterIndex: index + 1, mode: fstMode);
  int sndParameter =
      parameterValue(program, parameterIndex: index + 2, mode: sndMode);
  if (fstParameter < sndParameter)
    program[program[index + 3]] = 1;
  else
    program[program[index + 3]] = 0;
}

void equalTo(index, fstMode, sndMode, program) {
  int fstParameter =
      parameterValue(program, parameterIndex: index + 1, mode: fstMode);
  int sndParameter =
      parameterValue(program, parameterIndex: index + 2, mode: sndMode);
  if (fstParameter == sndParameter)
    program[program[index + 3]] = 1;
  else
    program[program[index + 3]] = 0;
}
