// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_estimate.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeliveryEstimate extends DeliveryEstimate {
  @override
  final int feeMinCentavos;
  @override
  final int feeMaxCentavos;
  @override
  final int tripsMin;
  @override
  final int tripsMax;
  @override
  final int vehiclesMin;
  @override
  final int vehiclesMax;
  @override
  final BuiltList<DeliveryEstimateOption> options;

  factory _$DeliveryEstimate(
          [void Function(DeliveryEstimateBuilder)? updates]) =>
      (DeliveryEstimateBuilder()..update(updates))._build();

  _$DeliveryEstimate._(
      {required this.feeMinCentavos,
      required this.feeMaxCentavos,
      required this.tripsMin,
      required this.tripsMax,
      required this.vehiclesMin,
      required this.vehiclesMax,
      required this.options})
      : super._();
  @override
  DeliveryEstimate rebuild(void Function(DeliveryEstimateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryEstimateBuilder toBuilder() =>
      DeliveryEstimateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryEstimate &&
        feeMinCentavos == other.feeMinCentavos &&
        feeMaxCentavos == other.feeMaxCentavos &&
        tripsMin == other.tripsMin &&
        tripsMax == other.tripsMax &&
        vehiclesMin == other.vehiclesMin &&
        vehiclesMax == other.vehiclesMax &&
        options == other.options;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, feeMinCentavos.hashCode);
    _$hash = $jc(_$hash, feeMaxCentavos.hashCode);
    _$hash = $jc(_$hash, tripsMin.hashCode);
    _$hash = $jc(_$hash, tripsMax.hashCode);
    _$hash = $jc(_$hash, vehiclesMin.hashCode);
    _$hash = $jc(_$hash, vehiclesMax.hashCode);
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryEstimate')
          ..add('feeMinCentavos', feeMinCentavos)
          ..add('feeMaxCentavos', feeMaxCentavos)
          ..add('tripsMin', tripsMin)
          ..add('tripsMax', tripsMax)
          ..add('vehiclesMin', vehiclesMin)
          ..add('vehiclesMax', vehiclesMax)
          ..add('options', options))
        .toString();
  }
}

class DeliveryEstimateBuilder
    implements Builder<DeliveryEstimate, DeliveryEstimateBuilder> {
  _$DeliveryEstimate? _$v;

  int? _feeMinCentavos;
  int? get feeMinCentavos => _$this._feeMinCentavos;
  set feeMinCentavos(int? feeMinCentavos) =>
      _$this._feeMinCentavos = feeMinCentavos;

  int? _feeMaxCentavos;
  int? get feeMaxCentavos => _$this._feeMaxCentavos;
  set feeMaxCentavos(int? feeMaxCentavos) =>
      _$this._feeMaxCentavos = feeMaxCentavos;

  int? _tripsMin;
  int? get tripsMin => _$this._tripsMin;
  set tripsMin(int? tripsMin) => _$this._tripsMin = tripsMin;

  int? _tripsMax;
  int? get tripsMax => _$this._tripsMax;
  set tripsMax(int? tripsMax) => _$this._tripsMax = tripsMax;

  int? _vehiclesMin;
  int? get vehiclesMin => _$this._vehiclesMin;
  set vehiclesMin(int? vehiclesMin) => _$this._vehiclesMin = vehiclesMin;

  int? _vehiclesMax;
  int? get vehiclesMax => _$this._vehiclesMax;
  set vehiclesMax(int? vehiclesMax) => _$this._vehiclesMax = vehiclesMax;

  ListBuilder<DeliveryEstimateOption>? _options;
  ListBuilder<DeliveryEstimateOption> get options =>
      _$this._options ??= ListBuilder<DeliveryEstimateOption>();
  set options(ListBuilder<DeliveryEstimateOption>? options) =>
      _$this._options = options;

  DeliveryEstimateBuilder() {
    DeliveryEstimate._defaults(this);
  }

  DeliveryEstimateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _feeMinCentavos = $v.feeMinCentavos;
      _feeMaxCentavos = $v.feeMaxCentavos;
      _tripsMin = $v.tripsMin;
      _tripsMax = $v.tripsMax;
      _vehiclesMin = $v.vehiclesMin;
      _vehiclesMax = $v.vehiclesMax;
      _options = $v.options.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryEstimate other) {
    _$v = other as _$DeliveryEstimate;
  }

  @override
  void update(void Function(DeliveryEstimateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryEstimate build() => _build();

  _$DeliveryEstimate _build() {
    _$DeliveryEstimate _$result;
    try {
      _$result = _$v ??
          _$DeliveryEstimate._(
            feeMinCentavos: BuiltValueNullFieldError.checkNotNull(
                feeMinCentavos, r'DeliveryEstimate', 'feeMinCentavos'),
            feeMaxCentavos: BuiltValueNullFieldError.checkNotNull(
                feeMaxCentavos, r'DeliveryEstimate', 'feeMaxCentavos'),
            tripsMin: BuiltValueNullFieldError.checkNotNull(
                tripsMin, r'DeliveryEstimate', 'tripsMin'),
            tripsMax: BuiltValueNullFieldError.checkNotNull(
                tripsMax, r'DeliveryEstimate', 'tripsMax'),
            vehiclesMin: BuiltValueNullFieldError.checkNotNull(
                vehiclesMin, r'DeliveryEstimate', 'vehiclesMin'),
            vehiclesMax: BuiltValueNullFieldError.checkNotNull(
                vehiclesMax, r'DeliveryEstimate', 'vehiclesMax'),
            options: options.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'options';
        options.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DeliveryEstimate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
