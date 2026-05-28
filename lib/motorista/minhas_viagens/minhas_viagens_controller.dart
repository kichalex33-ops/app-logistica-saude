import 'package:flutter/foundation.dart';

import '../../modules/transportes/models/viagem_model.dart';
import 'minhas_viagens_repository.dart';

class MinhasViagensController extends ChangeNotifier {
  final MinhasViagensRepository repository;

  MinhasViagensController({MinhasViagensRepository? repository})
    : repository = repository ?? MinhasViagensRepository();

  bool carregando = false;
  List<ViagemModel> viagens = const [];
  String? erro;

  Future<void> carregar(String motoristaId) async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      viagens = await repository.listarPorMotorista(motoristaId);
    } catch (error) {
      erro = error.toString();
      viagens = const [];
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
