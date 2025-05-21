// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'astronaut_pet.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAstronautPetCollection on Isar {
  IsarCollection<AstronautPet> get astronautPets => this.collection();
}

const AstronautPetSchema = CollectionSchema(
  name: r'AstronautPet',
  id: 8607012919912616147,
  properties: {
    r'hp': PropertySchema(
      id: 0,
      name: r'hp',
      type: IsarType.double,
    ),
    r'isAlive': PropertySchema(
      id: 1,
      name: r'isAlive',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'planetsCount': PropertySchema(
      id: 3,
      name: r'planetsCount',
      type: IsarType.long,
    ),
    r'progress': PropertySchema(
      id: 4,
      name: r'progress',
      type: IsarType.double,
    ),
    r'progressPoints': PropertySchema(
      id: 5,
      name: r'progressPoints',
      type: IsarType.long,
    ),
    r'shipType': PropertySchema(
      id: 6,
      name: r'shipType',
      type: IsarType.string,
    ),
    r'skinType': PropertySchema(
      id: 7,
      name: r'skinType',
      type: IsarType.string,
    )
  },
  estimateSize: _astronautPetEstimateSize,
  serialize: _astronautPetSerialize,
  deserialize: _astronautPetDeserialize,
  deserializeProp: _astronautPetDeserializeProp,
  idName: r'id',
  indexes: {
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _astronautPetGetId,
  getLinks: _astronautPetGetLinks,
  attach: _astronautPetAttach,
  version: '3.1.0+1',
);

int _astronautPetEstimateSize(
  AstronautPet object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.shipType.length * 3;
  bytesCount += 3 + object.skinType.length * 3;
  return bytesCount;
}

void _astronautPetSerialize(
  AstronautPet object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.hp);
  writer.writeBool(offsets[1], object.isAlive);
  writer.writeString(offsets[2], object.name);
  writer.writeLong(offsets[3], object.planetsCount);
  writer.writeDouble(offsets[4], object.progress);
  writer.writeLong(offsets[5], object.progressPoints);
  writer.writeString(offsets[6], object.shipType);
  writer.writeString(offsets[7], object.skinType);
}

AstronautPet _astronautPetDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AstronautPet();
  object.hp = reader.readDouble(offsets[0]);
  object.id = id;
  object.isAlive = reader.readBool(offsets[1]);
  object.name = reader.readString(offsets[2]);
  object.planetsCount = reader.readLong(offsets[3]);
  object.progress = reader.readDouble(offsets[4]);
  object.progressPoints = reader.readLong(offsets[5]);
  object.shipType = reader.readString(offsets[6]);
  object.skinType = reader.readString(offsets[7]);
  return object;
}

P _astronautPetDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _astronautPetGetId(AstronautPet object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _astronautPetGetLinks(AstronautPet object) {
  return [];
}

void _astronautPetAttach(
    IsarCollection<dynamic> col, Id id, AstronautPet object) {
  object.id = id;
}

extension AstronautPetByIndex on IsarCollection<AstronautPet> {
  Future<AstronautPet?> getByName(String name) {
    return getByIndex(r'name', [name]);
  }

  AstronautPet? getByNameSync(String name) {
    return getByIndexSync(r'name', [name]);
  }

  Future<bool> deleteByName(String name) {
    return deleteByIndex(r'name', [name]);
  }

  bool deleteByNameSync(String name) {
    return deleteByIndexSync(r'name', [name]);
  }

  Future<List<AstronautPet?>> getAllByName(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndex(r'name', values);
  }

  List<AstronautPet?> getAllByNameSync(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'name', values);
  }

  Future<int> deleteAllByName(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'name', values);
  }

  int deleteAllByNameSync(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'name', values);
  }

  Future<Id> putByName(AstronautPet object) {
    return putByIndex(r'name', object);
  }

  Id putByNameSync(AstronautPet object, {bool saveLinks = true}) {
    return putByIndexSync(r'name', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByName(List<AstronautPet> objects) {
    return putAllByIndex(r'name', objects);
  }

  List<Id> putAllByNameSync(List<AstronautPet> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'name', objects, saveLinks: saveLinks);
  }
}

