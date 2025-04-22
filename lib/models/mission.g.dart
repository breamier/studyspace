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
    r'text': PropertySchema(
      id: 4,
      name: r'text',
      type: IsarType.string,
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
  bytesCount += 3 + object.text.length * 3;
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
  writer.writeString(offsets[4], object.text);
}

Mission _missionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Mission(
    text: reader.readString(offsets[4]),
  );
  object.completed = reader.readBool(offsets[0]);
  object.completedDate = reader.readDateTimeOrNull(offsets[1]);
  object.dailyKey = reader.readString(offsets[2]);
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
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

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

  QueryBuilder<Mission, Mission, QDistinct> distinctByText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
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

  QueryBuilder<Mission, String, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }
}
