import 'package:flutter/foundation.dart';

import '../models/motorista_model.dart';
import '../models/veiculo_model.dart';
import '../models/viagem_model.dart';
import '../repositories/transportes_repository.dart';

class TransportesController extends ChangeNotifier {
  final TransportesRepository repository;

  TransportesController({TransportesRepository? repository})
    : repository = repository ?? TransportesRepository();

  Map<String, int> resumo = const {};
  List<ViagemModel> viagens = const [];
  List<MotoristaModel> motoristas = const [];
  List<VeiculoModel> veiculos = const [];
  bool carregando = false;

  Future<void> carregar() async {
    carregando = true;
    notifyListeners();
    resumo = await repository.resumo();
    viagens = await repository.listarViagens();
    motoristas = await repository.listarMotoristas();
    veiculos = await repository.listarVeiculos();
    carregando = false;
    notifyListeners();
  }

  Future<void> criarViagem({
    required String origem,
    required String destino,
    required DateTime dataHoraSaida,
    String? finalidade,
  }) async {
    await repository.criarViagem(
      municipioId: 'local',
      origem: origem,
      destino: destino,
      dataHoraSaida: dataHoraSaida,
      finalidade: finalidade,
    );
    await carregar();
  }

  Future<void> criarMotorista({required String nome, String? telefone}) async {
    await repository.criarMotorista(
      municipioId: 'local',
      nome: nome,
      telefone: telefone,
    );
    await carregar();
  }

  Future<void> criarVeiculo({
    required String placa,
    required String modelo,
    required String tipo,
    int capacidade = 0,
  }) async {
    await repository.criarVeiculo(
      municipioId: 'local',
      placa: placa,
      modelo: modelo,
      tipo: tipo,
      capacidade: capacidade,
    );
    await carregar();
  }
}
