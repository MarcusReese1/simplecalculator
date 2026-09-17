import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simplecalculator/main.dart';

Future<void> enterCalculation(WidgetTester tester, List<String> keys) async {
  for (final key in keys) {
    await tester.tap(find.text(key));
  }
  await tester.pump();
}

String displayText(WidgetTester tester) {
  return tester.widget<Text>(find.byKey(const Key('display'))).data!;
}

void main() {
  testWidgets('adds two numbers', (tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await enterCalculation(tester, ['2', '+', '3', '=']);

    expect(displayText(tester), '5');
  });

  testWidgets('subtracts two numbers', (tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await enterCalculation(tester, ['8', '−', '3', '=']);

    expect(displayText(tester), '5');
  });

  testWidgets('multiplies two numbers', (tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await enterCalculation(tester, ['6', '×', '7', '=']);

    expect(displayText(tester), '42');
  });

  testWidgets('divides two numbers', (tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await enterCalculation(tester, ['8', '÷', '2', '=']);

    expect(displayText(tester), '4');
  });

  testWidgets('clears the entered value', (tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await enterCalculation(tester, ['9', 'AC']);

    expect(displayText(tester), '0');
  });
}
