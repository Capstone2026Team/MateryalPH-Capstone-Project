// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compliance_lookup_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ComplianceLookupRequest extends ComplianceLookupRequest {
  @override
  final MarkingType markingType;
  @override
  final String number;

  factory _$ComplianceLookupRequest(
          [void Function(ComplianceLookupRequestBuilder)? updates]) =>
      (ComplianceLookupRequestBuilder()..update(updates))._build();

  _$ComplianceLookupRequest._({required this.markingType, required this.number})
      : super._();
  @override
  ComplianceLookupRequest rebuild(
          void Function(ComplianceLookupRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComplianceLookupRequestBuilder toBuilder() =>
      ComplianceLookupRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComplianceLookupRequest &&
        markingType == other.markingType &&
        number == other.number;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, markingType.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ComplianceLookupRequest')
          ..add('markingType', markingType)
          ..add('number', number))
        .toString();
  }
}

class ComplianceLookupRequestBuilder
    implements
        Builder<ComplianceLookupRequest, ComplianceLookupRequestBuilder> {
  _$ComplianceLookupRequest? _$v;

  MarkingType? _markingType;
  MarkingType? get markingType => _$this._markingType;
  set markingType(MarkingType? markingType) =>
      _$this._markingType = markingType;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  ComplianceLookupRequestBuilder() {
    ComplianceLookupRequest._defaults(this);
  }

  ComplianceLookupRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _markingType = $v.markingType;
      _number = $v.number;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComplianceLookupRequest other) {
    _$v = other as _$ComplianceLookupRequest;
  }

  @override
  void update(void Function(ComplianceLookupRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComplianceLookupRequest build() => _build();

  _$ComplianceLookupRequest _build() {
    final _$result = _$v ??
        _$ComplianceLookupRequest._(
          markingType: BuiltValueNullFieldError.checkNotNull(
              markingType, r'ComplianceLookupRequest', 'markingType'),
          number: BuiltValueNullFieldError.checkNotNull(
              number, r'ComplianceLookupRequest', 'number'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
