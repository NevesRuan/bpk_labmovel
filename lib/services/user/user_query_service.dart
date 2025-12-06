import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

// servico para buscar e filtrar usuarios
class UserQueryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'users';

  // busca usuarios por tipo especifico (apenas ativos)
  Future<List<UserModel>> getUsersByType(String type) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection(_collection)
          .where('tipos_usuario', arrayContains: type)
          .where('ativo', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // busca todos os alunos ativos
  Future<List<UserModel>> getAlunos() async {
    try {
      QuerySnapshot snapshot = await _db
          .collection(_collection)
          .where('tipos_usuario', arrayContains: 'user')
          .where('ativo', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .where((user) => user.isAluno)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // busca todos os atendentes ativos
  Future<List<UserModel>> getAtendentes() async {
    try {
      return await getUsersByType('atendente');
    } catch (e) {
      rethrow;
    }
  }

  /// Busca usuário por Registro Acadêmico (RA)
  /// 
  /// Parâmetros:
  /// - [ra]: Registro Acadêmico do aluno
  /// 
  /// Retorna: UserModel se encontrado, null caso contrário
  Future<UserModel?> getUserByRA(String ra) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection(_collection)
          .where('registro_academico', isEqualTo: ra)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return UserModel.fromFirestore(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Busca usuário por número de crachá
  /// 
  /// Parâmetros:
  /// - [cracha]: Número do crachá
  /// 
  /// Retorna: UserModel se encontrado, null caso contrário
  Future<UserModel?> getUserByCracha(String cracha) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection(_collection)
          .where('numCracha', isEqualTo: cracha)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return UserModel.fromFirestore(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Verifica se um RA já está cadastrado no sistema
  /// 
  /// Útil para validação antes de criar novo usuário
  /// 
  /// Parâmetros:
  /// - [ra]: Registro Acadêmico a verificar
  /// 
  /// Retorna: true se o RA já existe, false caso contrário
  Future<bool> raExists(String ra) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection(_collection)
          .where('registro_academico', isEqualTo: ra)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Verifica se um número de crachá já está cadastrado no sistema
  /// 
  /// Útil para validação antes de criar novo usuário
  /// 
  /// Parâmetros:
  /// - [cracha]: Número do crachá a verificar
  /// 
  /// Retorna: true se o crachá já existe, false caso contrário
  Future<bool> crachaExists(String cracha) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection(_collection)
          .where('numCracha', isEqualTo: cracha)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
