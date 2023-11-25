// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FeedModel _$FeedModelFromJson(Map<String, dynamic> json) {
  return _FeedModel.fromJson(json);
}

/// @nodoc
mixin _$FeedModel {
  /// id
  int? get id => throw _privateConstructorUsedError;

  /// feedの内容
  String? get memo => throw _privateConstructorUsedError; // feedの量
  @JsonKey(name: 'amount')
  int? get amount => throw _privateConstructorUsedError;

  /// feedを行う日付 UnixTime
  @JsonKey(name: 'feed_at')
  DateTime? get feedAt => throw _privateConstructorUsedError;

  /// 作成日 UnixTime
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// 更新日 UnixTime
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedModelCopyWith<FeedModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedModelCopyWith<$Res> {
  factory $FeedModelCopyWith(FeedModel value, $Res Function(FeedModel) then) =
      _$FeedModelCopyWithImpl<$Res, FeedModel>;
  @useResult
  $Res call(
      {int? id,
      String? memo,
      @JsonKey(name: 'amount') int? amount,
      @JsonKey(name: 'feed_at') DateTime? feedAt,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$FeedModelCopyWithImpl<$Res, $Val extends FeedModel>
    implements $FeedModelCopyWith<$Res> {
  _$FeedModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? memo = freezed,
    Object? amount = freezed,
    Object? feedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      memo: freezed == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int?,
      feedAt: freezed == feedAt
          ? _value.feedAt
          : feedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeedModelImplCopyWith<$Res>
    implements $FeedModelCopyWith<$Res> {
  factory _$$FeedModelImplCopyWith(
          _$FeedModelImpl value, $Res Function(_$FeedModelImpl) then) =
      __$$FeedModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? memo,
      @JsonKey(name: 'amount') int? amount,
      @JsonKey(name: 'feed_at') DateTime? feedAt,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$FeedModelImplCopyWithImpl<$Res>
    extends _$FeedModelCopyWithImpl<$Res, _$FeedModelImpl>
    implements _$$FeedModelImplCopyWith<$Res> {
  __$$FeedModelImplCopyWithImpl(
      _$FeedModelImpl _value, $Res Function(_$FeedModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? memo = freezed,
    Object? amount = freezed,
    Object? feedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$FeedModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      memo: freezed == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int?,
      feedAt: freezed == feedAt
          ? _value.feedAt
          : feedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedModelImpl extends _FeedModel {
  const _$FeedModelImpl(
      {this.id,
      this.memo = '',
      @JsonKey(name: 'amount') this.amount = 0,
      @JsonKey(name: 'feed_at') this.feedAt = 0,
      @JsonKey(name: 'created_at') this.createdAt = 0,
      @JsonKey(name: 'updated_at') this.updatedAt = 0})
      : super._();

  factory _$FeedModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedModelImplFromJson(json);

  /// id
  @override
  final int? id;

  /// feedの内容
  @override
  @JsonKey()
  final String? memo;
// feedの量
  @override
  @JsonKey(name: 'amount')
  final int? amount;

  /// feedを行う日付 UnixTime
  @override
  @JsonKey(name: 'feed_at')
  final DateTime? feedAt;

  /// 作成日 UnixTime
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// 更新日 UnixTime
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'FeedModel(id: $id, memo: $memo, amount: $amount, feedAt: $feedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.feedAt, feedAt) || other.feedAt == feedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, memo, amount, feedAt, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedModelImplCopyWith<_$FeedModelImpl> get copyWith =>
      __$$FeedModelImplCopyWithImpl<_$FeedModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedModelImplToJson(
      this,
    );
  }
}

abstract class _FeedModel extends FeedModel {
  const factory _FeedModel(
          {final int? id,
          final String? memo,
          @JsonKey(name: 'amount') final int? amount,
          @JsonKey(name: 'feed_at') final DateTime? feedAt,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$FeedModelImpl;
  const _FeedModel._() : super._();

  factory _FeedModel.fromJson(Map<String, dynamic> json) =
      _$FeedModelImpl.fromJson;

  @override

  /// id
  int? get id;
  @override

  /// feedの内容
  String? get memo;
  @override // feedの量
  @JsonKey(name: 'amount')
  int? get amount;
  @override

  /// feedを行う日付 UnixTime
  @JsonKey(name: 'feed_at')
  DateTime? get feedAt;
  @override

  /// 作成日 UnixTime
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override

  /// 更新日 UnixTime
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$FeedModelImplCopyWith<_$FeedModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
