import 'package:flutter_test/flutter_test.dart';
import 'package:okumayazma/main.dart';

void main() {
  test('curriculum has five ordered sound groups and 29 letters', () {
    expect(groups.length, 5);
    expect(groups.expand((g) => g).length, 29);
    expect(groups.first, ['a', 'n', 'e', 't', 'i', 'l']);
    expect(groups.last, ['p', 'h', 'v', 'ğ', 'f', 'j']);
  });

  test('each group has syllables and a sentence exercise', () {
    expect(syllables.length, 5);
    expect(sentences.length, 5);
    expect(syllables.every((items) => items.isNotEmpty), isTrue);
  });
}
