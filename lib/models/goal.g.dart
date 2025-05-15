// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGoalCollection on Isar {
  IsarCollection<Goal> get goals => this.collection();
}

const GoalSchema = CollectionSchema(
  name: r'Goal',
  id: 4693499363663894908,
  properties: {
    r'completedSessionDates': PropertySchema(
      id: 0,
      name: r'completedSessionDates',
      type: IsarType.dateTimeList,
    ),
    r'difficulty': PropertySchema(
      id: 1,
      name: r'difficulty',
      type: IsarType.string,
    ),
    r'easeFactor': PropertySchema(
      id: 2,
      name: r'easeFactor',
      type: IsarType.double,
    ),
    r'end': PropertySchema(
      id: 3,
      name: r'end',
      type: IsarType.dateTime,
    ),
    r'goalName': PropertySchema(
      id: 4,
      name: r'goalName',
      type: IsarType.string,
    ),
    r'interval': PropertySchema(
      id: 5,
      name: r'interval',
      type: IsarType.long,
    ),
    r'isCurrent': PropertySchema(
      id: 6,
      name: r'isCurrent',
      type: IsarType.bool,
    ),
    r'isUpcoming': PropertySchema(
      id: 7,
      name: r'isUpcoming',
      type: IsarType.bool,
    ),
    r'reps': PropertySchema(
      id: 8,
      name: r'reps',
      type: IsarType.long,
    ),
    r'start': PropertySchema(
      id: 9,
      name: r'start',
      type: IsarType.dateTime,
    ),
    r'subtopics': PropertySchema(
      id: 10,
      name: r'subtopics',
      type: IsarType.objectList,
      target: r'Subtopic',
    ),
    r'upcomingSessionDates': PropertySchema(
      id: 11,
      name: r'upcomingSessionDates',
      type: IsarType.dateTimeList,
    )
  },
  estimateSize: _goalEstimateSize,
  serialize: _goalSerialize,
  deserialize: _goalDeserialize,
  deserializeProp: _goalDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'sessions': LinkSchema(
      id: 5543848154071693983,
      name: r'sessions',
      target: r'Session',
      single: false,
      linkName: r'goal',
    )
  },
  embeddedSchemas: {r'Subtopic': SubtopicSchema},
  getId: _goalGetId,
  getLinks: _goalGetLinks,
  attach: _goalAttach,
  version: '3.1.0+1',
);

