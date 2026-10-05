// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_analytics_point.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorAnalyticsPointStatusEnum _$vendorAnalyticsPointStatusEnum_OK =
    const VendorAnalyticsPointStatusEnum._('OK');
const VendorAnalyticsPointStatusEnum
    _$vendorAnalyticsPointStatusEnum_SUPPRESSED =
    const VendorAnalyticsPointStatusEnum._('SUPPRESSED');
const VendorAnalyticsPointStatusEnum
    _$vendorAnalyticsPointStatusEnum_MISSING_DAY =
    const VendorAnalyticsPointStatusEnum._('MISSING_DAY');

VendorAnalyticsPointStatusEnum _$vendorAnalyticsPointStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'OK':
      return _$vendorAnalyticsPointStatusEnum_OK;
    case 'SUPPRESSED':
      return _$vendorAnalyticsPointStatusEnum_SUPPRESSED;
    case 'MISSING_DAY':
      return _$vendorAnalyticsPointStatusEnum_MISSING_DAY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorAnalyticsPointStatusEnum>
    _$vendorAnalyticsPointStatusEnumValues = BuiltSet<
        VendorAnalyticsPointStatusEnum>(const <VendorAnalyticsPointStatusEnum>[
  _$vendorAnalyticsPointStatusEnum_OK,
  _$vendorAnalyticsPointStatusEnum_SUPPRESSED,
  _$vendorAnalyticsPointStatusEnum_MISSING_DAY,
]);

Serializer<VendorAnalyticsPointStatusEnum>
    _$vendorAnalyticsPointStatusEnumSerializer =
    _$VendorAnalyticsPointStatusEnumSerializer();

class _$VendorAnalyticsPointStatusEnumSerializer
    implements PrimitiveSerializer<VendorAnalyticsPointStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OK': 'OK',
    'SUPPRESSED': 'SUPPRESSED',
    'MISSING_DAY': 'MISSING_DAY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OK': 'OK',
    'SUPPRESSED': 'SUPPRESSED',
    'MISSING_DAY': 'MISSING_DAY',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorAnalyticsPointStatusEnum];
  @override
  final String wireName = 'VendorAnalyticsPointStatusEnum';

  @override
  Object serialize(
          Serializers serializers, VendorAnalyticsPointStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorAnalyticsPointStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorAnalyticsPointStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorAnalyticsPoint extends VendorAnalyticsPoint {
  @override
  final Date date;
  @override
  final VendorAnalyticsPointStatusEnum status;
  @override
  final String? label;
  @override
  final String? averagePhp;
  @override
  final int? competitorCount;
  @override
  final bool? participantsChanged;

  factory _$VendorAnalyticsPoint(
          [void Function(VendorAnalyticsPointBuilder)? updates]) =>
      (VendorAnalyticsPointBuilder()..update(updates))._build();

  _$VendorAnalyticsPoint._(
      {required this.date,
      required this.status,
      this.label,
      this.averagePhp,
      this.competitorCount,
      this.participantsChanged})
      : super._();
  @override
  VendorAnalyticsPoint rebuild(
          void Function(VendorAnalyticsPointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorAnalyticsPointBuilder toBuilder() =>
      VendorAnalyticsPointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorAnalyticsPoint &&
        date == other.date &&
        status == other.status &&
        label == other.label &&
        averagePhp == other.averagePhp &&
        competitorCount == other.competitorCount &&
        participantsChanged == other.participantsChanged;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, averagePhp.hashCode);
    _$hash = $jc(_$hash, competitorCount.hashCode);
    _$hash = $jc(_$hash, participantsChanged.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorAnalyticsPoint')
          ..add('date', date)
          ..add('status', status)
          ..add('label', label)
          ..add('averagePhp', averagePhp)
          ..add('competitorCount', competitorCount)
          ..add('participantsChanged', participantsChanged))
        .toString();
  }
}

class VendorAnalyticsPointBuilder
    implements Builder<VendorAnalyticsPoint, VendorAnalyticsPointBuilder> {
  _$VendorAnalyticsPoint? _$v;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  VendorAnalyticsPointStatusEnum? _status;
  VendorAnalyticsPointStatusEnum? get status => _$this._status;
  set status(VendorAnalyticsPointStatusEnum? status) => _$this._status = status;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _averagePhp;
  String? get averagePhp => _$this._averagePhp;
  set averagePhp(String? averagePhp) => _$this._averagePhp = averagePhp;

  int? _competitorCount;
  int? get competitorCount => _$this._competitorCount;
  set competitorCount(int? competitorCount) =>
      _$this._competitorCount = competitorCount;

  bool? _participantsChanged;
  bool? get participantsChanged => _$this._participantsChanged;
  set participantsChanged(bool? participantsChanged) =>
      _$this._participantsChanged = participantsChanged;

  VendorAnalyticsPointBuilder() {
    VendorAnalyticsPoint._defaults(this);
  }

  VendorAnalyticsPointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _status = $v.status;
      _label = $v.label;
      _averagePhp = $v.averagePhp;
      _competitorCount = $v.competitorCount;
      _participantsChanged = $v.participantsChanged;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorAnalyticsPoint other) {
    _$v = other as _$VendorAnalyticsPoint;
  }

  @override
  void update(void Function(VendorAnalyticsPointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorAnalyticsPoint build() => _build();

  _$VendorAnalyticsPoint _build() {
    final _$result = _$v ??
        _$VendorAnalyticsPoint._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'VendorAnalyticsPoint', 'date'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'VendorAnalyticsPoint', 'status'),
          label: label,
          averagePhp: averagePhp,
          competitorCount: competitorCount,
          participantsChanged: participantsChanged,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
