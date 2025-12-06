import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/emprestimo_model.dart';
import '../../utils/brasilia_time.dart';

// servico para monitoramento em tempo real de emprestimos
class EmprestimoMonitorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'emprestimos';

  // monitora emprestimos ativos de um usuario em tempo real
  Stream<List<EmprestimoModel>> monitorarEmprestimosAtivos(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          // filtra e ordena
          final emprestimos = snapshot.docs
              .map((doc) => EmprestimoModel.fromJson(doc.data(), docId: doc.id))
              .where(
                (emprestimo) =>
                    emprestimo.confirmado == true &&
                    emprestimo.devolvido != true,
              )
              .toList();

          // ordena por data
          emprestimos.sort((a, b) => b.criadoEm.compareTo(a.criadoEm));

          return emprestimos;
        });
  }

  // monitora emprestimos ativos de um bloco especifico (apenas do dia atual)
  Stream<List<EmprestimoModel>> monitorarEmprestimosAtivosPorBloco(String bloco) {
    return _firestore
        .collection(_collection)
        .where('bloco', isEqualTo: bloco)
        .where('confirmado', isEqualTo: true)
        .where('devolvido', isEqualTo: null)
        .snapshots()
        .map((snapshot) {
          final hoje = BrasiliaTime.now();
          final inicioDia = DateTime(hoje.year, hoje.month, hoje.day);
          final fimDia = inicioDia.add(const Duration(days: 1));
          
          final emprestimos = snapshot.docs
              .map((doc) => EmprestimoModel.fromJson(doc.data(), docId: doc.id))
              .where((emprestimo) => 
                emprestimo.isAtivo && 
                emprestimo.criadoEm.isAfter(inicioDia.subtract(const Duration(seconds: 1))) &&
                emprestimo.criadoEm.isBefore(fimDia)
              )
              .toList();
          emprestimos.sort((a, b) => b.criadoEm.compareTo(a.criadoEm));
          return emprestimos;
        });
  }

  // monitora emprestimos pendentes de confirmacao
  Stream<List<EmprestimoModel>> monitorarEmprestimosPendentes() {
    return _firestore
        .collection(_collection)
        .where('confirmado', isEqualTo: null)
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => EmprestimoModel.fromJson(doc.data(), docId: doc.id))
              .toList();
        });
  }

  // monitora todos os emprestimos de um bloco no dia atual
  Stream<List<EmprestimoModel>> monitorarTodosEmprestimosPorBloco(String bloco) {
    final hoje = BrasiliaTime.now();
    final inicioDia = DateTime(hoje.year, hoje.month, hoje.day);
    final fimDia = inicioDia.add(const Duration(days: 1));

    return _firestore
        .collection(_collection)
        .where('bloco', isEqualTo: bloco)
        .where('criadoEm', isGreaterThanOrEqualTo: Timestamp.fromDate(inicioDia))
        .where('criadoEm', isLessThan: Timestamp.fromDate(fimDia))
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .map((snapshot) {
          final emprestimos = snapshot.docs
              .map((doc) => EmprestimoModel.fromJson(doc.data(), docId: doc.id))
              .toList();
          return emprestimos;
        });
  }

  // monitora todos os emprestimos de um bloco sem filtro de data
  Stream<List<EmprestimoModel>> monitorarTodosEmprestimosPorBlocoSemFiltro(String bloco) {
    return _firestore
        .collection(_collection)
        .where('bloco', isEqualTo: bloco)
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .map((snapshot) {
          final emprestimos = snapshot.docs
              .map((doc) => EmprestimoModel.fromJson(doc.data(), docId: doc.id))
              .toList();
          return emprestimos;
        });
  }

  // monitora emprestimos de um bloco em um dia especifico
  Stream<List<EmprestimoModel>> monitorarEmprestimosPorBlocoEDia(String bloco, DateTime dia) {
    final inicioDia = DateTime(dia.year, dia.month, dia.day);
    final fimDia = inicioDia.add(const Duration(days: 1));

    return _firestore
        .collection(_collection)
        .where('bloco', isEqualTo: bloco)
        .where('criadoEm', isGreaterThanOrEqualTo: Timestamp.fromDate(inicioDia))
        .where('criadoEm', isLessThan: Timestamp.fromDate(fimDia))
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .map((snapshot) {
          final emprestimos = snapshot.docs
              .map((doc) => EmprestimoModel.fromJson(doc.data(), docId: doc.id))
              .toList();
          return emprestimos;
        });
  }
}
