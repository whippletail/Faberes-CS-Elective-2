import 'package:flutter_test/flutter_test.dart';
import 'package:skimwave_shop/app.dart';
void main() {
  testWidgets('home displays products and opens details', (tester) async {
    await tester.pumpWidget(const SkimWaveApp());
    await tester.pumpAndSettle();
    expect(find.text('HOT BOARDS'), findsOneWidget);
    expect(find.text('Reef Glider'), findsOneWidget);
    await tester.tap(find.text('Reef Glider'));
    await tester.pumpAndSettle();
    expect(find.text('BOARD DETAILS'), findsOneWidget);
    expect(find.text('ADD TO CART'), findsOneWidget);
  });
}
