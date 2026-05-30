import 'package:flutter/material.dart';

/// Dados cenográficos usados somente para compor o dashboard executivo web
/// enquanto os módulos territoriais reais ainda não entregam todos os agregados.
/// Não são persistidos, não alteram banco e não participam da sincronização.
class DashboardMock {
  static const kpis = [
    DashboardKpiMock(
      icon: Icons.home_rounded,
      title: 'Imóveis Cadastrados',
      value: '12.458',
      variation: '2,4% vs mês anterior',
      positive: true,
    ),
    DashboardKpiMock(
      icon: Icons.fact_check_rounded,
      title: 'Visitas Realizadas',
      value: '8.947',
      variation: '5,6% vs mês anterior',
      positive: true,
    ),
    DashboardKpiMock(
      icon: Icons.warning_rounded,
      title: 'Pendências',
      value: '1.273',
      variation: '8,3% vs mês anterior',
      positive: false,
      color: Color(0xFFF2B84B),
    ),
    DashboardKpiMock(
      icon: Icons.gps_fixed_rounded,
      title: 'Focos Encontrados',
      value: '126',
      variation: '12,7% vs mês anterior',
      positive: false,
      color: Color(0xFFD7263D),
    ),
    DashboardKpiMock(
      icon: Icons.verified_user_rounded,
      title: 'Cobertura Territorial',
      value: '92%',
      variation: '3,1% vs mês anterior',
      positive: true,
    ),
  ];

  static const alerts = [
    DashboardAlertMock(
      'Área sem visita há mais de 45 dias',
      'Microárea 07 - 156 imóveis',
      3,
      Color(0xFFD7263D),
      Icons.warning_rounded,
    ),
    DashboardAlertMock(
      'PE com reincidência de foco',
      '4 pontos estratégicos',
      4,
      Color(0xFFF28C28),
      Icons.report_problem_rounded,
    ),
    DashboardAlertMock(
      'Aumento de focos em relação ao período anterior',
      'Centro - Microárea 03',
      2,
      Color(0xFFF2B84B),
      Icons.trending_up_rounded,
    ),
    DashboardAlertMock(
      'Microárea com baixa cobertura',
      'Microárea 12 - 38%',
      1,
      Color(0xFFF2B84B),
      Icons.warning_amber_rounded,
    ),
  ];

  static const microareas = [
    DashboardBarMock('Microárea 01', 95, Color(0xFF005B2E)),
    DashboardBarMock('Microárea 02', 90, Color(0xFF0C7A3E)),
    DashboardBarMock('Microárea 03', 78, Color(0xFF9CCB3B)),
    DashboardBarMock('Microárea 04', 65, Color(0xFFF4C430)),
    DashboardBarMock('Microárea 05', 92, Color(0xFF0C7A3E)),
    DashboardBarMock('Microárea 06', 88, Color(0xFF12824A)),
    DashboardBarMock('Microárea 07', 35, Color(0xFFE53935)),
    DashboardBarMock('Microárea 08', 70, Color(0xFFA8C928)),
  ];

  static const focusTypes = [
    DashboardSliceMock('Depósito D2', 54, Color(0xFFE53935)),
    DashboardSliceMock('Depósito D1', 28, Color(0xFFF28C28)),
    DashboardSliceMock('Pneus', 18, Color(0xFFF4C430)),
    DashboardSliceMock('Lixo / Entulho', 12, Color(0xFF35A852)),
    DashboardSliceMock('Outros', 14, Color(0xFF717C89)),
  ];

  static const focusHistory = [
    DashboardPointMock('Jan/26', 68),
    DashboardPointMock('Fev/26', 72),
    DashboardPointMock('Mar/26', 95),
    DashboardPointMock('Abr/26', 110),
    DashboardPointMock('Mai/26', 126),
  ];

  static const visits = [
    DashboardVisitMock(
      'Casa 128',
      'R. Sete de Setembro, 128',
      'Maria Silva',
      'Hoje, 08:45',
      'Concluída',
    ),
    DashboardVisitMock(
      'Casa 256',
      'R. Venâncio Aires, 256',
      'João Souza',
      'Hoje, 08:30',
      'Concluída',
    ),
    DashboardVisitMock(
      'Casa 89',
      'R. Dr. Bozano, 89',
      'Carlos Lima',
      'Hoje, 08:10',
      'Concluída',
    ),
    DashboardVisitMock(
      'Casa 512',
      'R. Silv. Jardim, 512',
      'Ana Paula',
      'Hoje, 07:55',
      'Concluída',
    ),
    DashboardVisitMock(
      'Casa 74',
      'R. Tuiuti, 74',
      'João Souza',
      'Hoje, 07:40',
      'Concluída',
    ),
  ];
}

class DashboardKpiMock {
  final IconData icon;
  final String title;
  final String value;
  final String variation;
  final bool positive;
  final Color color;

  const DashboardKpiMock({
    required this.icon,
    required this.title,
    required this.value,
    required this.variation,
    required this.positive,
    this.color = const Color(0xFF005B2E),
  });
}

class DashboardAlertMock {
  final String title;
  final String subtitle;
  final int count;
  final Color color;
  final IconData icon;

  const DashboardAlertMock(
    this.title,
    this.subtitle,
    this.count,
    this.color,
    this.icon,
  );
}

class DashboardBarMock {
  final String label;
  final int value;
  final Color color;

  const DashboardBarMock(this.label, this.value, this.color);
}

class DashboardSliceMock {
  final String label;
  final int value;
  final Color color;

  const DashboardSliceMock(this.label, this.value, this.color);
}

class DashboardPointMock {
  final String label;
  final int value;

  const DashboardPointMock(this.label, this.value);
}

class DashboardVisitMock {
  final String property;
  final String address;
  final String ace;
  final String time;
  final String status;

  const DashboardVisitMock(
    this.property,
    this.address,
    this.ace,
    this.time,
    this.status,
  );
}
