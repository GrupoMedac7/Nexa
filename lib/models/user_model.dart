import 'package:cloud_firestore/cloud_firestore.dart';

enum Theme {
  dark,
  light,
}

enum Role {
  admin,
  employee,
  user,
}

class UserPreferences {
  final bool notifications;
  final Theme theme;

  const UserPreferences({
    this.notifications = false,
    this.theme = Theme.light,
  });

  @override
  String toString() {
    return 'UserPreferences(notifications: $notifications, theme: ${theme.name})';
  }
}

class UserModel {
  final String uid;
  final String email;
  final String name;
  final UserPreferences preferences;
  final List<Role> roles;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.preferences = const UserPreferences(),
    this.roles = const [Role.user],
    required this.createdAt,
  });

  // Creates a UserModel from a Firestore document
  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      preferences: UserPreferences(
        notifications: data['preferences']['notifications'] ?? false,
        theme: _themeFromString(data['preferences']['theme']),
      ),
      roles: _rolesFromList(data['roles']),
      createdAt: _parseCreatedAt(data['created_at'])
    );
  }

  // Helper function for converting theme preferences to enum Theme
  static Theme _themeFromString(String theme) {
    return theme == 'dark' ? Theme.dark : Theme.light;
  }

  // Helper function for converting user roles from string to enum Role
  static List<Role> _rolesFromList(List<String> strRoles) {
    return strRoles.map<Role>((e) {
      return Role.values.firstWhere(
        (role) => role.name == e,
        orElse: () => Role.user,
      );
    }).toList();
  }

  static DateTime _parseCreatedAt(dynamic createdAt) {
    if (createdAt is Timestamp) {
      return createdAt.toDate();
    }
    else if (createdAt is String && DateTime.tryParse(createdAt) != null) {
      return DateTime.parse(createdAt);
    } else {
      return DateTime.now();
    }
  }

  // Convert UserModel to map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'preferences': preferences,
      'roles': roles,
      'created_at': Timestamp.fromDate(createdAt)
    };
  }

  // Copy a UserModel with updated fields
  UserModel copyWith({
    String? email,
    String? name,
    UserPreferences? preferences,
    List<Role>? roles,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid,
      email: email ?? this.email,
      name: name ?? this.name,
      preferences: preferences ?? this.preferences,
      roles: roles ?? this.roles,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Usermodel(uid: $uid, email: $email, name: $name, preferences: $preferences, roles: $roles, createdAt: $createdAt)';
  }
}