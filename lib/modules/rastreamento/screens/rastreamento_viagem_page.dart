import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class RastreamentoViagemPage extends StatefulWidget {
  final bool embed;

  const RastreamentoViagemPage({super.key, this.embed = false});

  @override
  State<RastreamentoViagemPage> createState() => _RastreamentoViagemPageState();
}

class _RastreamentoViagemPageState extends State<RastreamentoViagemPage> {
  Timer? timer;
  int posicaoAtual = 0;
  bool emViagem = true;

  final pontos = const [
    _PontoRota('UBS Centro', -29.5877, -51.3752, 'Saida confirmada'),
    _PontoRota('BR-386', -29.6764, -51.2510, 'Em deslocamento'),
    _PontoRota('Eldorado do Sul', -30.0830, -51.6169, 'Rota monitorada'),
    _PontoRota('Entrada POA', -30.0350, -51.3000, 'Chegando em POA'),
    _PontoRota('Hospital de POA', -30.0402, -51.2177, 'Paciente entregue'),
  ];

  final passageiros = const [
    _Passageiro('Maria L. Santos', 'Consulta cardiologia', 'Hospital de POA'),
    _Passageiro('Joao P. Oliveira', 'Exame de imagem', 'Hospital de POA'),
    _Passageiro('Ana R. Souza', 'Acompanhante', 'Hospital de POA'),
  ];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || !emViagem) return;
      setState(() {
        if (posicaoAtual < pontos.length - 1) {
          posicaoAtual++;
        } else {
          emViagem = false;
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void reiniciar() {
    setState(() {
      posicaoAtual = 0;
      emViagem = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ponto = pontos[posicaoAtual];

    return Scaffold(
      appBar: widget.embed
          ? null
          : AppBar(title: const Text('Rastreamento GPS')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _StatusViagemCard(
            ponto: ponto,
            progresso: (posicaoAtual + 1) / pontos.length,
            emViagem: emViagem,
            onReiniciar: reiniciar,
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 260,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: CustomPaint(
                painter: _RotaPainter(
                  pontos: pontos,
                  posicaoAtual: posicaoAtual,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const _ExperienciaOperacional(),
          const SizedBox(height: AppSpacing.md),
          _PassageirosCard(passageiros: passageiros),
          const SizedBox(height: AppSpacing.md),
          _ControleCard(pontos: pontos, posicaoAtual: posicaoAtual),
        ],
      ),
    );
  }
}

class _StatusViagemCard extends StatelessWidget {
  final _PontoRota ponto;
  final double progresso;
  final bool emViagem;
  final VoidCallback onReiniciar;

  const _StatusViagemCard({
    required this.ponto,
    required this.progresso,
    required this.emViagem,
    required this.onReiniciar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_shipping, color: AppColors.primary),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Viagem UBS Centro -> Hospital de POA',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                ),
                IconButton(
                  tooltip: 'Reiniciar simulado',
                  onPressed: onReiniciar,
                  icon: const Icon(Icons.replay),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            LinearProgressIndicator(value: progresso),
            const SizedBox(height: AppSpacing.sm),
            Text(
              emViagem ? ponto.status : 'Viagem finalizada',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              '${ponto.nome} | GPS ${ponto.latitude.toStringAsFixed(5)}, ${ponto.longitude.toStringAsFixed(5)}',
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExperienciaOperacional extends StatelessWidget {
  const _ExperienciaOperacional();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: const [
            _FluxoTile(
              icon: Icons.badge,
              title: 'Motorista',
              text: 'Confirma saida, visualiza passageiros e envia posicao GPS.',
            ),
            Divider(),
            _FluxoTile(
              icon: Icons.phone_android,
              title: 'App',
              text: 'Salva eventos offline e sincroniza quando houver rede.',
            ),
            Divider(),
            _FluxoTile(
              icon: Icons.monitor_heart,
              title: 'Controle',
              text: 'Acompanha rota, atrasos, chegada e entrega no hospital.',
            ),
          ],
        ),
      ),
    );
  }
}

class _FluxoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _FluxoTile({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(text),
    );
  }
}

class _PassageirosCard extends StatelessWidget {
  final List<_Passageiro> passageiros;

  const _PassageirosCard({required this.passageiros});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Passageiros e destinos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...passageiros.map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.airline_seat_recline_normal),
                title: Text(item.nome),
                subtitle: Text('${item.motivo} | ${item.destino}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ControleCard extends StatelessWidget {
  final List<_PontoRota> pontos;
  final int posicaoAtual;

  const _ControleCard({required this.pontos, required this.posicaoAtual});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Linha do tempo do controle',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (var i = 0; i < pontos.length; i++)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  i <= posicaoAtual ? Icons.check_circle : Icons.circle_outlined,
                  color: i <= posicaoAtual ? AppColors.emDia : AppColors.textMuted,
                ),
                title: Text(pontos[i].nome),
                subtitle: Text(pontos[i].status),
              ),
          ],
        ),
      ),
    );
  }
}

class _RotaPainter extends CustomPainter {
  final List<_PontoRota> pontos;
  final int posicaoAtual;

  _RotaPainter({required this.pontos, required this.posicaoAtual});

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFEAF2F7);
    canvas.drawRect(Offset.zero & size, bg);

    final line = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    final done = Paint()
      ..color = AppColors.emDia
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final offsets = List.generate(pontos.length, (index) {
      final x = 28 + (size.width - 56) * (index / (pontos.length - 1));
      final wave = index.isEven ? size.height * 0.62 : size.height * 0.34;
      return Offset(x, wave);
    });

    final path = Path()..moveTo(offsets.first.dx, offsets.first.dy);
    for (final point in offsets.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(path, line);

    final donePath = Path()..moveTo(offsets.first.dx, offsets.first.dy);
    for (var i = 1; i <= posicaoAtual; i++) {
      donePath.lineTo(offsets[i].dx, offsets[i].dy);
    }
    canvas.drawPath(donePath, done);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i < offsets.length; i++) {
      final pointPaint = Paint()
        ..color = i <= posicaoAtual ? AppColors.emDia : Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(offsets[i], i == posicaoAtual ? 12 : 9, pointPaint);
      canvas.drawCircle(
        offsets[i],
        i == posicaoAtual ? 12 : 9,
        Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

      textPainter.text = TextSpan(
        text: pontos[i].nome,
        style: const TextStyle(color: AppColors.textStrong, fontSize: 11),
      );
      textPainter.layout(maxWidth: 88);
      textPainter.paint(canvas, offsets[i] + const Offset(-28, 18));
    }

    final vehicle = offsets[posicaoAtual];
    const icon = Icons.local_shipping;
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        color: AppColors.atrasado,
        fontSize: 30,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, vehicle + const Offset(-15, -42));
  }

  @override
  bool shouldRepaint(covariant _RotaPainter oldDelegate) {
    return oldDelegate.posicaoAtual != posicaoAtual;
  }
}

class _PontoRota {
  final String nome;
  final double latitude;
  final double longitude;
  final String status;

  const _PontoRota(this.nome, this.latitude, this.longitude, this.status);
}

class _Passageiro {
  final String nome;
  final String motivo;
  final String destino;

  const _Passageiro(this.nome, this.motivo, this.destino);
}
