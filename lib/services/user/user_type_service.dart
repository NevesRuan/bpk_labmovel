import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

// servico para gerenciamento de tipos de usuario
class UserTypeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'users';

  // obtem todos os tipos de um usuario
  Future<List<String>> getUserTypes(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection(_collection).doc(uid).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['tipos_usuario'] != null) {
          return List<String>.from(data['tipos_usuario']);
        }
      }
      return ['user'];
    } catch (e) {
      return ['user'];
    }
  }

  // verifica se um usuario possui um tipo especifico
  Future<bool> hasUserType(String uid, String type) async {
    try {
      final types = await getUserTypes(uid);
      return types.contains(type);
    } catch (e) {
      return false;
    }
  }

  // adiciona um tipo ao usuario
  // parametros: [uid] id do usuario
  /// - [type]: Tipo a adicionar
  /// 
  /// Throws: Exception em caso de erro
  Future<void> addUserType(String uid, String type) async {
    try {
      final doc = await _db.collection(_collection).doc(uid).get();
      
      if (!doc.exists) {
        throw Exception('Usuário não encontrado');
      }

      final userData = doc.data() as Map<String, dynamic>;
      final currentTypes = userData['tipos_usuario'] != null
          ? List<String>.from(userData['tipos_usuario'])
          : ['user'];

      if (!currentTypes.contains(type)) {
        currentTypes.add(type);
        await _db.collection(_collection).doc(uid).update({
          'tipos_usuario': currentTypes,
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Remove um tipo do usuário
  /// 
  /// Se após a remoção o usuário ficar sem tipos, adiciona 'user' automaticamente.
  /// 
  /// Parâmetros:
  /// - [uid]: ID do usuário
  /// - [type]: Tipo a remover
  /// 
  /// Throws: Exception em caso de erro
  Future<void> removeUserType(String uid, String type) async {
    try {
      final doc = await _db.collection(_collection).doc(uid).get();
      
      if (!doc.exists) {
        throw Exception('Usuário não encontrado');
      }

      final userData = doc.data() as Map<String, dynamic>;
      final currentTypes = userData['tipos_usuario'] != null
          ? List<String>.from(userData['tipos_usuario'])
          : ['user'];

      if (currentTypes.contains(type)) {
        currentTypes.remove(type);

        // Se ficar sem tipos, adiciona 'user' como padrão
        if (currentTypes.isEmpty) {
          currentTypes.add('user');
        }

        await _db.collection(_collection).doc(uid).update({
          'tipos_usuario': currentTypes,
        });
      }
    } catch (e) {
      rethrow;
    }
  }
}
