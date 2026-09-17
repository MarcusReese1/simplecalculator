import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simplecalculator/main.dart';

void main() {
  testWidgets('calculates a basic addition', (tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tester.tap(find.text('2'));
    await tester.tap(find.text('+'));
    await tester.tap(find.text('3'));
    await tester.tap(find.text('='));
    await tester.pump();

    expect(find.byKey(const Key('display')), findsOneWidget);
    expect(tester.widget<Text>(find.byKey(const Key('display'))).data, '5');
  });
}
