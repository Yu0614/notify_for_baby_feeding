import '../../models/result/result.dart';
import '../../models/feed/feed.dart';
import '../../repository/feed_repository.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class FeedViewModel {
  /// constructor
  /// インスタンス生成時にloadを実行してデータを取得する
  FeedViewModel(this.feedRepository) {
    loadByDate(DateTime.now());
  }

  final FeedRepository feedRepository;

  /// 1日分のデータを取得する
  Future<Result<List<FeedModel>>> loadByDate(DateTime? date) async {
    date ??= DateTime.now();
    final startOfDate = DateTime(date.year, date.month, date.day, 0, 0);
    final endOfDate = DateTime(date.year, date.month, date.day, 23, 59);
    const where = "feed_at between ? and ?";
    final whereArgs = [
      startOfDate.toIso8601String(),
      endOfDate.toIso8601String()
    ];
    // print(whereArgs);
    final result =
        await feedRepository.fetch(where: where, whereArgs: whereArgs);
    print(result);
    return result.when(
      success: (data) {
        return Result.success(data: data);
      },
      failure: (error) {
        return Result.failure(error: error);
      },
    );
  } // データが何故か保存できないので調べるところから

  // idで対象の feed を検索
  Future<Result<List<FeedModel>>> findById(int id) async {
    const where = "id = ?";
    final whereArgs = [id];

    final result =
        await feedRepository.fetch(where: where, whereArgs: whereArgs);
    logger.i('find by id: $result');

    return result.when(
      success: (data) {
        return Result.success(data: data);
      },
      failure: (error) {
        return Result.failure(error: error);
      },
    );
  }

  /// [feed]を保存する
  /// primary keyがなければsave, あればupdateをする
  Future<Result<List<FeedModel>>> save(FeedModel feed) async {
    if (feed.id == null) {
      feed =
          feed.copyWith(createdAt: DateTime.now(), updatedAt: DateTime.now());

      final saveData = feed.copyWith();
      final saveResult = await feedRepository.save(saveData);
      final savedFeed = await findById(saveResult.dataOrThrow);

      return savedFeed.when(
        success: (data) {
          return Result.success(data: data);
        },
        failure: (error) {
          return Result.failure(error: error);
        },
      );
    } else {
      feed =
          feed.copyWith(updatedAt: DateTime.now());

      await feedRepository.update(feed);
      final updatedFeed = await findById(feed.id as int);

      return updatedFeed.when(
        success: (data) {
          return Result.success(data: data);
        },
        failure: (error) {
          return Result.failure(error: error);
        },
      );
    }
  }

  /// [feed]で指定したデータを削除する
  Future<Result<int>> delete(FeedModel feed) async {
    final result = await feedRepository.delete(feed);
    return result.when(
      success: (data) {
        // loadByDate();
        return Result.success(data: data);
      },
      failure: (error) {
        return Result.failure(error: error);
      },
    );
  }
}
