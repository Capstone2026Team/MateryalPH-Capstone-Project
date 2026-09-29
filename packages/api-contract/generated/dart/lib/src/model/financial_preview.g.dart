// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_preview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FinancialPreviewCurrencyEnum _$financialPreviewCurrencyEnum_PHP =
    const FinancialPreviewCurrencyEnum._('PHP');

FinancialPreviewCurrencyEnum _$financialPreviewCurrencyEnumValueOf(
    String name) {
  switch (name) {
    case 'PHP':
      return _$financialPreviewCurrencyEnum_PHP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FinancialPreviewCurrencyEnum>
    _$financialPreviewCurrencyEnumValues =
    BuiltSet<FinancialPreviewCurrencyEnum>(const <FinancialPreviewCurrencyEnum>[
  _$financialPreviewCurrencyEnum_PHP,
]);

const FinancialPreviewVatTreatmentEnum
    _$financialPreviewVatTreatmentEnum_PRICES_INCLUDE_VAT =
    const FinancialPreviewVatTreatmentEnum._('PRICES_INCLUDE_VAT');
const FinancialPreviewVatTreatmentEnum
    _$financialPreviewVatTreatmentEnum_NO_INCLUDED_VAT =
    const FinancialPreviewVatTreatmentEnum._('NO_INCLUDED_VAT');

FinancialPreviewVatTreatmentEnum _$financialPreviewVatTreatmentEnumValueOf(
    String name) {
  switch (name) {
    case 'PRICES_INCLUDE_VAT':
      return _$financialPreviewVatTreatmentEnum_PRICES_INCLUDE_VAT;
    case 'NO_INCLUDED_VAT':
      return _$financialPreviewVatTreatmentEnum_NO_INCLUDED_VAT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FinancialPreviewVatTreatmentEnum>
    _$financialPreviewVatTreatmentEnumValues = BuiltSet<
        FinancialPreviewVatTreatmentEnum>(const <FinancialPreviewVatTreatmentEnum>[
  _$financialPreviewVatTreatmentEnum_PRICES_INCLUDE_VAT,
  _$financialPreviewVatTreatmentEnum_NO_INCLUDED_VAT,
]);

const FinancialPreviewExcludesEnum
    _$financialPreviewExcludesEnum_VENDOR_COMMISSION =
    const FinancialPreviewExcludesEnum._('VENDOR_COMMISSION');
const FinancialPreviewExcludesEnum
    _$financialPreviewExcludesEnum_MERCHANT_WITHHOLDING =
    const FinancialPreviewExcludesEnum._('MERCHANT_WITHHOLDING');

FinancialPreviewExcludesEnum _$financialPreviewExcludesEnumValueOf(
    String name) {
  switch (name) {
    case 'VENDOR_COMMISSION':
      return _$financialPreviewExcludesEnum_VENDOR_COMMISSION;
    case 'MERCHANT_WITHHOLDING':
      return _$financialPreviewExcludesEnum_MERCHANT_WITHHOLDING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FinancialPreviewExcludesEnum>
    _$financialPreviewExcludesEnumValues =
    BuiltSet<FinancialPreviewExcludesEnum>(const <FinancialPreviewExcludesEnum>[
  _$financialPreviewExcludesEnum_VENDOR_COMMISSION,
  _$financialPreviewExcludesEnum_MERCHANT_WITHHOLDING,
]);

const FinancialPreviewStatusEnum
    _$financialPreviewStatusEnum_ADVISORY_UNTIL_VENDOR_CONFIRMATION =
    const FinancialPreviewStatusEnum._('ADVISORY_UNTIL_VENDOR_CONFIRMATION');

FinancialPreviewStatusEnum _$financialPreviewStatusEnumValueOf(String name) {
  switch (name) {
    case 'ADVISORY_UNTIL_VENDOR_CONFIRMATION':
      return _$financialPreviewStatusEnum_ADVISORY_UNTIL_VENDOR_CONFIRMATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FinancialPreviewStatusEnum> _$financialPreviewStatusEnumValues =
    BuiltSet<FinancialPreviewStatusEnum>(const <FinancialPreviewStatusEnum>[
  _$financialPreviewStatusEnum_ADVISORY_UNTIL_VENDOR_CONFIRMATION,
]);

Serializer<FinancialPreviewCurrencyEnum>
    _$financialPreviewCurrencyEnumSerializer =
    _$FinancialPreviewCurrencyEnumSerializer();
Serializer<FinancialPreviewVatTreatmentEnum>
    _$financialPreviewVatTreatmentEnumSerializer =
    _$FinancialPreviewVatTreatmentEnumSerializer();
Serializer<FinancialPreviewExcludesEnum>
    _$financialPreviewExcludesEnumSerializer =
    _$FinancialPreviewExcludesEnumSerializer();
Serializer<FinancialPreviewStatusEnum> _$financialPreviewStatusEnumSerializer =
    _$FinancialPreviewStatusEnumSerializer();

class _$FinancialPreviewCurrencyEnumSerializer
    implements PrimitiveSerializer<FinancialPreviewCurrencyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PHP': 'PHP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PHP': 'PHP',
  };

  @override
  final Iterable<Type> types = const <Type>[FinancialPreviewCurrencyEnum];
  @override
  final String wireName = 'FinancialPreviewCurrencyEnum';

  @override
  Object serialize(Serializers serializers, FinancialPreviewCurrencyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FinancialPreviewCurrencyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FinancialPreviewCurrencyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FinancialPreviewVatTreatmentEnumSerializer
    implements PrimitiveSerializer<FinancialPreviewVatTreatmentEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PRICES_INCLUDE_VAT': 'PRICES_INCLUDE_VAT',
    'NO_INCLUDED_VAT': 'NO_INCLUDED_VAT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PRICES_INCLUDE_VAT': 'PRICES_INCLUDE_VAT',
    'NO_INCLUDED_VAT': 'NO_INCLUDED_VAT',
  };

  @override
  final Iterable<Type> types = const <Type>[FinancialPreviewVatTreatmentEnum];
  @override
  final String wireName = 'FinancialPreviewVatTreatmentEnum';

  @override
  Object serialize(
          Serializers serializers, FinancialPreviewVatTreatmentEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FinancialPreviewVatTreatmentEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FinancialPreviewVatTreatmentEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FinancialPreviewExcludesEnumSerializer
    implements PrimitiveSerializer<FinancialPreviewExcludesEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VENDOR_COMMISSION': 'VENDOR_COMMISSION',
    'MERCHANT_WITHHOLDING': 'MERCHANT_WITHHOLDING',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VENDOR_COMMISSION': 'VENDOR_COMMISSION',
    'MERCHANT_WITHHOLDING': 'MERCHANT_WITHHOLDING',
  };

  @override
  final Iterable<Type> types = const <Type>[FinancialPreviewExcludesEnum];
  @override
  final String wireName = 'FinancialPreviewExcludesEnum';

  @override
  Object serialize(Serializers serializers, FinancialPreviewExcludesEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FinancialPreviewExcludesEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FinancialPreviewExcludesEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FinancialPreviewStatusEnumSerializer
    implements PrimitiveSerializer<FinancialPreviewStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ADVISORY_UNTIL_VENDOR_CONFIRMATION': 'ADVISORY_UNTIL_VENDOR_CONFIRMATION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ADVISORY_UNTIL_VENDOR_CONFIRMATION': 'ADVISORY_UNTIL_VENDOR_CONFIRMATION',
  };

  @override
  final Iterable<Type> types = const <Type>[FinancialPreviewStatusEnum];
  @override
  final String wireName = 'FinancialPreviewStatusEnum';

  @override
  Object serialize(Serializers serializers, FinancialPreviewStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FinancialPreviewStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FinancialPreviewStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FinancialPreview extends FinancialPreview {
  @override
  final FinancialPreviewCurrencyEnum currency;
  @override
  final String calculationVersion;
  @override
  final BuiltList<FinancialPreviewLine> lines;
  @override
  final int materialsSubtotalCentavos;
  @override
  final int includedVatCentavos;
  @override
  final int vatExclusiveMaterialsCentavos;
  @override
  final FinancialPreviewVatTreatmentEnum vatTreatment;
  @override
  final DeliveryAmount delivery;
  @override
  final ProcessingFeeAmount processingFee;
  @override
  final int? totalBeforeProcessingMinCentavos;
  @override
  final int? totalBeforeProcessingMaxCentavos;
  @override
  final BuiltList<FinancialPreviewExcludesEnum> excludes;
  @override
  final FinancialPreviewStatusEnum status;

  factory _$FinancialPreview(
          [void Function(FinancialPreviewBuilder)? updates]) =>
      (FinancialPreviewBuilder()..update(updates))._build();

  _$FinancialPreview._(
      {required this.currency,
      required this.calculationVersion,
      required this.lines,
      required this.materialsSubtotalCentavos,
      required this.includedVatCentavos,
      required this.vatExclusiveMaterialsCentavos,
      required this.vatTreatment,
      required this.delivery,
      required this.processingFee,
      this.totalBeforeProcessingMinCentavos,
      this.totalBeforeProcessingMaxCentavos,
      required this.excludes,
      required this.status})
      : super._();
  @override
  FinancialPreview rebuild(void Function(FinancialPreviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FinancialPreviewBuilder toBuilder() =>
      FinancialPreviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FinancialPreview &&
        currency == other.currency &&
        calculationVersion == other.calculationVersion &&
        lines == other.lines &&
        materialsSubtotalCentavos == other.materialsSubtotalCentavos &&
        includedVatCentavos == other.includedVatCentavos &&
        vatExclusiveMaterialsCentavos == other.vatExclusiveMaterialsCentavos &&
        vatTreatment == other.vatTreatment &&
        delivery == other.delivery &&
        processingFee == other.processingFee &&
        totalBeforeProcessingMinCentavos ==
            other.totalBeforeProcessingMinCentavos &&
        totalBeforeProcessingMaxCentavos ==
            other.totalBeforeProcessingMaxCentavos &&
        excludes == other.excludes &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, calculationVersion.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, materialsSubtotalCentavos.hashCode);
    _$hash = $jc(_$hash, includedVatCentavos.hashCode);
    _$hash = $jc(_$hash, vatExclusiveMaterialsCentavos.hashCode);
    _$hash = $jc(_$hash, vatTreatment.hashCode);
    _$hash = $jc(_$hash, delivery.hashCode);
    _$hash = $jc(_$hash, processingFee.hashCode);
    _$hash = $jc(_$hash, totalBeforeProcessingMinCentavos.hashCode);
    _$hash = $jc(_$hash, totalBeforeProcessingMaxCentavos.hashCode);
    _$hash = $jc(_$hash, excludes.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FinancialPreview')
          ..add('currency', currency)
          ..add('calculationVersion', calculationVersion)
          ..add('lines', lines)
          ..add('materialsSubtotalCentavos', materialsSubtotalCentavos)
          ..add('includedVatCentavos', includedVatCentavos)
          ..add('vatExclusiveMaterialsCentavos', vatExclusiveMaterialsCentavos)
          ..add('vatTreatment', vatTreatment)
          ..add('delivery', delivery)
          ..add('processingFee', processingFee)
          ..add('totalBeforeProcessingMinCentavos',
              totalBeforeProcessingMinCentavos)
          ..add('totalBeforeProcessingMaxCentavos',
              totalBeforeProcessingMaxCentavos)
          ..add('excludes', excludes)
          ..add('status', status))
        .toString();
  }
}

class FinancialPreviewBuilder
    implements Builder<FinancialPreview, FinancialPreviewBuilder> {
  _$FinancialPreview? _$v;

  FinancialPreviewCurrencyEnum? _currency;
  FinancialPreviewCurrencyEnum? get currency => _$this._currency;
  set currency(FinancialPreviewCurrencyEnum? currency) =>
      _$this._currency = currency;

  String? _calculationVersion;
  String? get calculationVersion => _$this._calculationVersion;
  set calculationVersion(String? calculationVersion) =>
      _$this._calculationVersion = calculationVersion;

  ListBuilder<FinancialPreviewLine>? _lines;
  ListBuilder<FinancialPreviewLine> get lines =>
      _$this._lines ??= ListBuilder<FinancialPreviewLine>();
  set lines(ListBuilder<FinancialPreviewLine>? lines) => _$this._lines = lines;

  int? _materialsSubtotalCentavos;
  int? get materialsSubtotalCentavos => _$this._materialsSubtotalCentavos;
  set materialsSubtotalCentavos(int? materialsSubtotalCentavos) =>
      _$this._materialsSubtotalCentavos = materialsSubtotalCentavos;

  int? _includedVatCentavos;
  int? get includedVatCentavos => _$this._includedVatCentavos;
  set includedVatCentavos(int? includedVatCentavos) =>
      _$this._includedVatCentavos = includedVatCentavos;

  int? _vatExclusiveMaterialsCentavos;
  int? get vatExclusiveMaterialsCentavos =>
      _$this._vatExclusiveMaterialsCentavos;
  set vatExclusiveMaterialsCentavos(int? vatExclusiveMaterialsCentavos) =>
      _$this._vatExclusiveMaterialsCentavos = vatExclusiveMaterialsCentavos;

  FinancialPreviewVatTreatmentEnum? _vatTreatment;
  FinancialPreviewVatTreatmentEnum? get vatTreatment => _$this._vatTreatment;
  set vatTreatment(FinancialPreviewVatTreatmentEnum? vatTreatment) =>
      _$this._vatTreatment = vatTreatment;

  DeliveryAmountBuilder? _delivery;
  DeliveryAmountBuilder get delivery =>
      _$this._delivery ??= DeliveryAmountBuilder();
  set delivery(DeliveryAmountBuilder? delivery) => _$this._delivery = delivery;

  ProcessingFeeAmountBuilder? _processingFee;
  ProcessingFeeAmountBuilder get processingFee =>
      _$this._processingFee ??= ProcessingFeeAmountBuilder();
  set processingFee(ProcessingFeeAmountBuilder? processingFee) =>
      _$this._processingFee = processingFee;

  int? _totalBeforeProcessingMinCentavos;
  int? get totalBeforeProcessingMinCentavos =>
      _$this._totalBeforeProcessingMinCentavos;
  set totalBeforeProcessingMinCentavos(int? totalBeforeProcessingMinCentavos) =>
      _$this._totalBeforeProcessingMinCentavos =
          totalBeforeProcessingMinCentavos;

  int? _totalBeforeProcessingMaxCentavos;
  int? get totalBeforeProcessingMaxCentavos =>
      _$this._totalBeforeProcessingMaxCentavos;
  set totalBeforeProcessingMaxCentavos(int? totalBeforeProcessingMaxCentavos) =>
      _$this._totalBeforeProcessingMaxCentavos =
          totalBeforeProcessingMaxCentavos;

  ListBuilder<FinancialPreviewExcludesEnum>? _excludes;
  ListBuilder<FinancialPreviewExcludesEnum> get excludes =>
      _$this._excludes ??= ListBuilder<FinancialPreviewExcludesEnum>();
  set excludes(ListBuilder<FinancialPreviewExcludesEnum>? excludes) =>
      _$this._excludes = excludes;

  FinancialPreviewStatusEnum? _status;
  FinancialPreviewStatusEnum? get status => _$this._status;
  set status(FinancialPreviewStatusEnum? status) => _$this._status = status;

  FinancialPreviewBuilder() {
    FinancialPreview._defaults(this);
  }

  FinancialPreviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _calculationVersion = $v.calculationVersion;
      _lines = $v.lines.toBuilder();
      _materialsSubtotalCentavos = $v.materialsSubtotalCentavos;
      _includedVatCentavos = $v.includedVatCentavos;
      _vatExclusiveMaterialsCentavos = $v.vatExclusiveMaterialsCentavos;
      _vatTreatment = $v.vatTreatment;
      _delivery = $v.delivery.toBuilder();
      _processingFee = $v.processingFee.toBuilder();
      _totalBeforeProcessingMinCentavos = $v.totalBeforeProcessingMinCentavos;
      _totalBeforeProcessingMaxCentavos = $v.totalBeforeProcessingMaxCentavos;
      _excludes = $v.excludes.toBuilder();
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FinancialPreview other) {
    _$v = other as _$FinancialPreview;
  }

  @override
  void update(void Function(FinancialPreviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FinancialPreview build() => _build();

  _$FinancialPreview _build() {
    _$FinancialPreview _$result;
    try {
      _$result = _$v ??
          _$FinancialPreview._(
            currency: BuiltValueNullFieldError.checkNotNull(
                currency, r'FinancialPreview', 'currency'),
            calculationVersion: BuiltValueNullFieldError.checkNotNull(
                calculationVersion, r'FinancialPreview', 'calculationVersion'),
            lines: lines.build(),
            materialsSubtotalCentavos: BuiltValueNullFieldError.checkNotNull(
                materialsSubtotalCentavos,
                r'FinancialPreview',
                'materialsSubtotalCentavos'),
            includedVatCentavos: BuiltValueNullFieldError.checkNotNull(
                includedVatCentavos,
                r'FinancialPreview',
                'includedVatCentavos'),
            vatExclusiveMaterialsCentavos:
                BuiltValueNullFieldError.checkNotNull(
                    vatExclusiveMaterialsCentavos,
                    r'FinancialPreview',
                    'vatExclusiveMaterialsCentavos'),
            vatTreatment: BuiltValueNullFieldError.checkNotNull(
                vatTreatment, r'FinancialPreview', 'vatTreatment'),
            delivery: delivery.build(),
            processingFee: processingFee.build(),
            totalBeforeProcessingMinCentavos: totalBeforeProcessingMinCentavos,
            totalBeforeProcessingMaxCentavos: totalBeforeProcessingMaxCentavos,
            excludes: excludes.build(),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'FinancialPreview', 'status'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();

        _$failedField = 'delivery';
        delivery.build();
        _$failedField = 'processingFee';
        processingFee.build();

        _$failedField = 'excludes';
        excludes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FinancialPreview', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
