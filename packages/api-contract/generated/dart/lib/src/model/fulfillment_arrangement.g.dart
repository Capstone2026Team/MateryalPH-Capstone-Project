// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fulfillment_arrangement.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FulfillmentArrangement extends FulfillmentArrangement {
  @override
  final BuiltList<FulfillmentArrangementVehicle> vehicles;
  @override
  final int finalFeeCentavos;
  @override
  final String? endpoint;
  @override
  final String? fulfillmentDate;
  @override
  final String? arrangement;
  @override
  final String notice;

  factory _$FulfillmentArrangement(
          [void Function(FulfillmentArrangementBuilder)? updates]) =>
      (FulfillmentArrangementBuilder()..update(updates))._build();

  _$FulfillmentArrangement._(
      {required this.vehicles,
      required this.finalFeeCentavos,
      this.endpoint,
      this.fulfillmentDate,
      this.arrangement,
      required this.notice})
      : super._();
  @override
  FulfillmentArrangement rebuild(
          void Function(FulfillmentArrangementBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FulfillmentArrangementBuilder toBuilder() =>
      FulfillmentArrangementBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FulfillmentArrangement &&
        vehicles == other.vehicles &&
        finalFeeCentavos == other.finalFeeCentavos &&
        endpoint == other.endpoint &&
        fulfillmentDate == other.fulfillmentDate &&
        arrangement == other.arrangement &&
        notice == other.notice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vehicles.hashCode);
    _$hash = $jc(_$hash, finalFeeCentavos.hashCode);
    _$hash = $jc(_$hash, endpoint.hashCode);
    _$hash = $jc(_$hash, fulfillmentDate.hashCode);
    _$hash = $jc(_$hash, arrangement.hashCode);
    _$hash = $jc(_$hash, notice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FulfillmentArrangement')
          ..add('vehicles', vehicles)
          ..add('finalFeeCentavos', finalFeeCentavos)
          ..add('endpoint', endpoint)
          ..add('fulfillmentDate', fulfillmentDate)
          ..add('arrangement', arrangement)
          ..add('notice', notice))
        .toString();
  }
}

class FulfillmentArrangementBuilder
    implements Builder<FulfillmentArrangement, FulfillmentArrangementBuilder> {
  _$FulfillmentArrangement? _$v;

  ListBuilder<FulfillmentArrangementVehicle>? _vehicles;
  ListBuilder<FulfillmentArrangementVehicle> get vehicles =>
      _$this._vehicles ??= ListBuilder<FulfillmentArrangementVehicle>();
  set vehicles(ListBuilder<FulfillmentArrangementVehicle>? vehicles) =>
      _$this._vehicles = vehicles;

  int? _finalFeeCentavos;
  int? get finalFeeCentavos => _$this._finalFeeCentavos;
  set finalFeeCentavos(int? finalFeeCentavos) =>
      _$this._finalFeeCentavos = finalFeeCentavos;

  String? _endpoint;
  String? get endpoint => _$this._endpoint;
  set endpoint(String? endpoint) => _$this._endpoint = endpoint;

  String? _fulfillmentDate;
  String? get fulfillmentDate => _$this._fulfillmentDate;
  set fulfillmentDate(String? fulfillmentDate) =>
      _$this._fulfillmentDate = fulfillmentDate;

  String? _arrangement;
  String? get arrangement => _$this._arrangement;
  set arrangement(String? arrangement) => _$this._arrangement = arrangement;

  String? _notice;
  String? get notice => _$this._notice;
  set notice(String? notice) => _$this._notice = notice;

  FulfillmentArrangementBuilder() {
    FulfillmentArrangement._defaults(this);
  }

  FulfillmentArrangementBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vehicles = $v.vehicles.toBuilder();
      _finalFeeCentavos = $v.finalFeeCentavos;
      _endpoint = $v.endpoint;
      _fulfillmentDate = $v.fulfillmentDate;
      _arrangement = $v.arrangement;
      _notice = $v.notice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FulfillmentArrangement other) {
    _$v = other as _$FulfillmentArrangement;
  }

  @override
  void update(void Function(FulfillmentArrangementBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FulfillmentArrangement build() => _build();

  _$FulfillmentArrangement _build() {
    _$FulfillmentArrangement _$result;
    try {
      _$result = _$v ??
          _$FulfillmentArrangement._(
            vehicles: vehicles.build(),
            finalFeeCentavos: BuiltValueNullFieldError.checkNotNull(
                finalFeeCentavos,
                r'FulfillmentArrangement',
                'finalFeeCentavos'),
            endpoint: endpoint,
            fulfillmentDate: fulfillmentDate,
            arrangement: arrangement,
            notice: BuiltValueNullFieldError.checkNotNull(
                notice, r'FulfillmentArrangement', 'notice'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vehicles';
        vehicles.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FulfillmentArrangement', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
