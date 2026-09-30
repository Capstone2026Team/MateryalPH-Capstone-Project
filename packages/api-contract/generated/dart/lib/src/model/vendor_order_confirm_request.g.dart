// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_order_confirm_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorOrderConfirmRequest extends VendorOrderConfirmRequest {
  @override
  final int lockVersion;
  @override
  final BuiltList<OrderLineQuantity> lines;
  @override
  final int? vendorDiscountCentavos;
  @override
  final NrpcProposal? nrpc;
  @override
  final PickupConfirmation? pickup;
  @override
  final DeliveryConfirmation? delivery;

  factory _$VendorOrderConfirmRequest(
          [void Function(VendorOrderConfirmRequestBuilder)? updates]) =>
      (VendorOrderConfirmRequestBuilder()..update(updates))._build();

  _$VendorOrderConfirmRequest._(
      {required this.lockVersion,
      required this.lines,
      this.vendorDiscountCentavos,
      this.nrpc,
      this.pickup,
      this.delivery})
      : super._();
  @override
  VendorOrderConfirmRequest rebuild(
          void Function(VendorOrderConfirmRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorOrderConfirmRequestBuilder toBuilder() =>
      VendorOrderConfirmRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorOrderConfirmRequest &&
        lockVersion == other.lockVersion &&
        lines == other.lines &&
        vendorDiscountCentavos == other.vendorDiscountCentavos &&
        nrpc == other.nrpc &&
        pickup == other.pickup &&
        delivery == other.delivery;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, vendorDiscountCentavos.hashCode);
    _$hash = $jc(_$hash, nrpc.hashCode);
    _$hash = $jc(_$hash, pickup.hashCode);
    _$hash = $jc(_$hash, delivery.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorOrderConfirmRequest')
          ..add('lockVersion', lockVersion)
          ..add('lines', lines)
          ..add('vendorDiscountCentavos', vendorDiscountCentavos)
          ..add('nrpc', nrpc)
          ..add('pickup', pickup)
          ..add('delivery', delivery))
        .toString();
  }
}

class VendorOrderConfirmRequestBuilder
    implements
        Builder<VendorOrderConfirmRequest, VendorOrderConfirmRequestBuilder> {
  _$VendorOrderConfirmRequest? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  ListBuilder<OrderLineQuantity>? _lines;
  ListBuilder<OrderLineQuantity> get lines =>
      _$this._lines ??= ListBuilder<OrderLineQuantity>();
  set lines(ListBuilder<OrderLineQuantity>? lines) => _$this._lines = lines;

  int? _vendorDiscountCentavos;
  int? get vendorDiscountCentavos => _$this._vendorDiscountCentavos;
  set vendorDiscountCentavos(int? vendorDiscountCentavos) =>
      _$this._vendorDiscountCentavos = vendorDiscountCentavos;

  NrpcProposalBuilder? _nrpc;
  NrpcProposalBuilder get nrpc => _$this._nrpc ??= NrpcProposalBuilder();
  set nrpc(NrpcProposalBuilder? nrpc) => _$this._nrpc = nrpc;

  PickupConfirmationBuilder? _pickup;
  PickupConfirmationBuilder get pickup =>
      _$this._pickup ??= PickupConfirmationBuilder();
  set pickup(PickupConfirmationBuilder? pickup) => _$this._pickup = pickup;

  DeliveryConfirmationBuilder? _delivery;
  DeliveryConfirmationBuilder get delivery =>
      _$this._delivery ??= DeliveryConfirmationBuilder();
  set delivery(DeliveryConfirmationBuilder? delivery) =>
      _$this._delivery = delivery;

  VendorOrderConfirmRequestBuilder() {
    VendorOrderConfirmRequest._defaults(this);
  }

  VendorOrderConfirmRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _lines = $v.lines.toBuilder();
      _vendorDiscountCentavos = $v.vendorDiscountCentavos;
      _nrpc = $v.nrpc?.toBuilder();
      _pickup = $v.pickup?.toBuilder();
      _delivery = $v.delivery?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorOrderConfirmRequest other) {
    _$v = other as _$VendorOrderConfirmRequest;
  }

  @override
  void update(void Function(VendorOrderConfirmRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorOrderConfirmRequest build() => _build();

  _$VendorOrderConfirmRequest _build() {
    _$VendorOrderConfirmRequest _$result;
    try {
      _$result = _$v ??
          _$VendorOrderConfirmRequest._(
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'VendorOrderConfirmRequest', 'lockVersion'),
            lines: lines.build(),
            vendorDiscountCentavos: vendorDiscountCentavos,
            nrpc: _nrpc?.build(),
            pickup: _pickup?.build(),
            delivery: _delivery?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();

        _$failedField = 'nrpc';
        _nrpc?.build();
        _$failedField = 'pickup';
        _pickup?.build();
        _$failedField = 'delivery';
        _delivery?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorOrderConfirmRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
