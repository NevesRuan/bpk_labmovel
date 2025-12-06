import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/emprestimo_model.dart';
import '../../utils/brasilia_time.dart';
import '../equipamento_service.dart';

// servico para acoes de emprestimo (confirmar, recusar, devolver)
class EmprestimoActionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final EquipamentoService _equipamentoService = EquipamentoService();
  final String _collection = 'emprestimos';

  // confirma um emprestimo
  Future<void> confirmarEmprestimo(String id, String atendenteId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();

      if (!doc.exists) {
        throw Exception('Empréstimo não encontrado');
      }

      final emprestimo = EmprestimoModel.fromJson(doc.data()!, docId: doc.id);

      // pega o bloco do emprestimo do equipamento para registro no banco
      String? bloco;
      if (emprestimo.codigosEquipamentos.isNotEmpty) {
        final equipamento = await _equipamentoService.buscarPorCodigo(
          emprestimo.codigosEquipamentos.first,
        );
        bloco = equipamento?.bloco;
      }

      // atualiza o status do emprestimo
      await _firestore.collection(_collection).doc(id).update({
        'confirmado': true,
        'confirmedoEm': Timestamp.fromDate(BrasiliaTime.now()),
        'atendenteEmprestimoId': atendenteId,
        'bloco': bloco,
      });

      // atualiza o estado de cada equipamento emprestado
      for (final codigoEquipamento in emprestimo.codigosEquipamentos) {
        await _equipamentoService.atualizarEstadoEmprestimo(
          codigoEquipamento,
          true,
        );
      }
    } catch (e) {
      throw Exception('Erro ao confirmar empréstimo: $e');
    }
  }

  // recusa um emprestimo
  Future<void> recusarEmprestimo(String id, {String? motivo}) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'confirmado': false,
        'confirmedoEm': Timestamp.fromDate(BrasiliaTime.now()),
        'motivoRecusa': motivo,
      });
    } catch (e) {
      throw Exception('Erro ao recusar empréstimo: $e');
    }
  }

  // devolve um emprestimo (finaliza)
  Future<void> devolverEmprestimo(String id, String atendenteId) async {
    try {
      // busca o emprestimo
      final doc = await _firestore.collection(_collection).doc(id).get();

      if (!doc.exists) {
        throw Exception('Empréstimo não encontrado');
      }

      final emprestimo = EmprestimoModel.fromJson(doc.data()!, docId: doc.id);

      // verifica se esta atrasado
      final agora = BrasiliaTime.now();
      final atrasado = agora.isAfter(emprestimo.prazoLimiteDevolucao);

      // atualiza o status do emprestimo
      await _firestore.collection(_collection).doc(id).update({
        'devolvido': true,
        'devolvidoEm': Timestamp.fromDate(agora),
        'atendenteDevolucaoId': atendenteId,
        'atrasado': atrasado,
      });

      // libera cada equipamento (estado_emprestado = false)
      for (final codigoEquipamento in emprestimo.codigosEquipamentos) {
        await _equipamentoService.atualizarEstadoEmprestimo(
          codigoEquipamento,
          false,
        );
      }
    } catch (e) {
      throw Exception('Erro ao devolver empréstimo: $e');
    }
  }
}
