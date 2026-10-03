// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_quotation_money.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatQuotationMoney extends ChatQuotationMoney {
  @override
  final int materialsPayableCentavos;
  @override
  final int materialsVatCentavos;
  @override
  final int vendorDiscountCentavos;
  @override
  final int deliveryCentavos;
  @override
  final int nrpcCentavos;
  @override
  final int commercialTotalCentavos;

  factory _$ChatQuotationMoney(
          [void Function(ChatQuotationMoneyBuilder)? updates]) =>
      (ChatQuotationMoneyBuilder()..update(updates))._build();

  _$ChatQuotationMoney._(
      {required this.materialsPayableCentavos,
      required this.materialsVatCentavos,
      required this.vendorDiscountCentavos,
      required this.deliveryCentavos,
      required this.nrpcCentavos,
      required this.commercialTotalCentavos})
      : super._();
  @override
  ChatQuotationMoney rebuild(
          void Function(ChatQuotationMoneyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatQuotationMoneyBuilder toBuilder() =>
      ChatQuotationMoneyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatQuotationMoney &&
        materialsPayableCentavos == other.materialsPayableCentavos &&
        materialsVatCentavos == other.materialsVatCentavos &&
        vendorDiscountCentavos == other.vendorDiscountCentavos &&
        deliveryCentavos == other.deliveryCentavos &&
        nrpcCentavos == other.nrpcCentavos &&
        commercialTotalCentavos == other.commercialTotalCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, materialsPayableCentavos.hashCode);
    _$hash = $jc(_$hash, materialsVatCentavos.hashCode);
    _$hash = $jc(_$hash, vendorDiscountCentavos.hashCode);
    _$hash = $jc(_$hash, deliveryCentavos.hashCode);
    _$hash = $jc(_$hash, nrpcCentavos.hashCode);
    _$hash = $jc(_$hash, commercialTotalCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatQuotationMoney')
          ..add('materialsPayableCentavos', materialsPayableCentavos)
          ..add('materialsVatCentavos', materialsVatCentavos)
          ..add('vendorDiscountCentavos', vendorDiscountCentavos)
          ..add('deliveryCentavos', deliveryCentavos)
          ..add('nrpcCentavos', nrpcCentavos)
          ..add('commercialTotalCentavos', commercialTotalCentavos))
        .toString();
  }
}

class ChatQuotationMoneyBuilder
    implements Builder<ChatQuotationMoney, ChatQuotationMoneyBuilder> {
  _$ChatQuotationMoney? _$v;

  int? _materialsPayableCentavos;
  int? get materialsPayableCentavos => _$this._materialsPayableCentavos;
  set materialsPayableCentavos(int? materialsPayableCentavos) =>
      _$this._materialsPayableCentavos = materialsPayableCentavos;

  int? _materialsVatCentavos;
  int? get materialsVatCentavos => _$this._materialsVatCentavos;
  set materialsVatCentavos(int? materialsVatCentavos) =>
      _$this._materialsVatCentavos = materialsVatCentavos;

  int? _vendorDiscountCentavos;
  int? get vendorDiscountCentavos => _$this._vendorDiscountCentavos;
  set vendorDiscountCentavos(int? vendorDiscountCentavos) =>
      _$this._vendorDiscountCentavos = vendorDiscountCentavos;

  int? _deliveryCentavos;
  int? get deliveryCentavos => _$this._deliveryCentavos;
  set deliveryCentavos(int? deliveryCentavos) =>
      _$this._deliveryCentavos = deliveryCentavos;

  int? _nrpcCentavos;
  int? get nrpcCentavos => _$this._nrpcCentavos;
  set nrpcCentavos(int? nrpcCentavos) => _$this._nrpcCentavos = nrpcCentavos;

  int? _commercialTotalCentavos;
  int? get commercialTotalCentavos => _$this._commercialTotalCentavos;
  set commercialTotalCentavos(int? commercialTotalCentavos) =>
      _$this._commercialTotalCentavos = commercialTotalCentavos;

  ChatQuotationMoneyBuilder() {
    ChatQuotationMoney._defaults(this);
  }

  ChatQuotationMoneyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _materialsPayableCentavos = $v.materialsPayableCentavos;
      _materialsVatCentavos = $v.materialsVatCentavos;
      _vendorDiscountCentavos = $v.vendorDiscountCentavos;
      _deliveryCentavos = $v.deliveryCentavos;
      _nrpcCentavos = $v.nrpcCentavos;
      _commercialTotalCentavos = $v.commercialTotalCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatQuotationMoney other) {
    _$v = other as _$ChatQuotationMoney;
  }

  @override
  void update(void Function(ChatQuotationMoneyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatQuotationMoney build() => _build();

  _$ChatQuotationMoney _build() {
    final _$result = _$v ??
        _$ChatQuotationMoney._(
          materialsPayableCentavos: BuiltValueNullFieldError.checkNotNull(
              materialsPayableCentavos,
              r'ChatQuotationMoney',
              'materialsPayableCentavos'),
          materialsVatCentavos: BuiltValueNullFieldError.checkNotNull(
              materialsVatCentavos,
              r'ChatQuotationMoney',
              'materialsVatCentavos'),
          vendorDiscountCentavos: BuiltValueNullFieldError.checkNotNull(
              vendorDiscountCentavos,
              r'ChatQuotationMoney',
              'vendorDiscountCentavos'),
          deliveryCentavos: BuiltValueNullFieldError.checkNotNull(
              deliveryCentavos, r'ChatQuotationMoney', 'deliveryCentavos'),
          nrpcCentavos: BuiltValueNullFieldError.checkNotNull(
              nrpcCentavos, r'ChatQuotationMoney', 'nrpcCentavos'),
          commercialTotalCentavos: BuiltValueNullFieldError.checkNotNull(
              commercialTotalCentavos,
              r'ChatQuotationMoney',
              'commercialTotalCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
