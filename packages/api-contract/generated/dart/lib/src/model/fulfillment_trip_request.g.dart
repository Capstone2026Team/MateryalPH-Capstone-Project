// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fulfillment_trip_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FulfillmentTripRequest extends FulfillmentTripRequest {
  @override
  final int vehicleIndex;
  @override
  final int tripNumber;

  factory _$FulfillmentTripRequest(
          [void Function(FulfillmentTripRequestBuilder)? updates]) =>
      (FulfillmentTripRequestBuilder()..update(updates))._build();

  _$FulfillmentTripRequest._(
      {required this.vehicleIndex, required this.tripNumber})
      : super._();
  @override
  FulfillmentTripRequest rebuild(
          void Function(FulfillmentTripRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FulfillmentTripRequestBuilder toBuilder() =>
      FulfillmentTripRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FulfillmentTripRequest &&
        vehicleIndex == other.vehicleIndex &&
        tripNumber == other.tripNumber;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vehicleIndex.hashCode);
    _$hash = $jc(_$hash, tripNumber.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FulfillmentTripRequest')
          ..add('vehicleIndex', vehicleIndex)
          ..add('tripNumber', tripNumber))
        .toString();
  }
}

class FulfillmentTripRequestBuilder
    implements Builder<FulfillmentTripRequest, FulfillmentTripRequestBuilder> {
  _$FulfillmentTripRequest? _$v;

  int? _vehicleIndex;
  int? get vehicleIndex => _$this._vehicleIndex;
  set vehicleIndex(int? vehicleIndex) => _$this._vehicleIndex = vehicleIndex;

  int? _tripNumber;
  int? get tripNumber => _$this._tripNumber;
  set tripNumber(int? tripNumber) => _$this._tripNumber = tripNumber;

  FulfillmentTripRequestBuilder() {
    FulfillmentTripRequest._defaults(this);
  }

  FulfillmentTripRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vehicleIndex = $v.vehicleIndex;
      _tripNumber = $v.tripNumber;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FulfillmentTripRequest other) {
    _$v = other as _$FulfillmentTripRequest;
  }

  @override
  void update(void Function(FulfillmentTripRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FulfillmentTripRequest build() => _build();

  _$FulfillmentTripRequest _build() {
    final _$result = _$v ??
        _$FulfillmentTripRequest._(
          vehicleIndex: BuiltValueNullFieldError.checkNotNull(
              vehicleIndex, r'FulfillmentTripRequest', 'vehicleIndex'),
          tripNumber: BuiltValueNullFieldError.checkNotNull(
              tripNumber, r'FulfillmentTripRequest', 'tripNumber'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
