// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_child_registered_buyers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoChildRegisteredBuyers extends GeoChildRegisteredBuyers {
  @override
  final int? value;
  @override
  final bool suppressed;

  factory _$GeoChildRegisteredBuyers(
          [void Function(GeoChildRegisteredBuyersBuilder)? updates]) =>
      (GeoChildRegisteredBuyersBuilder()..update(updates))._build();

  _$GeoChildRegisteredBuyers._({this.value, required this.suppressed})
      : super._();
  @override
  GeoChildRegisteredBuyers rebuild(
          void Function(GeoChildRegisteredBuyersBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoChildRegisteredBuyersBuilder toBuilder() =>
      GeoChildRegisteredBuyersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoChildRegisteredBuyers &&
        value == other.value &&
        suppressed == other.suppressed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, suppressed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoChildRegisteredBuyers')
          ..add('value', value)
          ..add('suppressed', suppressed))
        .toString();
  }
}

class GeoChildRegisteredBuyersBuilder
    implements
        Builder<GeoChildRegisteredBuyers, GeoChildRegisteredBuyersBuilder> {
  _$GeoChildRegisteredBuyers? _$v;

  int? _value;
  int? get value => _$this._value;
  set value(int? value) => _$this._value = value;

  bool? _suppressed;
  bool? get suppressed => _$this._suppressed;
  set suppressed(bool? suppressed) => _$this._suppressed = suppressed;

  GeoChildRegisteredBuyersBuilder() {
    GeoChildRegisteredBuyers._defaults(this);
  }

  GeoChildRegisteredBuyersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _value = $v.value;
      _suppressed = $v.suppressed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoChildRegisteredBuyers other) {
    _$v = other as _$GeoChildRegisteredBuyers;
  }

  @override
  void update(void Function(GeoChildRegisteredBuyersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoChildRegisteredBuyers build() => _build();

  _$GeoChildRegisteredBuyers _build() {
    final _$result = _$v ??
        _$GeoChildRegisteredBuyers._(
          value: value,
          suppressed: BuiltValueNullFieldError.checkNotNull(
              suppressed, r'GeoChildRegisteredBuyers', 'suppressed'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
