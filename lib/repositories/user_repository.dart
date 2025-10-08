import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexa/models/user_model.dart';

class UserRepository {
  final _firestore = FirebaseFirestore.instance;
  String collection = 'users';

  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection(collection).doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
    } catch (e) {
      print('[user repository] Error al obtener user: $e');
    }
    return null;
  }

  Future<void> saveUser(UserModel user) async {
    try {
      await _firestore.collection(collection).add(user.toMap());
    } catch (e) {
      print('[User repository] Error al guardar usuario: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(collection).doc(userId).delete();
    } catch (e) {
      print('[User repository] Error al borrar user: $e');
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection(collection).get();

      final userList = querySnapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data(), doc.id);
      }).toList();

      return userList;
    } catch (e) {
      print('[User repository] Error al obtener usuarios: $e');
      return [];
    }
  }
}
