// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compliance_lookup_register.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ComplianceLookupRegister extends ComplianceLookupRegister {
  @override
  final String? registerKind;
  @override
  final String? snapshotDate;
  @override
  final String? sourceReference;

  factory _$ComplianceLookupRegister(
          [void Function(ComplianceLookupRegisterBuilder)? updates]) =>
      (ComplianceLookupRegisterBuilder()..update(updates))._build();

  _$ComplianceLookupRegister._(
      {this.registerKind, this.snapshotDate, this.sourceReference})
      : super._();
  @override
  ComplianceLookupRegister rebuild(
          void Function(ComplianceLookupRegisterBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComplianceLookupRegisterBuilder toBuilder() =>
      ComplianceLookupRegisterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComplianceLookupRegister &&
        registerKind == other.registerKind &&
        snapshotDate == other.snapshotDate &&
        sourceReference == other.sourceReference;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, registerKind.hashCode);
    _$hash = $jc(_$hash, snapshotDate.hashCode);
    _$hash = $jc(_$hash, sourceReference.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ComplianceLookupRegister')
          ..add('registerKind', registerKind)
          ..add('snapshotDate', snapshotDate)
          ..add('sourceReference', sourceReference))
        .toString();
  }
}

class ComplianceLookupRegisterBuilder
    implements
        Builder<ComplianceLookupRegister, ComplianceLookupRegisterBuilder> {
  _$ComplianceLookupRegister? _$v;

  String? _registerKind;
  String? get registerKind => _$this._registerKind;
  set registerKind(String? registerKind) => _$this._registerKind = registerKind;

  String? _snapshotDate;
  String? get snapshotDate => _$this._snapshotDate;
  set snapshotDate(String? snapshotDate) => _$this._snapshotDate = snapshotDate;

  String? _sourceReference;
  String? get sourceReference => _$this._sourceReference;
  set sourceReference(String? sourceReference) =>
      _$this._sourceReference = sourceReference;

  ComplianceLookupRegisterBuilder() {
    ComplianceLookupRegister._defaults(this);
  }

  ComplianceLookupRegisterBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _registerKind = $v.registerKind;
      _snapshotDate = $v.snapshotDate;
      _sourceReference = $v.sourceReference;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComplianceLookupRegister other) {
    _$v = other as _$ComplianceLookupRegister;
  }

  @override
  void update(void Function(ComplianceLookupRegisterBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComplianceLookupRegister build() => _build();

  _$ComplianceLookupRegister _build() {
    final _$result = _$v ??
        _$ComplianceLookupRegister._(
          registerKind: registerKind,
          snapshotDate: snapshotDate,
          sourceReference: sourceReference,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
