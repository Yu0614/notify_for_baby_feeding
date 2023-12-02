import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed.freezed.dart';
part 'feed.g.dart';

@freezed
class FeedModel with _$FeedModel {
  const factory FeedModel({
    /// id
    int? id,

    /// feedの内容
    @Default('') String? memo,

    // feedの量
    @JsonKey(name: 'amount') @Default(0) int? amount,

    /// feedを行う日付 UnixTime
    @JsonKey(name: 'feed_at') @Default(null) DateTime? feedAt,

    /// 作成日 UnixTime
    @JsonKey(name: 'created_at') @Default(null) DateTime? createdAt,

    /// 更新日 UnixTime
    @JsonKey(name: 'updated_at') @Default(null) DateTime? updatedAt,
  }) = _FeedModel;

  const FeedModel._();

  @override
  factory FeedModel.fromJson(Map<String, dynamic> json) =>
      _$FeedModelFromJson(json);
  // String get formatDate => DateFormat('yyyy-MM-dd').format(dateTime);
}