extension AstronautPetQueryWhereSort
    on QueryBuilder<AstronautPet, AstronautPet, QWhere> {
  QueryBuilder<AstronautPet, AstronautPet, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AstronautPetQueryWhere
    on QueryBuilder<AstronautPet, AstronautPet, QWhereClause> {
  QueryBuilder<AstronautPet, AstronautPet, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterWhereClause> nameEqualTo(
      String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterWhereClause> nameNotEqualTo(
      String name) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AstronautPetQueryFilter
    on QueryBuilder<AstronautPet, AstronautPet, QFilterCondition> {
  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition> hpEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hp',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition> hpGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hp',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition> hpLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hp',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition> hpBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      isAliveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAlive',
        value: value,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      planetsCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planetsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      planetsCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'planetsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      planetsCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'planetsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      planetsCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'planetsCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      progressEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'progress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      progressGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'progress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      progressLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'progress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      progressBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'progress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      progressPointsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'progressPoints',
        value: value,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      progressPointsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'progressPoints',
        value: value,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      progressPointsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'progressPoints',
        value: value,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      progressPointsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'progressPoints',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      shipTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shipType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      shipTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shipType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      shipTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shipType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      shipTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shipType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      shipTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'shipType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      shipTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'shipType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      shipTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shipType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      shipTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shipType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      shipTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shipType',
        value: '',
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      shipTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shipType',
        value: '',
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      skinTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'skinType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      skinTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'skinType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      skinTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'skinType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      skinTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'skinType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      skinTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'skinType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      skinTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'skinType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      skinTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'skinType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      skinTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'skinType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      skinTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'skinType',
        value: '',
      ));
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterFilterCondition>
      skinTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'skinType',
        value: '',
      ));
    });
  }
}

extension AstronautPetQueryObject
    on QueryBuilder<AstronautPet, AstronautPet, QFilterCondition> {}

extension AstronautPetQueryLinks
    on QueryBuilder<AstronautPet, AstronautPet, QFilterCondition> {}

extension AstronautPetQuerySortBy
    on QueryBuilder<AstronautPet, AstronautPet, QSortBy> {
  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> sortByHp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hp', Sort.asc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> sortByHpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hp', Sort.desc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> sortByIsAlive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAlive', Sort.asc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> sortByIsAliveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAlive', Sort.desc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> sortByPlanetsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planetsCount', Sort.asc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy>
      sortByPlanetsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planetsCount', Sort.desc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> sortByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.asc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> sortByProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.desc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy>
      sortByProgressPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPoints', Sort.asc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy>
      sortByProgressPointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPoints', Sort.desc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> sortByShipType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shipType', Sort.asc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> sortByShipTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shipType', Sort.desc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> sortBySkinType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skinType', Sort.asc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> sortBySkinTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skinType', Sort.desc);
    });
  }
}

extension AstronautPetQuerySortThenBy
    on QueryBuilder<AstronautPet, AstronautPet, QSortThenBy> {
  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> thenByHp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hp', Sort.asc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> thenByHpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hp', Sort.desc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> thenByIsAlive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAlive', Sort.asc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> thenByIsAliveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAlive', Sort.desc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> thenByPlanetsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planetsCount', Sort.asc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy>
      thenByPlanetsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planetsCount', Sort.desc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> thenByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.asc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> thenByProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.desc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy>
      thenByProgressPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPoints', Sort.asc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy>
      thenByProgressPointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPoints', Sort.desc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> thenByShipType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shipType', Sort.asc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> thenByShipTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shipType', Sort.desc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> thenBySkinType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skinType', Sort.asc);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QAfterSortBy> thenBySkinTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skinType', Sort.desc);
    });
  }
}

extension AstronautPetQueryWhereDistinct
    on QueryBuilder<AstronautPet, AstronautPet, QDistinct> {
  QueryBuilder<AstronautPet, AstronautPet, QDistinct> distinctByHp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hp');
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QDistinct> distinctByIsAlive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAlive');
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QDistinct> distinctByPlanetsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'planetsCount');
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QDistinct> distinctByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progress');
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QDistinct>
      distinctByProgressPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progressPoints');
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QDistinct> distinctByShipType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shipType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AstronautPet, AstronautPet, QDistinct> distinctBySkinType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'skinType', caseSensitive: caseSensitive);
    });
  }
}

extension AstronautPetQueryProperty
    on QueryBuilder<AstronautPet, AstronautPet, QQueryProperty> {
  QueryBuilder<AstronautPet, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AstronautPet, double, QQueryOperations> hpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hp');
    });
  }

  QueryBuilder<AstronautPet, bool, QQueryOperations> isAliveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAlive');
    });
  }

  QueryBuilder<AstronautPet, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<AstronautPet, int, QQueryOperations> planetsCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'planetsCount');
    });
  }

  QueryBuilder<AstronautPet, double, QQueryOperations> progressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progress');
    });
  }

  QueryBuilder<AstronautPet, int, QQueryOperations> progressPointsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progressPoints');
    });
  }

  QueryBuilder<AstronautPet, String, QQueryOperations> shipTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shipType');
    });
  }

  QueryBuilder<AstronautPet, String, QQueryOperations> skinTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'skinType');
    });
  }
}