int _goalEstimateSize(
  Goal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.completedSessionDates.length * 8;
  bytesCount += 3 + object.difficulty.length * 3;
  bytesCount += 3 + object.goalName.length * 3;
  bytesCount += 3 + object.subtopics.length * 3;
  {
    final offsets = allOffsets[Subtopic]!;
    for (var i = 0; i < object.subtopics.length; i++) {
      final value = object.subtopics[i];
      bytesCount += SubtopicSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.upcomingSessionDates.length * 8;
  return bytesCount;
}

void _goalSerialize(
  Goal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTimeList(offsets[0], object.completedSessionDates);
  writer.writeString(offsets[1], object.difficulty);
  writer.writeDouble(offsets[2], object.easeFactor);
  writer.writeDateTime(offsets[3], object.end);
  writer.writeString(offsets[4], object.goalName);
  writer.writeLong(offsets[5], object.interval);
  writer.writeBool(offsets[6], object.isCurrent);
  writer.writeBool(offsets[7], object.isUpcoming);
  writer.writeLong(offsets[8], object.reps);
  writer.writeDateTime(offsets[9], object.start);
  writer.writeObjectList<Subtopic>(
    offsets[10],
    allOffsets,
    SubtopicSchema.serialize,
    object.subtopics,
  );
  writer.writeDateTimeList(offsets[11], object.upcomingSessionDates);
}

Goal _goalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Goal();
  object.completedSessionDates = reader.readDateTimeList(offsets[0]) ?? [];
  object.difficulty = reader.readString(offsets[1]);
  object.easeFactor = reader.readDouble(offsets[2]);
  object.end = reader.readDateTime(offsets[3]);
  object.goalName = reader.readString(offsets[4]);
  object.id = id;
  object.interval = reader.readLong(offsets[5]);
  object.reps = reader.readLong(offsets[8]);
  object.start = reader.readDateTime(offsets[9]);
  object.subtopics = reader.readObjectList<Subtopic>(
        offsets[10],
        SubtopicSchema.deserialize,
        allOffsets,
        Subtopic(),
      ) ??
      [];
  object.upcomingSessionDates = reader.readDateTimeList(offsets[11]) ?? [];
  return object;
}

P _goalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeList(offset) ?? []) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    case 10:
      return (reader.readObjectList<Subtopic>(
            offset,
            SubtopicSchema.deserialize,
            allOffsets,
            Subtopic(),
          ) ??
          []) as P;
    case 11:
      return (reader.readDateTimeList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _goalGetId(Goal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _goalGetLinks(Goal object) {
  return [object.sessions];
}

void _goalAttach(IsarCollection<dynamic> col, Id id, Goal object) {
  object.id = id;
  object.sessions.attach(col, col.isar.collection<Session>(), r'sessions', id);
}

extension GoalQueryWhereSort on QueryBuilder<Goal, Goal, QWhere> {
  QueryBuilder<Goal, Goal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GoalQueryWhere on QueryBuilder<Goal, Goal, QWhereClause> {
  QueryBuilder<Goal, Goal, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Goal, Goal, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Goal, Goal, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Goal, Goal, QAfterWhereClause> idBetween(
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

extension GoalQueryFilter on QueryBuilder<Goal, Goal, QFilterCondition> {
  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      completedSessionDatesElementEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedSessionDates',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      completedSessionDatesElementGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedSessionDates',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      completedSessionDatesElementLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedSessionDates',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      completedSessionDatesElementBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedSessionDates',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      completedSessionDatesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedSessionDates',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      completedSessionDatesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedSessionDates',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      completedSessionDatesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedSessionDates',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      completedSessionDatesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedSessionDates',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      completedSessionDatesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedSessionDates',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      completedSessionDatesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedSessionDates',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> difficultyEqualTo(
    String value, {
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

  QueryBuilder<Goal, Goal, QAfterFilterCondition> difficultyGreaterThan(
    String value, {
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

  QueryBuilder<Goal, Goal, QAfterFilterCondition> difficultyLessThan(
    String value, {
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

  QueryBuilder<Goal, Goal, QAfterFilterCondition> difficultyBetween(
    String lower,
    String upper, {
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

  QueryBuilder<Goal, Goal, QAfterFilterCondition> difficultyStartsWith(
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

  QueryBuilder<Goal, Goal, QAfterFilterCondition> difficultyEndsWith(
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

  QueryBuilder<Goal, Goal, QAfterFilterCondition> difficultyContains(
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

  QueryBuilder<Goal, Goal, QAfterFilterCondition> difficultyMatches(
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

  QueryBuilder<Goal, Goal, QAfterFilterCondition> difficultyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'difficulty',
        value: '',
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> difficultyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'difficulty',
        value: '',
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> easeFactorEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'easeFactor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> easeFactorGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'easeFactor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> easeFactorLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'easeFactor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> easeFactorBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'easeFactor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> endEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'end',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> endGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'end',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> endLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'end',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> endBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'end',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> goalNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'goalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> goalNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'goalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> goalNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'goalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> goalNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'goalName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> goalNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'goalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> goalNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'goalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> goalNameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'goalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> goalNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'goalName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> goalNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'goalName',
        value: '',
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> goalNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'goalName',
        value: '',
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Goal, Goal, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Goal, Goal, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Goal, Goal, QAfterFilterCondition> intervalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'interval',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> intervalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'interval',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> intervalLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'interval',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> intervalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'interval',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> isCurrentEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCurrent',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> isUpcomingEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isUpcoming',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> repsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reps',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> repsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reps',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> repsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reps',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> repsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> startEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'start',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> startGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'start',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> startLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'start',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> startBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'start',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> subtopicsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subtopics',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> subtopicsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subtopics',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> subtopicsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subtopics',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> subtopicsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subtopics',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> subtopicsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subtopics',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> subtopicsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subtopics',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      upcomingSessionDatesElementEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'upcomingSessionDates',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      upcomingSessionDatesElementGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'upcomingSessionDates',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      upcomingSessionDatesElementLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'upcomingSessionDates',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      upcomingSessionDatesElementBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'upcomingSessionDates',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      upcomingSessionDatesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'upcomingSessionDates',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      upcomingSessionDatesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'upcomingSessionDates',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      upcomingSessionDatesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'upcomingSessionDates',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      upcomingSessionDatesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'upcomingSessionDates',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      upcomingSessionDatesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'upcomingSessionDates',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      upcomingSessionDatesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'upcomingSessionDates',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension GoalQueryObject on QueryBuilder<Goal, Goal, QFilterCondition> {
  QueryBuilder<Goal, Goal, QAfterFilterCondition> subtopicsElement(
      FilterQuery<Subtopic> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'subtopics');
    });
  }
}

extension GoalQueryLinks on QueryBuilder<Goal, Goal, QFilterCondition> {
  QueryBuilder<Goal, Goal, QAfterFilterCondition> sessions(
      FilterQuery<Session> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'sessions');
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> sessionsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'sessions', length, true, length, true);
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> sessionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'sessions', 0, true, 0, true);
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> sessionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'sessions', 0, false, 999999, true);
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> sessionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'sessions', 0, true, length, include);
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> sessionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'sessions', length, include, 999999, true);
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> sessionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'sessions', lower, includeLower, upper, includeUpper);
    });
  }
}

extension GoalQuerySortBy on QueryBuilder<Goal, Goal, QSortBy> {
  QueryBuilder<Goal, Goal, QAfterSortBy> sortByDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficulty', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByDifficultyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficulty', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByEaseFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easeFactor', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByEaseFactorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easeFactor', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'end', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'end', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByGoalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalName', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByGoalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalName', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByIsCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCurrent', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByIsCurrentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCurrent', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByIsUpcoming() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUpcoming', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByIsUpcomingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUpcoming', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByReps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reps', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByRepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reps', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'start', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'start', Sort.desc);
    });
  }
}

extension GoalQuerySortThenBy on QueryBuilder<Goal, Goal, QSortThenBy> {
  QueryBuilder<Goal, Goal, QAfterSortBy> thenByDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficulty', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByDifficultyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficulty', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByEaseFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easeFactor', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByEaseFactorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easeFactor', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'end', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'end', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByGoalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalName', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByGoalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalName', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByIsCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCurrent', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByIsCurrentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCurrent', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByIsUpcoming() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUpcoming', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByIsUpcomingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUpcoming', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByReps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reps', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByRepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reps', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'start', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'start', Sort.desc);
    });
  }
}

