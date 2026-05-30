import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../mock/dashboard_mock.dart';
import '../controllers/dashboard_controller.dart';

const _red = Color(0xFFE53935);
const _orange = Color(0xFFF28C28);
const _yellow = Color(0xFFF4C430);

class PlataformaDashboardPage extends StatefulWidget {
  final bool embed;

  const PlataformaDashboardPage({super.key, this.embed = false});

  @override
  State<PlataformaDashboardPage> createState() =>
      _PlataformaDashboardPageState();
}

class _PlataformaDashboardPageState extends State<PlataformaDashboardPage> {
  late final PlataformaDashboardController controller;

  static const _sidebarWidth = 258.0;
  static const _radius = 16.0;
  static const _border = Color(0xFFE5ECE8);

  @override
  void initState() {
    super.initState();
    controller = PlataformaDashboardController()..carregar();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.carregando || controller.indicadores == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final desktop = constraints.maxWidth >= 1100;
            final tablet = constraints.maxWidth >= 760 && !desktop;

            if (!desktop) {
              return _MobileDashboard(
                tablet: tablet,
                body: _DashboardContent(
                  compact: !tablet,
                  showSidebar: false,
                  sidebarWidth: _sidebarWidth,
                ),
              );
            }

            return Row(
              children: [
                const _Sidebar(width: _sidebarWidth),
                Expanded(
                  child: _DashboardContent(
                    compact: false,
                    showSidebar: true,
                    sidebarWidth: _sidebarWidth,
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (widget.embed) {
      return content;
    }

    return Scaffold(backgroundColor: AppColors.background, body: content);
  }
}

class _DashboardContent extends StatelessWidget {
  final bool compact;
  final bool showSidebar;
  final double sidebarWidth;

  const _DashboardContent({
    required this.compact,
    required this.showSidebar,
    required this.sidebarWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Column(
        children: [
          _Topbar(compact: compact),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                compact ? 14 : 28,
                compact ? 14 : 22,
                compact ? 14 : 28,
                18,
              ),
              child: Column(
                children: [
                  _KpiGrid(compact: compact),
                  const SizedBox(height: 18),
                  if (compact)
                    const Column(
                      children: [
                        _TerritorialMapPanel(),
                        SizedBox(height: 16),
                        _RightRail(),
                      ],
                    )
                  else
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: _TerritorialMapPanel()),
                        SizedBox(width: 18),
                        SizedBox(width: 344, child: _RightRail()),
                      ],
                    ),
                  const SizedBox(height: 18),
                  if (compact)
                    const Column(
                      children: [
                        _MicroAreaChart(),
                        SizedBox(height: 16),
                        _FocusTypeChart(),
                        SizedBox(height: 16),
                        _FocusHistoryChart(),
                      ],
                    )
                  else
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _MicroAreaChart()),
                        SizedBox(width: 18),
                        Expanded(child: _FocusTypeChart()),
                        SizedBox(width: 18),
                        Expanded(child: _FocusHistoryChart()),
                      ],
                    ),
                  const SizedBox(height: 18),
                  _FooterStatus(compact: compact),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final double width;

  const _Sidebar({required this.width});

  static const items = [
    (Icons.dashboard_rounded, 'Dashboard', true),
    (Icons.qr_code_scanner_rounded, 'RG Digital', false),
    (Icons.assignment_turned_in_rounded, 'Visitas', false),
    (Icons.pending_actions_rounded, 'Pendências', false),
    (Icons.bar_chart_rounded, 'Indicadores', false),
    (Icons.description_rounded, 'Relatórios', false),
    (Icons.warning_amber_rounded, 'Alertas', false),
    (Icons.location_city_rounded, 'PE - Pontos Estratégicos', false),
    (Icons.settings_rounded, 'Configuração', false),
    (Icons.group_rounded, 'Usuários', false),
    (Icons.manage_search_rounded, 'Auditoria', false),
    (Icons.sync_rounded, 'Sincronização', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: AppColors.primaryDark,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 22, 16, 18),
          child: Column(
            children: [
              const _LogoBlock(),
              const SizedBox(height: 28),
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _SidebarItem(
                      icon: item.$1,
                      label: item.$2,
                      selected: item.$3,
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: AppColors.primary),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Supervisor', style: _whiteBold),
                          Text(
                            'SMS - Centro',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoBlock extends StatelessWidget {
  const _LogoBlock();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.maps_home_work_rounded,
            color: AppColors.primaryDark,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ACE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  height: .9,
                ),
              ),
              Text(
                'TERRITORIAL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'PLATAFORMA\nEPIDEMIOLÓGICA',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {},
        hoverColor: AppColors.primary.withValues(alpha: 0.35),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Topbar extends StatelessWidget {
  final bool compact;

  const _Topbar({required this.compact});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: compact ? null : 88,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 14 : 28,
        vertical: compact ? 14 : 0,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE9EFEC))),
      ),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Dashboard Executivo', style: _titleStyle),
                const SizedBox(height: 12),
                _Filters(compact: compact),
              ],
            )
          : Row(
              children: [
                const Expanded(
                  child: Text('Dashboard Executivo', style: _titleStyle),
                ),
                _Filters(compact: compact),
                const SizedBox(width: 20),
                const _UserArea(),
              ],
            ),
    );
  }
}

