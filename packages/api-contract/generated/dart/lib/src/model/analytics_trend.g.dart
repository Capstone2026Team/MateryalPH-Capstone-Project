// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_trend.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AnalyticsTrendDirectionEnum _$analyticsTrendDirectionEnum_INCREASING =
    const AnalyticsTrendDirectionEnum._('INCREASING');
const AnalyticsTrendDirectionEnum _$analyticsTrendDirectionEnum_DECREASING =
    const AnalyticsTrendDirectionEnum._('DECREASING');
const AnalyticsTrendDirectionEnum
    _$analyticsTrendDirectionEnum_NO_MATERIAL_CHANGE =
    const AnalyticsTrendDirectionEnum._('NO_MATERIAL_CHANGE');

AnalyticsTrendDirectionEnum _$analyticsTrendDirectionEnumValueOf(String name) {
  switch (name) {
    case 'INCREASING':
      return _$analyticsTrendDirectionEnum_INCREASING;
    case 'DECREASING':
      return _$analyticsTrendDirectionEnum_DECREASING;
    case 'NO_MATERIAL_CHANGE':
      return _$analyticsTrendDirectionEnum_NO_MATERIAL_CHANGE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AnalyticsTrendDirectionEnum>
    _$analyticsTrendDirectionEnumValues =
    BuiltSet<AnalyticsTrendDirectionEnum>(const <AnalyticsTrendDirectionEnum>[
  _$analyticsTrendDirectionEnum_INCREASING,
  _$analyticsTrendDirectionEnum_DECREASING,
  _$analyticsTrendDirectionEnum_NO_MATERIAL_CHANGE,
]);

const AnalyticsTrendReasonEnum
    _$analyticsTrendReasonEnum_INSUFFICIENT_LOCAL_DATA =
    const AnalyticsTrendReasonEnum._('INSUFFICIENT_LOCAL_DATA');
const AnalyticsTrendReasonEnum
    _$analyticsTrendReasonEnum_INSUFFICIENT_COMPETITOR_DATA =
    const AnalyticsTrendReasonEnum._('INSUFFICIENT_COMPETITOR_DATA');
const AnalyticsTrendReasonEnum
    _$analyticsTrendReasonEnum_MISSING_ENDPOINT_SNAPSHOT =
    const AnalyticsTrendReasonEnum._('MISSING_ENDPOINT_SNAPSHOT');
const AnalyticsTrendReasonEnum _$analyticsTrendReasonEnum_ZERO_BASELINE =
    const AnalyticsTrendReasonEnum._('ZERO_BASELINE');
const AnalyticsTrendReasonEnum _$analyticsTrendReasonEnum_NO_PUBLISHED_HISTORY =
    const AnalyticsTrendReasonEnum._('NO_PUBLISHED_HISTORY');

AnalyticsTrendReasonEnum _$analyticsTrendReasonEnumValueOf(String name) {
  switch (name) {
    case 'INSUFFICIENT_LOCAL_DATA':
      return _$analyticsTrendReasonEnum_INSUFFICIENT_LOCAL_DATA;
    case 'INSUFFICIENT_COMPETITOR_DATA':
      return _$analyticsTrendReasonEnum_INSUFFICIENT_COMPETITOR_DATA;
    case 'MISSING_ENDPOINT_SNAPSHOT':
      return _$analyticsTrendReasonEnum_MISSING_ENDPOINT_SNAPSHOT;
    case 'ZERO_BASELINE':
      return _$analyticsTrendReasonEnum_ZERO_BASELINE;
    case 'NO_PUBLISHED_HISTORY':
      return _$analyticsTrendReasonEnum_NO_PUBLISHED_HISTORY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AnalyticsTrendReasonEnum> _$analyticsTrendReasonEnumValues =
    BuiltSet<AnalyticsTrendReasonEnum>(const <AnalyticsTrendReasonEnum>[
  _$analyticsTrendReasonEnum_INSUFFICIENT_LOCAL_DATA,
  _$analyticsTrendReasonEnum_INSUFFICIENT_COMPETITOR_DATA,
  _$analyticsTrendReasonEnum_MISSING_ENDPOINT_SNAPSHOT,
  _$analyticsTrendReasonEnum_ZERO_BASELINE,
  _$analyticsTrendReasonEnum_NO_PUBLISHED_HISTORY,
]);

Serializer<AnalyticsTrendDirectionEnum>
    _$analyticsTrendDirectionEnumSerializer =
    _$AnalyticsTrendDirectionEnumSerializer();
Serializer<AnalyticsTrendReasonEnum> _$analyticsTrendReasonEnumSerializer =
    _$AnalyticsTrendReasonEnumSerializer();

class _$AnalyticsTrendDirectionEnumSerializer
    implements PrimitiveSerializer<AnalyticsTrendDirectionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INCREASING': 'INCREASING',
    'DECREASING': 'DECREASING',
    'NO_MATERIAL_CHANGE': 'NO_MATERIAL_CHANGE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INCREASING': 'INCREASING',
    'DECREASING': 'DECREASING',
    'NO_MATERIAL_CHANGE': 'NO_MATERIAL_CHANGE',
  };

  @override
  final Iterable<Type> types = const <Type>[AnalyticsTrendDirectionEnum];
  @override
  final String wireName = 'AnalyticsTrendDirectionEnum';

  @override
  Object serialize(Serializers serializers, AnalyticsTrendDirectionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AnalyticsTrendDirectionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AnalyticsTrendDirectionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AnalyticsTrendReasonEnumSerializer
    implements PrimitiveSerializer<AnalyticsTrendReasonEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INSUFFICIENT_LOCAL_DATA': 'INSUFFICIENT_LOCAL_DATA',
    'INSUFFICIENT_COMPETITOR_DATA': 'INSUFFICIENT_COMPETITOR_DATA',
    'MISSING_ENDPOINT_SNAPSHOT': 'MISSING_ENDPOINT_SNAPSHOT',
    'ZERO_BASELINE': 'ZERO_BASELINE',
    'NO_PUBLISHED_HISTORY': 'NO_PUBLISHED_HISTORY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INSUFFICIENT_LOCAL_DATA': 'INSUFFICIENT_LOCAL_DATA',
    'INSUFFICIENT_COMPETITOR_DATA': 'INSUFFICIENT_COMPETITOR_DATA',
    'MISSING_ENDPOINT_SNAPSHOT': 'MISSING_ENDPOINT_SNAPSHOT',
    'ZERO_BASELINE': 'ZERO_BASELINE',
    'NO_PUBLISHED_HISTORY': 'NO_PUBLISHED_HISTORY',
  };

  @override
  final Iterable<Type> types = const <Type>[AnalyticsTrendReasonEnum];
  @override
  final String wireName = 'AnalyticsTrendReasonEnum';

  @override
  Object serialize(Serializers serializers, AnalyticsTrendReasonEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AnalyticsTrendReasonEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AnalyticsTrendReasonEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AnalyticsTrend extends AnalyticsTrend {
  @override
  final String? changePercent;
  @override
  final AnalyticsTrendDirectionEnum? direction;
  @override
  final AnalyticsTrendReasonEnum? reason;
  @override
  final bool? compositionChanged;
  @override
  final Date? startDate;
  @override
  final Date? endDate;
  @override
  final String? label;
  @override
  final String? compositionNote;

  factory _$AnalyticsTrend([void Function(AnalyticsTrendBuilder)? updates]) =>
      (AnalyticsTrendBuilder()..update(updates))._build();

  _$AnalyticsTrend._(
      {this.changePercent,
      this.direction,
      this.reason,
      this.compositionChanged,
      this.startDate,
      this.endDate,
      this.label,
      this.compositionNote})
      : super._();
  @override
  AnalyticsTrend rebuild(void Function(AnalyticsTrendBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnalyticsTrendBuilder toBuilder() => AnalyticsTrendBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnalyticsTrend &&
        changePercent == other.changePercent &&
        direction == other.direction &&
        reason == other.reason &&
        compositionChanged == other.compositionChanged &&
        startDate == other.startDate &&
        endDate == other.endDate &&
        label == other.label &&
        compositionNote == other.compositionNote;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, changePercent.hashCode);
    _$hash = $jc(_$hash, direction.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, compositionChanged.hashCode);
    _$hash = $jc(_$hash, startDate.hashCode);
    _$hash = $jc(_$hash, endDate.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, compositionNote.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AnalyticsTrend')
          ..add('changePercent', changePercent)
          ..add('direction', direction)
          ..add('reason', reason)
          ..add('compositionChanged', compositionChanged)
          ..add('startDate', startDate)
          ..add('endDate', endDate)
          ..add('label', label)
          ..add('compositionNote', compositionNote))
        .toString();
  }
}

class AnalyticsTrendBuilder
    implements Builder<AnalyticsTrend, AnalyticsTrendBuilder> {
  _$AnalyticsTrend? _$v;

  String? _changePercent;
  String? get changePercent => _$this._changePercent;
  set changePercent(String? changePercent) =>
      _$this._changePercent = changePercent;

  AnalyticsTrendDirectionEnum? _direction;
  AnalyticsTrendDirectionEnum? get direction => _$this._direction;
  set direction(AnalyticsTrendDirectionEnum? direction) =>
      _$this._direction = direction;

  AnalyticsTrendReasonEnum? _reason;
  AnalyticsTrendReasonEnum? get reason => _$this._reason;
  set reason(AnalyticsTrendReasonEnum? reason) => _$this._reason = reason;

  bool? _compositionChanged;
  bool? get compositionChanged => _$this._compositionChanged;
  set compositionChanged(bool? compositionChanged) =>
      _$this._compositionChanged = compositionChanged;

  Date? _startDate;
  Date? get startDate => _$this._startDate;
  set startDate(Date? startDate) => _$this._startDate = startDate;

  Date? _endDate;
  Date? get endDate => _$this._endDate;
  set endDate(Date? endDate) => _$this._endDate = endDate;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _compositionNote;
  String? get compositionNote => _$this._compositionNote;
  set compositionNote(String? compositionNote) =>
      _$this._compositionNote = compositionNote;

  AnalyticsTrendBuilder() {
    AnalyticsTrend._defaults(this);
  }

  AnalyticsTrendBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _changePercent = $v.changePercent;
      _direction = $v.direction;
      _reason = $v.reason;
      _compositionChanged = $v.compositionChanged;
      _startDate = $v.startDate;
      _endDate = $v.endDate;
      _label = $v.label;
      _compositionNote = $v.compositionNote;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AnalyticsTrend other) {
    _$v = other as _$AnalyticsTrend;
  }

  @override
  void update(void Function(AnalyticsTrendBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnalyticsTrend build() => _build();

  _$AnalyticsTrend _build() {
    final _$result = _$v ??
        _$AnalyticsTrend._(
          changePercent: changePercent,
          direction: direction,
          reason: reason,
          compositionChanged: compositionChanged,
          startDate: startDate,
          endDate: endDate,
          label: label,
          compositionNote: compositionNote,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
