import 'dart:async';
import 'dart:core';
import 'dart:io';

final int imageLength = 25 * 6;

Future main() async {
  File file = File('day8.txt');
  String input = await file.readAsString();
  List<int> encodedImage =
      input.split('').map((elem) => int.parse(elem)).toList();
  List<List<int>> layers = getLayersFromEncodedImage(encodedImage);
  part1(layers);
  part2(layers);
}

/*--------------------PART 1--------------------*/
void part1(List<List<int>> layers) {
  List<int> min0Layer = layers.reduce(min0);
  int result = computeResult(min0Layer);
  print("Fewess 0 layer computation: \n");
  print("$result\n");
}

List<List<int>> getLayersFromEncodedImage(List<int> encodedImage) {
  List<List<int>> layers = List();
  while (encodedImage.isNotEmpty) {
    layers.add(encodedImage.sublist(0, imageLength));
    encodedImage.removeRange(0, imageLength);
  }
  return layers;
}

int computeResult(List<int> layer) {
  Map<int, int> map = Map();
  layer.forEach((elem) {
    if (map.containsKey(elem)) {
      map[elem] += 1;
    } else {
      map[elem] = 1;
    }
  });

  return map[1] * map[2];
}

List<int> min0(List<int> fst, List<int> snd) {
  int num0Fst = fst.where((elem) => elem == 0).length;
  int num0snd = snd.where((elem) => elem == 0).length;
  return (num0Fst < num0snd) ? fst : snd;
}

/*--------------PART 2------------------*/

void part2(List<List<int>> layers) {
  List<int> decodedImage = decodeImage(layers);
  printImage(decodedImage);
}

List<int> decodeImage(List<List<int>> layers) {
  List<int> decodedImage = List();
  for (int i = 0; i < imageLength; ++i) {
    for (List<int> layer in layers) {
      if (layer[i] != 2) {
        decodedImage.add(layer[i]);
        break;
      }
    }
  }
  return decodedImage;
}

void printImage(List<int> decodedImage) {
  print("Decoded Message: \n");
  for (int i = 0; i < 6; ++i) {
    print(decodedImage.getRange(i * 25, i * 25 + 25).toString());
  }
}
