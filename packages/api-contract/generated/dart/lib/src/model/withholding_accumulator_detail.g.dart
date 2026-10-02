// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withholding_accumulator_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WithholdingAccumulatorDetailStatusEnum
    _$withholdingAccumulatorDetailStatusEnum_RELIEF_ACTIVE =
    const WithholdingAccumulatorDetailStatusEnum._('RELIEF_ACTIVE');
const WithholdingAccumulatorDetailStatusEnum
    _$withholdingAccumulatorDetailStatusEnum_SUBJECT_STANDARD =
    const WithholdingAccumulatorDetailStatusEnum._('SUBJECT_STANDARD');
const WithholdingAccumulatorDetailStatusEnum
    _$withholdingAccumulatorDetailStatusEnum_SUBJECT_THRESHOLD_BREACHED =
    const WithholdingAccumulatorDetailStatusEnum._(
        'SUBJECT_THRESHOLD_BREACHED');
const WithholdingAccumulatorDetailStatusEnum
    _$withholdingAccumulatorDetailStatusEnum_SUBJECT_PRIOR_YEAR =
    const WithholdingAccumulatorDetailStatusEnum._('SUBJECT_PRIOR_YEAR');
const WithholdingAccumulatorDetailStatusEnum
    _$withholdingAccumulatorDetailStatusEnum_UNDER_REVIEW =
    const WithholdingAccumulatorDetailStatusEnum._('UNDER_REVIEW');

