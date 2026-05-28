import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../modules/transportes/models/viagem_status.dart';
import '../../modules/transportes/repositories/transportes_repository.dart';

class MinhasViagensPage extends StatefulWidget {
  final bool embed;

  const MinhasViagensPage({super.key, this.embed = false});

  @override
  State<MinhasViagensPage> createState() => _MinhasViagensPageState();
}

class _MinhasViagensPageState extends State<MinhasViagensPage> {
  final repository = TransportesRepository();
  bool carregando = true;
  List<dynamic> viagens = const [];

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    final resultado = await repository.listarViagens();
    if (!mounted) return;

    setState(() {
      viagens = resultado;
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.embed ? null : AppBar(title: const Text('Minhas viagens')),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : viagens.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma viagem atribuida',
                style: TextStyle(color: AppColors.textMuted),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: viagens.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final viagem = viagens[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.route, color: AppColors.primary),
                    title: Text('${viagem.origem} -> ${viagem.destino}'),
                    subtitle: Text(
                      [
                        ViagemStatus.label(viagem.status),
                        if (viagem.finalidade?.isNotEmpty == true)
                          viagem.finalidade,
                      ].whereType<String>().join(' | '),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
