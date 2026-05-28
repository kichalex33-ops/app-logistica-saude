import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../services/sync_service.dart';
import '../repositories/evento_operacional_repository.dart';

class EventoSyncResult {
  final int enviados;
  final int falhas;
  final String? erro;

  const EventoSyncResult({
    required this.enviados,
    required this.falhas,
    this.erro,
  });
}

class EventoSyncService {
  final EventoOperacionalRepository repository;
  final http.Client client;

  EventoSyncService({
    EventoOperacionalRepository? repository,
    http.Client? client,
  }) : repository = repository ?? EventoOperacionalRepository(),
       client = client ?? http.Client();

  Future<EventoSyncResult> enviarPendentes() async {
    final servidorUrl = await SyncService.carregarServidorUrl();
    final eventos = await repository.listarPendentes();
    var enviados = 0;
    var falhas = 0;
    String? ultimoErro;

    for (final evento in eventos) {
      try {
        final response = await client
            .post(
              Uri.parse('$servidorUrl/api/driver/events'),
              headers: {'Content-Type': 'application/json; charset=utf-8'},
              body: jsonEncode(evento.toMap()),
            )
            .timeout(const Duration(seconds: 10));

        if (response.statusCode != 200 && response.statusCode != 201) {
          throw Exception('Falha ${response.statusCode}: ${response.body}');
        }

        await repository.atualizarSyncStatus(
          eventoId: evento.id,
          syncStatus: 'synced',
        );
        enviados++;
      } catch (error) {
        await repository.atualizarSyncStatus(
          eventoId: evento.id,
          syncStatus: 'failed',
        );
        falhas++;
        ultimoErro = error.toString();
      }
    }

    return EventoSyncResult(
      enviados: enviados,
      falhas: falhas,
      erro: ultimoErro,
    );
  }
}
