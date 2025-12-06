import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/emprestimo_model.dart';
import '../../utils/brasilia_time.dart';
import '../equipamento_service.dart';

// servico base para operacoes crud de emprestimos
// cria, busca, atualiza, deleta e limpa emprestimos
class EmprestimoBaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final EquipamentoService _equipamentoService = EquipamentoService();
  final String _collection = 'emprestimos';

  // cria um novo emprestimo no firestore e retorna o modelo com o id gerado
  Future<EmprestimoModel> criarEmprestimo(EmprestimoModel emprestimo) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(emprestimo.toJson());

      return emprestimo.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Erro ao criar empréstimo: $e');
    }
  }

  // busca um emprestimo por id
  Future<EmprestimoModel?> buscarEmprestimo(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();

      if (!doc.exists) {
        return null;
      }

      return EmprestimoModel.fromJson(doc.data()!, docId: doc.id);
    } catch (e) {
      throw Exception('Erro ao buscar empréstimo: $e');
    }
  }

  // atualiza campos especificos de um emprestimo
  Future<void> atualizarEmprestimo(String id, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(_collection).doc(id).update(updates);
    } catch (e) {
      throw Exception('Erro ao atualizar empréstimo: $e');
    }
  }

  // atualiza isBlocoCorreto
  Future<void> atualizarIsBlocoCorreto(String id, bool isBlocoCorreto) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'isBlocoCorreto': isBlocoCorreto,
      });
    } catch (e) {
      throw Exception('Erro ao atualizar bloco correto: $e');
    }
  }

  // deleta um emprestimo
  Future<void> deletarEmprestimo(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao deletar empréstimo: $e');
    }
  }

  // limpa emprestimos antigos (nao confirmados com mais de 24h)
  Future<void> limparEmprestimosAntigos() async {
    try {
      final dataLimite = DateTime.now().subtract(const Duration(hours: 24));
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('confirmado', isEqualTo: null)
          .where('criadoEm', isLessThan: Timestamp.fromDate(dataLimite))
          .get();

      final batch = _firestore.batch();
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Erro ao limpar empréstimos antigos: $e');
    }
  }

  // lista todos os emprestimos de um usuario
  Future<List<EmprestimoModel>> listarEmprestimosPorUsuario(
    String userId,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('criadoEm', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => EmprestimoModel.fromJson(doc.data(), docId: doc.id))
          .toList();
    } catch (e) {
      throw Exception('Erro ao listar empréstimos: $e');
    }
  }

  // monitora o status de um emprestimo em tempo real
  Stream<EmprestimoModel?> monitorarEmprestimo(String id) {
    return _firestore.collection(_collection).doc(id).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists) {
        return null;
      }
      return EmprestimoModel.fromJson(snapshot.data()!, docId: snapshot.id);
    });
  }
}
