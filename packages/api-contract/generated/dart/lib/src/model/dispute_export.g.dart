// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_export.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisputeExportStateEnum _$disputeExportStateEnum_QUEUED =
    const DisputeExportStateEnum._('QUEUED');
const DisputeExportStateEnum _$disputeExportStateEnum_READY =
    const DisputeExportStateEnum._('READY');
const DisputeExportStateEnum _$disputeExportStateEnum_REVOKED =
    const DisputeExportStateEnum._('REVOKED');
const DisputeExportStateEnum _$disputeExportStateEnum_FAILED =
    const DisputeExportStateEnum._('FAILED');
const DisputeExportStateEnum _$disputeExportStateEnum_EXPIRED =
    const DisputeExportStateEnum._('EXPIRED');

DisputeExportStateEnum _$disputeExportStateEnumValueOf(String name) {
  switch (name) {
    case 'QUEUED':
      return _$disputeExportStateEnum_QUEUED;
    case 'READY':
      return _$disputeExportStateEnum_READY;
    case 'REVOKED':
      return _$disputeExportStateEnum_REVOKED;
    case 'FAILED':
      return _$disputeExportStateEnum_FAILED;
    case 'EXPIRED':
      return _$disputeExportStateEnum_EXPIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeExportStateEnum> _$disputeExportStateEnumValues =
    BuiltSet<DisputeExportStateEnum>(const <DisputeExportStateEnum>[
  _$disputeExportStateEnum_QUEUED,
  _$disputeExportStateEnum_READY,
  _$disputeExportStateEnum_REVOKED,
  _$disputeExportStateEnum_FAILED,
  _$disputeExportStateEnum_EXPIRED,
]);

Serializer<DisputeExportStateEnum> _$disputeExportStateEnumSerializer =
    _$DisputeExportStateEnumSerializer();

class _$DisputeExportStateEnumSerializer
    implements PrimitiveSerializer<DisputeExportStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'QUEUED': 'QUEUED',
    'READY': 'READY',
    'REVOKED': 'REVOKED',
    'FAILED': 'FAILED',
    'EXPIRED': 'EXPIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'QUEUED': 'QUEUED',
    'READY': 'READY',
    'REVOKED': 'REVOKED',
    'FAILED': 'FAILED',
    'EXPIRED': 'EXPIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeExportStateEnum];
  @override
  final String wireName = 'DisputeExportStateEnum';

  @override
  Object serialize(Serializers serializers, DisputeExportStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeExportStateEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeExportStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeExport extends DisputeExport {
  @override
  final String id;
  @override
  final DisputeExportStateEnum state;
  @override
  final int? rowCount;
  @override
  final DateTime requestedAt;
  @override
  final DateTime? completedAt;
  @override
  final DateTime? expiresAt;
  @override
  final String? revocationReason;

  factory _$DisputeExport([void Function(DisputeExportBuilder)? updates]) =>
      (DisputeExportBuilder()..update(updates))._build();

  _$DisputeExport._(
      {required this.id,
      required this.state,
      this.rowCount,
      required this.requestedAt,
      this.completedAt,
      this.expiresAt,
      this.revocationReason})
      : super._();
  @override
  DisputeExport rebuild(void Function(DisputeExportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeExportBuilder toBuilder() => DisputeExportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeExport &&
        id == other.id &&
        state == other.state &&
        rowCount == other.rowCount &&
        requestedAt == other.requestedAt &&
        completedAt == other.completedAt &&
        expiresAt == other.expiresAt &&
        revocationReason == other.revocationReason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, rowCount.hashCode);
    _$hash = $jc(_$hash, requestedAt.hashCode);
    _$hash = $jc(_$hash, completedAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, revocationReason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeExport')
          ..add('id', id)
          ..add('state', state)
          ..add('rowCount', rowCount)
          ..add('requestedAt', requestedAt)
          ..add('completedAt', completedAt)
          ..add('expiresAt', expiresAt)
          ..add('revocationReason', revocationReason))
        .toString();
  }
}

class DisputeExportBuilder
    implements Builder<DisputeExport, DisputeExportBuilder> {
  _$DisputeExport? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DisputeExportStateEnum? _state;
  DisputeExportStateEnum? get state => _$this._state;
  set state(DisputeExportStateEnum? state) => _$this._state = state;

  int? _rowCount;
  int? get rowCount => _$this._rowCount;
  set rowCount(int? rowCount) => _$this._rowCount = rowCount;

  DateTime? _requestedAt;
  DateTime? get requestedAt => _$this._requestedAt;
  set requestedAt(DateTime? requestedAt) => _$this._requestedAt = requestedAt;

  DateTime? _completedAt;
  DateTime? get completedAt => _$this._completedAt;
  set completedAt(DateTime? completedAt) => _$this._completedAt = completedAt;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  String? _revocationReason;
  String? get revocationReason => _$this._revocationReason;
  set revocationReason(String? revocationReason) =>
      _$this._revocationReason = revocationReason;

  DisputeExportBuilder() {
    DisputeExport._defaults(this);
  }

  DisputeExportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _state = $v.state;
      _rowCount = $v.rowCount;
      _requestedAt = $v.requestedAt;
      _completedAt = $v.completedAt;
      _expiresAt = $v.expiresAt;
      _revocationReason = $v.revocationReason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeExport other) {
    _$v = other as _$DisputeExport;
  }

  @override
  void update(void Function(DisputeExportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeExport build() => _build();

  _$DisputeExport _build() {
    final _$result = _$v ??
        _$DisputeExport._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'DisputeExport', 'id'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'DisputeExport', 'state'),
          rowCount: rowCount,
          requestedAt: BuiltValueNullFieldError.checkNotNull(
              requestedAt, r'DisputeExport', 'requestedAt'),
          completedAt: completedAt,
          expiresAt: expiresAt,
          revocationReason: revocationReason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
