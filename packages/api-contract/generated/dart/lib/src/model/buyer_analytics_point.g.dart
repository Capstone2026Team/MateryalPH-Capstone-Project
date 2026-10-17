// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_analytics_point.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuyerAnalyticsPointStatusEnum _$buyerAnalyticsPointStatusEnum_OK =
    const BuyerAnalyticsPointStatusEnum._('OK');
const BuyerAnalyticsPointStatusEnum
    _$buyerAnalyticsPointStatusEnum_LIMITED_DATA =
    const BuyerAnalyticsPointStatusEnum._('LIMITED_DATA');
const BuyerAnalyticsPointStatusEnum
    _$buyerAnalyticsPointStatusEnum_NO_LOCAL_OBSERVATIONS =
    const BuyerAnalyticsPointStatusEnum._('NO_LOCAL_OBSERVATIONS');
const BuyerAnalyticsPointStatusEnum _$buyerAnalyticsPointStatusEnum_SUPPRESSED =
    const BuyerAnalyticsPointStatusEnum._('SUPPRESSED');
const BuyerAnalyticsPointStatusEnum
    _$buyerAnalyticsPointStatusEnum_MISSING_DAY =
    const BuyerAnalyticsPointStatusEnum._('MISSING_DAY');

BuyerAnalyticsPointStatusEnum _$buyerAnalyticsPointStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'OK':
      return _$buyerAnalyticsPointStatusEnum_OK;
    case 'LIMITED_DATA':
      return _$buyerAnalyticsPointStatusEnum_LIMITED_DATA;
    case 'NO_LOCAL_OBSERVATIONS':
      return _$buyerAnalyticsPointStatusEnum_NO_LOCAL_OBSERVATIONS;
    case 'SUPPRESSED':
      return _$buyerAnalyticsPointStatusEnum_SUPPRESSED;
    case 'MISSING_DAY':
      return _$buyerAnalyticsPointStatusEnum_MISSING_DAY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerAnalyticsPointStatusEnum>
    _$buyerAnalyticsPointStatusEnumValues = BuiltSet<
        BuyerAnalyticsPointStatusEnum>(const <BuyerAnalyticsPointStatusEnum>[
  _$buyerAnalyticsPointStatusEnum_OK,
  _$buyerAnalyticsPointStatusEnum_LIMITED_DATA,
  _$buyerAnalyticsPointStatusEnum_NO_LOCAL_OBSERVATIONS,
  _$buyerAnalyticsPointStatusEnum_SUPPRESSED,
  _$buyerAnalyticsPointStatusEnum_MISSING_DAY,
]);

Serializer<BuyerAnalyticsPointStatusEnum>
    _$buyerAnalyticsPointStatusEnumSerializer =
    _$BuyerAnalyticsPointStatusEnumSerializer();

class _$BuyerAnalyticsPointStatusEnumSerializer
    implements PrimitiveSerializer<BuyerAnalyticsPointStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OK': 'OK',
    'LIMITED_DATA': 'LIMITED_DATA',
    'NO_LOCAL_OBSERVATIONS': 'NO_LOCAL_OBSERVATIONS',
    'SUPPRESSED': 'SUPPRESSED',
    'MISSING_DAY': 'MISSING_DAY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OK': 'OK',
    'LIMITED_DATA': 'LIMITED_DATA',
    'NO_LOCAL_OBSERVATIONS': 'NO_LOCAL_OBSERVATIONS',
    'SUPPRESSED': 'SUPPRESSED',
    'MISSING_DAY': 'MISSING_DAY',
  };

  @override
  final Iterable<Type> types = const <Type>[BuyerAnalyticsPointStatusEnum];
  @override
  final String wireName = 'BuyerAnalyticsPointStatusEnum';

  @override
  Object serialize(
          Serializers serializers, BuyerAnalyticsPointStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerAnalyticsPointStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerAnalyticsPointStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerAnalyticsPoint extends BuyerAnalyticsPoint {
  @override
  final Date date;
  @override
  final BuyerAnalyticsPointStatusEnum status;
  @override
  final String? label;
  @override
  final String? averagePhp;
  @override
  final int? vendorCount;
  @override
  final bool? participantsChanged;

  factory _$BuyerAnalyticsPoint(
          [void Function(BuyerAnalyticsPointBuilder)? updates]) =>
      (BuyerAnalyticsPointBuilder()..update(updates))._build();

  _$BuyerAnalyticsPoint._(
      {required this.date,
      required this.status,
      this.label,
      this.averagePhp,
      this.vendorCount,
      this.participantsChanged})
      : super._();
  @override
  BuyerAnalyticsPoint rebuild(
          void Function(BuyerAnalyticsPointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerAnalyticsPointBuilder toBuilder() =>
      BuyerAnalyticsPointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerAnalyticsPoint &&
        date == other.date &&
        status == other.status &&
        label == other.label &&
        averagePhp == other.averagePhp &&
        vendorCount == other.vendorCount &&
        participantsChanged == other.participantsChanged;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, averagePhp.hashCode);
    _$hash = $jc(_$hash, vendorCount.hashCode);
    _$hash = $jc(_$hash, participantsChanged.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerAnalyticsPoint')
          ..add('date', date)
          ..add('status', status)
          ..add('label', label)
          ..add('averagePhp', averagePhp)
          ..add('vendorCount', vendorCount)
          ..add('participantsChanged', participantsChanged))
        .toString();
  }
}

class BuyerAnalyticsPointBuilder
    implements Builder<BuyerAnalyticsPoint, BuyerAnalyticsPointBuilder> {
  _$BuyerAnalyticsPoint? _$v;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  BuyerAnalyticsPointStatusEnum? _status;
  BuyerAnalyticsPointStatusEnum? get status => _$this._status;
  set status(BuyerAnalyticsPointStatusEnum? status) => _$this._status = status;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _averagePhp;
  String? get averagePhp => _$this._averagePhp;
  set averagePhp(String? averagePhp) => _$this._averagePhp = averagePhp;

  int? _vendorCount;
  int? get vendorCount => _$this._vendorCount;
  set vendorCount(int? vendorCount) => _$this._vendorCount = vendorCount;

  bool? _participantsChanged;
  bool? get participantsChanged => _$this._participantsChanged;
  set participantsChanged(bool? participantsChanged) =>
      _$this._participantsChanged = participantsChanged;

  BuyerAnalyticsPointBuilder() {
    BuyerAnalyticsPoint._defaults(this);
  }

  BuyerAnalyticsPointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _status = $v.status;
      _label = $v.label;
      _averagePhp = $v.averagePhp;
      _vendorCount = $v.vendorCount;
      _participantsChanged = $v.participantsChanged;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerAnalyticsPoint other) {
    _$v = other as _$BuyerAnalyticsPoint;
  }

  @override
  void update(void Function(BuyerAnalyticsPointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerAnalyticsPoint build() => _build();

  _$BuyerAnalyticsPoint _build() {
    final _$result = _$v ??
        _$BuyerAnalyticsPoint._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'BuyerAnalyticsPoint', 'date'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'BuyerAnalyticsPoint', 'status'),
          label: label,
          averagePhp: averagePhp,
          vendorCount: vendorCount,
          participantsChanged: participantsChanged,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
