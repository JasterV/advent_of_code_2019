import 'dart:async';
import 'dart:core';
import 'dart:io';

final int imageLength = 25 * 6;
final int imageWeight = 25;
final int imageHeight = 6;

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
    if (map.containsKey(elem))
      map[elem] += 1;
    else
      map[elem] = 1;
  });
  return map[1] * map[2];
}

List<int> min0(List<int> fst, List<int> snd) {
  int num0Fst = 0, num0snd = 0;
  fst.forEach((elem) {
    if (elem == 0) num0Fst += 1;
  });
  snd.forEach((elem) {
    if (elem == 0) num0snd += 1;
  });
  return (num0Fst < num0snd) ? fst : snd;
}

/*--------------PART 2------------------*/

void part2(List<List<int>> layers) => printImage(decodeImage(layers));

List<int> decodeImage(List<List<int>> layers) {
  List<int> decodedImage = List();
  for (var i = 0; i < imageLength; ++i)
    for (var layer in layers)
      if (layer[i] != 2) {
        decodedImage.add(layer[i]);
        break;
      }
  return decodedImage;
}

void printImage(List<int> decodedImage) {
  print("Decoded Message: \n");
  for (var i = 0; i < imageHeight; i++) {
    for (var j = imageWeight * i; j < imageWeight * (i + 1); ++j)
      (decodedImage[j] == 0) ? stdout.write(' ') : stdout.write(1);
    stdout.write('\n');
  }
}