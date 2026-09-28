// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_accept_policy.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AutoAcceptPolicyPauseReasonEnum
    _$autoAcceptPolicyPauseReasonEnum_ALLOTMENT_EXHAUSTED =
    const AutoAcceptPolicyPauseReasonEnum._('ALLOTMENT_EXHAUSTED');
const AutoAcceptPolicyPauseReasonEnum _$autoAcceptPolicyPauseReasonEnum_MANUAL =
    const AutoAcceptPolicyPauseReasonEnum._('MANUAL');

AutoAcceptPolicyPauseReasonEnum _$autoAcceptPolicyPauseReasonEnumValueOf(
    String name) {
  switch (name) {
    case 'ALLOTMENT_EXHAUSTED':
      return _$autoAcceptPolicyPauseReasonEnum_ALLOTMENT_EXHAUSTED;
    case 'MANUAL':
      return _$autoAcceptPolicyPauseReasonEnum_MANUAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AutoAcceptPolicyPauseReasonEnum>
    _$autoAcceptPolicyPauseReasonEnumValues = BuiltSet<
        AutoAcceptPolicyPauseReasonEnum>(const <AutoAcceptPolicyPauseReasonEnum>[
  _$autoAcceptPolicyPauseReasonEnum_ALLOTMENT_EXHAUSTED,
  _$autoAcceptPolicyPauseReasonEnum_MANUAL,
]);

Serializer<AutoAcceptPolicyPauseReasonEnum>
    _$autoAcceptPolicyPauseReasonEnumSerializer =
    _$AutoAcceptPolicyPauseReasonEnumSerializer();

class _$AutoAcceptPolicyPauseReasonEnumSerializer
    implements PrimitiveSerializer<AutoAcceptPolicyPauseReasonEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ALLOTMENT_EXHAUSTED': 'ALLOTMENT_EXHAUSTED',
    'MANUAL': 'MANUAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ALLOTMENT_EXHAUSTED': 'ALLOTMENT_EXHAUSTED',
    'MANUAL': 'MANUAL',
  };

  @override
  final Iterable<Type> types = const <Type>[AutoAcceptPolicyPauseReasonEnum];
  @override
  final String wireName = 'AutoAcceptPolicyPauseReasonEnum';

  @override
  Object serialize(
          Serializers serializers, AutoAcceptPolicyPauseReasonEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AutoAcceptPolicyPauseReasonEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AutoAcceptPolicyPauseReasonEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AutoAcceptPolicy extends AutoAcceptPolicy {
  @override
  final AutoAcceptStatus status;
  @override
  final bool enabled;
  @override
  final bool paused;
  @override
  final AutoAcceptPolicyPauseReasonEnum? pauseReason;
  @override
  final String? pausedAt;
  @override
  final String allotmentQuantity;
  @override
  final String remainingAllotmentQuantity;
  @override
  final String? maxUnitCount;
  @override
  final int? maxOrderAmountCentavos;
  @override
  final int currentVersion;
  @override
  final int lockVersion;
  @override
  final String? updatedAt;
  @override
  final String? lastEditor;

  factory _$AutoAcceptPolicy(
          [void Function(AutoAcceptPolicyBuilder)? updates]) =>
      (AutoAcceptPolicyBuilder()..update(updates))._build();

  _$AutoAcceptPolicy._(
      {required this.status,
      required this.enabled,
      required this.paused,
      this.pauseReason,
      this.pausedAt,
      required this.allotmentQuantity,
      required this.remainingAllotmentQuantity,
      this.maxUnitCount,
      this.maxOrderAmountCentavos,
      required this.currentVersion,
      required this.lockVersion,
      this.updatedAt,
      this.lastEditor})
      : super._();
  @override
  AutoAcceptPolicy rebuild(void Function(AutoAcceptPolicyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AutoAcceptPolicyBuilder toBuilder() =>
      AutoAcceptPolicyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AutoAcceptPolicy &&
        status == other.status &&
        enabled == other.enabled &&
        paused == other.paused &&
        pauseReason == other.pauseReason &&
        pausedAt == other.pausedAt &&
        allotmentQuantity == other.allotmentQuantity &&
        remainingAllotmentQuantity == other.remainingAllotmentQuantity &&
        maxUnitCount == other.maxUnitCount &&
        maxOrderAmountCentavos == other.maxOrderAmountCentavos &&
        currentVersion == other.currentVersion &&
        lockVersion == other.lockVersion &&
        updatedAt == other.updatedAt &&
        lastEditor == other.lastEditor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, paused.hashCode);
    _$hash = $jc(_$hash, pauseReason.hashCode);
    _$hash = $jc(_$hash, pausedAt.hashCode);
    _$hash = $jc(_$hash, allotmentQuantity.hashCode);
    _$hash = $jc(_$hash, remainingAllotmentQuantity.hashCode);
    _$hash = $jc(_$hash, maxUnitCount.hashCode);
    _$hash = $jc(_$hash, maxOrderAmountCentavos.hashCode);
    _$hash = $jc(_$hash, currentVersion.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, lastEditor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AutoAcceptPolicy')
          ..add('status', status)
          ..add('enabled', enabled)
          ..add('paused', paused)
          ..add('pauseReason', pauseReason)
          ..add('pausedAt', pausedAt)
          ..add('allotmentQuantity', allotmentQuantity)
          ..add('remainingAllotmentQuantity', remainingAllotmentQuantity)
          ..add('maxUnitCount', maxUnitCount)
          ..add('maxOrderAmountCentavos', maxOrderAmountCentavos)
          ..add('currentVersion', currentVersion)
          ..add('lockVersion', lockVersion)
          ..add('updatedAt', updatedAt)
          ..add('lastEditor', lastEditor))
        .toString();
  }
}

class AutoAcceptPolicyBuilder
    implements Builder<AutoAcceptPolicy, AutoAcceptPolicyBuilder> {
  _$AutoAcceptPolicy? _$v;

  AutoAcceptStatus? _status;
  AutoAcceptStatus? get status => _$this._status;
  set status(AutoAcceptStatus? status) => _$this._status = status;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  bool? _paused;
  bool? get paused => _$this._paused;
  set paused(bool? paused) => _$this._paused = paused;

  AutoAcceptPolicyPauseReasonEnum? _pauseReason;
  AutoAcceptPolicyPauseReasonEnum? get pauseReason => _$this._pauseReason;
  set pauseReason(AutoAcceptPolicyPauseReasonEnum? pauseReason) =>
      _$this._pauseReason = pauseReason;

  String? _pausedAt;
  String? get pausedAt => _$this._pausedAt;
  set pausedAt(String? pausedAt) => _$this._pausedAt = pausedAt;

  String? _allotmentQuantity;
  String? get allotmentQuantity => _$this._allotmentQuantity;
  set allotmentQuantity(String? allotmentQuantity) =>
      _$this._allotmentQuantity = allotmentQuantity;

  String? _remainingAllotmentQuantity;
  String? get remainingAllotmentQuantity => _$this._remainingAllotmentQuantity;
  set remainingAllotmentQuantity(String? remainingAllotmentQuantity) =>
      _$this._remainingAllotmentQuantity = remainingAllotmentQuantity;

  String? _maxUnitCount;
  String? get maxUnitCount => _$this._maxUnitCount;
  set maxUnitCount(String? maxUnitCount) => _$this._maxUnitCount = maxUnitCount;

  int? _maxOrderAmountCentavos;
  int? get maxOrderAmountCentavos => _$this._maxOrderAmountCentavos;
  set maxOrderAmountCentavos(int? maxOrderAmountCentavos) =>
      _$this._maxOrderAmountCentavos = maxOrderAmountCentavos;

  int? _currentVersion;
  int? get currentVersion => _$this._currentVersion;
  set currentVersion(int? currentVersion) =>
      _$this._currentVersion = currentVersion;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  String? _lastEditor;
  String? get lastEditor => _$this._lastEditor;
  set lastEditor(String? lastEditor) => _$this._lastEditor = lastEditor;

  AutoAcceptPolicyBuilder() {
    AutoAcceptPolicy._defaults(this);
  }

  AutoAcceptPolicyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _enabled = $v.enabled;
      _paused = $v.paused;
      _pauseReason = $v.pauseReason;
      _pausedAt = $v.pausedAt;
      _allotmentQuantity = $v.allotmentQuantity;
      _remainingAllotmentQuantity = $v.remainingAllotmentQuantity;
      _maxUnitCount = $v.maxUnitCount;
      _maxOrderAmountCentavos = $v.maxOrderAmountCentavos;
      _currentVersion = $v.currentVersion;
      _lockVersion = $v.lockVersion;
      _updatedAt = $v.updatedAt;
      _lastEditor = $v.lastEditor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AutoAcceptPolicy other) {
    _$v = other as _$AutoAcceptPolicy;
  }

  @override
  void update(void Function(AutoAcceptPolicyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AutoAcceptPolicy build() => _build();

  _$AutoAcceptPolicy _build() {
    final _$result = _$v ??
        _$AutoAcceptPolicy._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AutoAcceptPolicy', 'status'),
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'AutoAcceptPolicy', 'enabled'),
          paused: BuiltValueNullFieldError.checkNotNull(
              paused, r'AutoAcceptPolicy', 'paused'),
          pauseReason: pauseReason,
          pausedAt: pausedAt,
          allotmentQuantity: BuiltValueNullFieldError.checkNotNull(
              allotmentQuantity, r'AutoAcceptPolicy', 'allotmentQuantity'),
          remainingAllotmentQuantity: BuiltValueNullFieldError.checkNotNull(
              remainingAllotmentQuantity,
              r'AutoAcceptPolicy',
              'remainingAllotmentQuantity'),
          maxUnitCount: maxUnitCount,
          maxOrderAmountCentavos: maxOrderAmountCentavos,
          currentVersion: BuiltValueNullFieldError.checkNotNull(
              currentVersion, r'AutoAcceptPolicy', 'currentVersion'),
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'AutoAcceptPolicy', 'lockVersion'),
          updatedAt: updatedAt,
          lastEditor: lastEditor,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
