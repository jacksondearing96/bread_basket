import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/providers/exerciseProvider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('Not working', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: Text('hello, world',
                style: TextStyle(
                    color: Colors.green, backgroundColor: Colors.red)))));

    await expectLater(find.byType(Material),
        matchesGoldenFile('destination.png'));
  });
}
