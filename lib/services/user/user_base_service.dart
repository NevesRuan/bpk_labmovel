import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

// servico base para operacoes crud de usuarios
class UserBaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'users';

  // cria um novo usuario no firestore apos registro no authentication
  Future<void> createUser({
    required String uid,
    required String email,
    required String nome,
    required String sobrenome,
    required String dataNasc,
    List<String> tiposUsuario = const ['user'],
    String? foto,
    String? registroAcademico,
    String? numCracha,
    String? curso,
    int? semestre,
  }) async {
    try {
      final nomeCompleto = '$nome $sobrenome';

      await _db.collection(_collection).doc(uid).set({
        'email': email,
        'nome': nome,
        'sobrenome': sobrenome,
        'nome_completo': nomeCompleto,
        'data_nasc': dataNasc,
        'tipos_usuario': tiposUsuario,
        'ativo': true,
        'foto': foto,
        'registro_academico': registroAcademico,
        'numCracha': numCracha,
        'curso': curso,
        'semestre': semestre,
        'comPendencias': false,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Busca um usuário específico por ID
  /// 
  /// Parâmetros:
  /// - [uid]: ID do usuário
  /// 
  /// Retorna: UserModel se encontrado, null caso contrário
  /// 
  /// Throws: Exception em caso de erro
  Future<UserModel?> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection(_collection).doc(uid).get();

      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Erro ao buscar usuário: $e');
      rethrow;
    }
  }

  /// Monitora um usuário em tempo real
  /// 
  /// Útil para atualizar a UI automaticamente quando os dados do usuário mudam
  /// 
  /// Parâmetros:
  /// - [uid]: ID do usuário
  /// 
  /// Retorna: Stream com UserModel atualizado ou null se não encontrado
  Stream<UserModel?> streamUser(String uid) {
    return _db
        .collection(_collection)
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
  }

  /// Atualiza dados de um usuário
  /// 
  /// Se os campos 'nome' ou 'sobrenome' forem atualizados,
  /// o campo 'nome_completo' é automaticamente recalculado.
  /// 
  /// Parâmetros:
  /// - [uid]: ID do usuário
  /// - [data]: Map com os campos a serem atualizados
  /// 
  /// Throws: Exception em caso de erro
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      // Atualiza nome_completo se nome ou sobrenome foram alterados
      if (data.containsKey('nome') || data.containsKey('sobrenome')) {
        final currentUser = await getUser(uid);
        if (currentUser != null) {
          final nome = data['nome'] ?? currentUser.nome;
          final sobrenome = data['sobrenome'] ?? currentUser.sobrenome;
          data['nome_completo'] = '$nome $sobrenome';
        }
      }

      await _db.collection(_collection).doc(uid).update(data);
    } catch (e) {
      rethrow;
    }
  }

  /// Atualiza a data/hora do último login do usuário
  /// 
  /// Chamado automaticamente ao fazer login
  /// 
  /// Parâmetros:
  /// - [uid]: ID do usuário
  Future<void> updateLastLogin(String uid) async {
    try {
      await _db.collection(_collection).doc(uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Ignora erro silenciosamente
    }
  }

  /// Desativa um usuário (soft delete)
  /// 
  /// O usuário não é removido do banco, apenas marcado como inativo
  /// 
  /// Parâmetros:
  /// - [uid]: ID do usuário
  /// 
  /// Throws: Exception em caso de erro
  Future<void> deactivateUser(String uid) async {
    try {
      await _db.collection(_collection).doc(uid).update({'ativo': false});
    } catch (e) {
      rethrow;
    }
  }

  /// Verifica se um usuário existe no Firestore
  /// 
  /// Parâmetros:
  /// - [uid]: ID do usuário
  /// 
  /// Retorna: true se o usuário existe, false caso contrário
  Future<bool> userExists(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection(_collection).doc(uid).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  /// Busca múltiplos usuários por IDs
  /// 
  /// Utiliza busca em lotes de 10 IDs por vez devido à limitação do Firestore
  /// na query 'whereIn' (máximo de 10 valores).
  /// 
  /// Parâmetros:
  /// - [userIds]: Set com IDs dos usuários a serem buscados
  /// 
  /// Retorna: Map com ID do usuário como chave e UserModel como valor
  Future<Map<String, UserModel>> getUsersMap(Set<String> userIds) async {
    try {
      if (userIds.isEmpty) return {};

      final Map<String, UserModel> usersMap = {};

      // Busca em lote de 10 por conta do limite do Firestore
      const batchSize = 10;
      final batches = <List<String>>[];

      final idsList = userIds.toList();
      for (var i = 0; i < idsList.length; i += batchSize) {
        final end = (i + batchSize < idsList.length) ? i + batchSize : idsList.length;
        batches.add(idsList.sublist(i, end));
      }

      for (final batch in batches) {
        final querySnapshot = await _db
            .collection(_collection)
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        for (final doc in querySnapshot.docs) {
          final user = UserModel.fromFirestore(doc);
          usersMap[doc.id] = user;
        }
      }

      return usersMap;
    } catch (e) {
      print('Erro ao buscar usuários: $e');
      return {};
    }
  }
}
