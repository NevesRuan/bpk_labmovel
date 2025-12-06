import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/emprestimo_model.dart';

// servico para queries avancadas de emprestimos por data (admin)
class EmprestimoQueryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'emprestimos';

  // lista emprestimos confirmados realizados em uma data especifica
  Future<List<EmprestimoModel>> listarEmprestimosRealizadosPorData(
    String bloco,
    DateTime data,
  ) async {
    final inicioDia = DateTime(data.year, data.month, data.day);
    final fimDia = inicioDia.add(const Duration(days: 1));

    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('bloco', isEqualTo: bloco)
          .where('confirmado', isEqualTo: true)
          .get();

      final emprestimos = querySnapshot.docs
          .map((doc) => EmprestimoModel.fromJson(doc.data(), docId: doc.id))
          .where((emprestimo) =>
              emprestimo.criadoEm.isAfter(inicioDia.subtract(const Duration(seconds: 1))) &&
              emprestimo.criadoEm.isBefore(fimDia))
          .toList();

      return emprestimos;
    } catch (e) {
      throw Exception('Erro ao listar empréstimos realizados por data: $e');
    }
  }

  // lista emprestimos confirmados realizados em um intervalo de datas
  Future<List<EmprestimoModel>> listarEmprestimosRealizadosPorIntervalo(
    String bloco,
    DateTime dataInicio,
    DateTime dataFim,
  ) async {
    try {
      var query = _firestore
          .collection(_collection)
          .where('confirmado', isEqualTo: true)
          .where('criadoEm', isGreaterThanOrEqualTo: Timestamp.fromDate(dataInicio))
          .where('criadoEm', isLessThan: Timestamp.fromDate(dataFim));

      if (bloco != 'Todos') {
        query = query.where('bloco', isEqualTo: bloco);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) => EmprestimoModel.fromJson(doc.data(), docId: doc.id))
          .toList();
    } catch (e) {
      throw Exception('Erro ao listar empréstimos realizados por intervalo: $e');
    }
  }

  /// Lista empréstimos devolvidos (no prazo) em uma data específica
  /// 
  /// Parâmetros:
  /// - [bloco]: Nome do bloco
  /// - [data]: Data para filtrar
  /// 
  // lista emprestimos devolvidos no prazo em uma data especifica
  Future<List<EmprestimoModel>> listarEmprestimosDevolvidosPorData(
    String bloco,
    DateTime data,
  ) async {
    final inicioDia = DateTime(data.year, data.month, data.day);
    final fimDia = inicioDia.add(const Duration(days: 1));

    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('bloco', isEqualTo: bloco)
          .where('devolvido', isEqualTo: true)
          .get();

      final emprestimos = querySnapshot.docs
          .map((doc) => EmprestimoModel.fromJson(doc.data(), docId: doc.id))
          .where((emprestimo) =>
              emprestimo.devolvidoEm != null &&
              emprestimo.devolvidoEm!.isAfter(inicioDia.subtract(const Duration(seconds: 1))) &&
              emprestimo.devolvidoEm!.isBefore(fimDia) &&
              emprestimo.atrasado == false)
          .toList();

      return emprestimos;
    } catch (e) {
      throw Exception('Erro ao listar empréstimos devolvidos por data: $e');
    }
  }

  // lista emprestimos devolvidos no prazo em um intervalo de datas
  Future<List<EmprestimoModel>> listarEmprestimosDevolvidosPorIntervalo(
    String bloco,
    DateTime dataInicio,
    DateTime dataFim,
  ) async {
    try {
      var query = _firestore
          .collection(_collection)
          .where('devolvido', isEqualTo: true)
          .where('atrasado', isEqualTo: false)
          .where('devolvidoEm', isGreaterThanOrEqualTo: Timestamp.fromDate(dataInicio))
          .where('devolvidoEm', isLessThan: Timestamp.fromDate(dataFim));

      if (bloco != 'Todos') {
        query = query.where('bloco', isEqualTo: bloco);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) => EmprestimoModel.fromJson(doc.data(), docId: doc.id))
          .toList();
    } catch (e) {
      throw Exception('Erro ao listar empréstimos devolvidos por intervalo: $e');
    }
  }

  // lista emprestimos atrasados devolvidos em uma data especifica
  Future<List<EmprestimoModel>> listarEmprestimosAtrasadosDevolvidosPorData(
    String bloco,
    DateTime data,
  ) async {
    final inicioDia = DateTime(data.year, data.month, data.day);
    final fimDia = inicioDia.add(const Duration(days: 1));

    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('bloco', isEqualTo: bloco)
          .where('devolvido', isEqualTo: true)
          .where('atrasado', isEqualTo: true)
          .get();

      final emprestimos = querySnapshot.docs
          .map((doc) => EmprestimoModel.fromJson(doc.data(), docId: doc.id))
          .where((emprestimo) =>
              emprestimo.devolvidoEm != null &&
              emprestimo.devolvidoEm!.isAfter(inicioDia.subtract(const Duration(seconds: 1))) &&
              emprestimo.devolvidoEm!.isBefore(fimDia))
          .toList();

      return emprestimos;
    } catch (e) {
      throw Exception('Erro ao listar empréstimos atrasados devolvidos por data: $e');
    }
  }

  /// Lista empréstimos atrasados devolvidos em um intervalo de datas
  /// 
  /// Parâmetros:
  /// - [bloco]: Nome do bloco ou 'Todos'
  /// - [dataInicio]: Data inicial do intervalo
  /// - [dataFim]: Data final do intervalo
  /// 
  /// Retorna: Lista de empréstimos atrasados devolvidos no intervalo
  Future<List<EmprestimoModel>> listarEmprestimosAtrasadosDevolvidosPorIntervalo(
    String bloco,
    DateTime dataInicio,
    DateTime dataFim,
  ) async {
    try {
      var query = _firestore
          .collection(_collection)
          .where('devolvido', isEqualTo: true)
          .where('atrasado', isEqualTo: true)
          .where('devolvidoEm', isGreaterThanOrEqualTo: Timestamp.fromDate(dataInicio))
          .where('devolvidoEm', isLessThan: Timestamp.fromDate(dataFim));

      if (bloco != 'Todos') {
        query = query.where('bloco', isEqualTo: bloco);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) => EmprestimoModel.fromJson(doc.data(), docId: doc.id))
          .toList();
    } catch (e) {
      throw Exception('Erro ao listar empréstimos atrasados devolvidos por intervalo: $e');
    }
  }

  /// Lista empréstimos atrasados ativos em uma data específica
  /// 
  /// Retorna empréstimos cujo prazo de devolução é anterior à data fornecida
  /// e que ainda não foram devolvidos
  /// 
  /// Parâmetros:
  /// - [bloco]: Nome do bloco
  /// - [data]: Data para verificar se estão atrasados
  /// 
  /// Retorna: Lista de empréstimos atrasados ativos na data
  Future<List<EmprestimoModel>> listarEmprestimosAtrasadosAtivosPorData(
    String bloco,
    DateTime data,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('bloco', isEqualTo: bloco)
          .where('devolvido', isEqualTo: false)
          .get();

      final emprestimos = querySnapshot.docs
          .map((doc) => EmprestimoModel.fromJson(doc.data(), docId: doc.id))
          .where((emprestimo) {
            final prazoLimite = emprestimo.prazoLimiteDevolucao;
            return prazoLimite.isBefore(data);
          })
          .toList();

      return emprestimos;
    } catch (e) {
      throw Exception('Erro ao listar empréstimos atrasados ativos por data: $e');
    }
  }

  /// Lista empréstimos atrasados ativos em uma data específica (query otimizada)
  /// 
  /// Versão otimizada usando query do Firebase
  /// 
  /// Parâmetros:
  /// - [bloco]: Nome do bloco ou 'Todos'
  /// - [data]: Data para verificar se estão atrasados
  /// 
  /// Retorna: Lista de empréstimos atrasados ativos na data
  Future<List<EmprestimoModel>> listarEmprestimosAtrasadosAtivosNaData(
    String bloco,
    DateTime data,
  ) async {
    try {
      var query = _firestore
          .collection(_collection)
          .where('devolvido', isEqualTo: false)
          .where('prazoLimiteDevolucao', isLessThan: Timestamp.fromDate(data));

      if (bloco != 'Todos') {
        query = query.where('bloco', isEqualTo: bloco);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) => EmprestimoModel.fromJson(doc.data(), docId: doc.id))
          .toList();
    } catch (e) {
      throw Exception('Erro ao listar empréstimos atrasados ativos na data: $e');
    }
  }
}