WithholdingAccumulatorDetailStatusEnum
    _$withholdingAccumulatorDetailStatusEnumValueOf(String name) {
  switch (name) {
    case 'RELIEF_ACTIVE':
      return _$withholdingAccumulatorDetailStatusEnum_RELIEF_ACTIVE;
    case 'SUBJECT_STANDARD':
      return _$withholdingAccumulatorDetailStatusEnum_SUBJECT_STANDARD;
    case 'SUBJECT_THRESHOLD_BREACHED':
      return _$withholdingAccumulatorDetailStatusEnum_SUBJECT_THRESHOLD_BREACHED;
    case 'SUBJECT_PRIOR_YEAR':
      return _$withholdingAccumulatorDetailStatusEnum_SUBJECT_PRIOR_YEAR;
    case 'UNDER_REVIEW':
      return _$withholdingAccumulatorDetailStatusEnum_UNDER_REVIEW;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WithholdingAccumulatorDetailStatusEnum>
    _$withholdingAccumulatorDetailStatusEnumValues = BuiltSet<
        WithholdingAccumulatorDetailStatusEnum>(const <WithholdingAccumulatorDetailStatusEnum>[
  _$withholdingAccumulatorDetailStatusEnum_RELIEF_ACTIVE,
  _$withholdingAccumulatorDetailStatusEnum_SUBJECT_STANDARD,
  _$withholdingAccumulatorDetailStatusEnum_SUBJECT_THRESHOLD_BREACHED,
  _$withholdingAccumulatorDetailStatusEnum_SUBJECT_PRIOR_YEAR,
  _$withholdingAccumulatorDetailStatusEnum_UNDER_REVIEW,
]);

Serializer<WithholdingAccumulatorDetailStatusEnum>
    _$withholdingAccumulatorDetailStatusEnumSerializer =
    _$WithholdingAccumulatorDetailStatusEnumSerializer();

class _$WithholdingAccumulatorDetailStatusEnumSerializer
    implements PrimitiveSerializer<WithholdingAccumulatorDetailStatusEnum> {
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
    WithholdingAccumulatorDetailStatusEnum
  ];
  @override
  final String wireName = 'WithholdingAccumulatorDetailStatusEnum';

  @override
  Object serialize(Serializers serializers,
          WithholdingAccumulatorDetailStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WithholdingAccumulatorDetailStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WithholdingAccumulatorDetailStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WithholdingAccumulatorDetail extends WithholdingAccumulatorDetail {
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
  final WithholdingAccumulatorDetailStatusEnum status;
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
  @override
  final BuiltMap<String, JsonObject?> taxProfile;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> events;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> assessments;

  factory _$WithholdingAccumulatorDetail(
          [void Function(WithholdingAccumulatorDetailBuilder)? updates]) =>
      (WithholdingAccumulatorDetailBuilder()..update(updates))._build();

  _$WithholdingAccumulatorDetail._(
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
      required this.demo,
      required this.taxProfile,
      required this.events,
      required this.assessments})
      : super._();
  @override
  WithholdingAccumulatorDetail rebuild(
          void Function(WithholdingAccumulatorDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WithholdingAccumulatorDetailBuilder toBuilder() =>
      WithholdingAccumulatorDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WithholdingAccumulatorDetail &&
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
        demo == other.demo &&
        taxProfile == other.taxProfile &&
        events == other.events &&
        assessments == other.assessments;
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
    _$hash = $jc(_$hash, taxProfile.hashCode);
    _$hash = $jc(_$hash, events.hashCode);
    _$hash = $jc(_$hash, assessments.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WithholdingAccumulatorDetail')
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
          ..add('demo', demo)
          ..add('taxProfile', taxProfile)
          ..add('events', events)
          ..add('assessments', assessments))
        .toString();
  }
}

class WithholdingAccumulatorDetailBuilder
    implements
        Builder<WithholdingAccumulatorDetail,
            WithholdingAccumulatorDetailBuilder> {
  _$WithholdingAccumulatorDetail? _$v;

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

  WithholdingAccumulatorDetailStatusEnum? _status;
  WithholdingAccumulatorDetailStatusEnum? get status => _$this._status;
  set status(WithholdingAccumulatorDetailStatusEnum? status) =>
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

  MapBuilder<String, JsonObject?>? _taxProfile;
  MapBuilder<String, JsonObject?> get taxProfile =>
      _$this._taxProfile ??= MapBuilder<String, JsonObject?>();
  set taxProfile(MapBuilder<String, JsonObject?>? taxProfile) =>
      _$this._taxProfile = taxProfile;

  ListBuilder<BuiltMap<String, JsonObject?>>? _events;
  ListBuilder<BuiltMap<String, JsonObject?>> get events =>
      _$this._events ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set events(ListBuilder<BuiltMap<String, JsonObject?>>? events) =>
      _$this._events = events;

  ListBuilder<BuiltMap<String, JsonObject?>>? _assessments;
  ListBuilder<BuiltMap<String, JsonObject?>> get assessments =>
      _$this._assessments ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set assessments(ListBuilder<BuiltMap<String, JsonObject?>>? assessments) =>
      _$this._assessments = assessments;

  WithholdingAccumulatorDetailBuilder() {
    WithholdingAccumulatorDetail._defaults(this);
  }

  WithholdingAccumulatorDetailBuilder get _$this {
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
      _taxProfile = $v.taxProfile.toBuilder();
      _events = $v.events.toBuilder();
      _assessments = $v.assessments.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WithholdingAccumulatorDetail other) {
    _$v = other as _$WithholdingAccumulatorDetail;
  }

  @override
  void update(void Function(WithholdingAccumulatorDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WithholdingAccumulatorDetail build() => _build();

  _$WithholdingAccumulatorDetail _build() {
    _$WithholdingAccumulatorDetail _$result;
    try {
      _$result = _$v ??
          _$WithholdingAccumulatorDetail._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'WithholdingAccumulatorDetail', 'id'),
            vendor: vendor.build(),
            environment: BuiltValueNullFieldError.checkNotNull(
                environment, r'WithholdingAccumulatorDetail', 'environment'),
            taxpayerKeySuffix: BuiltValueNullFieldError.checkNotNull(
                taxpayerKeySuffix,
                r'WithholdingAccumulatorDetail',
                'taxpayerKeySuffix'),
            taxableYear: BuiltValueNullFieldError.checkNotNull(
                taxableYear, r'WithholdingAccumulatorDetail', 'taxableYear'),
            thresholdCentavos: BuiltValueNullFieldError.checkNotNull(
                thresholdCentavos,
                r'WithholdingAccumulatorDetail',
                'thresholdCentavos'),
            gAccumulatedCentavos: BuiltValueNullFieldError.checkNotNull(
                gAccumulatedCentavos,
                r'WithholdingAccumulatorDetail',
                'gAccumulatedCentavos'),
            gExternalDeclaredCentavos: BuiltValueNullFieldError.checkNotNull(
                gExternalDeclaredCentavos,
                r'WithholdingAccumulatorDetail',
                'gExternalDeclaredCentavos'),
            gExternalOverlapCentavos: BuiltValueNullFieldError.checkNotNull(
                gExternalOverlapCentavos,
                r'WithholdingAccumulatorDetail',
                'gExternalOverlapCentavos'),
            gEffectiveCentavos: BuiltValueNullFieldError.checkNotNull(
                gEffectiveCentavos,
                r'WithholdingAccumulatorDetail',
                'gEffectiveCentavos'),
            remainingAllowanceCentavos: BuiltValueNullFieldError.checkNotNull(
                remainingAllowanceCentavos,
                r'WithholdingAccumulatorDetail',
                'remainingAllowanceCentavos'),
            externalOverlapState: BuiltValueNullFieldError.checkNotNull(
                externalOverlapState,
                r'WithholdingAccumulatorDetail',
                'externalOverlapState'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'WithholdingAccumulatorDetail', 'status'),
            statusLabel: BuiltValueNullFieldError.checkNotNull(
                statusLabel, r'WithholdingAccumulatorDetail', 'statusLabel'),
            reasonCode: BuiltValueNullFieldError.checkNotNull(
                reasonCode, r'WithholdingAccumulatorDetail', 'reasonCode'),
            breached: BuiltValueNullFieldError.checkNotNull(
                breached, r'WithholdingAccumulatorDetail', 'breached'),
            crossedAt: crossedAt,
            priorYearTotalCentavos: priorYearTotalCentavos,
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'WithholdingAccumulatorDetail', 'lockVersion'),
            demo: BuiltValueNullFieldError.checkNotNull(
                demo, r'WithholdingAccumulatorDetail', 'demo'),
            taxProfile: taxProfile.build(),
            events: events.build(),
            assessments: assessments.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vendor';
        vendor.build();

        _$failedField = 'taxProfile';
        taxProfile.build();
        _$failedField = 'events';
        events.build();
        _$failedField = 'assessments';
        assessments.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WithholdingAccumulatorDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
