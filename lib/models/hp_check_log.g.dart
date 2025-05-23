// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hp_check_log.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHpCheckLogCollection on Isar {
  IsarCollection<HpCheckLog> get hpCheckLogs => this.collection();
}

const HpCheckLogSchema = CollectionSchema(
  name: r'HpCheckLog',
  id: 1038737086230543241,
  properties: {
    r'lastChecked': PropertySchema(
      id: 0,
      name: r'lastChecked',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _hpCheckLogEstimateSize,
  serialize: _hpCheckLogSerialize,
  deserialize: _hpCheckLogDeserialize,
  deserializeProp: _hpCheckLogDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _hpCheckLogGetId,
  getLinks: _hpCheckLogGetLinks,
  attach: _hpCheckLogAttach,
  version: '3.1.0+1',
);

int _hpCheckLogEstimateSize(
  HpCheckLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _hpCheckLogSerialize(
  HpCheckLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.lastChecked);
}

HpCheckLog _hpCheckLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HpCheckLog();
  object.id = id;
  object.lastChecked = reader.readDateTime(offsets[0]);
  return object;
}

P _hpCheckLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _hpCheckLogGetId(HpCheckLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _hpCheckLogGetLinks(HpCheckLog object) {
  return [];
}

void _hpCheckLogAttach(IsarCollection<dynamic> col, Id id, HpCheckLog object) {
  object.id = id;
}

extension HpCheckLogQueryWhereSort
    on QueryBuilder<HpCheckLog, HpCheckLog, QWhere> {
  QueryBuilder<HpCheckLog, HpCheckLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HpCheckLogQueryWhere
    on QueryBuilder<HpCheckLog, HpCheckLog, QWhereClause> {
  QueryBuilder<HpCheckLog, HpCheckLog, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HpCheckLog, HpCheckLog, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<HpCheckLog, HpCheckLog, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HpCheckLog, HpCheckLog, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HpCheckLog, HpCheckLog, QAfterWhereClause> idBetween(
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
}

extension HpCheckLogQueryFilter
    on QueryBuilder<HpCheckLog, HpCheckLog, QFilterCondition> {
  QueryBuilder<HpCheckLog, HpCheckLog, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HpCheckLog, HpCheckLog, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<HpCheckLog, HpCheckLog, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<HpCheckLog, HpCheckLog, QAfterFilterCondition> idBetween(
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

  QueryBuilder<HpCheckLog, HpCheckLog, QAfterFilterCondition>
      lastCheckedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastChecked',
        value: value,
      ));
    });
  }

  QueryBuilder<HpCheckLog, HpCheckLog, QAfterFilterCondition>
      lastCheckedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastChecked',
        value: value,
      ));
    });
  }

  QueryBuilder<HpCheckLog, HpCheckLog, QAfterFilterCondition>
      lastCheckedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastChecked',
        value: value,
      ));
    });
  }

  QueryBuilder<HpCheckLog, HpCheckLog, QAfterFilterCondition>
      lastCheckedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastChecked',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HpCheckLogQueryObject
    on QueryBuilder<HpCheckLog, HpCheckLog, QFilterCondition> {}

extension HpCheckLogQueryLinks
    on QueryBuilder<HpCheckLog, HpCheckLog, QFilterCondition> {}

extension HpCheckLogQuerySortBy
    on QueryBuilder<HpCheckLog, HpCheckLog, QSortBy> {
  QueryBuilder<HpCheckLog, HpCheckLog, QAfterSortBy> sortByLastChecked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChecked', Sort.asc);
    });
  }

  QueryBuilder<HpCheckLog, HpCheckLog, QAfterSortBy> sortByLastCheckedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChecked', Sort.desc);
    });
  }
}

extension HpCheckLogQuerySortThenBy
    on QueryBuilder<HpCheckLog, HpCheckLog, QSortThenBy> {
  QueryBuilder<HpCheckLog, HpCheckLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HpCheckLog, HpCheckLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HpCheckLog, HpCheckLog, QAfterSortBy> thenByLastChecked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChecked', Sort.asc);
    });
  }

  QueryBuilder<HpCheckLog, HpCheckLog, QAfterSortBy> thenByLastCheckedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChecked', Sort.desc);
    });
  }
}

extension HpCheckLogQueryWhereDistinct
    on QueryBuilder<HpCheckLog, HpCheckLog, QDistinct> {
  QueryBuilder<HpCheckLog, HpCheckLog, QDistinct> distinctByLastChecked() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastChecked');
    });
  }
}

extension HpCheckLogQueryProperty
    on QueryBuilder<HpCheckLog, HpCheckLog, QQueryProperty> {
  QueryBuilder<HpCheckLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HpCheckLog, DateTime, QQueryOperations> lastCheckedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastChecked');
    });
  }
}
