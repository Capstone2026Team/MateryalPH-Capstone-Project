// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_destination_labels.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CartDestinationLabels extends CartDestinationLabels {
  @override
  final String intended;
  @override
  final String vehicleEndpoint;

  factory _$CartDestinationLabels(
          [void Function(CartDestinationLabelsBuilder)? updates]) =>
      (CartDestinationLabelsBuilder()..update(updates))._build();

  _$CartDestinationLabels._(
      {required this.intended, required this.vehicleEndpoint})
      : super._();
  @override
  CartDestinationLabels rebuild(
          void Function(CartDestinationLabelsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CartDestinationLabelsBuilder toBuilder() =>
      CartDestinationLabelsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CartDestinationLabels &&
        intended == other.intended &&
        vehicleEndpoint == other.vehicleEndpoint;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, intended.hashCode);
    _$hash = $jc(_$hash, vehicleEndpoint.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CartDestinationLabels')
          ..add('intended', intended)
          ..add('vehicleEndpoint', vehicleEndpoint))
        .toString();
  }
}

class CartDestinationLabelsBuilder
    implements Builder<CartDestinationLabels, CartDestinationLabelsBuilder> {
  _$CartDestinationLabels? _$v;

  String? _intended;
  String? get intended => _$this._intended;
  set intended(String? intended) => _$this._intended = intended;

  String? _vehicleEndpoint;
  String? get vehicleEndpoint => _$this._vehicleEndpoint;
  set vehicleEndpoint(String? vehicleEndpoint) =>
      _$this._vehicleEndpoint = vehicleEndpoint;

  CartDestinationLabelsBuilder() {
    CartDestinationLabels._defaults(this);
  }

  CartDestinationLabelsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _intended = $v.intended;
      _vehicleEndpoint = $v.vehicleEndpoint;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CartDestinationLabels other) {
    _$v = other as _$CartDestinationLabels;
  }

  @override
  void update(void Function(CartDestinationLabelsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CartDestinationLabels build() => _build();

  _$CartDestinationLabels _build() {
    final _$result = _$v ??
        _$CartDestinationLabels._(
          intended: BuiltValueNullFieldError.checkNotNull(
              intended, r'CartDestinationLabels', 'intended'),
          vehicleEndpoint: BuiltValueNullFieldError.checkNotNull(
              vehicleEndpoint, r'CartDestinationLabels', 'vehicleEndpoint'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
