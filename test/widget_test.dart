import 'package:flutter_test/flutter_test.dart';

import 'package:controle_ace/core/app_info.dart';
import 'package:controle_ace/main.dart';

void main() {
  testWidgets('mostra plataforma logistica', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ControleACEApp(carregarDashboard: false, mostrarLogin: false),
    );

    expect(find.text(AppInfo.nome), findsWidgets);
    expect(find.text('Painel'), findsOneWidget);
    expect(find.text('Viagens'), findsWidgets);
    expect(find.text('Pacientes'), findsWidgets);
    expect(find.text('Rastreio'), findsOneWidget);
  });
}
