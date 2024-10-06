// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class SkillModel extends Equatable {
  final int id;
  final String name;
  final int value;
  const SkillModel({
    required this.id,
    required this.name,
    required this.value,
  });

  SkillModel copyWith({
    int? id,
    String? name,
    int? value,
  }) {
    return SkillModel(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'value': value,
    };
  }

  factory SkillModel.fromMap(Map<String, dynamic> map) {
    return SkillModel(
      id: map['id'] as int,
      name: map['name'] as String,
      value: map['value'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SkillModel.fromJson(String source) => SkillModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, value];
}

enum SportsEnum {
  volleyball,
  soccer,
  futsal,
  tennis,
  basketball,
  handball,
  baseball
}
