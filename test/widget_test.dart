import 'package:flutter_test/flutter_test.dart';

import 'package:helpdesk_lite/main.dart';

void main() {
  testWidgets('renderiza o dashboard inicial com a nova navegacao', (
    tester,
  ) async {
    await tester.pumpWidget(const HelpDeskLiteApp());
    await tester.pumpAndSettle();

    expect(find.text('HelpDesk Lite'), findsOneWidget);
    expect(find.text('Central de chamados'), findsOneWidget);
    expect(find.text('Novo chamado'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Chamados'), findsOneWidget);
    expect(find.text('Novo'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
  });
}
