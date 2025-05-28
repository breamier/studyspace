// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMissionCollection on Isar {
  IsarCollection<Mission> get missions => this.collection();
}

const MissionSchema = CollectionSchema(
  name: r'Mission',
  id: -3542838313713095933,
  properties: {
    r'completed': PropertySchema(
      id: 0,
      name: r'completed',
      type: IsarType.bool,
    ),
    r'completedDate': PropertySchema(
      id: 1,
      name: r'completedDate',
      type: IsarType.dateTime,
    ),
    r'dailyKey': PropertySchema(
      id: 2,
      name: r'dailyKey',
      type: IsarType.string,
    ),
    r'dailyKeyIndex': PropertySchema(
      id: 3,
      name: r'dailyKeyIndex',
      type: IsarType.string,
    ),
    r'difficulty': PropertySchema(
      id: 4,
      name: r'difficulty',
      type: IsarType.string,
      enumMap: _MissiondifficultyEnumValueMap,
    ),
    r'expiryDate': PropertySchema(
      id: 5,
      name: r'expiryDate',
      type: IsarType.dateTime,
    ),
    r'hpPenalty': PropertySchema(
      id: 6,
      name: r'hpPenalty',
      type: IsarType.long,
    ),
    r'isActive': PropertySchema(
      id: 7,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'penaltyPoints': PropertySchema(
      id: 8,
      name: r'penaltyPoints',
      type: IsarType.long,
    ),
    r'rewardPoints': PropertySchema(
      id: 9,
      name: r'rewardPoints',
      type: IsarType.long,
    ),
    r'text': PropertySchema(
      id: 10,
      name: r'text',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 11,
      name: r'type',
      type: IsarType.string,
      enumMap: _MissiontypeEnumValueMap,
    )
  },
  estimateSize: _missionEstimateSize,
  serialize: _missionSerialize,
  deserialize: _missionDeserialize,
  deserializeProp: _missionDeserializeProp,
  idName: r'id',
  indexes: {
    r'dailyKeyIndex': IndexSchema(
      id: 1777564145055771419,
      name: r'dailyKeyIndex',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dailyKeyIndex',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _missionGetId,
  getLinks: _missionGetLinks,
  attach: _missionAttach,
  version: '3.1.0+1',
);

int _missionEstimateSize(
  Mission object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dailyKey.length * 3;
  bytesCount += 3 + object.dailyKeyIndex.length * 3;
  bytesCount += 3 + object.difficulty.name.length * 3;
  bytesCount += 3 + object.text.length * 3;
  bytesCount += 3 + object.type.name.length * 3;
  return bytesCount;
}

void _missionSerialize(
  Mission object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.completed);
  writer.writeDateTime(offsets[1], object.completedDate);
  writer.writeString(offsets[2], object.dailyKey);
  writer.writeString(offsets[3], object.dailyKeyIndex);
  writer.writeString(offsets[4], object.difficulty.name);
  writer.writeDateTime(offsets[5], object.expiryDate);
  writer.writeLong(offsets[6], object.hpPenalty);
  writer.writeBool(offsets[7], object.isActive);
  writer.writeLong(offsets[8], object.penaltyPoints);
  writer.writeLong(offsets[9], object.rewardPoints);
  writer.writeString(offsets[10], object.text);
  writer.writeString(offsets[11], object.type.name);
}

Mission _missionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Mission(
    completed: reader.readBoolOrNull(offsets[0]) ?? false,
    completedDate: reader.readDateTimeOrNull(offsets[1]),
    dailyKey: reader.readString(offsets[2]),
    difficulty:
        _MissiondifficultyValueEnumMap[reader.readStringOrNull(offsets[4])] ??
            MissionDifficulty.easy,
    expiryDate: reader.readDateTimeOrNull(offsets[5]),
    hpPenalty: reader.readLong(offsets[6]),
    isActive: reader.readBoolOrNull(offsets[7]) ?? true,
    penaltyPoints: reader.readLong(offsets[8]),
    rewardPoints: reader.readLong(offsets[9]),
    text: reader.readString(offsets[10]),
    type: _MissiontypeValueEnumMap[reader.readStringOrNull(offsets[11])] ??
        MissionType.minor,
  );
  object.id = id;
  return object;
}

P _missionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (_MissiondifficultyValueEnumMap[reader.readStringOrNull(offset)] ??
          MissionDifficulty.easy) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (_MissiontypeValueEnumMap[reader.readStringOrNull(offset)] ??
          MissionType.minor) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MissiondifficultyEnumValueMap = {
  r'easy': r'easy',
  r'medium': r'medium',
  r'hard': r'hard',
  r'extreme': r'extreme',
};
const _MissiondifficultyValueEnumMap = {
  r'easy': MissionDifficulty.easy,
  r'medium': MissionDifficulty.medium,
  r'hard': MissionDifficulty.hard,
  r'extreme': MissionDifficulty.extreme,
};
const _MissiontypeEnumValueMap = {
  r'study': r'study',
  r'minor': r'minor',
  r'selfie': r'selfie',
  r'travel': r'travel',
  r'purchase': r'purchase',
  r'deepMindFocus': r'deepMindFocus',
  r'informationOverload': r'informationOverload',
};
const _MissiontypeValueEnumMap = {
  r'study': MissionType.study,
  r'minor': MissionType.minor,
  r'selfie': MissionType.selfie,
  r'travel': MissionType.travel,
  r'purchase': MissionType.purchase,
  r'deepMindFocus': MissionType.deepMindFocus,
  r'informationOverload': MissionType.informationOverload,
};

Id _missionGetId(Mission object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _missionGetLinks(Mission object) {
  return [];
}

void _missionAttach(IsarCollection<dynamic> col, Id id, Mission object) {
  object.id = id;
}

extension MissionQueryWhereSort on QueryBuilder<Mission, Mission, QWhere> {
  QueryBuilder<Mission, Mission, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MissionQueryWhere on QueryBuilder<Mission, Mission, QWhereClause> {
  QueryBuilder<Mission, Mission, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Mission, Mission, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Mission, Mission, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Mission, Mission, QAfterWhereClause> idBetween(
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

  QueryBuilder<Mission, Mission, QAfterWhereClause> dailyKeyIndexEqualTo(
      String dailyKeyIndex) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dailyKeyIndex',
        value: [dailyKeyIndex],
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterWhereClause> dailyKeyIndexNotEqualTo(
      String dailyKeyIndex) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dailyKeyIndex',
              lower: [],
              upper: [dailyKeyIndex],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dailyKeyIndex',
              lower: [dailyKeyIndex],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dailyKeyIndex',
              lower: [dailyKeyIndex],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dailyKeyIndex',
              lower: [],
              upper: [dailyKeyIndex],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MissionQueryFilter
    on QueryBuilder<Mission, Mission, QFilterCondition> {
  QueryBuilder<Mission, Mission, QAfterFilterCondition> completedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completed',
        value: value,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> completedDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedDate',
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition>
      completedDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedDate',
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> completedDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition>
      completedDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> completedDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> completedDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> dailyKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> dailyKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> dailyKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> dailyKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> dailyKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dailyKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> dailyKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dailyKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> dailyKeyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dailyKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> dailyKeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dailyKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> dailyKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyKey',
        value: '',
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> dailyKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dailyKey',
        value: '',
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> dailyKeyIndexEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyKeyIndex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition>
      dailyKeyIndexGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyKeyIndex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> dailyKeyIndexLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyKeyIndex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> dailyKeyIndexBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyKeyIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> dailyKeyIndexStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dailyKeyIndex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> dailyKeyIndexEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dailyKeyIndex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> dailyKeyIndexContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dailyKeyIndex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> dailyKeyIndexMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dailyKeyIndex',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> dailyKeyIndexIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyKeyIndex',
        value: '',
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition>
      dailyKeyIndexIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dailyKeyIndex',
        value: '',
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> difficultyEqualTo(
    MissionDifficulty value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'difficulty',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> difficultyGreaterThan(
    MissionDifficulty value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'difficulty',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> difficultyLessThan(
    MissionDifficulty value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'difficulty',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> difficultyBetween(
    MissionDifficulty lower,
    MissionDifficulty upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'difficulty',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> difficultyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'difficulty',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> difficultyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'difficulty',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> difficultyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'difficulty',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> difficultyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'difficulty',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> difficultyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'difficulty',
        value: '',
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> difficultyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'difficulty',
        value: '',
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> expiryDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expiryDate',
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> expiryDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expiryDate',
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> expiryDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiryDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> expiryDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expiryDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> expiryDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expiryDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> expiryDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expiryDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> hpPenaltyEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hpPenalty',
        value: value,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> hpPenaltyGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hpPenalty',
        value: value,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> hpPenaltyLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hpPenalty',
        value: value,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> hpPenaltyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hpPenalty',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Mission, Mission, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Mission, Mission, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Mission, Mission, QAfterFilterCondition> isActiveEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> penaltyPointsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'penaltyPoints',
        value: value,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition>
      penaltyPointsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'penaltyPoints',
        value: value,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> penaltyPointsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'penaltyPoints',
        value: value,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> penaltyPointsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'penaltyPoints',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> rewardPointsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rewardPoints',
        value: value,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> rewardPointsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rewardPoints',
        value: value,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> rewardPointsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rewardPoints',
        value: value,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> rewardPointsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rewardPoints',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> textEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> textGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> textLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> textBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> textContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> textMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> typeEqualTo(
    MissionType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> typeGreaterThan(
    MissionType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> typeLessThan(
    MissionType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> typeBetween(
    MissionType lower,
    MissionType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Mission, Mission, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension MissionQueryObject
    on QueryBuilder<Mission, Mission, QFilterCondition> {}

extension MissionQueryLinks
    on QueryBuilder<Mission, Mission, QFilterCondition> {}

extension MissionQuerySortBy on QueryBuilder<Mission, Mission, QSortBy> {
  QueryBuilder<Mission, Mission, QAfterSortBy> sortByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedDate', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByCompletedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedDate', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByDailyKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyKey', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByDailyKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyKey', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByDailyKeyIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyKeyIndex', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByDailyKeyIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyKeyIndex', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficulty', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByDifficultyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficulty', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByExpiryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryDate', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByExpiryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryDate', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByHpPenalty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hpPenalty', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByHpPenaltyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hpPenalty', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByPenaltyPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penaltyPoints', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByPenaltyPointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penaltyPoints', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByRewardPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardPoints', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByRewardPointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardPoints', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension MissionQuerySortThenBy
    on QueryBuilder<Mission, Mission, QSortThenBy> {
  QueryBuilder<Mission, Mission, QAfterSortBy> thenByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedDate', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByCompletedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedDate', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByDailyKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyKey', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByDailyKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyKey', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByDailyKeyIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyKeyIndex', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByDailyKeyIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyKeyIndex', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficulty', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByDifficultyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficulty', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByExpiryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryDate', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByExpiryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryDate', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByHpPenalty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hpPenalty', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByHpPenaltyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hpPenalty', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByPenaltyPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penaltyPoints', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByPenaltyPointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penaltyPoints', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByRewardPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardPoints', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByRewardPointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardPoints', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Mission, Mission, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension MissionQueryWhereDistinct
    on QueryBuilder<Mission, Mission, QDistinct> {
  QueryBuilder<Mission, Mission, QDistinct> distinctByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completed');
    });
  }

  QueryBuilder<Mission, Mission, QDistinct> distinctByCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedDate');
    });
  }

  QueryBuilder<Mission, Mission, QDistinct> distinctByDailyKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Mission, Mission, QDistinct> distinctByDailyKeyIndex(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyKeyIndex',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Mission, Mission, QDistinct> distinctByDifficulty(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'difficulty', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Mission, Mission, QDistinct> distinctByExpiryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiryDate');
    });
  }

  QueryBuilder<Mission, Mission, QDistinct> distinctByHpPenalty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hpPenalty');
    });
  }

  QueryBuilder<Mission, Mission, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<Mission, Mission, QDistinct> distinctByPenaltyPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'penaltyPoints');
    });
  }

  QueryBuilder<Mission, Mission, QDistinct> distinctByRewardPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rewardPoints');
    });
  }

  QueryBuilder<Mission, Mission, QDistinct> distinctByText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Mission, Mission, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension MissionQueryProperty
    on QueryBuilder<Mission, Mission, QQueryProperty> {
  QueryBuilder<Mission, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Mission, bool, QQueryOperations> completedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completed');
    });
  }

  QueryBuilder<Mission, DateTime?, QQueryOperations> completedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedDate');
    });
  }

  QueryBuilder<Mission, String, QQueryOperations> dailyKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyKey');
    });
  }

  QueryBuilder<Mission, String, QQueryOperations> dailyKeyIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyKeyIndex');
    });
  }

  QueryBuilder<Mission, MissionDifficulty, QQueryOperations>
      difficultyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'difficulty');
    });
  }

  QueryBuilder<Mission, DateTime?, QQueryOperations> expiryDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiryDate');
    });
  }

  QueryBuilder<Mission, int, QQueryOperations> hpPenaltyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hpPenalty');
    });
  }

  QueryBuilder<Mission, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<Mission, int, QQueryOperations> penaltyPointsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'penaltyPoints');
    });
  }

  QueryBuilder<Mission, int, QQueryOperations> rewardPointsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rewardPoints');
    });
  }

  QueryBuilder<Mission, String, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }

  QueryBuilder<Mission, MissionType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