class _Filters extends StatelessWidget {
  final bool compact;

  const _Filters({required this.compact});

  @override
  Widget build(BuildContext context) {
    final children = [
      const _FilterBox(
        label: 'Município',
        value: 'Santa Maria',
        icon: Icons.expand_more,
      ),
      const _FilterBox(
        label: 'Período',
        value: 'Maio/2026',
        icon: Icons.calendar_today_rounded,
      ),
      const _FilterBox(
        label: 'Microárea',
        value: 'Todas',
        icon: Icons.expand_more,
      ),
      SizedBox(
        height: 48,
        child: FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.filter_alt_rounded, size: 18),
          label: const Text('Filtros'),
        ),
      ),
    ];

    if (compact) {
      return Wrap(spacing: 10, runSpacing: 10, children: children);
    }

    return Row(
      children: children
          .map(
            (child) =>
                Padding(padding: const EdgeInsets.only(left: 10), child: child),
          )
          .toList(),
    );
  }
}

class _FilterBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _FilterBox({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 172,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDDE7E1)),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textStrong,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: AppColors.textStrong, size: 18),
        ],
      ),
    );
  }
}

class _UserArea extends StatelessWidget {
  const _UserArea();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Badge(
          label: Text('3'),
          child: Icon(
            Icons.notifications_none_rounded,
            color: AppColors.primaryDark,
          ),
        ),
        SizedBox(width: 22),
        CircleAvatar(
          backgroundColor: AppColors.primaryLight,
          child: Icon(Icons.person, color: AppColors.primary),
        ),
        SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alexandre',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: AppColors.textStrong,
              ),
            ),
            Text(
              'Supervisor',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
        Icon(Icons.keyboard_arrow_down_rounded),
      ],
    );
  }
}

class _KpiGrid extends StatelessWidget {
  final bool compact;

  const _KpiGrid({required this.compact});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: DashboardMock.kpis.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: compact ? 1 : 5,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        mainAxisExtent: 112,
      ),
      itemBuilder: (context, index) => _KpiCard(kpi: DashboardMock.kpis[index]),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final DashboardKpiMock kpi;

  const _KpiCard({required this.kpi});

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: kpi.color.withValues(alpha: .11),
              shape: BoxShape.circle,
            ),
            child: Icon(kpi.icon, color: kpi.color, size: 34),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  kpi.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textStrong,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  kpi.value,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      kpi.positive ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 13,
                      color: kpi.positive ? AppColors.primary : _red,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        kpi.variation,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: kpi.positive ? AppColors.primary : _red,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TerritorialMapPanel extends StatelessWidget {
  const _TerritorialMapPanel();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 500,
        child: Stack(
          children: [
            const Positioned.fill(child: _TerritorialMapPainterWidget()),
            const Positioned(
              top: 16,
              left: 18,
              child: Text(
                'Mapa Territorial - Cobertura de Visitas',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
              top: 64,
              left: 18,
              child: Column(
                children: const [
                  _MapButton(icon: Icons.add),
                  SizedBox(height: 6),
                  _MapButton(icon: Icons.remove),
                  SizedBox(height: 18),
                  _MapButton(icon: Icons.my_location),
                  SizedBox(height: 18),
                  _MapButton(icon: Icons.layers_rounded),
                ],
              ),
            ),
            const Positioned(right: 20, top: 54, child: _MapLegend()),
            const Positioned(left: 18, bottom: 18, child: _LayerToggle()),
            const Positioned(right: 22, bottom: 18, child: _ScaleBar()),
          ],
        ),
      ),
    );
  }
}

