import 'package:trotter/trotter.dart';
import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import '../day5/operations_mixin.dart';
import 'dart:isolate';

Future main() async {
  File file = File('day7.txt');
  String input = await file.readAsString();
  List<int> program = input.split(',').map((item) => int.parse(item)).toList();
  part2(program);
}

/*---------------PART 2---------------------*/
List<int> inputs = List();
Machine machine = Machine();
List<int> amplisIndex;
List<List<int>> ampliPrograms = List();

void part2(List<int> program) {
  var perms = Permutations(5, [5, 6, 7, 8, 9]);
  List phases = List.from(perms.iterable);
  List<int> signals = runAllPhasePermutations(program, phases);
  int maxSignal = signals.reduce(max);
  print(maxSignal);
}

List<int> runAllPhasePermutations(List<int> program, List permutations) {
  List<int> signals = List();
  for (var phaseSettings in permutations) {
    int signalValue = runAmplifiers(phaseSettings, program);
    signals.add(signalValue);
  }
  return signals;
}

int runAmplifiers(List phaseSettings, List<int> program) {
  int lastOutputSignal = 0;
  int currentOutputSignal = 0;
  initializeAmplifiers(phaseSettings, program);
  lastOutputSignal = startAmplifierSoftware(phaseSettings);
  int ampli = 0;
  while (true) {
    currentOutputSignal = runAmplifier(lastOutputSignal, ampli);
    if (currentOutputSignal == -1) return lastOutputSignal;
    ampli = (ampli + 1) % 5;
    lastOutputSignal = currentOutputSignal;
  }
}

void initializeAmplifiers(List<dynamic> phaseSettings, List<int> program) {
  for (int i = 0; i < phaseSettings.length; ++i) {
    ampliPrograms.add(List.from(program));
  }
  amplisIndex = [0, 0, 0, 0, 0];
}

int startAmplifierSoftware(List phaseSettings) {
  int outputSignal = 0;
  for (int i = 0; i < phaseSettings.length; ++i) {
    outputSignal = runAmplifier(outputSignal, i, phase: phaseSettings[i]);
  }
  return outputSignal;
}

int runAmplifier(int input, int ampli, {int phase}) {
  inputs.add(input);
  if (phase != null) inputs.add(phase);
  return machine.runCode(ampli);
}

class Machine {
  int runCode(int ampli) {
    List<int> program = ampliPrograms[ampli];
    while (true) {
      int op = program[amplisIndex[ampli]] % 100;
      if (_isValidOperation(op)) {
        int parameterModes = (program[amplisIndex[ampli]] / 100).floor();
        int fstMode = parameterModes % 10;
        int sndMode = (parameterModes / 10).floor();
        switch (op) {
          case ADD:
            {
              _add(amplisIndex[ampli], fstMode, sndMode, program);
              amplisIndex[ampli] += 4;
            }
            break;
          case MULT:
            {
              _mult(amplisIndex[ampli], fstMode, sndMode, program);
              amplisIndex[ampli] += 4;
            }
            break;
          case READ:
            {
              int input = inputs.removeLast();
              _read(amplisIndex[ampli], input, program);
              if (inputs.isEmpty) {
                inputs.add(input);
              }
              amplisIndex[ampli] += 2;
            }
            break;
          case SHOW:
            {
              if (!inputs.isEmpty) {
                inputs.removeLast();
              }
              int value = _show(amplisIndex[ampli], fstMode, program);
              amplisIndex[ampli] += 2;
              return value;
            }
            break;
          case JUMP_IF_TRUE:
            {
              amplisIndex[ampli] =
                  _jumpIfTrue(amplisIndex[ampli], fstMode, sndMode, program);
            }
            break;
          case JUMP_IF_FALSE:
            {
              amplisIndex[ampli] =
                  _jumpIfFalse(amplisIndex[ampli], fstMode, sndMode, program);
            }
            break;
          case LESS_THAN:
            {
              _lessThan(amplisIndex[ampli], fstMode, sndMode, program);
              amplisIndex[ampli] += 4;
            }
            break;
          case EQUAL_TO:
            {
              _equalTo(amplisIndex[ampli], fstMode, sndMode, program);
              amplisIndex[ampli] += 4;
            }
            break;
          default:
            return -1;
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
    int storeAddress = program[index + 3];
    program[storeAddress] = _parameterValue(
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
    int storeAddress = program[index + 3];
    program[storeAddress] = _parameterValue(
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
    int storeAddress = program[index + 1];
    program[storeAddress] = input;
  }

  int _show(int index, int mode, List<int> program) =>
      _parameterValue(program, parameterIndex: index + 1, mode: mode);

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
