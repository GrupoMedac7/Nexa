import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexa/models/user_model.dart';
import 'package:nexa/services/logger.dart';

class UserRepository {
  final _firestore = FirebaseFirestore.instance;
  String collection = 'users';

  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection(collection).doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
    } catch (e, stacktrace) {
      String error = '[user repository] Error al obtener user: $e';
      Logger.error(error, stacktrace);
    }
    return null;
  }

  Future<void> saveUser(UserModel user) async {
    try {
      await _firestore.collection(collection).add(user.toMap());
    } catch (e, stacktrace) {
      String error = '[User repository] Error al guardar usuario: $e';
      Logger.error(error, stacktrace);
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(collection).doc(userId).delete();
    } catch (e, stacktrace) {
      String error = '[User repository] Error al borrar user: $e';
      Logger.error(error, stacktrace);
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection(collection).get();

      final userList = querySnapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data(), doc.id);
      }).toList();

      return userList;
    } catch (e, stacktrace) {
      String error = '[User repository] Error al obtener usuarios: $e';
      Logger.error(error, stacktrace);
      return [];
    }
  }
}