class _TerritorialMapPainterWidget extends StatelessWidget {
  const _TerritorialMapPainterWidget();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TerritorialMapPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _TerritorialMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFEAF0EA);
    canvas.drawRect(Offset.zero & size, bg);

    final road = Paint()
      ..color = Colors.white.withValues(alpha: .75)
      ..strokeWidth = 2;
    for (var i = 0; i < 11; i++) {
      final y = size.height * (.12 + i * .08);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y + math.sin(i) * 28),
        road,
      );
      final x = size.width * (.08 + i * .09);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + math.cos(i) * 30, size.height),
        road,
      );
    }

    final area = Path()
      ..moveTo(size.width * .18, size.height * .42)
      ..quadraticBezierTo(
        size.width * .28,
        size.height * .10,
        size.width * .46,
        size.height * .11,
      )
      ..quadraticBezierTo(
        size.width * .64,
        size.height * .06,
        size.width * .76,
        size.height * .24,
      )
      ..quadraticBezierTo(
        size.width * .92,
        size.height * .30,
        size.width * .86,
        size.height * .62,
      )
      ..quadraticBezierTo(
        size.width * .72,
        size.height * .88,
        size.width * .45,
        size.height * .80,
      )
      ..quadraticBezierTo(
        size.width * .20,
        size.height * .82,
        size.width * .18,
        size.height * .42,
      )
      ..close();
    canvas.drawPath(
      area,
      Paint()..color = const Color(0xFFBEDFAD).withValues(alpha: .42),
    );

    final clip = Path()..addPath(area, Offset.zero);
    canvas.save();
    canvas.clipPath(clip);
    final colors = [
      const Color(0xFF0B7A3B),
      const Color(0xFF7AC45A),
      _yellow,
      _orange,
      _red,
    ];
    for (var row = 0; row < 9; row++) {
      for (var col = 0; col < 14; col++) {
        final rect = Rect.fromLTWH(
          size.width * (.16 + col * .052),
          size.height * (.15 + row * .071),
          size.width * .046,
          size.height * .058,
        );
        final color = colors[(row * 3 + col * 5) % colors.length];
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(6)),
          Paint()..color = color.withValues(alpha: color == _red ? .78 : .68),
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(6)),
          Paint()
            ..color = Colors.white.withValues(alpha: .65)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      }
    }
    canvas.restore();
    canvas.drawPath(
      area,
      Paint()
        ..color = AppColors.primaryDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    final markers = [
      (
        Offset(size.width * .38, size.height * .28),
        Icons.home_rounded,
        AppColors.primary,
        '',
      ),
      (
        Offset(size.width * .54, size.height * .23),
        Icons.location_city,
        Colors.purple,
        'PE',
      ),
      (Offset(size.width * .64, size.height * .55), Icons.gps_fixed, _red, ''),
      (
        Offset(size.width * .46, size.height * .58),
        Icons.home_rounded,
        AppColors.primary,
        '',
      ),
      (
        Offset(size.width * .78, size.height * .36),
        Icons.location_city,
        Colors.purple,
        'PE',
      ),
      (
        Offset(size.width * .30, size.height * .66),
        Icons.home_rounded,
        AppColors.primary,
        '',
      ),
      (
        Offset(size.width * .69, size.height * .72),
        Icons.home_rounded,
        AppColors.primary,
        '',
      ),
      (
        Offset(size.width * .58, size.height * .45),
        Icons.home_rounded,
        AppColors.primary,
        '',
      ),
      (
        Offset(size.width * .34, size.height * .43),
        Icons.location_city,
        Colors.purple,
        'PE',
      ),
      (Offset(size.width * .50, size.height * .35), Icons.gps_fixed, _red, ''),
    ];

    for (final marker in markers) {
      final p = marker.$1;
      canvas.drawCircle(p, 12, Paint()..color = Colors.white);
      canvas.drawCircle(p, 10, Paint()..color = marker.$3);
      final text = marker.$4.isEmpty
          ? String.fromCharCode(marker.$2.codePoint)
          : marker.$4;
      final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: Colors.white,
            fontSize: marker.$4.isEmpty ? 13 : 9,
            fontFamily: marker.$4.isEmpty ? marker.$2.fontFamily : null,
            fontWeight: FontWeight.w900,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, p - Offset(painter.width / 2, painter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapButton extends StatelessWidget {
  final IconData icon;

  const _MapButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 10)],
      ),
      child: Icon(icon, size: 20, color: AppColors.textStrong),
    );
  }
}

