// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:team_build_balancer/src/skills/domain/model/player_model.dart';

class TeamsModel extends Equatable {
  final int id;
  final String name;
  final List<PlayerModel> players;
  const TeamsModel({
    required this.id,
    required this.name,
    required this.players,
  });

  TeamsModel copyWith({
    int? id,
    String? name,
    List<PlayerModel>? players,
  }) {
    return TeamsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      players: players ?? this.players,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'players': players.map((x) => x.toMap()).toList(),
    };
  }

  factory TeamsModel.fromMap(Map<String, dynamic> map) {
    return TeamsModel(
      id: map['id'] as int,
      name: map['name'] as String,
      players: List<PlayerModel>.from((map['players'] as List<int>).map<PlayerModel>((x) => PlayerModel.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory TeamsModel.fromJson(String source) => TeamsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, players];
}
