import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:controle_ace/core/app_info.dart';
import 'package:controle_ace/main.dart';

void main() {
  testWidgets('mostra plataforma logistica', (WidgetTester tester) async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    await tester.pumpWidget(
      const ControleACEApp(carregarDashboard: false, mostrarLogin: false),
    );

    expect(find.text(AppInfo.nome), findsWidgets);
    expect(find.text('Painel'), findsOneWidget);
    expect(find.text('Viagens'), findsWidgets);
    expect(find.text('Pacientes'), findsWidgets);
    expect(find.text('Rastreio'), findsOneWidget);

    await tester.tap(find.text('Rastreio'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Viagem LogiSaude 001'), findsOneWidget);
    expect(find.text('Mapa real da rota'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Manifesto de passageiros'),
      500,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Manifesto de passageiros'), findsOneWidget);
  });
}
