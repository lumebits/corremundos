import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:profile_repository/src/entities/entities.dart';
import 'package:uuid/uuid.dart';

@immutable
class Profile extends Equatable {
  Profile({
    required this.uid,
    String? id,
    String? name,
    List<dynamic>? documents,
  })  : id = id ?? const Uuid().v4(),
        name = name ?? '',
        documents = documents ?? <dynamic>[];

  Profile.fromEntity(ProfileEntity entity)
      : id = entity.id,
        uid = entity.uid,
        name = entity.name,
        documents = entity.documents;

  final String id;
  final String uid;
  final String? name;
  final List<dynamic>? documents;

  static Profile empty = Profile(uid: '');

  bool get isEmpty => this == Profile.empty;

  bool get isNotEmpty => this != Profile.empty;


  @override
  List<Object?> get props => [
        id,
        uid,
        name,
        documents,
      ];

  Profile copyWith(
      {String? uid,
      String? name,
      List<dynamic>? documents}) {
    return Profile(
      id: id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      documents: documents ?? this.documents,
    );
  }

  @override
  String toString() {
    return 'Profile '
        '{ uid: $uid, id: $id, name: $name, '
        'documents: $documents}';
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      uid: uid,
      name: name,
      documents: documents,
    );
  }
}
