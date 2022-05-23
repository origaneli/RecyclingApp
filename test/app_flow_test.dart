import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recycling/data/data_config_values.dart';
import 'package:recycling/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets("App flow test", (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      "flutter.${SharedPreferenceKeys.selectedDistrict.name}": "",
    });

    app.main();
    await tester.pumpAndSettle();

    expect(find.text("error occurred"), findsNothing);
    expect(find.text("Ein Fehler"), findsNothing);
    expect(find.text("No Data"), findsNothing);
    expect(find.text("Keine Daten"), findsNothing);

    // Go to home screen
    {
      Finder distSel = find.byType(InkWell);
      expect(distSel, findsWidgets);

      await tester.tap(distSel);
      await tester.pumpAndSettle();

      expect(find.text("Recycling App"), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    }

    // Go to data details
    {
      Finder recDataSel = find.byType(InkWell);
      expect(recDataSel, findsWidgets);

      await tester.tap(recDataSel.first);
      await tester.pumpAndSettle();
    }

    // Go to linked district data details
    {
      Finder infoBtn = find.byIcon(Icons.info_outlined);
      expect(infoBtn, findsOneWidget);

      await tester.tap(infoBtn);
      await tester.pumpAndSettle();

      Finder table = find.byType(Table);
      expect(table, findsOneWidget);
    }

    // Go back to home screen
    {
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
    }

    // Go to district overview
    {
      Finder distNav = find.byIcon(Icons.location_city);
      expect(distNav, findsOneWidget);

      await tester.tap(distNav);
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNothing);
    }

    // Go to district details
    {
      Finder distSel = find.byType(InkWell);
      expect(distSel, findsWidgets);

      await tester.tap(distSel.first);
      await tester.pumpAndSettle();

      Finder table = find.byType(Table);
      if (findsNothing.matches(table, {})) {
        // Found district entry; try to find data entry next
        await tester.pageBack();
        await tester.pumpAndSettle();

        await tester.tap(distSel.at(1));
        await tester.pumpAndSettle();

        Finder table2 = find.byType(Table);
        expect(table2, findsOneWidget);
      }
    }

    // Go back to home screen
    {
      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.text("Recycling App"), findsOneWidget);
    }
  });
}