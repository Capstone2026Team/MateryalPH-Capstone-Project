// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_breakdown.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MoneyBreakdownCurrencyEnum _$moneyBreakdownCurrencyEnum_PHP =
    const MoneyBreakdownCurrencyEnum._('PHP');

MoneyBreakdownCurrencyEnum _$moneyBreakdownCurrencyEnumValueOf(String name) {
  switch (name) {
    case 'PHP':
      return _$moneyBreakdownCurrencyEnum_PHP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MoneyBreakdownCurrencyEnum> _$moneyBreakdownCurrencyEnumValues =
    BuiltSet<MoneyBreakdownCurrencyEnum>(const <MoneyBreakdownCurrencyEnum>[
  _$moneyBreakdownCurrencyEnum_PHP,
]);

const MoneyBreakdownStatusEnum
    _$moneyBreakdownStatusEnum_ADVISORY_UNTIL_VENDOR_CONFIRMATION =
    const MoneyBreakdownStatusEnum._('ADVISORY_UNTIL_VENDOR_CONFIRMATION');
const MoneyBreakdownStatusEnum
    _$moneyBreakdownStatusEnum_AWAITING_BUYER_ACCEPTANCE =
    const MoneyBreakdownStatusEnum._('AWAITING_BUYER_ACCEPTANCE');
const MoneyBreakdownStatusEnum _$moneyBreakdownStatusEnum_ACCEPTED =
    const MoneyBreakdownStatusEnum._('ACCEPTED');

MoneyBreakdownStatusEnum _$moneyBreakdownStatusEnumValueOf(String name) {
  switch (name) {
    case 'ADVISORY_UNTIL_VENDOR_CONFIRMATION':
      return _$moneyBreakdownStatusEnum_ADVISORY_UNTIL_VENDOR_CONFIRMATION;
    case 'AWAITING_BUYER_ACCEPTANCE':
      return _$moneyBreakdownStatusEnum_AWAITING_BUYER_ACCEPTANCE;
    case 'ACCEPTED':
      return _$moneyBreakdownStatusEnum_ACCEPTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MoneyBreakdownStatusEnum> _$moneyBreakdownStatusEnumValues =
    BuiltSet<MoneyBreakdownStatusEnum>(const <MoneyBreakdownStatusEnum>[
  _$moneyBreakdownStatusEnum_ADVISORY_UNTIL_VENDOR_CONFIRMATION,
  _$moneyBreakdownStatusEnum_AWAITING_BUYER_ACCEPTANCE,
  _$moneyBreakdownStatusEnum_ACCEPTED,
]);

const MoneyBreakdownVatTreatmentEnum
    _$moneyBreakdownVatTreatmentEnum_PRICES_INCLUDE_VAT =
    const MoneyBreakdownVatTreatmentEnum._('PRICES_INCLUDE_VAT');
const MoneyBreakdownVatTreatmentEnum
    _$moneyBreakdownVatTreatmentEnum_NO_INCLUDED_VAT =
    const MoneyBreakdownVatTreatmentEnum._('NO_INCLUDED_VAT');

MoneyBreakdownVatTreatmentEnum _$moneyBreakdownVatTreatmentEnumValueOf(
    String name) {
  switch (name) {
    case 'PRICES_INCLUDE_VAT':
      return _$moneyBreakdownVatTreatmentEnum_PRICES_INCLUDE_VAT;
    case 'NO_INCLUDED_VAT':
      return _$moneyBreakdownVatTreatmentEnum_NO_INCLUDED_VAT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MoneyBreakdownVatTreatmentEnum>
    _$moneyBreakdownVatTreatmentEnumValues = BuiltSet<
        MoneyBreakdownVatTreatmentEnum>(const <MoneyBreakdownVatTreatmentEnum>[
  _$moneyBreakdownVatTreatmentEnum_PRICES_INCLUDE_VAT,
  _$moneyBreakdownVatTreatmentEnum_NO_INCLUDED_VAT,
]);

const MoneyBreakdownPaymentPurposeEnum
    _$moneyBreakdownPaymentPurposeEnum_FULL_ORDER_PAYMENT =
    const MoneyBreakdownPaymentPurposeEnum._('FULL_ORDER_PAYMENT');
const MoneyBreakdownPaymentPurposeEnum
    _$moneyBreakdownPaymentPurposeEnum_NRPC_ASSURANCE_PAYMENT =
    const MoneyBreakdownPaymentPurposeEnum._('NRPC_ASSURANCE_PAYMENT');

MoneyBreakdownPaymentPurposeEnum _$moneyBreakdownPaymentPurposeEnumValueOf(
    String name) {
  switch (name) {
    case 'FULL_ORDER_PAYMENT':
      return _$moneyBreakdownPaymentPurposeEnum_FULL_ORDER_PAYMENT;
    case 'NRPC_ASSURANCE_PAYMENT':
      return _$moneyBreakdownPaymentPurposeEnum_NRPC_ASSURANCE_PAYMENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MoneyBreakdownPaymentPurposeEnum>
    _$moneyBreakdownPaymentPurposeEnumValues = BuiltSet<
        MoneyBreakdownPaymentPurposeEnum>(const <MoneyBreakdownPaymentPurposeEnum>[
  _$moneyBreakdownPaymentPurposeEnum_FULL_ORDER_PAYMENT,
  _$moneyBreakdownPaymentPurposeEnum_NRPC_ASSURANCE_PAYMENT,
]);

const MoneyBreakdownExcludesEnum
    _$moneyBreakdownExcludesEnum_VENDOR_COMMISSION =
    const MoneyBreakdownExcludesEnum._('VENDOR_COMMISSION');
const MoneyBreakdownExcludesEnum
    _$moneyBreakdownExcludesEnum_MERCHANT_WITHHOLDING =
    const MoneyBreakdownExcludesEnum._('MERCHANT_WITHHOLDING');

MoneyBreakdownExcludesEnum _$moneyBreakdownExcludesEnumValueOf(String name) {
  switch (name) {
    case 'VENDOR_COMMISSION':
      return _$moneyBreakdownExcludesEnum_VENDOR_COMMISSION;
    case 'MERCHANT_WITHHOLDING':
      return _$moneyBreakdownExcludesEnum_MERCHANT_WITHHOLDING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MoneyBreakdownExcludesEnum> _$moneyBreakdownExcludesEnumValues =
    BuiltSet<MoneyBreakdownExcludesEnum>(const <MoneyBreakdownExcludesEnum>[
  _$moneyBreakdownExcludesEnum_VENDOR_COMMISSION,
  _$moneyBreakdownExcludesEnum_MERCHANT_WITHHOLDING,
]);

Serializer<MoneyBreakdownCurrencyEnum> _$moneyBreakdownCurrencyEnumSerializer =
    _$MoneyBreakdownCurrencyEnumSerializer();
Serializer<MoneyBreakdownStatusEnum> _$moneyBreakdownStatusEnumSerializer =
    _$MoneyBreakdownStatusEnumSerializer();
Serializer<MoneyBreakdownVatTreatmentEnum>
    _$moneyBreakdownVatTreatmentEnumSerializer =
    _$MoneyBreakdownVatTreatmentEnumSerializer();
Serializer<MoneyBreakdownPaymentPurposeEnum>
    _$moneyBreakdownPaymentPurposeEnumSerializer =
    _$MoneyBreakdownPaymentPurposeEnumSerializer();
Serializer<MoneyBreakdownExcludesEnum> _$moneyBreakdownExcludesEnumSerializer =
    _$MoneyBreakdownExcludesEnumSerializer();

class _$MoneyBreakdownCurrencyEnumSerializer
    implements PrimitiveSerializer<MoneyBreakdownCurrencyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PHP': 'PHP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PHP': 'PHP',
  };

  @override
  final Iterable<Type> types = const <Type>[MoneyBreakdownCurrencyEnum];
  @override
  final String wireName = 'MoneyBreakdownCurrencyEnum';

  @override
  Object serialize(Serializers serializers, MoneyBreakdownCurrencyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MoneyBreakdownCurrencyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MoneyBreakdownCurrencyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MoneyBreakdownStatusEnumSerializer
    implements PrimitiveSerializer<MoneyBreakdownStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ADVISORY_UNTIL_VENDOR_CONFIRMATION': 'ADVISORY_UNTIL_VENDOR_CONFIRMATION',
    'AWAITING_BUYER_ACCEPTANCE': 'AWAITING_BUYER_ACCEPTANCE',
    'ACCEPTED': 'ACCEPTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ADVISORY_UNTIL_VENDOR_CONFIRMATION': 'ADVISORY_UNTIL_VENDOR_CONFIRMATION',
    'AWAITING_BUYER_ACCEPTANCE': 'AWAITING_BUYER_ACCEPTANCE',
    'ACCEPTED': 'ACCEPTED',
  };

  @override
  final Iterable<Type> types = const <Type>[MoneyBreakdownStatusEnum];
  @override
  final String wireName = 'MoneyBreakdownStatusEnum';

  @override
  Object serialize(Serializers serializers, MoneyBreakdownStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MoneyBreakdownStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MoneyBreakdownStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MoneyBreakdownVatTreatmentEnumSerializer
    implements PrimitiveSerializer<MoneyBreakdownVatTreatmentEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PRICES_INCLUDE_VAT': 'PRICES_INCLUDE_VAT',
    'NO_INCLUDED_VAT': 'NO_INCLUDED_VAT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PRICES_INCLUDE_VAT': 'PRICES_INCLUDE_VAT',
    'NO_INCLUDED_VAT': 'NO_INCLUDED_VAT',
  };

  @override
  final Iterable<Type> types = const <Type>[MoneyBreakdownVatTreatmentEnum];
  @override
  final String wireName = 'MoneyBreakdownVatTreatmentEnum';

  @override
  Object serialize(
          Serializers serializers, MoneyBreakdownVatTreatmentEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MoneyBreakdownVatTreatmentEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MoneyBreakdownVatTreatmentEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MoneyBreakdownPaymentPurposeEnumSerializer
    implements PrimitiveSerializer<MoneyBreakdownPaymentPurposeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'FULL_ORDER_PAYMENT': 'FULL_ORDER_PAYMENT',
    'NRPC_ASSURANCE_PAYMENT': 'NRPC_ASSURANCE_PAYMENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FULL_ORDER_PAYMENT': 'FULL_ORDER_PAYMENT',
    'NRPC_ASSURANCE_PAYMENT': 'NRPC_ASSURANCE_PAYMENT',
  };

  @override
  final Iterable<Type> types = const <Type>[MoneyBreakdownPaymentPurposeEnum];
  @override
  final String wireName = 'MoneyBreakdownPaymentPurposeEnum';

  @override
  Object serialize(
          Serializers serializers, MoneyBreakdownPaymentPurposeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MoneyBreakdownPaymentPurposeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MoneyBreakdownPaymentPurposeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MoneyBreakdownExcludesEnumSerializer
    implements PrimitiveSerializer<MoneyBreakdownExcludesEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VENDOR_COMMISSION': 'VENDOR_COMMISSION',
    'MERCHANT_WITHHOLDING': 'MERCHANT_WITHHOLDING',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VENDOR_COMMISSION': 'VENDOR_COMMISSION',
    'MERCHANT_WITHHOLDING': 'MERCHANT_WITHHOLDING',
  };

  @override
  final Iterable<Type> types = const <Type>[MoneyBreakdownExcludesEnum];
  @override
  final String wireName = 'MoneyBreakdownExcludesEnum';

  @override
  Object serialize(Serializers serializers, MoneyBreakdownExcludesEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MoneyBreakdownExcludesEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MoneyBreakdownExcludesEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MoneyBreakdown extends MoneyBreakdown {
  @override
  final MoneyBreakdownCurrencyEnum currency;
  @override
  final String calculationVersion;
  @override
  final MoneyBreakdownStatusEnum status;
  @override
  final int materialsGrossCentavos;
  @override
  final int vendorDiscountCentavos;
  @override
  final int materialsSubtotalCentavos;
  @override
  final int includedVatCentavos;
  @override
  final int vatExclusiveCentavos;
  @override
  final MoneyBreakdownVatTreatmentEnum vatTreatment;
  @override
  final MoneyDelivery delivery;
  @override
  final MoneyNrpc nrpc;
  @override
  final ProcessingFee processingFee;
  @override
  final int? commercialTotalCentavos;
  @override
  final int? amountDueOnlineCentavos;
  @override
  final int? onlinePrincipalCentavos;
  @override
  final int? physicalBalanceCentavos;
  @override
  final MoneyBreakdownPaymentPurposeEnum? paymentPurpose;
  @override
  final BuiltList<MoneyBreakdownExcludesEnum> excludes;

  factory _$MoneyBreakdown([void Function(MoneyBreakdownBuilder)? updates]) =>
      (MoneyBreakdownBuilder()..update(updates))._build();

  _$MoneyBreakdown._(
      {required this.currency,
      required this.calculationVersion,
      required this.status,
      required this.materialsGrossCentavos,
      required this.vendorDiscountCentavos,
      required this.materialsSubtotalCentavos,
      required this.includedVatCentavos,
      required this.vatExclusiveCentavos,
      required this.vatTreatment,
      required this.delivery,
      required this.nrpc,
      required this.processingFee,
      this.commercialTotalCentavos,
      this.amountDueOnlineCentavos,
      this.onlinePrincipalCentavos,
      this.physicalBalanceCentavos,
      this.paymentPurpose,
      required this.excludes})
      : super._();
  @override
  MoneyBreakdown rebuild(void Function(MoneyBreakdownBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MoneyBreakdownBuilder toBuilder() => MoneyBreakdownBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MoneyBreakdown &&
        currency == other.currency &&
        calculationVersion == other.calculationVersion &&
        status == other.status &&
        materialsGrossCentavos == other.materialsGrossCentavos &&
        vendorDiscountCentavos == other.vendorDiscountCentavos &&
        materialsSubtotalCentavos == other.materialsSubtotalCentavos &&
        includedVatCentavos == other.includedVatCentavos &&
        vatExclusiveCentavos == other.vatExclusiveCentavos &&
        vatTreatment == other.vatTreatment &&
        delivery == other.delivery &&
        nrpc == other.nrpc &&
        processingFee == other.processingFee &&
        commercialTotalCentavos == other.commercialTotalCentavos &&
        amountDueOnlineCentavos == other.amountDueOnlineCentavos &&
        onlinePrincipalCentavos == other.onlinePrincipalCentavos &&
        physicalBalanceCentavos == other.physicalBalanceCentavos &&
        paymentPurpose == other.paymentPurpose &&
        excludes == other.excludes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, calculationVersion.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, materialsGrossCentavos.hashCode);
    _$hash = $jc(_$hash, vendorDiscountCentavos.hashCode);
    _$hash = $jc(_$hash, materialsSubtotalCentavos.hashCode);
    _$hash = $jc(_$hash, includedVatCentavos.hashCode);
    _$hash = $jc(_$hash, vatExclusiveCentavos.hashCode);
    _$hash = $jc(_$hash, vatTreatment.hashCode);
    _$hash = $jc(_$hash, delivery.hashCode);
    _$hash = $jc(_$hash, nrpc.hashCode);
    _$hash = $jc(_$hash, processingFee.hashCode);
    _$hash = $jc(_$hash, commercialTotalCentavos.hashCode);
    _$hash = $jc(_$hash, amountDueOnlineCentavos.hashCode);
    _$hash = $jc(_$hash, onlinePrincipalCentavos.hashCode);
    _$hash = $jc(_$hash, physicalBalanceCentavos.hashCode);
    _$hash = $jc(_$hash, paymentPurpose.hashCode);
    _$hash = $jc(_$hash, excludes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MoneyBreakdown')
          ..add('currency', currency)
          ..add('calculationVersion', calculationVersion)
          ..add('status', status)
          ..add('materialsGrossCentavos', materialsGrossCentavos)
          ..add('vendorDiscountCentavos', vendorDiscountCentavos)
          ..add('materialsSubtotalCentavos', materialsSubtotalCentavos)
          ..add('includedVatCentavos', includedVatCentavos)
          ..add('vatExclusiveCentavos', vatExclusiveCentavos)
          ..add('vatTreatment', vatTreatment)
          ..add('delivery', delivery)
          ..add('nrpc', nrpc)
          ..add('processingFee', processingFee)
          ..add('commercialTotalCentavos', commercialTotalCentavos)
          ..add('amountDueOnlineCentavos', amountDueOnlineCentavos)
          ..add('onlinePrincipalCentavos', onlinePrincipalCentavos)
          ..add('physicalBalanceCentavos', physicalBalanceCentavos)
          ..add('paymentPurpose', paymentPurpose)
          ..add('excludes', excludes))
        .toString();
  }
}

class MoneyBreakdownBuilder
    implements Builder<MoneyBreakdown, MoneyBreakdownBuilder> {
  _$MoneyBreakdown? _$v;

  MoneyBreakdownCurrencyEnum? _currency;
  MoneyBreakdownCurrencyEnum? get currency => _$this._currency;
  set currency(MoneyBreakdownCurrencyEnum? currency) =>
      _$this._currency = currency;

  String? _calculationVersion;
  String? get calculationVersion => _$this._calculationVersion;
  set calculationVersion(String? calculationVersion) =>
      _$this._calculationVersion = calculationVersion;

  MoneyBreakdownStatusEnum? _status;
  MoneyBreakdownStatusEnum? get status => _$this._status;
  set status(MoneyBreakdownStatusEnum? status) => _$this._status = status;

  int? _materialsGrossCentavos;
  int? get materialsGrossCentavos => _$this._materialsGrossCentavos;
  set materialsGrossCentavos(int? materialsGrossCentavos) =>
      _$this._materialsGrossCentavos = materialsGrossCentavos;

  int? _vendorDiscountCentavos;
  int? get vendorDiscountCentavos => _$this._vendorDiscountCentavos;
  set vendorDiscountCentavos(int? vendorDiscountCentavos) =>
      _$this._vendorDiscountCentavos = vendorDiscountCentavos;

  int? _materialsSubtotalCentavos;
  int? get materialsSubtotalCentavos => _$this._materialsSubtotalCentavos;
  set materialsSubtotalCentavos(int? materialsSubtotalCentavos) =>
      _$this._materialsSubtotalCentavos = materialsSubtotalCentavos;

  int? _includedVatCentavos;
  int? get includedVatCentavos => _$this._includedVatCentavos;
  set includedVatCentavos(int? includedVatCentavos) =>
      _$this._includedVatCentavos = includedVatCentavos;

  int? _vatExclusiveCentavos;
  int? get vatExclusiveCentavos => _$this._vatExclusiveCentavos;
  set vatExclusiveCentavos(int? vatExclusiveCentavos) =>
      _$this._vatExclusiveCentavos = vatExclusiveCentavos;

  MoneyBreakdownVatTreatmentEnum? _vatTreatment;
  MoneyBreakdownVatTreatmentEnum? get vatTreatment => _$this._vatTreatment;
  set vatTreatment(MoneyBreakdownVatTreatmentEnum? vatTreatment) =>
      _$this._vatTreatment = vatTreatment;

  MoneyDeliveryBuilder? _delivery;
  MoneyDeliveryBuilder get delivery =>
      _$this._delivery ??= MoneyDeliveryBuilder();
  set delivery(MoneyDeliveryBuilder? delivery) => _$this._delivery = delivery;

  MoneyNrpcBuilder? _nrpc;
  MoneyNrpcBuilder get nrpc => _$this._nrpc ??= MoneyNrpcBuilder();
  set nrpc(MoneyNrpcBuilder? nrpc) => _$this._nrpc = nrpc;

  ProcessingFeeBuilder? _processingFee;
  ProcessingFeeBuilder get processingFee =>
      _$this._processingFee ??= ProcessingFeeBuilder();
  set processingFee(ProcessingFeeBuilder? processingFee) =>
      _$this._processingFee = processingFee;

  int? _commercialTotalCentavos;
  int? get commercialTotalCentavos => _$this._commercialTotalCentavos;
  set commercialTotalCentavos(int? commercialTotalCentavos) =>
      _$this._commercialTotalCentavos = commercialTotalCentavos;

  int? _amountDueOnlineCentavos;
  int? get amountDueOnlineCentavos => _$this._amountDueOnlineCentavos;
  set amountDueOnlineCentavos(int? amountDueOnlineCentavos) =>
      _$this._amountDueOnlineCentavos = amountDueOnlineCentavos;

  int? _onlinePrincipalCentavos;
  int? get onlinePrincipalCentavos => _$this._onlinePrincipalCentavos;
  set onlinePrincipalCentavos(int? onlinePrincipalCentavos) =>
      _$this._onlinePrincipalCentavos = onlinePrincipalCentavos;

  int? _physicalBalanceCentavos;
  int? get physicalBalanceCentavos => _$this._physicalBalanceCentavos;
  set physicalBalanceCentavos(int? physicalBalanceCentavos) =>
      _$this._physicalBalanceCentavos = physicalBalanceCentavos;

  MoneyBreakdownPaymentPurposeEnum? _paymentPurpose;
  MoneyBreakdownPaymentPurposeEnum? get paymentPurpose =>
      _$this._paymentPurpose;
  set paymentPurpose(MoneyBreakdownPaymentPurposeEnum? paymentPurpose) =>
      _$this._paymentPurpose = paymentPurpose;

  ListBuilder<MoneyBreakdownExcludesEnum>? _excludes;
  ListBuilder<MoneyBreakdownExcludesEnum> get excludes =>
      _$this._excludes ??= ListBuilder<MoneyBreakdownExcludesEnum>();
  set excludes(ListBuilder<MoneyBreakdownExcludesEnum>? excludes) =>
      _$this._excludes = excludes;

  MoneyBreakdownBuilder() {
    MoneyBreakdown._defaults(this);
  }

  MoneyBreakdownBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _calculationVersion = $v.calculationVersion;
      _status = $v.status;
      _materialsGrossCentavos = $v.materialsGrossCentavos;
      _vendorDiscountCentavos = $v.vendorDiscountCentavos;
      _materialsSubtotalCentavos = $v.materialsSubtotalCentavos;
      _includedVatCentavos = $v.includedVatCentavos;
      _vatExclusiveCentavos = $v.vatExclusiveCentavos;
      _vatTreatment = $v.vatTreatment;
      _delivery = $v.delivery.toBuilder();
      _nrpc = $v.nrpc.toBuilder();
      _processingFee = $v.processingFee.toBuilder();
      _commercialTotalCentavos = $v.commercialTotalCentavos;
      _amountDueOnlineCentavos = $v.amountDueOnlineCentavos;
      _onlinePrincipalCentavos = $v.onlinePrincipalCentavos;
      _physicalBalanceCentavos = $v.physicalBalanceCentavos;
      _paymentPurpose = $v.paymentPurpose;
      _excludes = $v.excludes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MoneyBreakdown other) {
    _$v = other as _$MoneyBreakdown;
  }

  @override
  void update(void Function(MoneyBreakdownBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MoneyBreakdown build() => _build();

  _$MoneyBreakdown _build() {
    _$MoneyBreakdown _$result;
    try {
      _$result = _$v ??
          _$MoneyBreakdown._(
            currency: BuiltValueNullFieldError.checkNotNull(
                currency, r'MoneyBreakdown', 'currency'),
            calculationVersion: BuiltValueNullFieldError.checkNotNull(
                calculationVersion, r'MoneyBreakdown', 'calculationVersion'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'MoneyBreakdown', 'status'),
            materialsGrossCentavos: BuiltValueNullFieldError.checkNotNull(
                materialsGrossCentavos,
                r'MoneyBreakdown',
                'materialsGrossCentavos'),
            vendorDiscountCentavos: BuiltValueNullFieldError.checkNotNull(
                vendorDiscountCentavos,
                r'MoneyBreakdown',
                'vendorDiscountCentavos'),
            materialsSubtotalCentavos: BuiltValueNullFieldError.checkNotNull(
                materialsSubtotalCentavos,
                r'MoneyBreakdown',
                'materialsSubtotalCentavos'),
            includedVatCentavos: BuiltValueNullFieldError.checkNotNull(
                includedVatCentavos, r'MoneyBreakdown', 'includedVatCentavos'),
            vatExclusiveCentavos: BuiltValueNullFieldError.checkNotNull(
                vatExclusiveCentavos,
                r'MoneyBreakdown',
                'vatExclusiveCentavos'),
            vatTreatment: BuiltValueNullFieldError.checkNotNull(
                vatTreatment, r'MoneyBreakdown', 'vatTreatment'),
            delivery: delivery.build(),
            nrpc: nrpc.build(),
            processingFee: processingFee.build(),
            commercialTotalCentavos: commercialTotalCentavos,
            amountDueOnlineCentavos: amountDueOnlineCentavos,
            onlinePrincipalCentavos: onlinePrincipalCentavos,
            physicalBalanceCentavos: physicalBalanceCentavos,
            paymentPurpose: paymentPurpose,
            excludes: excludes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'delivery';
        delivery.build();
        _$failedField = 'nrpc';
        nrpc.build();
        _$failedField = 'processingFee';
        processingFee.build();

        _$failedField = 'excludes';
        excludes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MoneyBreakdown', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
