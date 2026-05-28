import 'package:flutter/foundation.dart';

import '../../modules/transportes/models/passageiro_model.dart';
import 'passageiros_repository.dart';

class PassageirosController extends ChangeNotifier {
  final PassageirosRepository repository;

  PassageirosController({PassageirosRepository? repository})
    : repository = repository ?? PassageirosRepository();

  bool carregando = false;
  List<PassageiroModel> passageiros = const [];
  String? erro;
  final Map<String, String> operacoesLocais = {};
  final Map<String, String> observacoesLocais = {};

  Future<void> carregar(String viagemId) async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      passageiros = await repository.listarPorViagem(viagemId);
    } catch (error) {
      erro = error.toString();
      passageiros = const [];
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  void registrarOperacao(String passageiroId, String operacao) {
    operacoesLocais[passageiroId] = operacao;
    notifyListeners();
  }

  void registrarObservacao(String passageiroId, String observacao) {
    observacoesLocais[passageiroId] = observacao;
    notifyListeners();
  }
}
