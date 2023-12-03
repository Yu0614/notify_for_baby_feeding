import '../../models/result/result.dart';
import '../../models/feed/feed.dart';
import '../../repository/feed_repository.dart';

class FeedViewModel {
  /// constructor
  /// インスタンス生成時にloadを実行してデータを取得する
  FeedViewModel(this.feedRepository) {
    loadByDate(DateTime.now());
  }

  final FeedRepository feedRepository;

  /// 1日分のデータを取得する
  Future<Result<List<FeedModel>>> loadByDate(date) async {
    final startOfDate = DateTime(date.year, date.month, date.day, 00, 00);
    final endOfDate = DateTime(date.year, date.month, date.day, 23, 59);
    const where = "date between ? and ?";
    final whereArgs = [
      startOfDate.millisecondsSinceEpoch,
      endOfDate.millisecondsSinceEpoch
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

  /// [feed]を保存する
  /// primary keyがなければsave, あればupdateをする
  Future<Result<String>> save(FeedModel feed) async {
    feed = feed.copyWith(createdAt: DateTime.now(), updatedAt: DateTime.now());

    if (feed.id == null) {
      final saveData = feed.copyWith();
      final result = await feedRepository.save(saveData);

      return result.when(
        success: (data) {
          loadByDate(saveData.feedAt);
          return Result.success(data: saveData.id!.toString());
        },
        failure: (error) {
          return Result.failure(error: error);
        },
      );
    } else {
      final result = await feedRepository.update(feed);
      return result.when(
        success: (data) {
          loadByDate(DateTime.now());
          return Result.success(data: feed.id!.toString());
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
