import 'package:flutter/material.dart';

import '../../core/app_info.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../screens/login_page.dart';
import '../../services/theme_mode_service.dart';

class MotoristaHomePage extends StatelessWidget {
  final String? motorista;
  final String? municipio;
  final ThemeModeService? themeModeService;

  const MotoristaHomePage({
    super.key,
    this.motorista,
    this.municipio,
    this.themeModeService,
  });

  void _mostrarIndisponivel(BuildContext context, String recurso) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$recurso sera conectado nas proximas etapas.')),
    );
  }

  void _sair(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LoginPage(
          onEntrar: (context, novoMotorista, novoMunicipio) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => MotoristaHomePage(
                  motorista: novoMotorista,
                  municipio: novoMunicipio,
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
    final nomeMotorista = motorista?.trim().isNotEmpty == true
        ? motorista!.trim()
        : 'Motorista local';
    final nomeMunicipio = municipio?.trim().isNotEmpty == true
        ? municipio!.trim()
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
            onPressed: () => _mostrarIndisponivel(context, 'Minhas viagens'),
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
