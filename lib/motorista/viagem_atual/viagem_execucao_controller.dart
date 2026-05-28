import 'package:flutter/foundation.dart';

import '../../auth/motorista_model.dart';
import '../../modules/transportes/models/viagem_model.dart';
import 'viagem_execucao_repository.dart';

class ViagemExecucaoController extends ChangeNotifier {
  final ViagemExecucaoRepository repository;

  ViagemExecucaoController({ViagemExecucaoRepository? repository})
    : repository = repository ?? ViagemExecucaoRepository();

  bool processando = false;
  String? erro;

  Future<void> registrarAcao({
    required ViagemModel viagem,
    required MotoristaModel motorista,
    required String tipo,
  }) async {
    processando = true;
    erro = null;
    notifyListeners();

    try {
      await repository.registrarPlaceholder(
        viagem: viagem,
        motorista: motorista,
        tipo: tipo,
      );
    } catch (error) {
      erro = error.toString();
    } finally {
      processando = false;
      notifyListeners();
    }
  }
}
