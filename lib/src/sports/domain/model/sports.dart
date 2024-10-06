// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:team_build_balancer/core/utils/contants.dart';

class SportsModel extends Equatable {
  final int id;
  final String name;
  final String? image;

  const SportsModel({
    required this.id,
    required this.name,
    this.image,
  });

  SportsModel copyWith({
    int? id,
    String? name,
    String? image,
  }) {
    return SportsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
    };
  }

  factory SportsModel.fromMap(Map<String, dynamic> map) {
    return SportsModel(
      id: map['id'] as int,
      name: map['name'] as String,
      image: map['image'] != null ? map['image'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SportsModel.fromJson(String source) =>
      SportsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name];

  static List<SportsModel> mockDefaultSports() => [
        const SportsModel(
          id: 0,
          name: 'Volleyball',
          image: volleyballBackground,
        ),
        const SportsModel(
          id: 1,
          name: 'Soccer',
          image: footballBackground,
        ),
        const SportsModel(
          id: 2,
          name: 'Futsal',
          image: futsalBackground,
        ),
        const SportsModel(
          id: 3,
          name: 'Tennis',
          image: tennisBackground,
        ),
        const SportsModel(
          id: 4,
          name: 'Basketball',
          image: basketballBackground,
        ),
        const SportsModel(
          id: 5,
          name: 'Handball',
          image: handballBackground,
        ),
        const SportsModel(
          id: 6,
          name: 'Baseball',
          image: baseballBackground,
        ),
        const SportsModel(
          id: 7,
          name: 'FootVolley',
          image: footvolleyBackground,
        ),
      ];
}
