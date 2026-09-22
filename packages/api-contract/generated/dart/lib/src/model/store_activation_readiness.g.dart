// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_activation_readiness.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const StoreActivationReadinessStatusEnum
    _$storeActivationReadinessStatusEnum_READY =
    const StoreActivationReadinessStatusEnum._('READY');
const StoreActivationReadinessStatusEnum
    _$storeActivationReadinessStatusEnum_NOT_READY =
    const StoreActivationReadinessStatusEnum._('NOT_READY');

StoreActivationReadinessStatusEnum _$storeActivationReadinessStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'READY':
      return _$storeActivationReadinessStatusEnum_READY;
    case 'NOT_READY':
      return _$storeActivationReadinessStatusEnum_NOT_READY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<StoreActivationReadinessStatusEnum>
    _$storeActivationReadinessStatusEnumValues = BuiltSet<
        StoreActivationReadinessStatusEnum>(const <StoreActivationReadinessStatusEnum>[
  _$storeActivationReadinessStatusEnum_READY,
  _$storeActivationReadinessStatusEnum_NOT_READY,
]);

Serializer<StoreActivationReadinessStatusEnum>
    _$storeActivationReadinessStatusEnumSerializer =
    _$StoreActivationReadinessStatusEnumSerializer();

class _$StoreActivationReadinessStatusEnumSerializer
    implements PrimitiveSerializer<StoreActivationReadinessStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'READY': 'READY',
    'NOT_READY': 'NOT_READY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'READY': 'READY',
    'NOT_READY': 'NOT_READY',
  };

  @override
  final Iterable<Type> types = const <Type>[StoreActivationReadinessStatusEnum];
  @override
  final String wireName = 'StoreActivationReadinessStatusEnum';

  @override
  Object serialize(
          Serializers serializers, StoreActivationReadinessStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  StoreActivationReadinessStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      StoreActivationReadinessStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$StoreActivationReadiness extends StoreActivationReadiness {
  @override
  final bool ready;
  @override
  final StoreActivationReadinessStatusEnum status;
  @override
  final String ruleVersion;
  @override
  final BuiltList<StoreActivationBlocker> blockers;

  factory _$StoreActivationReadiness(
          [void Function(StoreActivationReadinessBuilder)? updates]) =>
      (StoreActivationReadinessBuilder()..update(updates))._build();

  _$StoreActivationReadiness._(
      {required this.ready,
      required this.status,
      required this.ruleVersion,
      required this.blockers})
      : super._();
  @override
  StoreActivationReadiness rebuild(
          void Function(StoreActivationReadinessBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StoreActivationReadinessBuilder toBuilder() =>
      StoreActivationReadinessBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StoreActivationReadiness &&
        ready == other.ready &&
        status == other.status &&
        ruleVersion == other.ruleVersion &&
        blockers == other.blockers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ready.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, ruleVersion.hashCode);
    _$hash = $jc(_$hash, blockers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StoreActivationReadiness')
          ..add('ready', ready)
          ..add('status', status)
          ..add('ruleVersion', ruleVersion)
          ..add('blockers', blockers))
        .toString();
  }
}

class StoreActivationReadinessBuilder
    implements
        Builder<StoreActivationReadiness, StoreActivationReadinessBuilder> {
  _$StoreActivationReadiness? _$v;

  bool? _ready;
  bool? get ready => _$this._ready;
  set ready(bool? ready) => _$this._ready = ready;

  StoreActivationReadinessStatusEnum? _status;
  StoreActivationReadinessStatusEnum? get status => _$this._status;
  set status(StoreActivationReadinessStatusEnum? status) =>
      _$this._status = status;

  String? _ruleVersion;
  String? get ruleVersion => _$this._ruleVersion;
  set ruleVersion(String? ruleVersion) => _$this._ruleVersion = ruleVersion;

  ListBuilder<StoreActivationBlocker>? _blockers;
  ListBuilder<StoreActivationBlocker> get blockers =>
      _$this._blockers ??= ListBuilder<StoreActivationBlocker>();
  set blockers(ListBuilder<StoreActivationBlocker>? blockers) =>
      _$this._blockers = blockers;

  StoreActivationReadinessBuilder() {
    StoreActivationReadiness._defaults(this);
  }

  StoreActivationReadinessBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ready = $v.ready;
      _status = $v.status;
      _ruleVersion = $v.ruleVersion;
      _blockers = $v.blockers.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StoreActivationReadiness other) {
    _$v = other as _$StoreActivationReadiness;
  }

  @override
  void update(void Function(StoreActivationReadinessBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StoreActivationReadiness build() => _build();

  _$StoreActivationReadiness _build() {
    _$StoreActivationReadiness _$result;
    try {
      _$result = _$v ??
          _$StoreActivationReadiness._(
            ready: BuiltValueNullFieldError.checkNotNull(
                ready, r'StoreActivationReadiness', 'ready'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'StoreActivationReadiness', 'status'),
            ruleVersion: BuiltValueNullFieldError.checkNotNull(
                ruleVersion, r'StoreActivationReadiness', 'ruleVersion'),
            blockers: blockers.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'blockers';
        blockers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'StoreActivationReadiness', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
