import 'package:flutter_test/flutter_test.dart';
import 'package:okumayazma/main.dart';

void main() {
  test('official curriculum contains five sound groups and 29 letters', () {
    expect(officialSoundGroups.length, 5);
    expect(officialSoundGroups.expand((g) => g).length, 29);
    expect(officialSoundGroups.first, ['a', 'n', 'e', 't', 'i', 'l']);
    expect(officialSoundGroups.last, ['p', 'h', 'v', 'ğ', 'f', 'j']);
  });

  test('four learning stages follow the theme progression', () {
    expect(groups.length, 4);
    expect(groups[0], ['a', 'n', 'e', 't']);
    expect(groups[1], ['i', 'l', 'o', 'k', 'u']);
    expect(groups[2], ['r', 'ı', 'm', 'ü', 's', 'ö', 'y', 'd', 'z']);
    expect(groups[3], ['ç', 'b', 'g', 'c', 'ş', 'p', 'h', 'v', 'ğ', 'f', 'j']);
    expect(groups.expand((g) => g).toSet().length, 29);
  });

  test('Turkish uppercase letters are rendered correctly', () {
    expect(upperLetter('i'), 'İ');
    expect(upperLetter('ı'), 'I');
    expect(upperLetter('ş'), 'Ş');
    expect(upperLetter('ğ'), 'Ğ');
  });

  test('each stage has syllable and word practice', () {
    expect(syllables.length, 4);
    expect(words.length, 4);
    expect(sentences.length, 4);
    for (var i = 0; i < groups.length; i++) {
      expect(syllables[i], isNotEmpty);
      expect(words[i], isNotEmpty);
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
          reason: 'Stage ${i + 1} contains not-yet-taught letters: $item',
        );
      }
    }
  });
  test('letter example cards do not reveal future letters', () {
    for (var i = 0; i < groups.length; i++) {
      final learned = groups.take(i + 1).expand((g) => g).toSet();
      for (final letter in groups[i]) {
        for (final example in examples[letter] ?? const <String>[]) {
          final normalized = example.toLowerCase().replaceAll(
            RegExp(r'[^a-zçğıöşü]'),
            '',
          );
          expect(
            normalized.split('').every(learned.contains),
            isTrue,
            reason: 'Stage ${i + 1}, letter $letter: $example',
          );
        }
      }
    }
  });

  test('reading passages are original and use the full taught alphabet', () {
    expect(readingPassages.length, 3);
    final learned = officialSoundGroups.expand((g) => g).toSet();
    for (final passage in readingPassages) {
      final text = '${passage.title} ${passage.body} ${passage.question} ${passage.options.join(' ')}';
      final normalized = text.toLowerCase().replaceAll(
        RegExp(r'[^a-zçğıöşü]'),
        '',
      );
      expect(normalized.split('').every(learned.contains), isTrue);
      expect(passage.answer, inInclusiveRange(0, passage.options.length - 1));
    }
  });

}
