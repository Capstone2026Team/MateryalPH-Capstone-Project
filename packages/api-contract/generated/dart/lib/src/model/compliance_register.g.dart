// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compliance_register.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ComplianceRegisterRegisterKindEnum
    _$complianceRegisterRegisterKindEnum_PS_LICENSE =
    const ComplianceRegisterRegisterKindEnum._('PS_LICENSE');
const ComplianceRegisterRegisterKindEnum
    _$complianceRegisterRegisterKindEnum_ICC_CERTIFICATE =
    const ComplianceRegisterRegisterKindEnum._('ICC_CERTIFICATE');

ComplianceRegisterRegisterKindEnum _$complianceRegisterRegisterKindEnumValueOf(
    String name) {
  switch (name) {
    case 'PS_LICENSE':
      return _$complianceRegisterRegisterKindEnum_PS_LICENSE;
    case 'ICC_CERTIFICATE':
      return _$complianceRegisterRegisterKindEnum_ICC_CERTIFICATE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ComplianceRegisterRegisterKindEnum>
    _$complianceRegisterRegisterKindEnumValues = BuiltSet<
        ComplianceRegisterRegisterKindEnum>(const <ComplianceRegisterRegisterKindEnum>[
  _$complianceRegisterRegisterKindEnum_PS_LICENSE,
  _$complianceRegisterRegisterKindEnum_ICC_CERTIFICATE,
]);

const ComplianceRegisterStatusEnum _$complianceRegisterStatusEnum_DRAFT =
    const ComplianceRegisterStatusEnum._('DRAFT');
const ComplianceRegisterStatusEnum _$complianceRegisterStatusEnum_ACTIVE =
    const ComplianceRegisterStatusEnum._('ACTIVE');
const ComplianceRegisterStatusEnum _$complianceRegisterStatusEnum_SUPERSEDED =
    const ComplianceRegisterStatusEnum._('SUPERSEDED');

ComplianceRegisterStatusEnum _$complianceRegisterStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'DRAFT':
      return _$complianceRegisterStatusEnum_DRAFT;
    case 'ACTIVE':
      return _$complianceRegisterStatusEnum_ACTIVE;
    case 'SUPERSEDED':
      return _$complianceRegisterStatusEnum_SUPERSEDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ComplianceRegisterStatusEnum>
    _$complianceRegisterStatusEnumValues =
    BuiltSet<ComplianceRegisterStatusEnum>(const <ComplianceRegisterStatusEnum>[
  _$complianceRegisterStatusEnum_DRAFT,
  _$complianceRegisterStatusEnum_ACTIVE,
  _$complianceRegisterStatusEnum_SUPERSEDED,
]);

Serializer<ComplianceRegisterRegisterKindEnum>
    _$complianceRegisterRegisterKindEnumSerializer =
    _$ComplianceRegisterRegisterKindEnumSerializer();
Serializer<ComplianceRegisterStatusEnum>
    _$complianceRegisterStatusEnumSerializer =
    _$ComplianceRegisterStatusEnumSerializer();

class _$ComplianceRegisterRegisterKindEnumSerializer
    implements PrimitiveSerializer<ComplianceRegisterRegisterKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PS_LICENSE': 'PS_LICENSE',
    'ICC_CERTIFICATE': 'ICC_CERTIFICATE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PS_LICENSE': 'PS_LICENSE',
    'ICC_CERTIFICATE': 'ICC_CERTIFICATE',
  };

  @override
  final Iterable<Type> types = const <Type>[ComplianceRegisterRegisterKindEnum];
  @override
  final String wireName = 'ComplianceRegisterRegisterKindEnum';

  @override
  Object serialize(
          Serializers serializers, ComplianceRegisterRegisterKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ComplianceRegisterRegisterKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ComplianceRegisterRegisterKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ComplianceRegisterStatusEnumSerializer
    implements PrimitiveSerializer<ComplianceRegisterStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DRAFT': 'DRAFT',
    'ACTIVE': 'ACTIVE',
    'SUPERSEDED': 'SUPERSEDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DRAFT': 'DRAFT',
    'ACTIVE': 'ACTIVE',
    'SUPERSEDED': 'SUPERSEDED',
  };

  @override
  final Iterable<Type> types = const <Type>[ComplianceRegisterStatusEnum];
  @override
  final String wireName = 'ComplianceRegisterStatusEnum';

  @override
  Object serialize(Serializers serializers, ComplianceRegisterStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ComplianceRegisterStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ComplianceRegisterStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ComplianceRegister extends ComplianceRegister {
  @override
  final String id;
  @override
  final ComplianceRegisterRegisterKindEnum registerKind;
  @override
  final String sourceReference;
  @override
  final Date snapshotDate;
  @override
  final ComplianceRegisterStatusEnum status;
  @override
  final int rowCount;
  @override
  final int rejectedRowCount;
  @override
  final String? activatedAt;
  @override
  final String? supersededAt;
  @override
  final String? createdAt;
  @override
  final BuiltMap<String, JsonObject?>? columnMapping;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>>? rejectedRows;

  factory _$ComplianceRegister(
          [void Function(ComplianceRegisterBuilder)? updates]) =>
      (ComplianceRegisterBuilder()..update(updates))._build();

  _$ComplianceRegister._(
      {required this.id,
      required this.registerKind,
      required this.sourceReference,
      required this.snapshotDate,
      required this.status,
      required this.rowCount,
      required this.rejectedRowCount,
      this.activatedAt,
      this.supersededAt,
      this.createdAt,
      this.columnMapping,
      this.rejectedRows})
      : super._();
  @override
  ComplianceRegister rebuild(
          void Function(ComplianceRegisterBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComplianceRegisterBuilder toBuilder() =>
      ComplianceRegisterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComplianceRegister &&
        id == other.id &&
        registerKind == other.registerKind &&
        sourceReference == other.sourceReference &&
        snapshotDate == other.snapshotDate &&
        status == other.status &&
        rowCount == other.rowCount &&
        rejectedRowCount == other.rejectedRowCount &&
        activatedAt == other.activatedAt &&
        supersededAt == other.supersededAt &&
        createdAt == other.createdAt &&
        columnMapping == other.columnMapping &&
        rejectedRows == other.rejectedRows;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, registerKind.hashCode);
    _$hash = $jc(_$hash, sourceReference.hashCode);
    _$hash = $jc(_$hash, snapshotDate.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, rowCount.hashCode);
    _$hash = $jc(_$hash, rejectedRowCount.hashCode);
    _$hash = $jc(_$hash, activatedAt.hashCode);
    _$hash = $jc(_$hash, supersededAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, columnMapping.hashCode);
    _$hash = $jc(_$hash, rejectedRows.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ComplianceRegister')
          ..add('id', id)
          ..add('registerKind', registerKind)
          ..add('sourceReference', sourceReference)
          ..add('snapshotDate', snapshotDate)
          ..add('status', status)
          ..add('rowCount', rowCount)
          ..add('rejectedRowCount', rejectedRowCount)
          ..add('activatedAt', activatedAt)
          ..add('supersededAt', supersededAt)
          ..add('createdAt', createdAt)
          ..add('columnMapping', columnMapping)
          ..add('rejectedRows', rejectedRows))
        .toString();
  }
}

class ComplianceRegisterBuilder
    implements Builder<ComplianceRegister, ComplianceRegisterBuilder> {
  _$ComplianceRegister? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ComplianceRegisterRegisterKindEnum? _registerKind;
  ComplianceRegisterRegisterKindEnum? get registerKind => _$this._registerKind;
  set registerKind(ComplianceRegisterRegisterKindEnum? registerKind) =>
      _$this._registerKind = registerKind;

  String? _sourceReference;
  String? get sourceReference => _$this._sourceReference;
  set sourceReference(String? sourceReference) =>
      _$this._sourceReference = sourceReference;

  Date? _snapshotDate;
  Date? get snapshotDate => _$this._snapshotDate;
  set snapshotDate(Date? snapshotDate) => _$this._snapshotDate = snapshotDate;

  ComplianceRegisterStatusEnum? _status;
  ComplianceRegisterStatusEnum? get status => _$this._status;
  set status(ComplianceRegisterStatusEnum? status) => _$this._status = status;

  int? _rowCount;
  int? get rowCount => _$this._rowCount;
  set rowCount(int? rowCount) => _$this._rowCount = rowCount;

  int? _rejectedRowCount;
  int? get rejectedRowCount => _$this._rejectedRowCount;
  set rejectedRowCount(int? rejectedRowCount) =>
      _$this._rejectedRowCount = rejectedRowCount;

  String? _activatedAt;
  String? get activatedAt => _$this._activatedAt;
  set activatedAt(String? activatedAt) => _$this._activatedAt = activatedAt;

  String? _supersededAt;
  String? get supersededAt => _$this._supersededAt;
  set supersededAt(String? supersededAt) => _$this._supersededAt = supersededAt;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  MapBuilder<String, JsonObject?>? _columnMapping;
  MapBuilder<String, JsonObject?> get columnMapping =>
      _$this._columnMapping ??= MapBuilder<String, JsonObject?>();
  set columnMapping(MapBuilder<String, JsonObject?>? columnMapping) =>
      _$this._columnMapping = columnMapping;

  ListBuilder<BuiltMap<String, JsonObject?>>? _rejectedRows;
  ListBuilder<BuiltMap<String, JsonObject?>> get rejectedRows =>
      _$this._rejectedRows ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set rejectedRows(ListBuilder<BuiltMap<String, JsonObject?>>? rejectedRows) =>
      _$this._rejectedRows = rejectedRows;

  ComplianceRegisterBuilder() {
    ComplianceRegister._defaults(this);
  }

  ComplianceRegisterBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _registerKind = $v.registerKind;
      _sourceReference = $v.sourceReference;
      _snapshotDate = $v.snapshotDate;
      _status = $v.status;
      _rowCount = $v.rowCount;
      _rejectedRowCount = $v.rejectedRowCount;
      _activatedAt = $v.activatedAt;
      _supersededAt = $v.supersededAt;
      _createdAt = $v.createdAt;
      _columnMapping = $v.columnMapping?.toBuilder();
      _rejectedRows = $v.rejectedRows?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComplianceRegister other) {
    _$v = other as _$ComplianceRegister;
  }

  @override
  void update(void Function(ComplianceRegisterBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComplianceRegister build() => _build();

  _$ComplianceRegister _build() {
    _$ComplianceRegister _$result;
    try {
      _$result = _$v ??
          _$ComplianceRegister._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ComplianceRegister', 'id'),
            registerKind: BuiltValueNullFieldError.checkNotNull(
                registerKind, r'ComplianceRegister', 'registerKind'),
            sourceReference: BuiltValueNullFieldError.checkNotNull(
                sourceReference, r'ComplianceRegister', 'sourceReference'),
            snapshotDate: BuiltValueNullFieldError.checkNotNull(
                snapshotDate, r'ComplianceRegister', 'snapshotDate'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ComplianceRegister', 'status'),
            rowCount: BuiltValueNullFieldError.checkNotNull(
                rowCount, r'ComplianceRegister', 'rowCount'),
            rejectedRowCount: BuiltValueNullFieldError.checkNotNull(
                rejectedRowCount, r'ComplianceRegister', 'rejectedRowCount'),
            activatedAt: activatedAt,
            supersededAt: supersededAt,
            createdAt: createdAt,
            columnMapping: _columnMapping?.build(),
            rejectedRows: _rejectedRows?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'columnMapping';
        _columnMapping?.build();
        _$failedField = 'rejectedRows';
        _rejectedRows?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ComplianceRegister', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
