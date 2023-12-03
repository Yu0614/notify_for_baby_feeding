import '../db/feeds.dart';
import '../models/feed/feed.dart';
import '../models/result/result.dart';
import 'base.dart';

class FeedRepository implements RepositoryBase<FeedModel> {
  FeedRepository();

  /// [where]は id = ? のような形式にする
  @override
  Future<Result<List<FeedModel>>> fetch({
    String? where,
    List? whereArgs,
  }) async {
    return Result.guardFuture(() async {
      final result = await FeedsDBAccessor.db.get(
        where: where,
        whereArgs: whereArgs,
      );
      return result.map((e) => FeedModel.fromJson(e)).toList();
    });
  }

  @override
  Future<Result<int>> save(FeedModel feed) async {
    return Result.guardFuture(
      () async => await FeedsDBAccessor.db.create(json: feed.toJson()),
    );
  }

  @override
  Future<Result<int>> update(FeedModel feed) async {
    return Result.guardFuture(
      () async => await FeedsDBAccessor.db.update(
        json: feed.toJson(),
        primaryKey: feed.id!,
      ),
    );
  }

  @override
  Future<Result<int>> delete(FeedModel feed) async {
    return Result.guardFuture(
      () async => await FeedsDBAccessor.db.delete(
        primaryKey: feed.id!,
      ),
    );
  }
}
