// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comparable_group_envelope_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ComparableGroupEnvelopeData extends ComparableGroupEnvelopeData {
  @override
  final String groupId;
  @override
  final String groupVersionId;
  @override
  final int mappedVariants;

  factory _$ComparableGroupEnvelopeData(
          [void Function(ComparableGroupEnvelopeDataBuilder)? updates]) =>
      (ComparableGroupEnvelopeDataBuilder()..update(updates))._build();

  _$ComparableGroupEnvelopeData._(
      {required this.groupId,
      required this.groupVersionId,
      required this.mappedVariants})
      : super._();
  @override
  ComparableGroupEnvelopeData rebuild(
          void Function(ComparableGroupEnvelopeDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComparableGroupEnvelopeDataBuilder toBuilder() =>
      ComparableGroupEnvelopeDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComparableGroupEnvelopeData &&
        groupId == other.groupId &&
        groupVersionId == other.groupVersionId &&
        mappedVariants == other.mappedVariants;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, groupId.hashCode);
    _$hash = $jc(_$hash, groupVersionId.hashCode);
    _$hash = $jc(_$hash, mappedVariants.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ComparableGroupEnvelopeData')
          ..add('groupId', groupId)
          ..add('groupVersionId', groupVersionId)
          ..add('mappedVariants', mappedVariants))
        .toString();
  }
}

class ComparableGroupEnvelopeDataBuilder
    implements
        Builder<ComparableGroupEnvelopeData,
            ComparableGroupEnvelopeDataBuilder> {
  _$ComparableGroupEnvelopeData? _$v;

  String? _groupId;
  String? get groupId => _$this._groupId;
  set groupId(String? groupId) => _$this._groupId = groupId;

  String? _groupVersionId;
  String? get groupVersionId => _$this._groupVersionId;
  set groupVersionId(String? groupVersionId) =>
      _$this._groupVersionId = groupVersionId;

  int? _mappedVariants;
  int? get mappedVariants => _$this._mappedVariants;
  set mappedVariants(int? mappedVariants) =>
      _$this._mappedVariants = mappedVariants;

  ComparableGroupEnvelopeDataBuilder() {
    ComparableGroupEnvelopeData._defaults(this);
  }

  ComparableGroupEnvelopeDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _groupId = $v.groupId;
      _groupVersionId = $v.groupVersionId;
      _mappedVariants = $v.mappedVariants;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComparableGroupEnvelopeData other) {
    _$v = other as _$ComparableGroupEnvelopeData;
  }

  @override
  void update(void Function(ComparableGroupEnvelopeDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComparableGroupEnvelopeData build() => _build();

  _$ComparableGroupEnvelopeData _build() {
    final _$result = _$v ??
        _$ComparableGroupEnvelopeData._(
          groupId: BuiltValueNullFieldError.checkNotNull(
              groupId, r'ComparableGroupEnvelopeData', 'groupId'),
          groupVersionId: BuiltValueNullFieldError.checkNotNull(
              groupVersionId, r'ComparableGroupEnvelopeData', 'groupVersionId'),
          mappedVariants: BuiltValueNullFieldError.checkNotNull(
              mappedVariants, r'ComparableGroupEnvelopeData', 'mappedVariants'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
