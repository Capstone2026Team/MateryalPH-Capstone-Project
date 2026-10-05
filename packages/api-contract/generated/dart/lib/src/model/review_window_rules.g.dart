// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_window_rules.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReviewWindowRules extends ReviewWindowRules {
  @override
  final int windowDays;
  @override
  final int editHours;
  @override
  final int commentMax;
  @override
  final int mediaMax;
  @override
  final String blindReveal;

  factory _$ReviewWindowRules(
          [void Function(ReviewWindowRulesBuilder)? updates]) =>
      (ReviewWindowRulesBuilder()..update(updates))._build();

  _$ReviewWindowRules._(
      {required this.windowDays,
      required this.editHours,
      required this.commentMax,
      required this.mediaMax,
      required this.blindReveal})
      : super._();
  @override
  ReviewWindowRules rebuild(void Function(ReviewWindowRulesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReviewWindowRulesBuilder toBuilder() =>
      ReviewWindowRulesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReviewWindowRules &&
        windowDays == other.windowDays &&
        editHours == other.editHours &&
        commentMax == other.commentMax &&
        mediaMax == other.mediaMax &&
        blindReveal == other.blindReveal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, windowDays.hashCode);
    _$hash = $jc(_$hash, editHours.hashCode);
    _$hash = $jc(_$hash, commentMax.hashCode);
    _$hash = $jc(_$hash, mediaMax.hashCode);
    _$hash = $jc(_$hash, blindReveal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReviewWindowRules')
          ..add('windowDays', windowDays)
          ..add('editHours', editHours)
          ..add('commentMax', commentMax)
          ..add('mediaMax', mediaMax)
          ..add('blindReveal', blindReveal))
        .toString();
  }
}

class ReviewWindowRulesBuilder
    implements Builder<ReviewWindowRules, ReviewWindowRulesBuilder> {
  _$ReviewWindowRules? _$v;

  int? _windowDays;
  int? get windowDays => _$this._windowDays;
  set windowDays(int? windowDays) => _$this._windowDays = windowDays;

  int? _editHours;
  int? get editHours => _$this._editHours;
  set editHours(int? editHours) => _$this._editHours = editHours;

  int? _commentMax;
  int? get commentMax => _$this._commentMax;
  set commentMax(int? commentMax) => _$this._commentMax = commentMax;

  int? _mediaMax;
  int? get mediaMax => _$this._mediaMax;
  set mediaMax(int? mediaMax) => _$this._mediaMax = mediaMax;

  String? _blindReveal;
  String? get blindReveal => _$this._blindReveal;
  set blindReveal(String? blindReveal) => _$this._blindReveal = blindReveal;

  ReviewWindowRulesBuilder() {
    ReviewWindowRules._defaults(this);
  }

  ReviewWindowRulesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _windowDays = $v.windowDays;
      _editHours = $v.editHours;
      _commentMax = $v.commentMax;
      _mediaMax = $v.mediaMax;
      _blindReveal = $v.blindReveal;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReviewWindowRules other) {
    _$v = other as _$ReviewWindowRules;
  }

  @override
  void update(void Function(ReviewWindowRulesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReviewWindowRules build() => _build();

  _$ReviewWindowRules _build() {
    final _$result = _$v ??
        _$ReviewWindowRules._(
          windowDays: BuiltValueNullFieldError.checkNotNull(
              windowDays, r'ReviewWindowRules', 'windowDays'),
          editHours: BuiltValueNullFieldError.checkNotNull(
              editHours, r'ReviewWindowRules', 'editHours'),
          commentMax: BuiltValueNullFieldError.checkNotNull(
              commentMax, r'ReviewWindowRules', 'commentMax'),
          mediaMax: BuiltValueNullFieldError.checkNotNull(
              mediaMax, r'ReviewWindowRules', 'mediaMax'),
          blindReveal: BuiltValueNullFieldError.checkNotNull(
              blindReveal, r'ReviewWindowRules', 'blindReveal'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
