// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appdata_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AchievementsDao? _achievementsDaoInstance;

  QuestionnaireDao? _questionnaireDaoInstance;

  StatisticsDao? _statisticsDataDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `achievements` (`id` INTEGER NOT NULL, `date` TEXT NOT NULL, `levelOfSustainability` INTEGER NOT NULL, `trees` INTEGER NOT NULL, PRIMARY KEY (`id`, `date`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `questionnaire` (`id` INTEGER NOT NULL, `date` TEXT NOT NULL, `question1` INTEGER NOT NULL, `question2` INTEGER NOT NULL, `question3` INTEGER NOT NULL, `total` INTEGER NOT NULL, PRIMARY KEY (`id`, `date`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `statisticsData` (`id` INTEGER NOT NULL, `date` TEXT NOT NULL, `dailySteps` INTEGER NOT NULL, `dailyDistance` INTEGER NOT NULL, `dailyActivityTime` INTEGER NOT NULL, PRIMARY KEY (`id`, `date`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AchievementsDao get achievementsDao {
    return _achievementsDaoInstance ??=
        _$AchievementsDao(database, changeListener);
  }

  @override
  QuestionnaireDao get questionnaireDao {
    return _questionnaireDaoInstance ??=
        _$QuestionnaireDao(database, changeListener);
  }

  @override
  StatisticsDao get statisticsDataDao {
    return _statisticsDataDaoInstance ??=
        _$StatisticsDao(database, changeListener);
  }
}

class _$AchievementsDao extends AchievementsDao {
  _$AchievementsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _achievementsInsertionAdapter = InsertionAdapter(
            database,
            'achievements',
            (Achievements item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'levelOfSustainability': item.levelOfSustainability,
                  'trees': item.trees
                }),
        _achievementsUpdateAdapter = UpdateAdapter(
            database,
            'achievements',
            ['id', 'date'],
            (Achievements item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'levelOfSustainability': item.levelOfSustainability,
                  'trees': item.trees
                }),
        _achievementsDeletionAdapter = DeletionAdapter(
            database,
            'achievements',
            ['id', 'date'],
            (Achievements item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'levelOfSustainability': item.levelOfSustainability,
                  'trees': item.trees
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Achievements> _achievementsInsertionAdapter;

  final UpdateAdapter<Achievements> _achievementsUpdateAdapter;

  final DeletionAdapter<Achievements> _achievementsDeletionAdapter;

  @override
  Future<List<int>> dateRangeLoS(
    int id,
    String date,
    String startDate,
    String endDate,
  ) async {
    return _queryAdapter.queryList(
        'SELECT levelOfSustainability FROM achievements WHERE id = ?1 AND date = ?2 BETWEEN start = ?3 AND end = ?4',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id, date, startDate, endDate]);
  }

  @override
  Future<int?> totalTrees(
    int id,
    String date,
  ) async {
    return _queryAdapter.query(
        'SELECT trees FROM achievements WHERE id = ?1 AND date = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id, date]);
  }

  @override
  Future<int?> totalLoS(
    int id,
    String date,
  ) async {
    return _queryAdapter.query(
        'SELECT SUM (levelOfSustainability) FROM achievements WHERE id = ?1 AND date = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id, date]);
  }

  @override
  Future<void> insertAchievements(Achievements answers) async {
    await _achievementsInsertionAdapter.insert(
        answers, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateAchievements(Achievements answers) async {
    await _achievementsUpdateAdapter.update(answers, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteAchievements(Achievements achievement) async {
    await _achievementsDeletionAdapter.delete(achievement);
  }
}

class _$QuestionnaireDao extends QuestionnaireDao {
  _$QuestionnaireDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _questionnaireInsertionAdapter = InsertionAdapter(
            database,
            'questionnaire',
            (Questionnaire item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'question1': item.question1,
                  'question2': item.question2,
                  'question3': item.question3,
                  'total': item.total
                }),
        _questionnaireUpdateAdapter = UpdateAdapter(
            database,
            'questionnaire',
            ['id', 'date'],
            (Questionnaire item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'question1': item.question1,
                  'question2': item.question2,
                  'question3': item.question3,
                  'total': item.total
                }),
        _questionnaireDeletionAdapter = DeletionAdapter(
            database,
            'questionnaire',
            ['id', 'date'],
            (Questionnaire item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'question1': item.question1,
                  'question2': item.question2,
                  'question3': item.question3,
                  'total': item.total
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Questionnaire> _questionnaireInsertionAdapter;

  final UpdateAdapter<Questionnaire> _questionnaireUpdateAdapter;

  final DeletionAdapter<Questionnaire> _questionnaireDeletionAdapter;

  @override
  Future<int?> dailyTotal(
    int id,
    String date,
  ) async {
    return _queryAdapter.query(
        'SELECT total FROM questionnaire WHERE id = ?1 AND date = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id, date]);
  }

  @override
  Future<void> insertAnswers(Questionnaire answers) async {
    await _questionnaireInsertionAdapter.insert(
        answers, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateAnswers(Questionnaire answers) async {
    await _questionnaireUpdateAdapter.update(answers, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteQuestions(Questionnaire answersGiven) async {
    await _questionnaireDeletionAdapter.delete(answersGiven);
  }
}

class _$StatisticsDao extends StatisticsDao {
  _$StatisticsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _statisticsDataInsertionAdapter = InsertionAdapter(
            database,
            'statisticsData',
            (StatisticsData item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'dailySteps': item.dailySteps,
                  'dailyDistance': item.dailyDistance,
                  'dailyActivityTime': item.dailyActivityTime
                }),
        _statisticsDataUpdateAdapter = UpdateAdapter(
            database,
            'statisticsData',
            ['id', 'date'],
            (StatisticsData item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'dailySteps': item.dailySteps,
                  'dailyDistance': item.dailyDistance,
                  'dailyActivityTime': item.dailyActivityTime
                }),
        _statisticsDataDeletionAdapter = DeletionAdapter(
            database,
            'statisticsData',
            ['id', 'date'],
            (StatisticsData item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'dailySteps': item.dailySteps,
                  'dailyDistance': item.dailyDistance,
                  'dailyActivityTime': item.dailyActivityTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<StatisticsData> _statisticsDataInsertionAdapter;

  final UpdateAdapter<StatisticsData> _statisticsDataUpdateAdapter;

  final DeletionAdapter<StatisticsData> _statisticsDataDeletionAdapter;

  @override
  Future<List<int>> dateRangeSteps(
    int id,
    String date,
    String startDate,
    String endDate,
  ) async {
    return _queryAdapter.queryList(
        'SELECT dailySteps FROM statisticsData WHERE id = ?1 AND date = ?2 BETWEEN start = ?3 AND end = ?4',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id, date, startDate, endDate]);
  }

  @override
  Future<List<int>> dateRangeDistance(
    int id,
    String date,
    String startDate,
    String endDate,
  ) async {
    return _queryAdapter.queryList(
        'SELECT dailyDistance FROM statisticsData WHERE id = ?1 AND date = ?2 BETWEEN start = ?3 AND end = ?4',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id, date, startDate, endDate]);
  }

  @override
  Future<List<int>> dateRangeActivityTime(
    int id,
    String date,
    String startDate,
    String endDate,
  ) async {
    return _queryAdapter.queryList(
        'SELECT dailyActivityTime FROM statisticsData WHERE id = ?1 AND date = ?2 BETWEEN start = ?3 AND end = ?4',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id, date, startDate, endDate]);
  }

  @override
  Future<void> insertData(StatisticsData data) async {
    await _statisticsDataInsertionAdapter.insert(
        data, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateData(StatisticsData data) async {
    await _statisticsDataUpdateAdapter.update(data, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteRecord(StatisticsData data) async {
    await _statisticsDataDeletionAdapter.delete(data);
  }
}
