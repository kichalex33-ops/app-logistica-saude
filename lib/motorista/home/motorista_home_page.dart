import 'package:flutter/material.dart';

import '../../auth/motorista_login_page.dart';
import '../../auth/motorista_model.dart';
import '../../auth/motorista_session.dart';
import '../../core/app_info.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../motorista/minhas_viagens/minhas_viagens_page.dart';
import '../../services/theme_mode_service.dart';

class MotoristaHomePage extends StatelessWidget {
  final MotoristaModel? motorista;
  final ThemeModeService? themeModeService;
  final MotoristaSession session;

  MotoristaHomePage({
    super.key,
    this.motorista,
    this.themeModeService,
    MotoristaSession? session,
  }) : session = session ?? MotoristaSession();

  void _mostrarIndisponivel(BuildContext context, String recurso) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$recurso sera conectado nas proximas etapas.')),
    );
  }

  Future<void> _sair(BuildContext context) async {
    await session.limpar();
    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MotoristaLoginPage(
          onEntrar: (novoMotorista) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => MotoristaHomePage(
                  motorista: novoMotorista,
                  themeModeService: themeModeService,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nomeMotorista = motorista?.nome.trim().isNotEmpty == true
        ? motorista!.nome.trim()
        : 'Motorista local';
    final nomeMunicipio = motorista?.municipio.trim().isNotEmpty == true
        ? motorista!.municipio.trim()
        : 'Municipio local';

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppInfo.nome),
        actions: [
          IconButton(
            tooltip: 'Sair',
            onPressed: () => _sair(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _InfoCard(
            icon: Icons.badge,
            title: 'Motorista logado',
            value: nomeMotorista,
          ),
          const SizedBox(height: AppSpacing.sm),
          _InfoCard(
            icon: Icons.location_city,
            title: 'Municipio',
            value: nomeMunicipio,
          ),
          const SizedBox(height: AppSpacing.sm),
          const _InfoCard(
            icon: Icons.route,
            title: 'Viagem atual',
            value: 'Nenhuma viagem em andamento',
          ),
          const SizedBox(height: AppSpacing.sm),
          const _InfoCard(
            icon: Icons.event_available,
            title: 'Proximas viagens',
            value: 'Aguardando viagens atribuidas pelo painel web',
          ),
          const SizedBox(height: AppSpacing.sm),
          const _InfoCard(
            icon: Icons.cloud_sync,
            title: 'Status de sync',
            value: 'Sem pendencias conhecidas nesta tela',
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MinhasViagensPage()),
              );
            },
            icon: const Icon(Icons.route),
            label: const Text('Ver minhas viagens'),
          ),
          const SizedBox(height: AppSpacing.sm),
          FilledButton.icon(
            onPressed: () => _mostrarIndisponivel(context, 'Continuar viagem'),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Continuar viagem'),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: () => _mostrarIndisponivel(context, 'Sincronizacao'),
            icon: const Icon(Icons.cloud_sync),
            label: const Text('Sincronizar agora'),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
