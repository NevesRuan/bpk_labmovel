import 'package:cloud_firestore/cloud_firestore.dart';

// servico para verificacao e atualizacao de pendencias de usuarios
class UserPendenciaService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionUsers = 'users';
  final String _collectionEmprestimos = 'emprestimos';

  // verifica e atualiza o status de pendencias de um usuario
  Future<void> verificarEAtualizarPendencias(String uid) async {
    try {
      // busca emprestimos ativos do usuario
      final emprestimosQuery = await _db
          .collection(_collectionEmprestimos)
          .where('userId', isEqualTo: uid)
          .where('confirmado', isEqualTo: true)
          .where('devolvido', isEqualTo: null)
          .get();

      bool temPendencias = false;

      // verifica se algum emprestimo esta atrasado
      for (var doc in emprestimosQuery.docs) {
        final data = doc.data();
        final confirmedoEm = (data['confirmedoEm'] as Timestamp?)?.toDate();

        if (confirmedoEm != null) {
          // calcula prazo limite (22:30 do dia de confirmacao)
          final prazoLimite = DateTime(
            confirmedoEm.year,
            confirmedoEm.month,
            confirmedoEm.day,
            22,
            30,
          );

          // verifica se esta atrasado
          if (DateTime.now().isAfter(prazoLimite)) {
            temPendencias = true;
            break;
          }
        }
      }

      // atualiza o campo compendencias no documento do usuario
      await _db.collection(_collectionUsers).doc(uid).update({
        'comPendencias': temPendencias,
      });
    } catch (e) {
      print('Erro ao verificar pendências: $e');
      rethrow;
    }
  }

  // marca usuario como tendo pendencias
  // parametros:
  /// - [uid]: ID do usuário
  /// 
  /// Throws: Exception em caso de erro
  Future<void> marcarComPendencia(String uid) async {
    try {
      await _db.collection(_collectionUsers).doc(uid).update({
        'comPendencias': true,
      });
    } catch (e) {
      print('Erro ao marcar pendência: $e');
      rethrow;
    }
  }

  /// Remove marca de pendências do usuário
  /// 
  /// Deve ser chamado quando todos os empréstimos atrasados forem devolvidos
  /// 
  /// Parâmetros:
  /// - [uid]: ID do usuário
  /// 
  /// Throws: Exception em caso de erro
  Future<void> limparPendencias(String uid) async {
    try {
      await _db.collection(_collectionUsers).doc(uid).update({
        'comPendencias': false,
      });
    } catch (e) {
      print('Erro ao limpar pendências: $e');
      rethrow;
    }
  }

  /// Verifica se usuário tem pendências (sem atualizar)
  /// 
  /// Retorna o valor atual do campo 'comPendencias'
  /// 
  /// Parâmetros:
  /// - [uid]: ID do usuário
  /// 
  /// Retorna: true se tem pendências, false caso contrário
  Future<bool> temPendencias(String uid) async {
    try {
      final doc = await _db.collection(_collectionUsers).doc(uid).get();
      
      if (!doc.exists) {
        return false;
      }

      final data = doc.data() as Map<String, dynamic>;
      return data['comPendencias'] ?? false;
    } catch (e) {
      print('Erro ao verificar pendências: $e');
      return false;
    }
  }
}
