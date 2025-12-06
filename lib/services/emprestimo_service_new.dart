/// Serviço principal de gerenciamento de empréstimos
/// 
/// Este arquivo agrega todos os sub-serviços de empréstimo em uma única interface,
/// mantendo a compatibilidade com o código existente.
/// 
/// Estrutura modular:
/// - [EmprestimoBaseService]: Operações CRUD básicas
/// - [EmprestimoActionService]: Ações (confirmar, recusar, devolver)
/// - [EmprestimoMonitorService]: Monitoramento em tempo real
/// - [EmprestimoStatsService]: Estatísticas e contadores
/// - [EmprestimoQueryService]: Queries avançadas por data (Admin)
/// 
/// Exemplo de uso:
/// ```dart
/// final service = EmprestimoService();
/// await service.criarEmprestimo(emprestimo);
/// await service.confirmarEmprestimo(id, atendenteId);
/// ```

export 'emprestimo/emprestimo_base_service.dart';
export 'emprestimo/emprestimo_action_service.dart';
export 'emprestimo/emprestimo_monitor_service.dart';
export 'emprestimo/emprestimo_stats_service.dart';
export 'emprestimo/emprestimo_query_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/emprestimo_model.dart';
import 'emprestimo/emprestimo_base_service.dart';
import 'emprestimo/emprestimo_action_service.dart';
import 'emprestimo/emprestimo_monitor_service.dart';
import 'emprestimo/emprestimo_stats_service.dart';
import 'emprestimo/emprestimo_query_service.dart';

/// Serviço unificado de empréstimos
/// 
/// Agrega todos os sub-serviços em uma única classe para facilitar o uso
/// e manter compatibilidade com código existente.
class EmprestimoService {
  // Instâncias dos sub-serviços
  final EmprestimoBaseService _baseService = EmprestimoBaseService();
  final EmprestimoActionService _actionService = EmprestimoActionService();
  final EmprestimoMonitorService _monitorService = EmprestimoMonitorService();
  final EmprestimoStatsService _statsService = EmprestimoStatsService();
  final EmprestimoQueryService _queryService = EmprestimoQueryService();

  // ============================================================================
  // Operações CRUD Básicas (EmprestimoBaseService)
  // ============================================================================

  Future<EmprestimoModel> criarEmprestimo(EmprestimoModel emprestimo) =>
      _baseService.criarEmprestimo(emprestimo);

  Future<EmprestimoModel?> buscarEmprestimo(String id) =>
      _baseService.buscarEmprestimo(id);

  Future<void> atualizarEmprestimo(String id, Map<String, dynamic> updates) =>
      _baseService.atualizarEmprestimo(id, updates);

  Future<void> atualizarIsBlocoCorreto(String id, bool isBlocoCorreto) =>
      _baseService.atualizarIsBlocoCorreto(id, isBlocoCorreto);

  Future<void> deletarEmprestimo(String id) =>
      _baseService.deletarEmprestimo(id);

  Future<void> limparEmprestimosAntigos() =>
      _baseService.limparEmprestimosAntigos();

  Future<List<EmprestimoModel>> listarEmprestimosPorUsuario(String userId) =>
      _baseService.listarEmprestimosPorUsuario(userId);

  Stream<EmprestimoModel?> monitorarEmprestimo(String id) =>
      _baseService.monitorarEmprestimo(id);

  // ============================================================================
  // Ações de Empréstimo (EmprestimoActionService)
  // ============================================================================

  Future<void> confirmarEmprestimo(String id, String atendenteId) =>
      _actionService.confirmarEmprestimo(id, atendenteId);

  Future<void> recusarEmprestimo(String id, {String? motivo}) =>
      _actionService.recusarEmprestimo(id, motivo: motivo);

  Future<void> devolverEmprestimo(String id, String atendenteId) =>
      _actionService.devolverEmprestimo(id, atendenteId);

  // ============================================================================
  // Monitoramento em Tempo Real (EmprestimoMonitorService)
  // ============================================================================

  Stream<List<EmprestimoModel>> monitorarEmprestimosAtivos(String userId) =>
      _monitorService.monitorarEmprestimosAtivos(userId);

  Stream<List<EmprestimoModel>> monitorarEmprestimosAtivosPorBloco(String bloco) =>
      _monitorService.monitorarEmprestimosAtivosPorBloco(bloco);

