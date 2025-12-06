/// Serviço principal de gerenciamento de usuários
/// 
/// Este arquivo agrega todos os sub-serviços de usuário em uma única interface,
/// mantendo a compatibilidade com o código existente.
/// 
/// Estrutura modular:
/// - [UserBaseService]: Operações CRUD básicas
/// - [UserTypeService]: Gerenciamento de tipos de usuário
/// - [UserQueryService]: Buscas e filtros avançados
/// - [UserPendenciaService]: Verificação e gerenciamento de pendências
/// 
/// Exemplo de uso:
/// ```dart
/// final service = UserService();
/// await service.createUser(uid: uid, email: email, ...);
/// final user = await service.getUser(uid);
/// ```

export 'user/user_base_service.dart';
export 'user/user_type_service.dart';
export 'user/user_query_service.dart';
export 'user/user_pendencia_service.dart';

import '../models/user_model.dart';
import 'user/user_base_service.dart';
import 'user/user_type_service.dart';
import 'user/user_query_service.dart';
import 'user/user_pendencia_service.dart';

/// Serviço unificado de usuários
/// 
/// Agrega todos os sub-serviços em uma única classe para facilitar o uso
/// e manter compatibilidade com código existente.
class UserService {
  // Instâncias dos sub-serviços
  final UserBaseService _baseService = UserBaseService();
  final UserTypeService _typeService = UserTypeService();
  final UserQueryService _queryService = UserQueryService();
  final UserPendenciaService _pendenciaService = UserPendenciaService();

  // ============================================================================
  // Operações CRUD Básicas (UserBaseService)
  // ============================================================================

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
  }) => _baseService.createUser(
    uid: uid,
    email: email,
    nome: nome,
    sobrenome: sobrenome,
    dataNasc: dataNasc,
    tiposUsuario: tiposUsuario,
    foto: foto,
    registroAcademico: registroAcademico,
    numCracha: numCracha,
    curso: curso,
    semestre: semestre,
  );

  Future<UserModel?> getUser(String uid) =>
      _baseService.getUser(uid);

  Stream<UserModel?> streamUser(String uid) =>
      _baseService.streamUser(uid);

  Future<void> updateUser(String uid, Map<String, dynamic> data) =>
      _baseService.updateUser(uid, data);

  Future<void> updateLastLogin(String uid) =>
      _baseService.updateLastLogin(uid);

  Future<void> deactivateUser(String uid) =>
      _baseService.deactivateUser(uid);

  Future<bool> userExists(String uid) =>
      _baseService.userExists(uid);

  Future<Map<String, UserModel>> getUsersMap(Set<String> userIds) =>
      _baseService.getUsersMap(userIds);

  // ============================================================================
  // Gerenciamento de Tipos (UserTypeService)
  // ============================================================================

  Future<List<String>> getUserTypes(String uid) =>
      _typeService.getUserTypes(uid);

  Future<bool> hasUserType(String uid, String type) =>
      _typeService.hasUserType(uid, type);

  Future<void> addUserType(String uid, String type) =>
      _typeService.addUserType(uid, type);

  Future<void> removeUserType(String uid, String type) =>
      _typeService.removeUserType(uid, type);

  // ============================================================================
  // Buscas e Filtros (UserQueryService)
  // ============================================================================

  Future<List<UserModel>> getUsersByType(String type) =>
      _queryService.getUsersByType(type);

  Future<List<UserModel>> getAlunos() =>
      _queryService.getAlunos();

  Future<List<UserModel>> getAtendentes() =>
      _queryService.getAtendentes();

  Future<UserModel?> getUserByRA(String ra) =>
      _queryService.getUserByRA(ra);

  Future<UserModel?> getUserByCracha(String cracha) =>
      _queryService.getUserByCracha(cracha);

  Future<bool> raExists(String ra) =>
      _queryService.raExists(ra);

  Future<bool> crachaExists(String cracha) =>
      _queryService.crachaExists(cracha);

  // ============================================================================
  // Gerenciamento de Pendências (UserPendenciaService)
  // ============================================================================

  Future<void> verificarEAtualizarPendencias(String uid) =>
      _pendenciaService.verificarEAtualizarPendencias(uid);

  Future<void> marcarComPendencia(String uid) =>
      _pendenciaService.marcarComPendencia(uid);

  Future<void> limparPendencias(String uid) =>
      _pendenciaService.limparPendencias(uid);

  Future<bool> temPendencias(String uid) =>
      _pendenciaService.temPendencias(uid);
}
