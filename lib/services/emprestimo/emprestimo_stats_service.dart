import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/emprestimo_model.dart';
import '../../utils/brasilia_time.dart';

// servico para estatisticas e contadores de emprestimos
class EmprestimoStatsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'emprestimos';

  // conta emprestimos confirmados hoje no bloco
  Future<int> contarEmprestimosRealizadosHoje(String bloco) async {
    final hoje = BrasiliaTime.now();
    final inicioDia = DateTime(hoje.year, hoje.month, hoje.day);
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

      return emprestimos.length;
    } catch (e) {
      throw Exception('Erro ao contar empréstimos realizados hoje: $e');
    }
  }

  // conta emprestimos devolvidos hoje no bloco (apenas no prazo)
  Future<int> contarEmprestimosDevolvidosHoje(String bloco) async {
    final hoje = BrasiliaTime.now();
    final inicioDia = DateTime(hoje.year, hoje.month, hoje.day);
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

      return emprestimos.length;
    } catch (e) {
      throw Exception('Erro ao contar empréstimos devolvidos hoje: $e');
    }
  }

  /// Conta empréstimos atrasados ativos no bloco
  /// 
  /// Inclui apenas empréstimos:
  /// - Confirmados (confirmado == true)
  /// - Não devolvidos (devolvido != true)
  /// - Com prazo vencido (isAtrasadoAtual == true)
  // conta emprestimos atrasados ativos no bloco
  Future<int> contarEmprestimosAtrasados(String bloco) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('bloco', isEqualTo: bloco)
          .where('confirmado', isEqualTo: true)
          .where('devolvido', isNotEqualTo: true)
          .get();

      final emprestimos = querySnapshot.docs
          .map((doc) => EmprestimoModel.fromJson(doc.data(), docId: doc.id))
          .where((emprestimo) => emprestimo.isAtrasadoAtual)
          .toList();

      return emprestimos.length;
    } catch (e) {
      throw Exception('Erro ao contar empréstimos atrasados: $e');
    }
  }

  // lista emprestimos atrasados devolvidos hoje no bloco
  Future<List<EmprestimoModel>> listarEmprestimosAtrasadosDevolvidosHoje(String bloco) async {
    final hoje = BrasiliaTime.now();
    final inicioDia = DateTime(hoje.year, hoje.month, hoje.day);
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
      throw Exception('Erro ao listar empréstimos atrasados devolvidos hoje: $e');
    }
  }

  // lista emprestimos atrasados ativos no bloco
  Future<List<EmprestimoModel>> listarEmprestimosAtrasadosAtivos(String bloco) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('bloco', isEqualTo: bloco)
          .where('confirmado', isEqualTo: true)
          .where('devolvido', isNotEqualTo: true)
          .get();

      final emprestimos = querySnapshot.docs
          .map((doc) => EmprestimoModel.fromJson(doc.data(), docId: doc.id))
          .where((emprestimo) => emprestimo.isAtrasadoAtual)
          .toList();

      return emprestimos;
    } catch (e) {
      throw Exception('Erro ao listar empréstimos atrasados ativos: $e');
    }
  }

  /// Lista empréstimos confirmados realizados hoje no bloco
  /// 
  /// Inclui todos os empréstimos do dia, mesmo os que estão atrasados
  /// 
  /// Parâmetros:
  /// - [bloco]: Nome do bloco
  /// 
  /// Retorna: Lista de empréstimos realizados hoje
  Future<List<EmprestimoModel>> listarEmprestimosRealizadosHoje(String bloco) async {
    final hoje = BrasiliaTime.now();
    final inicioDia = DateTime(hoje.year, hoje.month, hoje.day);
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
      throw Exception('Erro ao listar empréstimos realizados hoje: $e');
    }
  }

  /// Lista empréstimos devolvidos hoje no bloco (apenas no prazo correto)
  /// 
  /// Não inclui empréstimos atrasados
  /// 
  /// Parâmetros:
  /// - [bloco]: Nome do bloco
  /// 
  /// Retorna: Lista de empréstimos devolvidos hoje no prazo
  Future<List<EmprestimoModel>> listarEmprestimosDevolvidosHoje(String bloco) async {
    final hoje = BrasiliaTime.now();
    final inicioDia = DateTime(hoje.year, hoje.month, hoje.day);
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
      throw Exception('Erro ao listar empréstimos devolvidos hoje: $e');
    }
  }
}