  Stream<List<EmprestimoModel>> monitorarEmprestimosPendentes() =>
      _monitorService.monitorarEmprestimosPendentes();

  Stream<List<EmprestimoModel>> monitorarTodosEmprestimosPorBloco(String bloco) =>
      _monitorService.monitorarTodosEmprestimosPorBloco(bloco);

  Stream<List<EmprestimoModel>> monitorarTodosEmprestimosPorBlocoSemFiltro(String bloco) =>
      _monitorService.monitorarTodosEmprestimosPorBlocoSemFiltro(bloco);

  Stream<List<EmprestimoModel>> monitorarEmprestimosPorBlocoEDia(String bloco, DateTime dia) =>
      _monitorService.monitorarEmprestimosPorBlocoEDia(bloco, dia);

  // ============================================================================
  // Estatísticas e Contadores (EmprestimoStatsService)
  // ============================================================================

  Future<int> contarEmprestimosRealizadosHoje(String bloco) =>
      _statsService.contarEmprestimosRealizadosHoje(bloco);

  Future<int> contarEmprestimosDevolvidosHoje(String bloco) =>
      _statsService.contarEmprestimosDevolvidosHoje(bloco);

  Future<int> contarEmprestimosAtrasados(String bloco) =>
      _statsService.contarEmprestimosAtrasados(bloco);

  Future<List<EmprestimoModel>> listarEmprestimosAtrasadosDevolvidosHoje(String bloco) =>
      _statsService.listarEmprestimosAtrasadosDevolvidosHoje(bloco);

  Future<List<EmprestimoModel>> listarEmprestimosAtrasadosAtivos(String bloco) =>
      _statsService.listarEmprestimosAtrasadosAtivos(bloco);

  Future<List<EmprestimoModel>> listarEmprestimosRealizadosHoje(String bloco) =>
      _statsService.listarEmprestimosRealizadosHoje(bloco);

  Future<List<EmprestimoModel>> listarEmprestimosDevolvidosHoje(String bloco) =>
      _statsService.listarEmprestimosDevolvidosHoje(bloco);

  // ============================================================================
  // Queries Avançadas por Data - Admin (EmprestimoQueryService)
  // ============================================================================

  Future<List<EmprestimoModel>> listarEmprestimosRealizadosPorData(String bloco, DateTime data) =>
      _queryService.listarEmprestimosRealizadosPorData(bloco, data);

  Future<List<EmprestimoModel>> listarEmprestimosRealizadosPorIntervalo(
    String bloco,
    DateTime dataInicio,
    DateTime dataFim,
  ) => _queryService.listarEmprestimosRealizadosPorIntervalo(bloco, dataInicio, dataFim);

  Future<List<EmprestimoModel>> listarEmprestimosDevolvidosPorData(String bloco, DateTime data) =>
      _queryService.listarEmprestimosDevolvidosPorData(bloco, data);

  Future<List<EmprestimoModel>> listarEmprestimosDevolvidosPorIntervalo(
    String bloco,
    DateTime dataInicio,
    DateTime dataFim,
  ) => _queryService.listarEmprestimosDevolvidosPorIntervalo(bloco, dataInicio, dataFim);

  Future<List<EmprestimoModel>> listarEmprestimosAtrasadosDevolvidosPorData(String bloco, DateTime data) =>
      _queryService.listarEmprestimosAtrasadosDevolvidosPorData(bloco, data);

  Future<List<EmprestimoModel>> listarEmprestimosAtrasadosDevolvidosPorIntervalo(
    String bloco,
    DateTime dataInicio,
    DateTime dataFim,
  ) => _queryService.listarEmprestimosAtrasadosDevolvidosPorIntervalo(bloco, dataInicio, dataFim);

  Future<List<EmprestimoModel>> listarEmprestimosAtrasadosAtivosPorData(String bloco, DateTime data) =>
      _queryService.listarEmprestimosAtrasadosAtivosPorData(bloco, data);

  Future<List<EmprestimoModel>> listarEmprestimosAtrasadosAtivosNaData(String bloco, DateTime data) =>
      _queryService.listarEmprestimosAtrasadosAtivosNaData(bloco, data);
}
