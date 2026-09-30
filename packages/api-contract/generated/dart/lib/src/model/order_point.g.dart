// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_point.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderPoint extends OrderPoint {
  @override
  final String? locationId;
  @override
  final String? label;
  @override
  final String? kind;
  @override
  final String? formattedAddress;

  factory _$OrderPoint([void Function(OrderPointBuilder)? updates]) =>
      (OrderPointBuilder()..update(updates))._build();

  _$OrderPoint._(
      {this.locationId, this.label, this.kind, this.formattedAddress})
      : super._();
  @override
  OrderPoint rebuild(void Function(OrderPointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderPointBuilder toBuilder() => OrderPointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderPoint &&
        locationId == other.locationId &&
        label == other.label &&
        kind == other.kind &&
        formattedAddress == other.formattedAddress;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, locationId.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, formattedAddress.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderPoint')
          ..add('locationId', locationId)
          ..add('label', label)
          ..add('kind', kind)
          ..add('formattedAddress', formattedAddress))
        .toString();
  }
}

class OrderPointBuilder implements Builder<OrderPoint, OrderPointBuilder> {
  _$OrderPoint? _$v;

  String? _locationId;
  String? get locationId => _$this._locationId;
  set locationId(String? locationId) => _$this._locationId = locationId;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _kind;
  String? get kind => _$this._kind;
  set kind(String? kind) => _$this._kind = kind;

  String? _formattedAddress;
  String? get formattedAddress => _$this._formattedAddress;
  set formattedAddress(String? formattedAddress) =>
      _$this._formattedAddress = formattedAddress;

  OrderPointBuilder() {
    OrderPoint._defaults(this);
  }

  OrderPointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _locationId = $v.locationId;
      _label = $v.label;
      _kind = $v.kind;
      _formattedAddress = $v.formattedAddress;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderPoint other) {
    _$v = other as _$OrderPoint;
  }

  @override
  void update(void Function(OrderPointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderPoint build() => _build();

  _$OrderPoint _build() {
    final _$result = _$v ??
        _$OrderPoint._(
          locationId: locationId,
          label: label,
          kind: kind,
          formattedAddress: formattedAddress,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
