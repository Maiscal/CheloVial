import 'package:flutter_test/flutter_test.dart';

import 'package:chelo_vial/main.dart';

void main() {
  testWidgets('muestra la pantalla de inicio de CheloVial', (tester) async {
    await tester.pumpWidget(const CheloVialApp());
    expect(find.text('¡Hola! Soy Chelo'), findsOneWidget);
  });
}