class _MapLegend extends StatelessWidget {
  const _MapLegend();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      width: 230,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Cobertura de Visitas',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 14),
          _LegendDot('90% ou mais', Color(0xFF0B7A3B)),
          _LegendDot('70% - 89%', Color(0xFF7AC45A)),
          _LegendDot('50% - 69%', _yellow),
          _LegendDot('30% - 49%', _orange),
          _LegendDot('Menos de 30%', _red),
          Divider(height: 28),
          _LegendIcon('Ponto Estratégico', Colors.purple, 'PE'),
          _LegendIcon('Foco Encontrado', _red, '◎'),
          _LegendIcon('Imóvel com Pendência', _yellow, '!'),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendDot(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          CircleAvatar(radius: 7, backgroundColor: color),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _LegendIcon extends StatelessWidget {
  final String label;
  final Color color;
  final String text;

  const _LegendIcon(this.label, this.color, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 9,
            backgroundColor: color,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _LayerToggle extends StatelessWidget {
  const _LayerToggle();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_box, color: AppColors.primary, size: 18),
          SizedBox(width: 8),
          Text(
            'Exibir limites',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ScaleBar extends StatelessWidget {
  const _ScaleBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('0'), Text('500'), Text('1000 m')],
          ),
          Container(height: 3, color: Colors.black),
        ],
      ),
    );
  }
}

class _RightRail extends StatelessWidget {
  const _RightRail();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _AlertsPanel(),
        SizedBox(height: 18),
        _PendingTypePanel(),
        SizedBox(height: 18),
        _VisitsPanel(),
      ],
    );
  }
}

