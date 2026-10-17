// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_analytics_point.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminAnalyticsPointStatusEnum _$adminAnalyticsPointStatusEnum_OK =
    const AdminAnalyticsPointStatusEnum._('OK');
const AdminAnalyticsPointStatusEnum
    _$adminAnalyticsPointStatusEnum_LIMITED_DATA =
    const AdminAnalyticsPointStatusEnum._('LIMITED_DATA');
const AdminAnalyticsPointStatusEnum
    _$adminAnalyticsPointStatusEnum_NO_LOCAL_OBSERVATIONS =
    const AdminAnalyticsPointStatusEnum._('NO_LOCAL_OBSERVATIONS');
const AdminAnalyticsPointStatusEnum _$adminAnalyticsPointStatusEnum_SUPPRESSED =
    const AdminAnalyticsPointStatusEnum._('SUPPRESSED');
const AdminAnalyticsPointStatusEnum
    _$adminAnalyticsPointStatusEnum_MISSING_DAY =
    const AdminAnalyticsPointStatusEnum._('MISSING_DAY');

AdminAnalyticsPointStatusEnum _$adminAnalyticsPointStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'OK':
      return _$adminAnalyticsPointStatusEnum_OK;
    case 'LIMITED_DATA':
      return _$adminAnalyticsPointStatusEnum_LIMITED_DATA;
    case 'NO_LOCAL_OBSERVATIONS':
      return _$adminAnalyticsPointStatusEnum_NO_LOCAL_OBSERVATIONS;
    case 'SUPPRESSED':
      return _$adminAnalyticsPointStatusEnum_SUPPRESSED;
    case 'MISSING_DAY':
      return _$adminAnalyticsPointStatusEnum_MISSING_DAY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminAnalyticsPointStatusEnum>
    _$adminAnalyticsPointStatusEnumValues = BuiltSet<
        AdminAnalyticsPointStatusEnum>(const <AdminAnalyticsPointStatusEnum>[
  _$adminAnalyticsPointStatusEnum_OK,
  _$adminAnalyticsPointStatusEnum_LIMITED_DATA,
  _$adminAnalyticsPointStatusEnum_NO_LOCAL_OBSERVATIONS,
  _$adminAnalyticsPointStatusEnum_SUPPRESSED,
  _$adminAnalyticsPointStatusEnum_MISSING_DAY,
]);

Serializer<AdminAnalyticsPointStatusEnum>
    _$adminAnalyticsPointStatusEnumSerializer =
    _$AdminAnalyticsPointStatusEnumSerializer();

class _$AdminAnalyticsPointStatusEnumSerializer
    implements PrimitiveSerializer<AdminAnalyticsPointStatusEnum> {
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
  final Iterable<Type> types = const <Type>[AdminAnalyticsPointStatusEnum];
  @override
  final String wireName = 'AdminAnalyticsPointStatusEnum';

  @override
  Object serialize(
          Serializers serializers, AdminAnalyticsPointStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminAnalyticsPointStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminAnalyticsPointStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminAnalyticsPoint extends AdminAnalyticsPoint {
  @override
  final Date date;
  @override
  final AdminAnalyticsPointStatusEnum status;
  @override
  final String? label;
  @override
  final String? averagePhp;
  @override
  final String? averagePhpExact;
  @override
  final int? vendorCount;
  @override
  final bool? participantsChanged;

  factory _$AdminAnalyticsPoint(
          [void Function(AdminAnalyticsPointBuilder)? updates]) =>
      (AdminAnalyticsPointBuilder()..update(updates))._build();

  _$AdminAnalyticsPoint._(
      {required this.date,
      required this.status,
      this.label,
      this.averagePhp,
      this.averagePhpExact,
      this.vendorCount,
      this.participantsChanged})
      : super._();
  @override
  AdminAnalyticsPoint rebuild(
          void Function(AdminAnalyticsPointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminAnalyticsPointBuilder toBuilder() =>
      AdminAnalyticsPointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAnalyticsPoint &&
        date == other.date &&
        status == other.status &&
        label == other.label &&
        averagePhp == other.averagePhp &&
        averagePhpExact == other.averagePhpExact &&
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
    _$hash = $jc(_$hash, averagePhpExact.hashCode);
    _$hash = $jc(_$hash, vendorCount.hashCode);
    _$hash = $jc(_$hash, participantsChanged.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminAnalyticsPoint')
          ..add('date', date)
          ..add('status', status)
          ..add('label', label)
          ..add('averagePhp', averagePhp)
          ..add('averagePhpExact', averagePhpExact)
          ..add('vendorCount', vendorCount)
          ..add('participantsChanged', participantsChanged))
        .toString();
  }
}

class AdminAnalyticsPointBuilder
    implements Builder<AdminAnalyticsPoint, AdminAnalyticsPointBuilder> {
  _$AdminAnalyticsPoint? _$v;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  AdminAnalyticsPointStatusEnum? _status;
  AdminAnalyticsPointStatusEnum? get status => _$this._status;
  set status(AdminAnalyticsPointStatusEnum? status) => _$this._status = status;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _averagePhp;
  String? get averagePhp => _$this._averagePhp;
  set averagePhp(String? averagePhp) => _$this._averagePhp = averagePhp;

  String? _averagePhpExact;
  String? get averagePhpExact => _$this._averagePhpExact;
  set averagePhpExact(String? averagePhpExact) =>
      _$this._averagePhpExact = averagePhpExact;

  int? _vendorCount;
  int? get vendorCount => _$this._vendorCount;
  set vendorCount(int? vendorCount) => _$this._vendorCount = vendorCount;

  bool? _participantsChanged;
  bool? get participantsChanged => _$this._participantsChanged;
  set participantsChanged(bool? participantsChanged) =>
      _$this._participantsChanged = participantsChanged;

  AdminAnalyticsPointBuilder() {
    AdminAnalyticsPoint._defaults(this);
  }

  AdminAnalyticsPointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _status = $v.status;
      _label = $v.label;
      _averagePhp = $v.averagePhp;
      _averagePhpExact = $v.averagePhpExact;
      _vendorCount = $v.vendorCount;
      _participantsChanged = $v.participantsChanged;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAnalyticsPoint other) {
    _$v = other as _$AdminAnalyticsPoint;
  }

  @override
  void update(void Function(AdminAnalyticsPointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAnalyticsPoint build() => _build();

  _$AdminAnalyticsPoint _build() {
    final _$result = _$v ??
        _$AdminAnalyticsPoint._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'AdminAnalyticsPoint', 'date'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminAnalyticsPoint', 'status'),
          label: label,
          averagePhp: averagePhp,
          averagePhpExact: averagePhpExact,
          vendorCount: vendorCount,
          participantsChanged: participantsChanged,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
