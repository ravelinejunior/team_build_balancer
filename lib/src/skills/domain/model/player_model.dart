// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:team_build_balancer/src/skills/domain/model/skills_model.dart';

class PlayerModel extends Equatable {
  final int id;
  final String name;
  final String? imageUrl;
  final List<SkillModel> skills;
  const PlayerModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.skills,
  });

  PlayerModel copyWith({
    int? id,
    String? name,
    String? imageUrl,
    List<SkillModel>? skills,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      skills: skills ?? this.skills,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'skills': skills.map((x) => x.toMap()).toList(),
    };
  }

  factory PlayerModel.fromMap(Map<String, dynamic> map) {
    return PlayerModel(
      id: map['id'] as int,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      skills: List<SkillModel>.from(
        (map['skills'] as List<int>).map<SkillModel>(
          (x) => SkillModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlayerModel.fromJson(String source) =>
      PlayerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, skills];
}
