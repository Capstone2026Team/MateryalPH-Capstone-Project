// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_reported.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReviewReported extends ReviewReported {
  @override
  final bool reported;

  factory _$ReviewReported([void Function(ReviewReportedBuilder)? updates]) =>
      (ReviewReportedBuilder()..update(updates))._build();

  _$ReviewReported._({required this.reported}) : super._();
  @override
  ReviewReported rebuild(void Function(ReviewReportedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReviewReportedBuilder toBuilder() => ReviewReportedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReviewReported && reported == other.reported;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reported.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReviewReported')
          ..add('reported', reported))
        .toString();
  }
}

class ReviewReportedBuilder
    implements Builder<ReviewReported, ReviewReportedBuilder> {
  _$ReviewReported? _$v;

  bool? _reported;
  bool? get reported => _$this._reported;
  set reported(bool? reported) => _$this._reported = reported;

  ReviewReportedBuilder() {
    ReviewReported._defaults(this);
  }

  ReviewReportedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reported = $v.reported;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReviewReported other) {
    _$v = other as _$ReviewReported;
  }

  @override
  void update(void Function(ReviewReportedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReviewReported build() => _build();

  _$ReviewReported _build() {
    final _$result = _$v ??
        _$ReviewReported._(
          reported: BuiltValueNullFieldError.checkNotNull(
              reported, r'ReviewReported', 'reported'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
