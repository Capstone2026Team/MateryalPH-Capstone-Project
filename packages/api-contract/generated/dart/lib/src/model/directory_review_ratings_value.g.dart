// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_review_ratings_value.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DirectoryReviewRatingsValue extends DirectoryReviewRatingsValue {
  @override
  final AnyOf anyOf;

  factory _$DirectoryReviewRatingsValue(
          [void Function(DirectoryReviewRatingsValueBuilder)? updates]) =>
      (DirectoryReviewRatingsValueBuilder()..update(updates))._build();

  _$DirectoryReviewRatingsValue._({required this.anyOf}) : super._();
  @override
  DirectoryReviewRatingsValue rebuild(
          void Function(DirectoryReviewRatingsValueBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryReviewRatingsValueBuilder toBuilder() =>
      DirectoryReviewRatingsValueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryReviewRatingsValue && anyOf == other.anyOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, anyOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectoryReviewRatingsValue')
          ..add('anyOf', anyOf))
        .toString();
  }
}

class DirectoryReviewRatingsValueBuilder
    implements
        Builder<DirectoryReviewRatingsValue,
            DirectoryReviewRatingsValueBuilder> {
  _$DirectoryReviewRatingsValue? _$v;

  AnyOf? _anyOf;
  AnyOf? get anyOf => _$this._anyOf;
  set anyOf(AnyOf? anyOf) => _$this._anyOf = anyOf;

  DirectoryReviewRatingsValueBuilder() {
    DirectoryReviewRatingsValue._defaults(this);
  }

  DirectoryReviewRatingsValueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _anyOf = $v.anyOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectoryReviewRatingsValue other) {
    _$v = other as _$DirectoryReviewRatingsValue;
  }

  @override
  void update(void Function(DirectoryReviewRatingsValueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryReviewRatingsValue build() => _build();

  _$DirectoryReviewRatingsValue _build() {
    final _$result = _$v ??
        _$DirectoryReviewRatingsValue._(
          anyOf: BuiltValueNullFieldError.checkNotNull(
              anyOf, r'DirectoryReviewRatingsValue', 'anyOf'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
