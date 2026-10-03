// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withholding_threshold_panel.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WithholdingThresholdPanelExternalOverlapStateEnum
    _$withholdingThresholdPanelExternalOverlapStateEnum_NONE =
    const WithholdingThresholdPanelExternalOverlapStateEnum._('NONE');
const WithholdingThresholdPanelExternalOverlapStateEnum
    _$withholdingThresholdPanelExternalOverlapStateEnum_UNRESOLVED =
    const WithholdingThresholdPanelExternalOverlapStateEnum._('UNRESOLVED');
const WithholdingThresholdPanelExternalOverlapStateEnum
    _$withholdingThresholdPanelExternalOverlapStateEnum_RESOLVED =
    const WithholdingThresholdPanelExternalOverlapStateEnum._('RESOLVED');

WithholdingThresholdPanelExternalOverlapStateEnum
    _$withholdingThresholdPanelExternalOverlapStateEnumValueOf(String name) {
  switch (name) {
    case 'NONE':
      return _$withholdingThresholdPanelExternalOverlapStateEnum_NONE;
    case 'UNRESOLVED':
      return _$withholdingThresholdPanelExternalOverlapStateEnum_UNRESOLVED;
    case 'RESOLVED':
      return _$withholdingThresholdPanelExternalOverlapStateEnum_RESOLVED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WithholdingThresholdPanelExternalOverlapStateEnum>
    _$withholdingThresholdPanelExternalOverlapStateEnumValues = BuiltSet<
        WithholdingThresholdPanelExternalOverlapStateEnum>(const <WithholdingThresholdPanelExternalOverlapStateEnum>[
  _$withholdingThresholdPanelExternalOverlapStateEnum_NONE,
  _$withholdingThresholdPanelExternalOverlapStateEnum_UNRESOLVED,
  _$withholdingThresholdPanelExternalOverlapStateEnum_RESOLVED,
]);

const WithholdingThresholdPanelStatusEnum
    _$withholdingThresholdPanelStatusEnum_RELIEF_ACTIVE =
    const WithholdingThresholdPanelStatusEnum._('RELIEF_ACTIVE');
const WithholdingThresholdPanelStatusEnum
    _$withholdingThresholdPanelStatusEnum_SUBJECT_STANDARD =
    const WithholdingThresholdPanelStatusEnum._('SUBJECT_STANDARD');
const WithholdingThresholdPanelStatusEnum
    _$withholdingThresholdPanelStatusEnum_SUBJECT_THRESHOLD_BREACHED =
    const WithholdingThresholdPanelStatusEnum._('SUBJECT_THRESHOLD_BREACHED');
const WithholdingThresholdPanelStatusEnum
    _$withholdingThresholdPanelStatusEnum_SUBJECT_PRIOR_YEAR =
    const WithholdingThresholdPanelStatusEnum._('SUBJECT_PRIOR_YEAR');
const WithholdingThresholdPanelStatusEnum
    _$withholdingThresholdPanelStatusEnum_UNDER_REVIEW =
    const WithholdingThresholdPanelStatusEnum._('UNDER_REVIEW');
const WithholdingThresholdPanelStatusEnum
    _$withholdingThresholdPanelStatusEnum_NOT_STARTED =
    const WithholdingThresholdPanelStatusEnum._('NOT_STARTED');

WithholdingThresholdPanelStatusEnum
    _$withholdingThresholdPanelStatusEnumValueOf(String name) {
  switch (name) {
    case 'RELIEF_ACTIVE':
      return _$withholdingThresholdPanelStatusEnum_RELIEF_ACTIVE;
    case 'SUBJECT_STANDARD':
      return _$withholdingThresholdPanelStatusEnum_SUBJECT_STANDARD;
    case 'SUBJECT_THRESHOLD_BREACHED':
      return _$withholdingThresholdPanelStatusEnum_SUBJECT_THRESHOLD_BREACHED;
    case 'SUBJECT_PRIOR_YEAR':
      return _$withholdingThresholdPanelStatusEnum_SUBJECT_PRIOR_YEAR;
    case 'UNDER_REVIEW':
      return _$withholdingThresholdPanelStatusEnum_UNDER_REVIEW;
    case 'NOT_STARTED':
      return _$withholdingThresholdPanelStatusEnum_NOT_STARTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WithholdingThresholdPanelStatusEnum>
    _$withholdingThresholdPanelStatusEnumValues = BuiltSet<
        WithholdingThresholdPanelStatusEnum>(const <WithholdingThresholdPanelStatusEnum>[
  _$withholdingThresholdPanelStatusEnum_RELIEF_ACTIVE,
  _$withholdingThresholdPanelStatusEnum_SUBJECT_STANDARD,
  _$withholdingThresholdPanelStatusEnum_SUBJECT_THRESHOLD_BREACHED,
  _$withholdingThresholdPanelStatusEnum_SUBJECT_PRIOR_YEAR,
  _$withholdingThresholdPanelStatusEnum_UNDER_REVIEW,
  _$withholdingThresholdPanelStatusEnum_NOT_STARTED,
]);

Serializer<WithholdingThresholdPanelExternalOverlapStateEnum>
    _$withholdingThresholdPanelExternalOverlapStateEnumSerializer =
    _$WithholdingThresholdPanelExternalOverlapStateEnumSerializer();
Serializer<WithholdingThresholdPanelStatusEnum>
    _$withholdingThresholdPanelStatusEnumSerializer =
    _$WithholdingThresholdPanelStatusEnumSerializer();

class _$WithholdingThresholdPanelExternalOverlapStateEnumSerializer
    implements
        PrimitiveSerializer<WithholdingThresholdPanelExternalOverlapStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NONE': 'NONE',
    'UNRESOLVED': 'UNRESOLVED',
    'RESOLVED': 'RESOLVED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NONE': 'NONE',
    'UNRESOLVED': 'UNRESOLVED',
    'RESOLVED': 'RESOLVED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    WithholdingThresholdPanelExternalOverlapStateEnum
  ];
  @override
  final String wireName = 'WithholdingThresholdPanelExternalOverlapStateEnum';

  @override
  Object serialize(Serializers serializers,
          WithholdingThresholdPanelExternalOverlapStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WithholdingThresholdPanelExternalOverlapStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WithholdingThresholdPanelExternalOverlapStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WithholdingThresholdPanelStatusEnumSerializer
    implements PrimitiveSerializer<WithholdingThresholdPanelStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'RELIEF_ACTIVE': 'RELIEF_ACTIVE',
    'SUBJECT_STANDARD': 'SUBJECT_STANDARD',
    'SUBJECT_THRESHOLD_BREACHED': 'SUBJECT_THRESHOLD_BREACHED',
    'SUBJECT_PRIOR_YEAR': 'SUBJECT_PRIOR_YEAR',
    'UNDER_REVIEW': 'UNDER_REVIEW',
    'NOT_STARTED': 'NOT_STARTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'RELIEF_ACTIVE': 'RELIEF_ACTIVE',
    'SUBJECT_STANDARD': 'SUBJECT_STANDARD',
    'SUBJECT_THRESHOLD_BREACHED': 'SUBJECT_THRESHOLD_BREACHED',
    'SUBJECT_PRIOR_YEAR': 'SUBJECT_PRIOR_YEAR',
    'UNDER_REVIEW': 'UNDER_REVIEW',
    'NOT_STARTED': 'NOT_STARTED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    WithholdingThresholdPanelStatusEnum
  ];
  @override
  final String wireName = 'WithholdingThresholdPanelStatusEnum';

  @override
  Object serialize(
          Serializers serializers, WithholdingThresholdPanelStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WithholdingThresholdPanelStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WithholdingThresholdPanelStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WithholdingThresholdPanel extends WithholdingThresholdPanel {
  @override
  final bool demo;
  @override
  final int taxableYear;
  @override
  final DateTime yearStartAt;
  @override
  final DateTime yearEndAt;
  @override
  final int thresholdCentavos;
  @override
  final int cumulativeGrossCentavos;
  @override
  final int remainingAllowanceCentavos;
  @override
  final int localGrossCentavos;
  @override
  final int externalDeclaredCentavos;
  @override
  final int externalOverlapCentavos;
  @override
  final WithholdingThresholdPanelExternalOverlapStateEnum externalOverlapState;
  @override
  final int percentOfThreshold;
  @override
  final bool advisory;
  @override
  final WithholdingThresholdPanelStatusEnum status;
  @override
  final String statusLabel;
  @override
  final String statusIcon;
  @override
  final String? reasonCode;
  @override
  final DateTime? crossedAt;
  @override
  final String? crossedAtManila;
  @override
  final int? priorYearTotalCentavos;
  @override
  final String finalForYearNotice;
  @override
  final BuiltList<ThresholdStatusEvent> events;

  factory _$WithholdingThresholdPanel(
          [void Function(WithholdingThresholdPanelBuilder)? updates]) =>
      (WithholdingThresholdPanelBuilder()..update(updates))._build();

  _$WithholdingThresholdPanel._(
      {required this.demo,
      required this.taxableYear,
      required this.yearStartAt,
      required this.yearEndAt,
      required this.thresholdCentavos,
      required this.cumulativeGrossCentavos,
      required this.remainingAllowanceCentavos,
      required this.localGrossCentavos,
      required this.externalDeclaredCentavos,
      required this.externalOverlapCentavos,
      required this.externalOverlapState,
      required this.percentOfThreshold,
      required this.advisory,
      required this.status,
      required this.statusLabel,
      required this.statusIcon,
      this.reasonCode,
      this.crossedAt,
      this.crossedAtManila,
      this.priorYearTotalCentavos,
      required this.finalForYearNotice,
      required this.events})
      : super._();
  @override
  WithholdingThresholdPanel rebuild(
          void Function(WithholdingThresholdPanelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WithholdingThresholdPanelBuilder toBuilder() =>
      WithholdingThresholdPanelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WithholdingThresholdPanel &&
        demo == other.demo &&
        taxableYear == other.taxableYear &&
        yearStartAt == other.yearStartAt &&
        yearEndAt == other.yearEndAt &&
        thresholdCentavos == other.thresholdCentavos &&
        cumulativeGrossCentavos == other.cumulativeGrossCentavos &&
        remainingAllowanceCentavos == other.remainingAllowanceCentavos &&
        localGrossCentavos == other.localGrossCentavos &&
        externalDeclaredCentavos == other.externalDeclaredCentavos &&
        externalOverlapCentavos == other.externalOverlapCentavos &&
        externalOverlapState == other.externalOverlapState &&
        percentOfThreshold == other.percentOfThreshold &&
        advisory == other.advisory &&
        status == other.status &&
        statusLabel == other.statusLabel &&
        statusIcon == other.statusIcon &&
        reasonCode == other.reasonCode &&
        crossedAt == other.crossedAt &&
        crossedAtManila == other.crossedAtManila &&
        priorYearTotalCentavos == other.priorYearTotalCentavos &&
        finalForYearNotice == other.finalForYearNotice &&
        events == other.events;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, demo.hashCode);
    _$hash = $jc(_$hash, taxableYear.hashCode);
    _$hash = $jc(_$hash, yearStartAt.hashCode);
    _$hash = $jc(_$hash, yearEndAt.hashCode);
    _$hash = $jc(_$hash, thresholdCentavos.hashCode);
    _$hash = $jc(_$hash, cumulativeGrossCentavos.hashCode);
    _$hash = $jc(_$hash, remainingAllowanceCentavos.hashCode);
    _$hash = $jc(_$hash, localGrossCentavos.hashCode);
    _$hash = $jc(_$hash, externalDeclaredCentavos.hashCode);
    _$hash = $jc(_$hash, externalOverlapCentavos.hashCode);
    _$hash = $jc(_$hash, externalOverlapState.hashCode);
    _$hash = $jc(_$hash, percentOfThreshold.hashCode);
    _$hash = $jc(_$hash, advisory.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, statusLabel.hashCode);
    _$hash = $jc(_$hash, statusIcon.hashCode);
    _$hash = $jc(_$hash, reasonCode.hashCode);
    _$hash = $jc(_$hash, crossedAt.hashCode);
    _$hash = $jc(_$hash, crossedAtManila.hashCode);
    _$hash = $jc(_$hash, priorYearTotalCentavos.hashCode);
    _$hash = $jc(_$hash, finalForYearNotice.hashCode);
    _$hash = $jc(_$hash, events.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WithholdingThresholdPanel')
          ..add('demo', demo)
          ..add('taxableYear', taxableYear)
          ..add('yearStartAt', yearStartAt)
          ..add('yearEndAt', yearEndAt)
          ..add('thresholdCentavos', thresholdCentavos)
          ..add('cumulativeGrossCentavos', cumulativeGrossCentavos)
          ..add('remainingAllowanceCentavos', remainingAllowanceCentavos)
          ..add('localGrossCentavos', localGrossCentavos)
          ..add('externalDeclaredCentavos', externalDeclaredCentavos)
          ..add('externalOverlapCentavos', externalOverlapCentavos)
          ..add('externalOverlapState', externalOverlapState)
          ..add('percentOfThreshold', percentOfThreshold)
          ..add('advisory', advisory)
          ..add('status', status)
          ..add('statusLabel', statusLabel)
          ..add('statusIcon', statusIcon)
          ..add('reasonCode', reasonCode)
          ..add('crossedAt', crossedAt)
          ..add('crossedAtManila', crossedAtManila)
          ..add('priorYearTotalCentavos', priorYearTotalCentavos)
          ..add('finalForYearNotice', finalForYearNotice)
          ..add('events', events))
        .toString();
  }
}

class WithholdingThresholdPanelBuilder
    implements
        Builder<WithholdingThresholdPanel, WithholdingThresholdPanelBuilder> {
  _$WithholdingThresholdPanel? _$v;

  bool? _demo;
  bool? get demo => _$this._demo;
  set demo(bool? demo) => _$this._demo = demo;

  int? _taxableYear;
  int? get taxableYear => _$this._taxableYear;
  set taxableYear(int? taxableYear) => _$this._taxableYear = taxableYear;

  DateTime? _yearStartAt;
  DateTime? get yearStartAt => _$this._yearStartAt;
  set yearStartAt(DateTime? yearStartAt) => _$this._yearStartAt = yearStartAt;

  DateTime? _yearEndAt;
  DateTime? get yearEndAt => _$this._yearEndAt;
  set yearEndAt(DateTime? yearEndAt) => _$this._yearEndAt = yearEndAt;

  int? _thresholdCentavos;
  int? get thresholdCentavos => _$this._thresholdCentavos;
  set thresholdCentavos(int? thresholdCentavos) =>
      _$this._thresholdCentavos = thresholdCentavos;

  int? _cumulativeGrossCentavos;
  int? get cumulativeGrossCentavos => _$this._cumulativeGrossCentavos;
  set cumulativeGrossCentavos(int? cumulativeGrossCentavos) =>
      _$this._cumulativeGrossCentavos = cumulativeGrossCentavos;

  int? _remainingAllowanceCentavos;
  int? get remainingAllowanceCentavos => _$this._remainingAllowanceCentavos;
  set remainingAllowanceCentavos(int? remainingAllowanceCentavos) =>
      _$this._remainingAllowanceCentavos = remainingAllowanceCentavos;

  int? _localGrossCentavos;
  int? get localGrossCentavos => _$this._localGrossCentavos;
  set localGrossCentavos(int? localGrossCentavos) =>
      _$this._localGrossCentavos = localGrossCentavos;

  int? _externalDeclaredCentavos;
  int? get externalDeclaredCentavos => _$this._externalDeclaredCentavos;
  set externalDeclaredCentavos(int? externalDeclaredCentavos) =>
      _$this._externalDeclaredCentavos = externalDeclaredCentavos;

  int? _externalOverlapCentavos;
  int? get externalOverlapCentavos => _$this._externalOverlapCentavos;
  set externalOverlapCentavos(int? externalOverlapCentavos) =>
      _$this._externalOverlapCentavos = externalOverlapCentavos;

  WithholdingThresholdPanelExternalOverlapStateEnum? _externalOverlapState;
  WithholdingThresholdPanelExternalOverlapStateEnum? get externalOverlapState =>
      _$this._externalOverlapState;
  set externalOverlapState(
          WithholdingThresholdPanelExternalOverlapStateEnum?
              externalOverlapState) =>
      _$this._externalOverlapState = externalOverlapState;

  int? _percentOfThreshold;
  int? get percentOfThreshold => _$this._percentOfThreshold;
  set percentOfThreshold(int? percentOfThreshold) =>
      _$this._percentOfThreshold = percentOfThreshold;

  bool? _advisory;
  bool? get advisory => _$this._advisory;
  set advisory(bool? advisory) => _$this._advisory = advisory;

  WithholdingThresholdPanelStatusEnum? _status;
  WithholdingThresholdPanelStatusEnum? get status => _$this._status;
  set status(WithholdingThresholdPanelStatusEnum? status) =>
      _$this._status = status;

  String? _statusLabel;
  String? get statusLabel => _$this._statusLabel;
  set statusLabel(String? statusLabel) => _$this._statusLabel = statusLabel;

  String? _statusIcon;
  String? get statusIcon => _$this._statusIcon;
  set statusIcon(String? statusIcon) => _$this._statusIcon = statusIcon;

  String? _reasonCode;
  String? get reasonCode => _$this._reasonCode;
  set reasonCode(String? reasonCode) => _$this._reasonCode = reasonCode;

  DateTime? _crossedAt;
  DateTime? get crossedAt => _$this._crossedAt;
  set crossedAt(DateTime? crossedAt) => _$this._crossedAt = crossedAt;

  String? _crossedAtManila;
  String? get crossedAtManila => _$this._crossedAtManila;
  set crossedAtManila(String? crossedAtManila) =>
      _$this._crossedAtManila = crossedAtManila;

  int? _priorYearTotalCentavos;
  int? get priorYearTotalCentavos => _$this._priorYearTotalCentavos;
  set priorYearTotalCentavos(int? priorYearTotalCentavos) =>
      _$this._priorYearTotalCentavos = priorYearTotalCentavos;

  String? _finalForYearNotice;
  String? get finalForYearNotice => _$this._finalForYearNotice;
  set finalForYearNotice(String? finalForYearNotice) =>
      _$this._finalForYearNotice = finalForYearNotice;

  ListBuilder<ThresholdStatusEvent>? _events;
  ListBuilder<ThresholdStatusEvent> get events =>
      _$this._events ??= ListBuilder<ThresholdStatusEvent>();
  set events(ListBuilder<ThresholdStatusEvent>? events) =>
      _$this._events = events;

  WithholdingThresholdPanelBuilder() {
    WithholdingThresholdPanel._defaults(this);
  }

  WithholdingThresholdPanelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _demo = $v.demo;
      _taxableYear = $v.taxableYear;
      _yearStartAt = $v.yearStartAt;
      _yearEndAt = $v.yearEndAt;
      _thresholdCentavos = $v.thresholdCentavos;
      _cumulativeGrossCentavos = $v.cumulativeGrossCentavos;
      _remainingAllowanceCentavos = $v.remainingAllowanceCentavos;
      _localGrossCentavos = $v.localGrossCentavos;
      _externalDeclaredCentavos = $v.externalDeclaredCentavos;
      _externalOverlapCentavos = $v.externalOverlapCentavos;
      _externalOverlapState = $v.externalOverlapState;
      _percentOfThreshold = $v.percentOfThreshold;
      _advisory = $v.advisory;
      _status = $v.status;
      _statusLabel = $v.statusLabel;
      _statusIcon = $v.statusIcon;
      _reasonCode = $v.reasonCode;
      _crossedAt = $v.crossedAt;
      _crossedAtManila = $v.crossedAtManila;
      _priorYearTotalCentavos = $v.priorYearTotalCentavos;
      _finalForYearNotice = $v.finalForYearNotice;
      _events = $v.events.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WithholdingThresholdPanel other) {
    _$v = other as _$WithholdingThresholdPanel;
  }

  @override
  void update(void Function(WithholdingThresholdPanelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WithholdingThresholdPanel build() => _build();

  _$WithholdingThresholdPanel _build() {
    _$WithholdingThresholdPanel _$result;
    try {
      _$result = _$v ??
          _$WithholdingThresholdPanel._(
            demo: BuiltValueNullFieldError.checkNotNull(
                demo, r'WithholdingThresholdPanel', 'demo'),
            taxableYear: BuiltValueNullFieldError.checkNotNull(
                taxableYear, r'WithholdingThresholdPanel', 'taxableYear'),
            yearStartAt: BuiltValueNullFieldError.checkNotNull(
                yearStartAt, r'WithholdingThresholdPanel', 'yearStartAt'),
            yearEndAt: BuiltValueNullFieldError.checkNotNull(
                yearEndAt, r'WithholdingThresholdPanel', 'yearEndAt'),
            thresholdCentavos: BuiltValueNullFieldError.checkNotNull(
                thresholdCentavos,
                r'WithholdingThresholdPanel',
                'thresholdCentavos'),
            cumulativeGrossCentavos: BuiltValueNullFieldError.checkNotNull(
                cumulativeGrossCentavos,
                r'WithholdingThresholdPanel',
                'cumulativeGrossCentavos'),
            remainingAllowanceCentavos: BuiltValueNullFieldError.checkNotNull(
                remainingAllowanceCentavos,
                r'WithholdingThresholdPanel',
                'remainingAllowanceCentavos'),
            localGrossCentavos: BuiltValueNullFieldError.checkNotNull(
                localGrossCentavos,
                r'WithholdingThresholdPanel',
                'localGrossCentavos'),
            externalDeclaredCentavos: BuiltValueNullFieldError.checkNotNull(
                externalDeclaredCentavos,
                r'WithholdingThresholdPanel',
                'externalDeclaredCentavos'),
            externalOverlapCentavos: BuiltValueNullFieldError.checkNotNull(
                externalOverlapCentavos,
                r'WithholdingThresholdPanel',
                'externalOverlapCentavos'),
            externalOverlapState: BuiltValueNullFieldError.checkNotNull(
                externalOverlapState,
                r'WithholdingThresholdPanel',
                'externalOverlapState'),
            percentOfThreshold: BuiltValueNullFieldError.checkNotNull(
                percentOfThreshold,
                r'WithholdingThresholdPanel',
                'percentOfThreshold'),
            advisory: BuiltValueNullFieldError.checkNotNull(
                advisory, r'WithholdingThresholdPanel', 'advisory'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'WithholdingThresholdPanel', 'status'),
            statusLabel: BuiltValueNullFieldError.checkNotNull(
                statusLabel, r'WithholdingThresholdPanel', 'statusLabel'),
            statusIcon: BuiltValueNullFieldError.checkNotNull(
                statusIcon, r'WithholdingThresholdPanel', 'statusIcon'),
            reasonCode: reasonCode,
            crossedAt: crossedAt,
            crossedAtManila: crossedAtManila,
            priorYearTotalCentavos: priorYearTotalCentavos,
            finalForYearNotice: BuiltValueNullFieldError.checkNotNull(
                finalForYearNotice,
                r'WithholdingThresholdPanel',
                'finalForYearNotice'),
            events: events.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'events';
        events.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WithholdingThresholdPanel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
