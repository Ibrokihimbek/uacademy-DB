const String userTable = "cached_user";

class CachedUsersFields {
  static final List<String> values = [
    /// Add all fields
    id, userName, age,
  ];
  static const String id = "_id";
  static const String userName = "user_name";
  static const String age = "age";
}


class CachedUser {
  final int? id;
  final int age;
  final String userName;

  CachedUser({
    this.id,
    required this.age,
    required this.userName,
  });

  CachedUser copyWith({
    int? id,
    int? age,
    String? userName,
  }) =>
      CachedUser(
        id: id ?? this.id,
        userName: userName ?? this.userName,
        age: age ?? this.age,
      );

  static CachedUser fromJson(Map<String, Object?> json) => CachedUser(
    id: json[CachedUsersFields.id] as int?,
    userName: json[CachedUsersFields.userName] as String,
    age: json[CachedUsersFields.age] as int,
  );

  Map<String, Object?> toJson() => {
    CachedUsersFields.id: id,
    CachedUsersFields.userName: userName,
    CachedUsersFields.age: age,
  };
}