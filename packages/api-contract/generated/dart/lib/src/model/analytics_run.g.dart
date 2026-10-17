// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_run.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AnalyticsRunStateEnum _$analyticsRunStateEnum_RUNNING =
    const AnalyticsRunStateEnum._('RUNNING');
const AnalyticsRunStateEnum _$analyticsRunStateEnum_VALIDATED =
    const AnalyticsRunStateEnum._('VALIDATED');
const AnalyticsRunStateEnum _$analyticsRunStateEnum_PUBLISHED =
    const AnalyticsRunStateEnum._('PUBLISHED');
const AnalyticsRunStateEnum _$analyticsRunStateEnum_FAILED =
    const AnalyticsRunStateEnum._('FAILED');
const AnalyticsRunStateEnum _$analyticsRunStateEnum_SUPERSEDED =
    const AnalyticsRunStateEnum._('SUPERSEDED');

AnalyticsRunStateEnum _$analyticsRunStateEnumValueOf(String name) {
  switch (name) {
    case 'RUNNING':
      return _$analyticsRunStateEnum_RUNNING;
    case 'VALIDATED':
      return _$analyticsRunStateEnum_VALIDATED;
    case 'PUBLISHED':
      return _$analyticsRunStateEnum_PUBLISHED;
    case 'FAILED':
      return _$analyticsRunStateEnum_FAILED;
    case 'SUPERSEDED':
      return _$analyticsRunStateEnum_SUPERSEDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AnalyticsRunStateEnum> _$analyticsRunStateEnumValues =
    BuiltSet<AnalyticsRunStateEnum>(const <AnalyticsRunStateEnum>[
  _$analyticsRunStateEnum_RUNNING,
  _$analyticsRunStateEnum_VALIDATED,
  _$analyticsRunStateEnum_PUBLISHED,
  _$analyticsRunStateEnum_FAILED,
  _$analyticsRunStateEnum_SUPERSEDED,
]);

Serializer<AnalyticsRunStateEnum> _$analyticsRunStateEnumSerializer =
    _$AnalyticsRunStateEnumSerializer();

class _$AnalyticsRunStateEnumSerializer
    implements PrimitiveSerializer<AnalyticsRunStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'RUNNING': 'RUNNING',
    'VALIDATED': 'VALIDATED',
    'PUBLISHED': 'PUBLISHED',
    'FAILED': 'FAILED',
    'SUPERSEDED': 'SUPERSEDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'RUNNING': 'RUNNING',
    'VALIDATED': 'VALIDATED',
    'PUBLISHED': 'PUBLISHED',
    'FAILED': 'FAILED',
    'SUPERSEDED': 'SUPERSEDED',
  };

  @override
  final Iterable<Type> types = const <Type>[AnalyticsRunStateEnum];
  @override
  final String wireName = 'AnalyticsRunStateEnum';

  @override
  Object serialize(Serializers serializers, AnalyticsRunStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AnalyticsRunStateEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AnalyticsRunStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AnalyticsRun extends AnalyticsRun {
  @override
  final String id;
  @override
  final Date snapshotDate;
  @override
  final int revision;
  @override
  final AnalyticsRunStateEnum state;
  @override
  final String? errorCode;
  @override
  final DateTime? observedAt;
  @override
  final DateTime? publishedAt;
  @override
  final int observations;
  @override
  final int selected;
  @override
  final int vendors;
  @override
  final bool delayed;
  @override
  final String? reviewerReason;

  factory _$AnalyticsRun([void Function(AnalyticsRunBuilder)? updates]) =>
      (AnalyticsRunBuilder()..update(updates))._build();

  _$AnalyticsRun._(
      {required this.id,
      required this.snapshotDate,
      required this.revision,
      required this.state,
      this.errorCode,
      this.observedAt,
      this.publishedAt,
      required this.observations,
      required this.selected,
      required this.vendors,
      required this.delayed,
      this.reviewerReason})
      : super._();
  @override
  AnalyticsRun rebuild(void Function(AnalyticsRunBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnalyticsRunBuilder toBuilder() => AnalyticsRunBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnalyticsRun &&
        id == other.id &&
        snapshotDate == other.snapshotDate &&
        revision == other.revision &&
        state == other.state &&
        errorCode == other.errorCode &&
        observedAt == other.observedAt &&
        publishedAt == other.publishedAt &&
        observations == other.observations &&
        selected == other.selected &&
        vendors == other.vendors &&
        delayed == other.delayed &&
        reviewerReason == other.reviewerReason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, snapshotDate.hashCode);
    _$hash = $jc(_$hash, revision.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, errorCode.hashCode);
    _$hash = $jc(_$hash, observedAt.hashCode);
    _$hash = $jc(_$hash, publishedAt.hashCode);
    _$hash = $jc(_$hash, observations.hashCode);
    _$hash = $jc(_$hash, selected.hashCode);
    _$hash = $jc(_$hash, vendors.hashCode);
    _$hash = $jc(_$hash, delayed.hashCode);
    _$hash = $jc(_$hash, reviewerReason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AnalyticsRun')
          ..add('id', id)
          ..add('snapshotDate', snapshotDate)
          ..add('revision', revision)
          ..add('state', state)
          ..add('errorCode', errorCode)
          ..add('observedAt', observedAt)
          ..add('publishedAt', publishedAt)
          ..add('observations', observations)
          ..add('selected', selected)
          ..add('vendors', vendors)
          ..add('delayed', delayed)
          ..add('reviewerReason', reviewerReason))
        .toString();
  }
}

class AnalyticsRunBuilder
    implements Builder<AnalyticsRun, AnalyticsRunBuilder> {
  _$AnalyticsRun? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  Date? _snapshotDate;
  Date? get snapshotDate => _$this._snapshotDate;
  set snapshotDate(Date? snapshotDate) => _$this._snapshotDate = snapshotDate;

  int? _revision;
  int? get revision => _$this._revision;
  set revision(int? revision) => _$this._revision = revision;

  AnalyticsRunStateEnum? _state;
  AnalyticsRunStateEnum? get state => _$this._state;
  set state(AnalyticsRunStateEnum? state) => _$this._state = state;

  String? _errorCode;
  String? get errorCode => _$this._errorCode;
  set errorCode(String? errorCode) => _$this._errorCode = errorCode;

  DateTime? _observedAt;
  DateTime? get observedAt => _$this._observedAt;
  set observedAt(DateTime? observedAt) => _$this._observedAt = observedAt;

  DateTime? _publishedAt;
  DateTime? get publishedAt => _$this._publishedAt;
  set publishedAt(DateTime? publishedAt) => _$this._publishedAt = publishedAt;

  int? _observations;
  int? get observations => _$this._observations;
  set observations(int? observations) => _$this._observations = observations;

  int? _selected;
  int? get selected => _$this._selected;
  set selected(int? selected) => _$this._selected = selected;

  int? _vendors;
  int? get vendors => _$this._vendors;
  set vendors(int? vendors) => _$this._vendors = vendors;

  bool? _delayed;
  bool? get delayed => _$this._delayed;
  set delayed(bool? delayed) => _$this._delayed = delayed;

  String? _reviewerReason;
  String? get reviewerReason => _$this._reviewerReason;
  set reviewerReason(String? reviewerReason) =>
      _$this._reviewerReason = reviewerReason;

  AnalyticsRunBuilder() {
    AnalyticsRun._defaults(this);
  }

  AnalyticsRunBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _snapshotDate = $v.snapshotDate;
      _revision = $v.revision;
      _state = $v.state;
      _errorCode = $v.errorCode;
      _observedAt = $v.observedAt;
      _publishedAt = $v.publishedAt;
      _observations = $v.observations;
      _selected = $v.selected;
      _vendors = $v.vendors;
      _delayed = $v.delayed;
      _reviewerReason = $v.reviewerReason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AnalyticsRun other) {
    _$v = other as _$AnalyticsRun;
  }

  @override
  void update(void Function(AnalyticsRunBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnalyticsRun build() => _build();

  _$AnalyticsRun _build() {
    final _$result = _$v ??
        _$AnalyticsRun._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'AnalyticsRun', 'id'),
          snapshotDate: BuiltValueNullFieldError.checkNotNull(
              snapshotDate, r'AnalyticsRun', 'snapshotDate'),
          revision: BuiltValueNullFieldError.checkNotNull(
              revision, r'AnalyticsRun', 'revision'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'AnalyticsRun', 'state'),
          errorCode: errorCode,
          observedAt: observedAt,
          publishedAt: publishedAt,
          observations: BuiltValueNullFieldError.checkNotNull(
              observations, r'AnalyticsRun', 'observations'),
          selected: BuiltValueNullFieldError.checkNotNull(
              selected, r'AnalyticsRun', 'selected'),
          vendors: BuiltValueNullFieldError.checkNotNull(
              vendors, r'AnalyticsRun', 'vendors'),
          delayed: BuiltValueNullFieldError.checkNotNull(
              delayed, r'AnalyticsRun', 'delayed'),
          reviewerReason: reviewerReason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
