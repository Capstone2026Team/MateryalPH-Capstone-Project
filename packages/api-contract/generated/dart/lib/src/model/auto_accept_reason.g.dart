// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_accept_reason.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AutoAcceptReason extends AutoAcceptReason {
  @override
  final String code;
  @override
  final String? listingVariantId;

  factory _$AutoAcceptReason(
          [void Function(AutoAcceptReasonBuilder)? updates]) =>
      (AutoAcceptReasonBuilder()..update(updates))._build();

  _$AutoAcceptReason._({required this.code, this.listingVariantId}) : super._();
  @override
  AutoAcceptReason rebuild(void Function(AutoAcceptReasonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AutoAcceptReasonBuilder toBuilder() =>
      AutoAcceptReasonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AutoAcceptReason &&
        code == other.code &&
        listingVariantId == other.listingVariantId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, listingVariantId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AutoAcceptReason')
          ..add('code', code)
          ..add('listingVariantId', listingVariantId))
        .toString();
  }
}

class AutoAcceptReasonBuilder
    implements Builder<AutoAcceptReason, AutoAcceptReasonBuilder> {
  _$AutoAcceptReason? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _listingVariantId;
  String? get listingVariantId => _$this._listingVariantId;
  set listingVariantId(String? listingVariantId) =>
      _$this._listingVariantId = listingVariantId;

  AutoAcceptReasonBuilder() {
    AutoAcceptReason._defaults(this);
  }

  AutoAcceptReasonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _listingVariantId = $v.listingVariantId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AutoAcceptReason other) {
    _$v = other as _$AutoAcceptReason;
  }

  @override
  void update(void Function(AutoAcceptReasonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AutoAcceptReason build() => _build();

  _$AutoAcceptReason _build() {
    final _$result = _$v ??
        _$AutoAcceptReason._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'AutoAcceptReason', 'code'),
          listingVariantId: listingVariantId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
