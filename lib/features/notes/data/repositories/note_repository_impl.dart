// lib/features/notes/data/repositories/note_repository_impl.dart
//
// Concrete implementation of [NoteRepository] for the data layer.
//
// Key design decisions:
//
// 1. DEPENDS ONLY ON THE INTERFACE, NOT THE IMPLEMENTATION.
//    The constructor accepts [NoteLocalDataSource] (the abstract interface),
//    not [HiveNoteLocalDataSource] (the concrete class). The repository
//    never imports Hive. If Hive is replaced tomorrow with Isar or SQLite,
//    this file does not change — only the data source changes.
//
// 2. SINGLE _RUN HELPER ELIMINATES REPETITION.
//    All 15 methods delegate to _run<T>(), which:
//      a. Awaits the data source call.
//      b. Returns Right(result) on success.
//      c. Maps typed AppExceptions to typed Failure subclasses.
//      d. Catches any other exception as UnexpectedFailure.
//    Without this helper, each method would contain identical try/catch
//    blocks — a violation of DRY and a maintenance hazard.
//
// 3. TYPED EXCEPTION → FAILURE MAPPING.
//    The mapping is explicit and exhaustive:
//      NoteNotFoundException  →  NoteNotFoundFailure
//      NoteStorageException   →  NoteStorageFailure
//      any other Exception    →  UnexpectedFailure
//    New exception types added to the data source must be added here too —
//    the compiler will not remind you, but code review will catch it.
//
// 4. CONSTRUCTOR INJECTION FOR TESTABILITY.
//    Injecting [NoteLocalDataSource] via the constructor means unit tests
//    can pass a mock data source that returns specific values or throws
//    specific exceptions, without any real Hive box.

import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/note_local_data_source.dart';

/// Hive-backed implementation of [NoteRepository].
///
/// Delegates every operation to [NoteLocalDataSource] and converts
/// [AppException]s into [Failure] values wrapped in [Either].
///
/// Never imports or references Hive directly.
class NoteRepositoryImpl implements NoteRepository {
  /// Creates an instance backed by the given [dataSource].
  ///
  /// In production, the Riverpod provider (Step 6) injects
  /// [HiveNoteLocalDataSource]. In tests, a mock is injected instead.
  const NoteRepositoryImpl({required NoteLocalDataSource dataSource})
      : _dataSource = dataSource;

  final NoteLocalDataSource _dataSource;

  // ─── Private Helper ───────────────────────────────────────────────────────

  /// Executes [action] and wraps the result in [Either].
  ///
  /// On success, returns [Right] with the result value.
  /// On [NoteNotFoundException], returns [Left] with [NoteNotFoundFailure].
  /// On [NoteStorageException], returns [Left] with [NoteStorageFailure].
  /// On any other error, returns [Left] with [UnexpectedFailure].
  ///
  /// All 15 public methods delegate to this single entry point, ensuring
  /// the exception-to-failure mapping is consistent and tested once.
  Future<Either<Failure, T>> _run<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on NoteNotFoundException catch (e) {
      return Left(NoteNotFoundFailure(e.message));
    } on NoteStorageException catch (e) {
      return Left(NoteStorageFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: $e'));
    }
  }

  // ─── Write Operations ─────────────────────────────────────────────────────

  @override
  Future<Either<Failure, NoteEntity>> createNote(NoteEntity entity) =>
      _run(() => _dataSource.createNote(entity));

  @override
  Future<Either<Failure, NoteEntity>> updateNote(NoteEntity entity) =>
      _run(() => _dataSource.updateNote(entity));

  @override
  Future<Either<Failure, NoteEntity>> deleteNote(String id) =>
      _run(() => _dataSource.deleteNote(id));

  @override
  Future<Either<Failure, NoteEntity>> restoreNote(String id) =>
      _run(() => _dataSource.restoreNote(id));

  @override
  Future<Either<Failure, NoteEntity>> archiveNote(String id) =>
      _run(() => _dataSource.archiveNote(id));

  @override
  Future<Either<Failure, NoteEntity>> unarchiveNote(String id) =>
      _run(() => _dataSource.unarchiveNote(id));

  @override
  Future<Either<Failure, NoteEntity>> pinNote(String id) =>
      _run(() => _dataSource.pinNote(id));

  @override
  Future<Either<Failure, NoteEntity>> unpinNote(String id) =>
      _run(() => _dataSource.unpinNote(id));

  @override
  Future<Either<Failure, NoteEntity>> toggleFavorite(String id) =>
      _run(() => _dataSource.toggleFavorite(id));

  // ─── Read Operations ──────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<NoteEntity>>> getAllNotes() =>
      _run(() => _dataSource.getAllNotes());

  @override
  Future<Either<Failure, List<NoteEntity>>> getActiveNotes() =>
      _run(() => _dataSource.getActiveNotes());

  @override
  Future<Either<Failure, List<NoteEntity>>> getArchivedNotes() =>
      _run(() => _dataSource.getArchivedNotes());

  @override
  Future<Either<Failure, List<NoteEntity>>> getTrashedNotes() =>
      _run(() => _dataSource.getTrashedNotes());

  @override
  Future<Either<Failure, List<NoteEntity>>> searchNotes(String query) =>
      _run(() => _dataSource.searchNotes(query));

  @override
  Future<Either<Failure, NoteEntity>> getNoteById(String id) =>
      _run(() => _dataSource.getNoteById(id));
}