class _AlertsPanel extends StatelessWidget {
  const _AlertsPanel();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          const _PanelHeader('Alertas Críticos'),
          ...DashboardMock.alerts.map((alert) => _AlertTile(alert: alert)),
        ],
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final DashboardAlertMock alert;

  const _AlertTile({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: alert.color.withValues(alpha: .13),
            child: Icon(alert.icon, color: alert.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.subtitle,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 15,
            backgroundColor: alert.color,
            child: Text(
              '${alert.count}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingTypePanel extends StatelessWidget {
  const _PendingTypePanel();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PanelHeader('Pendências por Tipo'),
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(
                width: 126,
                height: 126,
                child: _DonutChart(total: '1.273'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: const [
                    _MiniLegend('Visita Pendente', '842 (66%)', _red),
                    _MiniLegend('Foco não tratado', '215 (17%)', _orange),
                    _MiniLegend('Recusa de acesso', '126 (10%)', _yellow),
                    _MiniLegend(
                      'Atualização cadastral',
                      '90 (7%)',
                      AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VisitsPanel extends StatelessWidget {
  const _VisitsPanel();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          const _PanelHeader('Últimas Visitas Realizadas'),
          const SizedBox(height: 8),
          ...DashboardMock.visits.map((visit) => _VisitTile(visit: visit)),
        ],
      ),
    );
  }
}

class _VisitTile extends StatelessWidget {
  final DashboardVisitMock visit;

  const _VisitTile({required this.visit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.primaryLight,
            child: Icon(Icons.home_rounded, size: 17, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visit.property,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
                Text(
                  visit.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                visit.ace,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                visit.time,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              visit.status,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MicroAreaChart extends StatelessWidget {
  const _MicroAreaChart();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          const _PanelHeader('Visitas por Microárea'),
          const SizedBox(height: 12),
          ...DashboardMock.microareas.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                children: [
                  SizedBox(
                    width: 88,
                    child: Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: item.value / 100,
                        minHeight: 12,
                        color: item.color,
                        backgroundColor: const Color(0xFFE9EFEC),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 36,
                    child: Text(
                      '${item.value}%',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0%'),
              Text('25%'),
              Text('50%'),
              Text('75%'),
              Text('100%'),
            ],
          ),
        ],
      ),
    );
  }
}

class _FocusTypeChart extends StatelessWidget {
  const _FocusTypeChart();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PanelHeader('Focos por Tipo - Mês Atual'),
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(
                width: 146,
                height: 146,
                child: _DonutChart(total: '126'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: DashboardMock.focusTypes
                      .map(
                        (item) => _MiniLegend(
                          item.label,
                          '${item.value}',
                          item.color,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutChart extends StatelessWidget {
  final String total;

  const _DonutChart({required this.total});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DonutPainter(),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              total,
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
            ),
            const Text(
              'Total',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    var start = -math.pi / 2;
    for (final item in DashboardMock.focusTypes) {
      final sweep = (item.value / 126) * math.pi * 2;
      canvas.drawArc(
        rect.deflate(14),
        start,
        sweep,
        false,
        Paint()
          ..color = item.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 20
          ..strokeCap = StrokeCap.butt,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FocusHistoryChart extends StatelessWidget {
  const _FocusHistoryChart();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _PanelHeader('Histórico de Focos (6 meses)'),
          SizedBox(height: 16),
          SizedBox(height: 178, child: _LineChart()),
        ],
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LineChartPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final axis = Paint()
      ..color = const Color(0xFFE6ECE8)
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = size.height * (.12 + i * .24);
      canvas.drawLine(Offset(36, y), Offset(size.width - 8, y), axis);
    }

    final points = DashboardMock.focusHistory;
    final maxValue = points.map((e) => e.value).reduce(math.max).toDouble();
    final path = Path();
    final fill = Path();
    for (var i = 0; i < points.length; i++) {
      final x = 42 + i * ((size.width - 62) / (points.length - 1));
      final y =
          size.height - 34 - (points[i].value / maxValue) * (size.height - 54);
      if (i == 0) {
        path.moveTo(x, y);
        fill.moveTo(x, size.height - 30);
        fill.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fill.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = _red);
      final tp = TextPainter(
        text: TextSpan(
          text: '${points[i].value}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, y - 24));
      final label = TextPainter(
        text: TextSpan(
          text: points[i].label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      label.paint(canvas, Offset(x - label.width / 2, size.height - 18));
    }
    fill.lineTo(size.width - 20, size.height - 30);
    fill.close();
    canvas.drawPath(fill, Paint()..color = _red.withValues(alpha: .08));
    canvas.drawPath(
      path,
      Paint()
        ..color = _red
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FooterStatus extends StatelessWidget {
  final bool compact;

  const _FooterStatus({required this.compact});

  @override
  Widget build(BuildContext context) {
    final cards = const [
      (Icons.maps_home_work_rounded, 'Municípios Integrados', '12'),
      (Icons.grid_view_rounded, 'Microáreas', '245'),
      (Icons.groups_rounded, 'ACEs Ativos', '312'),
      (Icons.cloud_sync_rounded, 'Sincronização', 'Última: Hoje, 09:15'),
      (Icons.circle, 'Status do Sistema', 'Operacional'),
    ];

    return _Panel(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Wrap(
        spacing: 28,
        runSpacing: 14,
        alignment: WrapAlignment.spaceBetween,
        children: cards
            .map(
              (item) => SizedBox(
                width: compact ? double.infinity : 210,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primaryLight,
                      child: Icon(item.$1, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.$2,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            item.$3,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  final String title;

  const _PanelHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
        const Text(
          'Ver relatório',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
      ],
    );
  }
}

class _MiniLegend extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniLegend(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        children: [
          CircleAvatar(radius: 5, backgroundColor: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textStrong,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? width;

  const _Panel({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _PlataformaDashboardPageState._border),
        borderRadius: BorderRadius.circular(
          _PlataformaDashboardPageState._radius,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _MobileDashboard extends StatelessWidget {
  final bool tablet;
  final Widget body;

  const _MobileDashboard({required this.tablet, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 64,
          color: AppColors.primaryDark,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: const Row(
            children: [
              Icon(Icons.menu, color: Colors.white),
              SizedBox(width: 12),
              Text(
                'ACE Territorial',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        Expanded(child: body),
      ],
    );
  }
}

const _titleStyle = TextStyle(
  color: Colors.black,
  fontSize: 26,
  fontWeight: FontWeight.w900,
);

const _whiteBold = TextStyle(color: Colors.white, fontWeight: FontWeight.w900);
