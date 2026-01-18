class User {
  const User({
    required this.id,
    this.name,
  });

  const User.empty()
      : id = '',
        name = null;

  final String id;
  final String? name;

  User copyWith({
    String? id,
    String? name,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  String toString() => 'User(id: $id, name: $name)';
}
