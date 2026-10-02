// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withholding_accumulator_view.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WithholdingAccumulatorViewStatusEnum
    _$withholdingAccumulatorViewStatusEnum_RELIEF_ACTIVE =
    const WithholdingAccumulatorViewStatusEnum._('RELIEF_ACTIVE');
const WithholdingAccumulatorViewStatusEnum
    _$withholdingAccumulatorViewStatusEnum_SUBJECT_STANDARD =
    const WithholdingAccumulatorViewStatusEnum._('SUBJECT_STANDARD');
const WithholdingAccumulatorViewStatusEnum
    _$withholdingAccumulatorViewStatusEnum_SUBJECT_THRESHOLD_BREACHED =
    const WithholdingAccumulatorViewStatusEnum._('SUBJECT_THRESHOLD_BREACHED');
const WithholdingAccumulatorViewStatusEnum
    _$withholdingAccumulatorViewStatusEnum_SUBJECT_PRIOR_YEAR =
    const WithholdingAccumulatorViewStatusEnum._('SUBJECT_PRIOR_YEAR');
const WithholdingAccumulatorViewStatusEnum
    _$withholdingAccumulatorViewStatusEnum_UNDER_REVIEW =
    const WithholdingAccumulatorViewStatusEnum._('UNDER_REVIEW');

