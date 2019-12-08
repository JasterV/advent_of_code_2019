import 'package:trotter/trotter.dart';
import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import '../day5/operations_mixin.dart';

Future main() async {
  File file = File('day7.txt');
  String input = await file.readAsString();
  List<int> program = input.split(',').map((item) => int.parse(item)).toList();
  part1(program);
}

/*---------------PART 1---------------------*/
List<int> inputs = List();
Machine machine = Machine();

void part1(List<int> program) {
  var perms = Permutations(5, [0, 1, 2, 3, 4]);
  List<dynamic> phases = List.from(perms.iterable);
  List<int> signals = runAllPhasePermutations(program, phases);
  int maxSignal = signals.reduce(max);
  print(maxSignal);
}

List<int> runAllPhasePermutations(
    List<int> program, List<dynamic> permutations) {
  List<int> signals = List();
  for (var phaseSettings in permutations) {
    int signalValue = runAmplifiers(phaseSettings, program);
    signals.add(signalValue);
  }
  return signals;
}

int runAmplifiers(List<dynamic> phaseSettings, List<int> program) {
  int outputSignal = 0;
  for (int phase in phaseSettings) {
    outputSignal = runAmplifier(outputSignal, phase, program);
  }
  return outputSignal;
}

int runAmplifier(int input, int phase, List<int> program) {
  List<int> programCopy = List.from(program);
  inputs.add(input);
  inputs.add(phase);
  return machine.runCode(programCopy, inputs);
}

class Machine {
  int runCode(List<int> program, List<int> inputs) {
    int result = 0;
    bool halt = false;
    int index = 0;
    while (true) {
      int op = program[index] % 100;
      if (_isValidOperation(op)) {
        int parameterModes = (program[index] / 100).floor();
        int fstMode = parameterModes % 10;
        int sndMode = (parameterModes / 10).floor();
        switch (op) {
          case ADD:
            {
              _add(index, fstMode, sndMode, program);
              index += 4;
            }
            break;
          case MULT:
            {
              _mult(index, fstMode, sndMode, program);
              index += 4;
            }
            break;
          case READ:
            {
              int input = inputs.last;
              _read(index, input, program);
              inputs.removeLast();
              index += 2;
            }
            break;
          case SHOW:
            {
              result = _show(index, fstMode, program);
              index += 2;
            }
            break;
          case JUMP_IF_TRUE:
            {
              index = _jumpIfTrue(index, fstMode, sndMode, program);
            }
            break;
          case JUMP_IF_FALSE:
            {
              index = _jumpIfFalse(index, fstMode, sndMode, program);
            }
            break;
          case LESS_THAN:
            {
              _lessThan(index, fstMode, sndMode, program);
              index += 4;
            }
            break;
          case EQUAL_TO:
            {
              _equalTo(index, fstMode, sndMode, program);
              index += 4;
            }
            break;
          default:
            return result;
        }
      } else {
        throw FormatException("Invalid operation");
      }
    }
  }

  bool _isValidOperation(int op) {
    return operations.contains(op);
  }

  int _parameterValue(List<int> program, {int parameterIndex, int mode}) {
    if (mode == POSITION)
      return program[program[parameterIndex]];
    else
      return program[parameterIndex];
  }

  void _add(int index, int fstMode, int sndMode, List<int> program) {
    int sto_reAddress = program[index + 3];
    program[sto_reAddress] = _parameterValue(
          program,
          parameterIndex: index + 1,
          mode: fstMode,
        ) +
        _parameterValue(
          program,
          parameterIndex: index + 2,
          mode: sndMode,
        );
  }

  void _mult(int index, int fstMode, int sndMode, List<int> program) {
    int sto_reAddress = program[index + 3];
    program[sto_reAddress] = _parameterValue(
          program,
          parameterIndex: index + 1,
          mode: fstMode,
        ) *
        _parameterValue(
          program,
          parameterIndex: index + 2,
          mode: sndMode,
        );
  }

  void _read(int index, int input, List<int> program) {
    int sto_reAddress = program[index + 1];
    program[sto_reAddress] = input;
  }

  int _show(int index, int mode, List<int> program) {
    int result =
        _parameterValue(program, parameterIndex: index + 1, mode: mode);
    return result;
  }

  int _jumpIfTrue(index, fstMode, sndMode, program) {
    int fstParameter =
        _parameterValue(program, parameterIndex: index + 1, mode: fstMode);
    int sndParameter =
        _parameterValue(program, parameterIndex: index + 2, mode: sndMode);
    if (fstParameter != 0)
      return sndParameter;
    else
      return index + 3;
  }

  int _jumpIfFalse(index, fstMode, sndMode, program) {
    int fstParameter =
        _parameterValue(program, parameterIndex: index + 1, mode: fstMode);
    int sndParameter =
        _parameterValue(program, parameterIndex: index + 2, mode: sndMode);
    if (fstParameter == 0)
      return sndParameter;
    else
      return index + 3;
  }

  void _lessThan(index, fstMode, sndMode, program) {
    int fstParameter =
        _parameterValue(program, parameterIndex: index + 1, mode: fstMode);
    int sndParameter =
        _parameterValue(program, parameterIndex: index + 2, mode: sndMode);
    if (fstParameter < sndParameter)
      program[program[index + 3]] = 1;
    else
      program[program[index + 3]] = 0;
  }

  void _equalTo(index, fstMode, sndMode, program) {
    int fstParameter =
        _parameterValue(program, parameterIndex: index + 1, mode: fstMode);
    int sndParameter =
        _parameterValue(program, parameterIndex: index + 2, mode: sndMode);
    if (fstParameter == sndParameter)
      program[program[index + 3]] = 1;
    else
      program[program[index + 3]] = 0;
  }
}