extension GoalQueryWhereDistinct on QueryBuilder<Goal, Goal, QDistinct> {
  QueryBuilder<Goal, Goal, QDistinct> distinctByCompletedSessionDates() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedSessionDates');
    });
  }

  QueryBuilder<Goal, Goal, QDistinct> distinctByDifficulty(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'difficulty', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Goal, Goal, QDistinct> distinctByEaseFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'easeFactor');
    });
  }

  QueryBuilder<Goal, Goal, QDistinct> distinctByEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'end');
    });
  }

  QueryBuilder<Goal, Goal, QDistinct> distinctByGoalName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Goal, Goal, QDistinct> distinctByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'interval');
    });
  }

  QueryBuilder<Goal, Goal, QDistinct> distinctByIsCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCurrent');
    });
  }

  QueryBuilder<Goal, Goal, QDistinct> distinctByIsUpcoming() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isUpcoming');
    });
  }

  QueryBuilder<Goal, Goal, QDistinct> distinctByReps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reps');
    });
  }

  QueryBuilder<Goal, Goal, QDistinct> distinctByStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'start');
    });
  }

  QueryBuilder<Goal, Goal, QDistinct> distinctByUpcomingSessionDates() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'upcomingSessionDates');
    });
  }
}

extension GoalQueryProperty on QueryBuilder<Goal, Goal, QQueryProperty> {
  QueryBuilder<Goal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Goal, List<DateTime>, QQueryOperations>
      completedSessionDatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedSessionDates');
    });
  }

  QueryBuilder<Goal, String, QQueryOperations> difficultyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'difficulty');
    });
  }

  QueryBuilder<Goal, double, QQueryOperations> easeFactorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'easeFactor');
    });
  }

  QueryBuilder<Goal, DateTime, QQueryOperations> endProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'end');
    });
  }

  QueryBuilder<Goal, String, QQueryOperations> goalNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalName');
    });
  }

  QueryBuilder<Goal, int, QQueryOperations> intervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'interval');
    });
  }

  QueryBuilder<Goal, bool, QQueryOperations> isCurrentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCurrent');
    });
  }

  QueryBuilder<Goal, bool, QQueryOperations> isUpcomingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isUpcoming');
    });
  }

  QueryBuilder<Goal, int, QQueryOperations> repsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reps');
    });
  }

  QueryBuilder<Goal, DateTime, QQueryOperations> startProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'start');
    });
  }

  QueryBuilder<Goal, List<Subtopic>, QQueryOperations> subtopicsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subtopics');
    });
  }

  QueryBuilder<Goal, List<DateTime>, QQueryOperations>
      upcomingSessionDatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'upcomingSessionDates');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SubtopicSchema = Schema(
  name: r'Subtopic',
  id: -1565134535968889765,
  properties: {
    r'completed': PropertySchema(
      id: 0,
      name: r'completed',
      type: IsarType.bool,
    ),
    r'hashCode': PropertySchema(
      id: 1,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _subtopicEstimateSize,
  serialize: _subtopicSerialize,
  deserialize: _subtopicDeserialize,
  deserializeProp: _subtopicDeserializeProp,
);

int _subtopicEstimateSize(
  Subtopic object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _subtopicSerialize(
  Subtopic object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.completed);
  writer.writeLong(offsets[1], object.hashCode);
  writer.writeString(offsets[2], object.name);
}

Subtopic _subtopicDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Subtopic();
  object.completed = reader.readBool(offsets[0]);
  object.name = reader.readString(offsets[2]);
  return object;
}

P _subtopicDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SubtopicQueryFilter
    on QueryBuilder<Subtopic, Subtopic, QFilterCondition> {
  QueryBuilder<Subtopic, Subtopic, QAfterFilterCondition> completedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completed',
        value: value,
      ));
    });
  }

  QueryBuilder<Subtopic, Subtopic, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Subtopic, Subtopic, QAfterFilterCondition> hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Subtopic, Subtopic, QAfterFilterCondition> hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<Subtopic, Subtopic, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Subtopic, Subtopic, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Subtopic, Subtopic, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Subtopic, Subtopic, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Subtopic, Subtopic, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Subtopic, Subtopic, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Subtopic, Subtopic, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Subtopic, Subtopic, QAfterFilterCondition> nameContains(
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

  QueryBuilder<Subtopic, Subtopic, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<Subtopic, Subtopic, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Subtopic, Subtopic, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension SubtopicQueryObject
    on QueryBuilder<Subtopic, Subtopic, QFilterCondition> {}