WithholdingAccumulatorViewStatusEnum
    _$withholdingAccumulatorViewStatusEnumValueOf(String name) {
  switch (name) {
    case 'RELIEF_ACTIVE':
      return _$withholdingAccumulatorViewStatusEnum_RELIEF_ACTIVE;
    case 'SUBJECT_STANDARD':
      return _$withholdingAccumulatorViewStatusEnum_SUBJECT_STANDARD;
    case 'SUBJECT_THRESHOLD_BREACHED':
      return _$withholdingAccumulatorViewStatusEnum_SUBJECT_THRESHOLD_BREACHED;
    case 'SUBJECT_PRIOR_YEAR':
      return _$withholdingAccumulatorViewStatusEnum_SUBJECT_PRIOR_YEAR;
    case 'UNDER_REVIEW':
      return _$withholdingAccumulatorViewStatusEnum_UNDER_REVIEW;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WithholdingAccumulatorViewStatusEnum>
    _$withholdingAccumulatorViewStatusEnumValues = BuiltSet<
        WithholdingAccumulatorViewStatusEnum>(const <WithholdingAccumulatorViewStatusEnum>[
  _$withholdingAccumulatorViewStatusEnum_RELIEF_ACTIVE,
  _$withholdingAccumulatorViewStatusEnum_SUBJECT_STANDARD,
  _$withholdingAccumulatorViewStatusEnum_SUBJECT_THRESHOLD_BREACHED,
  _$withholdingAccumulatorViewStatusEnum_SUBJECT_PRIOR_YEAR,
  _$withholdingAccumulatorViewStatusEnum_UNDER_REVIEW,
]);

Serializer<WithholdingAccumulatorViewStatusEnum>
    _$withholdingAccumulatorViewStatusEnumSerializer =
    _$WithholdingAccumulatorViewStatusEnumSerializer();

class _$WithholdingAccumulatorViewStatusEnumSerializer
    implements PrimitiveSerializer<WithholdingAccumulatorViewStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'RELIEF_ACTIVE': 'RELIEF_ACTIVE',
    'SUBJECT_STANDARD': 'SUBJECT_STANDARD',
    'SUBJECT_THRESHOLD_BREACHED': 'SUBJECT_THRESHOLD_BREACHED',
    'SUBJECT_PRIOR_YEAR': 'SUBJECT_PRIOR_YEAR',
    'UNDER_REVIEW': 'UNDER_REVIEW',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'RELIEF_ACTIVE': 'RELIEF_ACTIVE',
    'SUBJECT_STANDARD': 'SUBJECT_STANDARD',
    'SUBJECT_THRESHOLD_BREACHED': 'SUBJECT_THRESHOLD_BREACHED',
    'SUBJECT_PRIOR_YEAR': 'SUBJECT_PRIOR_YEAR',
    'UNDER_REVIEW': 'UNDER_REVIEW',
  };

  @override
  final Iterable<Type> types = const <Type>[
    WithholdingAccumulatorViewStatusEnum
  ];
  @override
  final String wireName = 'WithholdingAccumulatorViewStatusEnum';

  @override
  Object serialize(
          Serializers serializers, WithholdingAccumulatorViewStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WithholdingAccumulatorViewStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WithholdingAccumulatorViewStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WithholdingAccumulatorView extends WithholdingAccumulatorView {
  @override
  final String id;
  @override
  final BuiltMap<String, JsonObject?> vendor;
  @override
  final String environment;
  @override
  final String taxpayerKeySuffix;
  @override
  final int taxableYear;
  @override
  final int thresholdCentavos;
  @override
  final int gAccumulatedCentavos;
  @override
  final int gExternalDeclaredCentavos;
  @override
  final int gExternalOverlapCentavos;
  @override
  final int gEffectiveCentavos;
  @override
  final int remainingAllowanceCentavos;
  @override
  final String externalOverlapState;
  @override
  final WithholdingAccumulatorViewStatusEnum status;
  @override
  final String statusLabel;
  @override
  final String reasonCode;
  @override
  final bool breached;
  @override
  final DateTime? crossedAt;
  @override
  final int? priorYearTotalCentavos;
  @override
  final int lockVersion;
  @override
  final bool demo;

  factory _$WithholdingAccumulatorView(
          [void Function(WithholdingAccumulatorViewBuilder)? updates]) =>
      (WithholdingAccumulatorViewBuilder()..update(updates))._build();

  _$WithholdingAccumulatorView._(
      {required this.id,
      required this.vendor,
      required this.environment,
      required this.taxpayerKeySuffix,
      required this.taxableYear,
      required this.thresholdCentavos,
      required this.gAccumulatedCentavos,
      required this.gExternalDeclaredCentavos,
      required this.gExternalOverlapCentavos,
      required this.gEffectiveCentavos,
      required this.remainingAllowanceCentavos,
      required this.externalOverlapState,
      required this.status,
      required this.statusLabel,
      required this.reasonCode,
      required this.breached,
      this.crossedAt,
      this.priorYearTotalCentavos,
      required this.lockVersion,
      required this.demo})
      : super._();
  @override
  WithholdingAccumulatorView rebuild(
          void Function(WithholdingAccumulatorViewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WithholdingAccumulatorViewBuilder toBuilder() =>
      WithholdingAccumulatorViewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WithholdingAccumulatorView &&
        id == other.id &&
        vendor == other.vendor &&
        environment == other.environment &&
        taxpayerKeySuffix == other.taxpayerKeySuffix &&
        taxableYear == other.taxableYear &&
        thresholdCentavos == other.thresholdCentavos &&
        gAccumulatedCentavos == other.gAccumulatedCentavos &&
        gExternalDeclaredCentavos == other.gExternalDeclaredCentavos &&
        gExternalOverlapCentavos == other.gExternalOverlapCentavos &&
        gEffectiveCentavos == other.gEffectiveCentavos &&
        remainingAllowanceCentavos == other.remainingAllowanceCentavos &&
        externalOverlapState == other.externalOverlapState &&
        status == other.status &&
        statusLabel == other.statusLabel &&
        reasonCode == other.reasonCode &&
        breached == other.breached &&
        crossedAt == other.crossedAt &&
        priorYearTotalCentavos == other.priorYearTotalCentavos &&
        lockVersion == other.lockVersion &&
        demo == other.demo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, vendor.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, taxpayerKeySuffix.hashCode);
    _$hash = $jc(_$hash, taxableYear.hashCode);
    _$hash = $jc(_$hash, thresholdCentavos.hashCode);
    _$hash = $jc(_$hash, gAccumulatedCentavos.hashCode);
    _$hash = $jc(_$hash, gExternalDeclaredCentavos.hashCode);
    _$hash = $jc(_$hash, gExternalOverlapCentavos.hashCode);
    _$hash = $jc(_$hash, gEffectiveCentavos.hashCode);
    _$hash = $jc(_$hash, remainingAllowanceCentavos.hashCode);
    _$hash = $jc(_$hash, externalOverlapState.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, statusLabel.hashCode);
    _$hash = $jc(_$hash, reasonCode.hashCode);
    _$hash = $jc(_$hash, breached.hashCode);
    _$hash = $jc(_$hash, crossedAt.hashCode);
    _$hash = $jc(_$hash, priorYearTotalCentavos.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, demo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WithholdingAccumulatorView')
          ..add('id', id)
          ..add('vendor', vendor)
          ..add('environment', environment)
          ..add('taxpayerKeySuffix', taxpayerKeySuffix)
          ..add('taxableYear', taxableYear)
          ..add('thresholdCentavos', thresholdCentavos)
          ..add('gAccumulatedCentavos', gAccumulatedCentavos)
          ..add('gExternalDeclaredCentavos', gExternalDeclaredCentavos)
          ..add('gExternalOverlapCentavos', gExternalOverlapCentavos)
          ..add('gEffectiveCentavos', gEffectiveCentavos)
          ..add('remainingAllowanceCentavos', remainingAllowanceCentavos)
          ..add('externalOverlapState', externalOverlapState)
          ..add('status', status)
          ..add('statusLabel', statusLabel)
          ..add('reasonCode', reasonCode)
          ..add('breached', breached)
          ..add('crossedAt', crossedAt)
          ..add('priorYearTotalCentavos', priorYearTotalCentavos)
          ..add('lockVersion', lockVersion)
          ..add('demo', demo))
        .toString();
  }
}

class WithholdingAccumulatorViewBuilder
    implements
        Builder<WithholdingAccumulatorView, WithholdingAccumulatorViewBuilder> {
  _$WithholdingAccumulatorView? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  MapBuilder<String, JsonObject?>? _vendor;
  MapBuilder<String, JsonObject?> get vendor =>
      _$this._vendor ??= MapBuilder<String, JsonObject?>();
  set vendor(MapBuilder<String, JsonObject?>? vendor) =>
      _$this._vendor = vendor;

  String? _environment;
  String? get environment => _$this._environment;
  set environment(String? environment) => _$this._environment = environment;

  String? _taxpayerKeySuffix;
  String? get taxpayerKeySuffix => _$this._taxpayerKeySuffix;
  set taxpayerKeySuffix(String? taxpayerKeySuffix) =>
      _$this._taxpayerKeySuffix = taxpayerKeySuffix;

  int? _taxableYear;
  int? get taxableYear => _$this._taxableYear;
  set taxableYear(int? taxableYear) => _$this._taxableYear = taxableYear;

  int? _thresholdCentavos;
  int? get thresholdCentavos => _$this._thresholdCentavos;
  set thresholdCentavos(int? thresholdCentavos) =>
      _$this._thresholdCentavos = thresholdCentavos;

  int? _gAccumulatedCentavos;
  int? get gAccumulatedCentavos => _$this._gAccumulatedCentavos;
  set gAccumulatedCentavos(int? gAccumulatedCentavos) =>
      _$this._gAccumulatedCentavos = gAccumulatedCentavos;

  int? _gExternalDeclaredCentavos;
  int? get gExternalDeclaredCentavos => _$this._gExternalDeclaredCentavos;
  set gExternalDeclaredCentavos(int? gExternalDeclaredCentavos) =>
      _$this._gExternalDeclaredCentavos = gExternalDeclaredCentavos;

  int? _gExternalOverlapCentavos;
  int? get gExternalOverlapCentavos => _$this._gExternalOverlapCentavos;
  set gExternalOverlapCentavos(int? gExternalOverlapCentavos) =>
      _$this._gExternalOverlapCentavos = gExternalOverlapCentavos;

  int? _gEffectiveCentavos;
  int? get gEffectiveCentavos => _$this._gEffectiveCentavos;
  set gEffectiveCentavos(int? gEffectiveCentavos) =>
      _$this._gEffectiveCentavos = gEffectiveCentavos;

  int? _remainingAllowanceCentavos;
  int? get remainingAllowanceCentavos => _$this._remainingAllowanceCentavos;
  set remainingAllowanceCentavos(int? remainingAllowanceCentavos) =>
      _$this._remainingAllowanceCentavos = remainingAllowanceCentavos;

  String? _externalOverlapState;
  String? get externalOverlapState => _$this._externalOverlapState;
  set externalOverlapState(String? externalOverlapState) =>
      _$this._externalOverlapState = externalOverlapState;

  WithholdingAccumulatorViewStatusEnum? _status;
  WithholdingAccumulatorViewStatusEnum? get status => _$this._status;
  set status(WithholdingAccumulatorViewStatusEnum? status) =>
      _$this._status = status;

  String? _statusLabel;
  String? get statusLabel => _$this._statusLabel;
  set statusLabel(String? statusLabel) => _$this._statusLabel = statusLabel;

  String? _reasonCode;
  String? get reasonCode => _$this._reasonCode;
  set reasonCode(String? reasonCode) => _$this._reasonCode = reasonCode;

  bool? _breached;
  bool? get breached => _$this._breached;
  set breached(bool? breached) => _$this._breached = breached;

  DateTime? _crossedAt;
  DateTime? get crossedAt => _$this._crossedAt;
  set crossedAt(DateTime? crossedAt) => _$this._crossedAt = crossedAt;

  int? _priorYearTotalCentavos;
  int? get priorYearTotalCentavos => _$this._priorYearTotalCentavos;
  set priorYearTotalCentavos(int? priorYearTotalCentavos) =>
      _$this._priorYearTotalCentavos = priorYearTotalCentavos;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  bool? _demo;
  bool? get demo => _$this._demo;
  set demo(bool? demo) => _$this._demo = demo;

  WithholdingAccumulatorViewBuilder() {
    WithholdingAccumulatorView._defaults(this);
  }

  WithholdingAccumulatorViewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _vendor = $v.vendor.toBuilder();
      _environment = $v.environment;
      _taxpayerKeySuffix = $v.taxpayerKeySuffix;
      _taxableYear = $v.taxableYear;
      _thresholdCentavos = $v.thresholdCentavos;
      _gAccumulatedCentavos = $v.gAccumulatedCentavos;
      _gExternalDeclaredCentavos = $v.gExternalDeclaredCentavos;
      _gExternalOverlapCentavos = $v.gExternalOverlapCentavos;
      _gEffectiveCentavos = $v.gEffectiveCentavos;
      _remainingAllowanceCentavos = $v.remainingAllowanceCentavos;
      _externalOverlapState = $v.externalOverlapState;
      _status = $v.status;
      _statusLabel = $v.statusLabel;
      _reasonCode = $v.reasonCode;
      _breached = $v.breached;
      _crossedAt = $v.crossedAt;
      _priorYearTotalCentavos = $v.priorYearTotalCentavos;
      _lockVersion = $v.lockVersion;
      _demo = $v.demo;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WithholdingAccumulatorView other) {
    _$v = other as _$WithholdingAccumulatorView;
  }

  @override
  void update(void Function(WithholdingAccumulatorViewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WithholdingAccumulatorView build() => _build();

  _$WithholdingAccumulatorView _build() {
    _$WithholdingAccumulatorView _$result;
    try {
      _$result = _$v ??
          _$WithholdingAccumulatorView._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'WithholdingAccumulatorView', 'id'),
            vendor: vendor.build(),
            environment: BuiltValueNullFieldError.checkNotNull(
                environment, r'WithholdingAccumulatorView', 'environment'),
            taxpayerKeySuffix: BuiltValueNullFieldError.checkNotNull(
                taxpayerKeySuffix,
                r'WithholdingAccumulatorView',
                'taxpayerKeySuffix'),
            taxableYear: BuiltValueNullFieldError.checkNotNull(
                taxableYear, r'WithholdingAccumulatorView', 'taxableYear'),
            thresholdCentavos: BuiltValueNullFieldError.checkNotNull(
                thresholdCentavos,
                r'WithholdingAccumulatorView',
                'thresholdCentavos'),
            gAccumulatedCentavos: BuiltValueNullFieldError.checkNotNull(
                gAccumulatedCentavos,
                r'WithholdingAccumulatorView',
                'gAccumulatedCentavos'),
            gExternalDeclaredCentavos: BuiltValueNullFieldError.checkNotNull(
                gExternalDeclaredCentavos,
                r'WithholdingAccumulatorView',
                'gExternalDeclaredCentavos'),
            gExternalOverlapCentavos: BuiltValueNullFieldError.checkNotNull(
                gExternalOverlapCentavos,
                r'WithholdingAccumulatorView',
                'gExternalOverlapCentavos'),
            gEffectiveCentavos: BuiltValueNullFieldError.checkNotNull(
                gEffectiveCentavos,
                r'WithholdingAccumulatorView',
                'gEffectiveCentavos'),
            remainingAllowanceCentavos: BuiltValueNullFieldError.checkNotNull(
                remainingAllowanceCentavos,
                r'WithholdingAccumulatorView',
                'remainingAllowanceCentavos'),
            externalOverlapState: BuiltValueNullFieldError.checkNotNull(
                externalOverlapState,
                r'WithholdingAccumulatorView',
                'externalOverlapState'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'WithholdingAccumulatorView', 'status'),
            statusLabel: BuiltValueNullFieldError.checkNotNull(
                statusLabel, r'WithholdingAccumulatorView', 'statusLabel'),
            reasonCode: BuiltValueNullFieldError.checkNotNull(
                reasonCode, r'WithholdingAccumulatorView', 'reasonCode'),
            breached: BuiltValueNullFieldError.checkNotNull(
                breached, r'WithholdingAccumulatorView', 'breached'),
            crossedAt: crossedAt,
            priorYearTotalCentavos: priorYearTotalCentavos,
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'WithholdingAccumulatorView', 'lockVersion'),
            demo: BuiltValueNullFieldError.checkNotNull(
                demo, r'WithholdingAccumulatorView', 'demo'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vendor';
        vendor.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WithholdingAccumulatorView', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
