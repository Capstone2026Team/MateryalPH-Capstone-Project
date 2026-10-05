// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_current_counts.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AnalyticsCurrentCountsStatusEnum
    _$analyticsCurrentCountsStatusEnum_AVAILABLE =
    const AnalyticsCurrentCountsStatusEnum._('AVAILABLE');
const AnalyticsCurrentCountsStatusEnum
    _$analyticsCurrentCountsStatusEnum_NO_CURRENT_OFFERS =
    const AnalyticsCurrentCountsStatusEnum._('NO_CURRENT_OFFERS');

AnalyticsCurrentCountsStatusEnum _$analyticsCurrentCountsStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'AVAILABLE':
      return _$analyticsCurrentCountsStatusEnum_AVAILABLE;
    case 'NO_CURRENT_OFFERS':
      return _$analyticsCurrentCountsStatusEnum_NO_CURRENT_OFFERS;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AnalyticsCurrentCountsStatusEnum>
    _$analyticsCurrentCountsStatusEnumValues = BuiltSet<
        AnalyticsCurrentCountsStatusEnum>(const <AnalyticsCurrentCountsStatusEnum>[
  _$analyticsCurrentCountsStatusEnum_AVAILABLE,
  _$analyticsCurrentCountsStatusEnum_NO_CURRENT_OFFERS,
]);

Serializer<AnalyticsCurrentCountsStatusEnum>
    _$analyticsCurrentCountsStatusEnumSerializer =
    _$AnalyticsCurrentCountsStatusEnumSerializer();

class _$AnalyticsCurrentCountsStatusEnumSerializer
    implements PrimitiveSerializer<AnalyticsCurrentCountsStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AVAILABLE': 'AVAILABLE',
    'NO_CURRENT_OFFERS': 'NO_CURRENT_OFFERS',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AVAILABLE': 'AVAILABLE',
    'NO_CURRENT_OFFERS': 'NO_CURRENT_OFFERS',
  };

  @override
  final Iterable<Type> types = const <Type>[AnalyticsCurrentCountsStatusEnum];
  @override
  final String wireName = 'AnalyticsCurrentCountsStatusEnum';

  @override
  Object serialize(
          Serializers serializers, AnalyticsCurrentCountsStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AnalyticsCurrentCountsStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AnalyticsCurrentCountsStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AnalyticsCurrentCounts extends AnalyticsCurrentCounts {
  @override
  final int vendorCount;
  @override
  final int listingCount;
  @override
  final AnalyticsCurrentCountsStatusEnum status;

  factory _$AnalyticsCurrentCounts(
          [void Function(AnalyticsCurrentCountsBuilder)? updates]) =>
      (AnalyticsCurrentCountsBuilder()..update(updates))._build();

  _$AnalyticsCurrentCounts._(
      {required this.vendorCount,
      required this.listingCount,
      required this.status})
      : super._();
  @override
  AnalyticsCurrentCounts rebuild(
          void Function(AnalyticsCurrentCountsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnalyticsCurrentCountsBuilder toBuilder() =>
      AnalyticsCurrentCountsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnalyticsCurrentCounts &&
        vendorCount == other.vendorCount &&
        listingCount == other.listingCount &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vendorCount.hashCode);
    _$hash = $jc(_$hash, listingCount.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AnalyticsCurrentCounts')
          ..add('vendorCount', vendorCount)
          ..add('listingCount', listingCount)
          ..add('status', status))
        .toString();
  }
}

class AnalyticsCurrentCountsBuilder
    implements Builder<AnalyticsCurrentCounts, AnalyticsCurrentCountsBuilder> {
  _$AnalyticsCurrentCounts? _$v;

  int? _vendorCount;
  int? get vendorCount => _$this._vendorCount;
  set vendorCount(int? vendorCount) => _$this._vendorCount = vendorCount;

  int? _listingCount;
  int? get listingCount => _$this._listingCount;
  set listingCount(int? listingCount) => _$this._listingCount = listingCount;

  AnalyticsCurrentCountsStatusEnum? _status;
  AnalyticsCurrentCountsStatusEnum? get status => _$this._status;
  set status(AnalyticsCurrentCountsStatusEnum? status) =>
      _$this._status = status;

  AnalyticsCurrentCountsBuilder() {
    AnalyticsCurrentCounts._defaults(this);
  }

  AnalyticsCurrentCountsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vendorCount = $v.vendorCount;
      _listingCount = $v.listingCount;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AnalyticsCurrentCounts other) {
    _$v = other as _$AnalyticsCurrentCounts;
  }

  @override
  void update(void Function(AnalyticsCurrentCountsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnalyticsCurrentCounts build() => _build();

  _$AnalyticsCurrentCounts _build() {
    final _$result = _$v ??
        _$AnalyticsCurrentCounts._(
          vendorCount: BuiltValueNullFieldError.checkNotNull(
              vendorCount, r'AnalyticsCurrentCounts', 'vendorCount'),
          listingCount: BuiltValueNullFieldError.checkNotNull(
              listingCount, r'AnalyticsCurrentCounts', 'listingCount'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AnalyticsCurrentCounts', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
