// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_confirmation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeliveryConfirmation extends DeliveryConfirmation {
  @override
  final BuiltList<DeliveryVehicleSelection> vehicles;
  @override
  final int finalFeeCentavos;
  @override
  final Date fulfillmentDate;
  @override
  final String arrangement;
  @override
  final bool accessConfirmed;
  @override
  final bool? heavyVehicleAccessConfirmed;
  @override
  final String? manualReviewNote;

  factory _$DeliveryConfirmation(
          [void Function(DeliveryConfirmationBuilder)? updates]) =>
      (DeliveryConfirmationBuilder()..update(updates))._build();

  _$DeliveryConfirmation._(
      {required this.vehicles,
      required this.finalFeeCentavos,
      required this.fulfillmentDate,
      required this.arrangement,
      required this.accessConfirmed,
      this.heavyVehicleAccessConfirmed,
      this.manualReviewNote})
      : super._();
  @override
  DeliveryConfirmation rebuild(
          void Function(DeliveryConfirmationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryConfirmationBuilder toBuilder() =>
      DeliveryConfirmationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryConfirmation &&
        vehicles == other.vehicles &&
        finalFeeCentavos == other.finalFeeCentavos &&
        fulfillmentDate == other.fulfillmentDate &&
        arrangement == other.arrangement &&
        accessConfirmed == other.accessConfirmed &&
        heavyVehicleAccessConfirmed == other.heavyVehicleAccessConfirmed &&
        manualReviewNote == other.manualReviewNote;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vehicles.hashCode);
    _$hash = $jc(_$hash, finalFeeCentavos.hashCode);
    _$hash = $jc(_$hash, fulfillmentDate.hashCode);
    _$hash = $jc(_$hash, arrangement.hashCode);
    _$hash = $jc(_$hash, accessConfirmed.hashCode);
    _$hash = $jc(_$hash, heavyVehicleAccessConfirmed.hashCode);
    _$hash = $jc(_$hash, manualReviewNote.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryConfirmation')
          ..add('vehicles', vehicles)
          ..add('finalFeeCentavos', finalFeeCentavos)
          ..add('fulfillmentDate', fulfillmentDate)
          ..add('arrangement', arrangement)
          ..add('accessConfirmed', accessConfirmed)
          ..add('heavyVehicleAccessConfirmed', heavyVehicleAccessConfirmed)
          ..add('manualReviewNote', manualReviewNote))
        .toString();
  }
}

class DeliveryConfirmationBuilder
    implements Builder<DeliveryConfirmation, DeliveryConfirmationBuilder> {
  _$DeliveryConfirmation? _$v;

  ListBuilder<DeliveryVehicleSelection>? _vehicles;
  ListBuilder<DeliveryVehicleSelection> get vehicles =>
      _$this._vehicles ??= ListBuilder<DeliveryVehicleSelection>();
  set vehicles(ListBuilder<DeliveryVehicleSelection>? vehicles) =>
      _$this._vehicles = vehicles;

  int? _finalFeeCentavos;
  int? get finalFeeCentavos => _$this._finalFeeCentavos;
  set finalFeeCentavos(int? finalFeeCentavos) =>
      _$this._finalFeeCentavos = finalFeeCentavos;

  Date? _fulfillmentDate;
  Date? get fulfillmentDate => _$this._fulfillmentDate;
  set fulfillmentDate(Date? fulfillmentDate) =>
      _$this._fulfillmentDate = fulfillmentDate;

  String? _arrangement;
  String? get arrangement => _$this._arrangement;
  set arrangement(String? arrangement) => _$this._arrangement = arrangement;

  bool? _accessConfirmed;
  bool? get accessConfirmed => _$this._accessConfirmed;
  set accessConfirmed(bool? accessConfirmed) =>
      _$this._accessConfirmed = accessConfirmed;

  bool? _heavyVehicleAccessConfirmed;
  bool? get heavyVehicleAccessConfirmed => _$this._heavyVehicleAccessConfirmed;
  set heavyVehicleAccessConfirmed(bool? heavyVehicleAccessConfirmed) =>
      _$this._heavyVehicleAccessConfirmed = heavyVehicleAccessConfirmed;

  String? _manualReviewNote;
  String? get manualReviewNote => _$this._manualReviewNote;
  set manualReviewNote(String? manualReviewNote) =>
      _$this._manualReviewNote = manualReviewNote;

  DeliveryConfirmationBuilder() {
    DeliveryConfirmation._defaults(this);
  }

  DeliveryConfirmationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vehicles = $v.vehicles.toBuilder();
      _finalFeeCentavos = $v.finalFeeCentavos;
      _fulfillmentDate = $v.fulfillmentDate;
      _arrangement = $v.arrangement;
      _accessConfirmed = $v.accessConfirmed;
      _heavyVehicleAccessConfirmed = $v.heavyVehicleAccessConfirmed;
      _manualReviewNote = $v.manualReviewNote;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryConfirmation other) {
    _$v = other as _$DeliveryConfirmation;
  }

  @override
  void update(void Function(DeliveryConfirmationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryConfirmation build() => _build();

  _$DeliveryConfirmation _build() {
    _$DeliveryConfirmation _$result;
    try {
      _$result = _$v ??
          _$DeliveryConfirmation._(
            vehicles: vehicles.build(),
            finalFeeCentavos: BuiltValueNullFieldError.checkNotNull(
                finalFeeCentavos, r'DeliveryConfirmation', 'finalFeeCentavos'),
            fulfillmentDate: BuiltValueNullFieldError.checkNotNull(
                fulfillmentDate, r'DeliveryConfirmation', 'fulfillmentDate'),
            arrangement: BuiltValueNullFieldError.checkNotNull(
                arrangement, r'DeliveryConfirmation', 'arrangement'),
            accessConfirmed: BuiltValueNullFieldError.checkNotNull(
                accessConfirmed, r'DeliveryConfirmation', 'accessConfirmed'),
            heavyVehicleAccessConfirmed: heavyVehicleAccessConfirmed,
            manualReviewNote: manualReviewNote,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vehicles';
        vehicles.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DeliveryConfirmation', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
