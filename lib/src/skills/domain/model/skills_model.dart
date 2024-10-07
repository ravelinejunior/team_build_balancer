// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class SkillModel extends Equatable {
  final String name;
  final int value;
  const SkillModel({
    required this.name,
    required this.value,
  });

  SkillModel copyWith({
    String? name,
    int? value,
  }) {
    return SkillModel(
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'value': value,
    };
  }

  factory SkillModel.fromMap(Map<String, dynamic> map) {
    return SkillModel(
      name: map['name'] as String,
      value: map['value'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SkillModel.fromJson(String source) =>
      SkillModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [name, value];
}

class SkillToPlayerAmountParams {
  final int amountOfPlayers;
  final int amountOfTeams;
  SkillToPlayerAmountParams({
    required this.amountOfPlayers,
    required this.amountOfTeams,
  });

  SkillToPlayerAmountParams copyWith({
    int? amountOfPlayers,
    int? amountOfTeams,
  }) {
    return SkillToPlayerAmountParams(
      amountOfPlayers: amountOfPlayers ?? this.amountOfPlayers,
      amountOfTeams: amountOfTeams ?? this.amountOfTeams,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amountOfPlayers': amountOfPlayers,
      'amountOfTeams': amountOfTeams,
    };
  }

  factory SkillToPlayerAmountParams.fromMap(Map<String, dynamic> map) {
    return SkillToPlayerAmountParams(
      amountOfPlayers: map['amountOfPlayers'] as int,
      amountOfTeams: map['amountOfTeams'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SkillToPlayerAmountParams.fromJson(String source) =>
      SkillToPlayerAmountParams.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SkillToPlayerParams(amountOfPlayers: $amountOfPlayers, amountOfTeams: $amountOfTeams)';

  @override
  bool operator ==(covariant SkillToPlayerAmountParams other) {
    if (identical(this, other)) return true;

    return other.amountOfPlayers == amountOfPlayers &&
        other.amountOfTeams == amountOfTeams;
  }

  @override
  int get hashCode => amountOfPlayers.hashCode ^ amountOfTeams.hashCode;
}
