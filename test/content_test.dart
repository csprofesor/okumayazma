import 'package:flutter_test/flutter_test.dart';
import 'package:okumayazma/main.dart';

void main() {
  test('curriculum has five ordered sound groups and 29 letters', () {
    expect(groups.length, 5);
    expect(groups.expand((g) => g).length, 29);
    expect(groups.first, ['a', 'n', 'e', 't', 'i', 'l']);
    expect(groups.last, ['p', 'h', 'v', 'ğ', 'f', 'j']);
  });

  test('every group has syllable, word and sentence practice', () {
    expect(syllables.length, 5);
    expect(words.length, 5);
    expect(sentences.length, 5);
    for (var i = 0; i < groups.length; i++) {
      expect(syllables[i], isNotEmpty);
      expect(words[i], isNotEmpty);
      expect(sentences[i], isNotEmpty);
    }
  });

  test('practice vocabulary uses only introduced letters', () {
    for (var i = 0; i < groups.length; i++) {
      final learned = groups.take(i + 1).expand((g) => g).toSet();
      final items = [...syllables[i], ...words[i], sentences[i]];
      for (final item in items) {
        final normalized = item.toLowerCase().replaceAll(
          RegExp(r'[^a-zçğıöşü]'),
          '',
        );
        expect(
          normalized.split('').every(learned.contains),
          isTrue,
          reason: 'Group ${i + 1} contains not-yet-taught letters: $item',
        );
      }
    }
  });
}
