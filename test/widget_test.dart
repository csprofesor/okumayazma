import 'package:flutter_test/flutter_test.dart';
import 'package:okumayazma/main.dart';

void main() {
  testWidgets('Minik Okur smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MinikOkur());
    expect(find.text('Minik Okur'), findsWidgets);
    expect(find.text('Ana Sayfa'), findsOneWidget);
    expect(find.text('Oyunlar'), findsOneWidget);
    expect(find.text('Yazı'), findsOneWidget);
    expect(find.text('Veli'), findsOneWidget);
  });
}
