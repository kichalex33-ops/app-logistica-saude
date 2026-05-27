import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../controllers/transportes_controller.dart';

class TransportesPage extends StatefulWidget {
  final bool embed;

  const TransportesPage({super.key, this.embed = false});

  @override
  State<TransportesPage> createState() => _TransportesPageState();
}

class _TransportesPageState extends State<TransportesPage>
    with SingleTickerProviderStateMixin {
  late final TransportesController controller;
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    controller = TransportesController()..carregar();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> _novaViagem() async {
    final origem = TextEditingController();
    final destino = TextEditingController();
    final finalidade = TextEditingController();
    final salvou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova viagem'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: origem,
              decoration: const InputDecoration(labelText: 'Origem'),
            ),
            TextField(
              controller: destino,
              decoration: const InputDecoration(labelText: 'Destino'),
            ),
            TextField(
              controller: finalidade,
              decoration: const InputDecoration(labelText: 'Finalidade'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    if (salvou != true ||
        origem.text.trim().isEmpty ||
        destino.text.trim().isEmpty) {
      return;
    }
    await controller.criarViagem(
      origem: origem.text.trim(),
      destino: destino.text.trim(),
      finalidade: finalidade.text.trim(),
      dataHoraSaida: DateTime.now(),
    );
  }

  Future<void> _novoMotorista() async {
    final nome = TextEditingController();
    final telefone = TextEditingController();
    final salvou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Novo motorista'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nome,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: telefone,
              decoration: const InputDecoration(labelText: 'Telefone'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    if (salvou != true || nome.text.trim().isEmpty) return;
    await controller.criarMotorista(
      nome: nome.text.trim(),
      telefone: telefone.text.trim(),
    );
  }

  Future<void> _novoVeiculo() async {
    final placa = TextEditingController();
    final modelo = TextEditingController();
    final tipo = TextEditingController(text: 'Ambulancia');
    final capacidade = TextEditingController(text: '4');
    final salvou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Novo veiculo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: placa,
              decoration: const InputDecoration(labelText: 'Placa'),
            ),
            TextField(
              controller: modelo,
              decoration: const InputDecoration(labelText: 'Modelo'),
            ),
            TextField(
              controller: tipo,
              decoration: const InputDecoration(labelText: 'Tipo'),
            ),
            TextField(
              controller: capacidade,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Capacidade'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    if (salvou != true ||
        placa.text.trim().isEmpty ||
        modelo.text.trim().isEmpty) {
      return;
    }
    await controller.criarVeiculo(
      placa: placa.text.trim(),
      modelo: modelo.text.trim(),
      tipo: tipo.text.trim().isEmpty ? 'Veiculo' : tipo.text.trim(),
      capacidade: int.tryParse(capacidade.text.trim()) ?? 0,
    );
  }

  Future<void> _acaoPrincipal() {
    return switch (tabController.index) {
      0 => _novaViagem(),
      1 => _novoMotorista(),
      _ => _novoVeiculo(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.embed ? null : AppBar(title: const Text('Transportes')),
      floatingActionButton: FloatingActionButton(
        onPressed: _acaoPrincipal,
        child: const Icon(Icons.add),
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          if (controller.carregando) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    _ResumoChip(
                      label: 'Viagens',
                      value: controller.resumo['viagens'] ?? 0,
                    ),
                    _ResumoChip(
                      label: 'Motoristas',
                      value: controller.resumo['motoristas'] ?? 0,
                    ),
                    _ResumoChip(
                      label: 'Veiculos',
                      value: controller.resumo['veiculos'] ?? 0,
                    ),
                  ],
                ),
              ),
              TabBar(
                controller: tabController,
                onTap: (_) => setState(() {}),
                tabs: const [
                  Tab(icon: Icon(Icons.route), text: 'Viagens'),
                  Tab(icon: Icon(Icons.badge), text: 'Motoristas'),
                  Tab(icon: Icon(Icons.directions_bus), text: 'Veiculos'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    _Lista(
                      empty: 'Nenhuma viagem cadastrada',
                      children: controller.viagens
                          .map(
                            (item) => ListTile(
                              leading: const Icon(
                                Icons.route,
                                color: AppColors.primary,
                              ),
                              title: Text('${item.origem} -> ${item.destino}'),
                              subtitle: Text(
                                item.finalidade?.isNotEmpty == true
                                    ? item.finalidade!
                                    : item.status,
                              ),
                              trailing: const Icon(
                                Icons.cloud_upload,
                                size: 18,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    _Lista(
                      empty: 'Nenhum motorista cadastrado',
                      children: controller.motoristas
                          .map(
                            (item) => ListTile(
                              leading: const Icon(
                                Icons.badge,
                                color: AppColors.primary,
                              ),
                              title: Text(item.nome),
                              subtitle: Text(item.telefone ?? item.status),
                            ),
                          )
                          .toList(),
                    ),
                    _Lista(
                      empty: 'Nenhum veiculo cadastrado',
                      children: controller.veiculos
                          .map(
                            (item) => ListTile(
                              leading: const Icon(
                                Icons.directions_bus,
                                color: AppColors.primary,
                              ),
                              title: Text('${item.placa} - ${item.modelo}'),
                              subtitle: Text(
                                '${item.tipo} | ${item.capacidade} lugares',
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ResumoChip extends StatelessWidget {
  final String label;
  final int value;

  const _ResumoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}

class _Lista extends StatelessWidget {
  final String empty;
  final List<Widget> children;

  const _Lista({required this.empty, required this.children});

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return Center(
        child: Text(empty, style: const TextStyle(color: AppColors.textMuted)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemBuilder: (context, index) => Card(child: children[index]),
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemCount: children.length,
    );
  }
}
