// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enforcement_evidence.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EnforcementEvidence extends EnforcementEvidence {
  @override
  final String id;
  @override
  final String name;
  @override
  final String contentType;
  @override
  final int byteSize;

  factory _$EnforcementEvidence(
          [void Function(EnforcementEvidenceBuilder)? updates]) =>
      (EnforcementEvidenceBuilder()..update(updates))._build();

  _$EnforcementEvidence._(
      {required this.id,
      required this.name,
      required this.contentType,
      required this.byteSize})
      : super._();
  @override
  EnforcementEvidence rebuild(
          void Function(EnforcementEvidenceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EnforcementEvidenceBuilder toBuilder() =>
      EnforcementEvidenceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EnforcementEvidence &&
        id == other.id &&
        name == other.name &&
        contentType == other.contentType &&
        byteSize == other.byteSize;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, byteSize.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EnforcementEvidence')
          ..add('id', id)
          ..add('name', name)
          ..add('contentType', contentType)
          ..add('byteSize', byteSize))
        .toString();
  }
}

class EnforcementEvidenceBuilder
    implements Builder<EnforcementEvidence, EnforcementEvidenceBuilder> {
  _$EnforcementEvidence? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _contentType;
  String? get contentType => _$this._contentType;
  set contentType(String? contentType) => _$this._contentType = contentType;

  int? _byteSize;
  int? get byteSize => _$this._byteSize;
  set byteSize(int? byteSize) => _$this._byteSize = byteSize;

  EnforcementEvidenceBuilder() {
    EnforcementEvidence._defaults(this);
  }

  EnforcementEvidenceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _contentType = $v.contentType;
      _byteSize = $v.byteSize;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EnforcementEvidence other) {
    _$v = other as _$EnforcementEvidence;
  }

  @override
  void update(void Function(EnforcementEvidenceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EnforcementEvidence build() => _build();

  _$EnforcementEvidence _build() {
    final _$result = _$v ??
        _$EnforcementEvidence._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'EnforcementEvidence', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'EnforcementEvidence', 'name'),
          contentType: BuiltValueNullFieldError.checkNotNull(
              contentType, r'EnforcementEvidence', 'contentType'),
          byteSize: BuiltValueNullFieldError.checkNotNull(
              byteSize, r'EnforcementEvidence', 'byteSize'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
