// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_preset_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const InvoicePresetInputInvoiceTypeEnum
    _$invoicePresetInputInvoiceTypeEnum_VENDOR_GOODS_INVOICE =
    const InvoicePresetInputInvoiceTypeEnum._('VENDOR_GOODS_INVOICE');
const InvoicePresetInputInvoiceTypeEnum
    _$invoicePresetInputInvoiceTypeEnum_VENDOR_ADJUSTMENT_DOCUMENT =
    const InvoicePresetInputInvoiceTypeEnum._('VENDOR_ADJUSTMENT_DOCUMENT');

InvoicePresetInputInvoiceTypeEnum _$invoicePresetInputInvoiceTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'VENDOR_GOODS_INVOICE':
      return _$invoicePresetInputInvoiceTypeEnum_VENDOR_GOODS_INVOICE;
    case 'VENDOR_ADJUSTMENT_DOCUMENT':
      return _$invoicePresetInputInvoiceTypeEnum_VENDOR_ADJUSTMENT_DOCUMENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InvoicePresetInputInvoiceTypeEnum>
    _$invoicePresetInputInvoiceTypeEnumValues = BuiltSet<
        InvoicePresetInputInvoiceTypeEnum>(const <InvoicePresetInputInvoiceTypeEnum>[
  _$invoicePresetInputInvoiceTypeEnum_VENDOR_GOODS_INVOICE,
  _$invoicePresetInputInvoiceTypeEnum_VENDOR_ADJUSTMENT_DOCUMENT,
]);

const InvoicePresetInputSourceSystemEnum
    _$invoicePresetInputSourceSystemEnum_REGISTERED_CAS =
    const InvoicePresetInputSourceSystemEnum._('REGISTERED_CAS');
const InvoicePresetInputSourceSystemEnum
    _$invoicePresetInputSourceSystemEnum_BIR_EIS =
    const InvoicePresetInputSourceSystemEnum._('BIR_EIS');
const InvoicePresetInputSourceSystemEnum
    _$invoicePresetInputSourceSystemEnum_LOOSE_LEAF_OR_PRINTED =
    const InvoicePresetInputSourceSystemEnum._('LOOSE_LEAF_OR_PRINTED');
const InvoicePresetInputSourceSystemEnum
    _$invoicePresetInputSourceSystemEnum_OTHER_REGISTERED =
    const InvoicePresetInputSourceSystemEnum._('OTHER_REGISTERED');

InvoicePresetInputSourceSystemEnum _$invoicePresetInputSourceSystemEnumValueOf(
    String name) {
  switch (name) {
    case 'REGISTERED_CAS':
      return _$invoicePresetInputSourceSystemEnum_REGISTERED_CAS;
    case 'BIR_EIS':
      return _$invoicePresetInputSourceSystemEnum_BIR_EIS;
    case 'LOOSE_LEAF_OR_PRINTED':
      return _$invoicePresetInputSourceSystemEnum_LOOSE_LEAF_OR_PRINTED;
    case 'OTHER_REGISTERED':
      return _$invoicePresetInputSourceSystemEnum_OTHER_REGISTERED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InvoicePresetInputSourceSystemEnum>
    _$invoicePresetInputSourceSystemEnumValues = BuiltSet<
        InvoicePresetInputSourceSystemEnum>(const <InvoicePresetInputSourceSystemEnum>[
  _$invoicePresetInputSourceSystemEnum_REGISTERED_CAS,
  _$invoicePresetInputSourceSystemEnum_BIR_EIS,
  _$invoicePresetInputSourceSystemEnum_LOOSE_LEAF_OR_PRINTED,
  _$invoicePresetInputSourceSystemEnum_OTHER_REGISTERED,
]);

const InvoicePresetInputInvoicingMethodEnum
    _$invoicePresetInputInvoicingMethodEnum_ELECTRONIC =
    const InvoicePresetInputInvoicingMethodEnum._('ELECTRONIC');
const InvoicePresetInputInvoicingMethodEnum
    _$invoicePresetInputInvoicingMethodEnum_COMPUTERIZED =
    const InvoicePresetInputInvoicingMethodEnum._('COMPUTERIZED');
const InvoicePresetInputInvoicingMethodEnum
    _$invoicePresetInputInvoicingMethodEnum_MANUAL =
    const InvoicePresetInputInvoicingMethodEnum._('MANUAL');

InvoicePresetInputInvoicingMethodEnum
    _$invoicePresetInputInvoicingMethodEnumValueOf(String name) {
  switch (name) {
    case 'ELECTRONIC':
      return _$invoicePresetInputInvoicingMethodEnum_ELECTRONIC;
    case 'COMPUTERIZED':
      return _$invoicePresetInputInvoicingMethodEnum_COMPUTERIZED;
    case 'MANUAL':
      return _$invoicePresetInputInvoicingMethodEnum_MANUAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InvoicePresetInputInvoicingMethodEnum>
    _$invoicePresetInputInvoicingMethodEnumValues = BuiltSet<
        InvoicePresetInputInvoicingMethodEnum>(const <InvoicePresetInputInvoicingMethodEnum>[
  _$invoicePresetInputInvoicingMethodEnum_ELECTRONIC,
  _$invoicePresetInputInvoicingMethodEnum_COMPUTERIZED,
  _$invoicePresetInputInvoicingMethodEnum_MANUAL,
]);

Serializer<InvoicePresetInputInvoiceTypeEnum>
    _$invoicePresetInputInvoiceTypeEnumSerializer =
    _$InvoicePresetInputInvoiceTypeEnumSerializer();
Serializer<InvoicePresetInputSourceSystemEnum>
    _$invoicePresetInputSourceSystemEnumSerializer =
    _$InvoicePresetInputSourceSystemEnumSerializer();
Serializer<InvoicePresetInputInvoicingMethodEnum>
    _$invoicePresetInputInvoicingMethodEnumSerializer =
    _$InvoicePresetInputInvoicingMethodEnumSerializer();

class _$InvoicePresetInputInvoiceTypeEnumSerializer
    implements PrimitiveSerializer<InvoicePresetInputInvoiceTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VENDOR_GOODS_INVOICE': 'VENDOR_GOODS_INVOICE',
    'VENDOR_ADJUSTMENT_DOCUMENT': 'VENDOR_ADJUSTMENT_DOCUMENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VENDOR_GOODS_INVOICE': 'VENDOR_GOODS_INVOICE',
    'VENDOR_ADJUSTMENT_DOCUMENT': 'VENDOR_ADJUSTMENT_DOCUMENT',
  };

  @override
  final Iterable<Type> types = const <Type>[InvoicePresetInputInvoiceTypeEnum];
  @override
  final String wireName = 'InvoicePresetInputInvoiceTypeEnum';

  @override
  Object serialize(
          Serializers serializers, InvoicePresetInputInvoiceTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InvoicePresetInputInvoiceTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InvoicePresetInputInvoiceTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InvoicePresetInputSourceSystemEnumSerializer
    implements PrimitiveSerializer<InvoicePresetInputSourceSystemEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'REGISTERED_CAS': 'REGISTERED_CAS',
    'BIR_EIS': 'BIR_EIS',
    'LOOSE_LEAF_OR_PRINTED': 'LOOSE_LEAF_OR_PRINTED',
    'OTHER_REGISTERED': 'OTHER_REGISTERED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'REGISTERED_CAS': 'REGISTERED_CAS',
    'BIR_EIS': 'BIR_EIS',
    'LOOSE_LEAF_OR_PRINTED': 'LOOSE_LEAF_OR_PRINTED',
    'OTHER_REGISTERED': 'OTHER_REGISTERED',
  };

  @override
  final Iterable<Type> types = const <Type>[InvoicePresetInputSourceSystemEnum];
  @override
  final String wireName = 'InvoicePresetInputSourceSystemEnum';

  @override
  Object serialize(
          Serializers serializers, InvoicePresetInputSourceSystemEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InvoicePresetInputSourceSystemEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InvoicePresetInputSourceSystemEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InvoicePresetInputInvoicingMethodEnumSerializer
    implements PrimitiveSerializer<InvoicePresetInputInvoicingMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ELECTRONIC': 'ELECTRONIC',
    'COMPUTERIZED': 'COMPUTERIZED',
    'MANUAL': 'MANUAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ELECTRONIC': 'ELECTRONIC',
    'COMPUTERIZED': 'COMPUTERIZED',
    'MANUAL': 'MANUAL',
  };

  @override
  final Iterable<Type> types = const <Type>[
    InvoicePresetInputInvoicingMethodEnum
  ];
  @override
  final String wireName = 'InvoicePresetInputInvoicingMethodEnum';

  @override
  Object serialize(
          Serializers serializers, InvoicePresetInputInvoicingMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InvoicePresetInputInvoicingMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InvoicePresetInputInvoicingMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InvoicePresetInput extends InvoicePresetInput {
  @override
  final InvoicePresetInputInvoiceTypeEnum invoiceType;
  @override
  final String issuerName;
  @override
  final InvoicePresetInputSourceSystemEnum sourceSystem;
  @override
  final InvoicePresetInputInvoicingMethodEnum invoicingMethod;
  @override
  final int lockVersion;

  factory _$InvoicePresetInput(
          [void Function(InvoicePresetInputBuilder)? updates]) =>
      (InvoicePresetInputBuilder()..update(updates))._build();

  _$InvoicePresetInput._(
      {required this.invoiceType,
      required this.issuerName,
      required this.sourceSystem,
      required this.invoicingMethod,
      required this.lockVersion})
      : super._();
  @override
  InvoicePresetInput rebuild(
          void Function(InvoicePresetInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvoicePresetInputBuilder toBuilder() =>
      InvoicePresetInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvoicePresetInput &&
        invoiceType == other.invoiceType &&
        issuerName == other.issuerName &&
        sourceSystem == other.sourceSystem &&
        invoicingMethod == other.invoicingMethod &&
        lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, invoiceType.hashCode);
    _$hash = $jc(_$hash, issuerName.hashCode);
    _$hash = $jc(_$hash, sourceSystem.hashCode);
    _$hash = $jc(_$hash, invoicingMethod.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InvoicePresetInput')
          ..add('invoiceType', invoiceType)
          ..add('issuerName', issuerName)
          ..add('sourceSystem', sourceSystem)
          ..add('invoicingMethod', invoicingMethod)
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class InvoicePresetInputBuilder
    implements Builder<InvoicePresetInput, InvoicePresetInputBuilder> {
  _$InvoicePresetInput? _$v;

  InvoicePresetInputInvoiceTypeEnum? _invoiceType;
  InvoicePresetInputInvoiceTypeEnum? get invoiceType => _$this._invoiceType;
  set invoiceType(InvoicePresetInputInvoiceTypeEnum? invoiceType) =>
      _$this._invoiceType = invoiceType;

  String? _issuerName;
  String? get issuerName => _$this._issuerName;
  set issuerName(String? issuerName) => _$this._issuerName = issuerName;

  InvoicePresetInputSourceSystemEnum? _sourceSystem;
  InvoicePresetInputSourceSystemEnum? get sourceSystem => _$this._sourceSystem;
  set sourceSystem(InvoicePresetInputSourceSystemEnum? sourceSystem) =>
      _$this._sourceSystem = sourceSystem;

  InvoicePresetInputInvoicingMethodEnum? _invoicingMethod;
  InvoicePresetInputInvoicingMethodEnum? get invoicingMethod =>
      _$this._invoicingMethod;
  set invoicingMethod(InvoicePresetInputInvoicingMethodEnum? invoicingMethod) =>
      _$this._invoicingMethod = invoicingMethod;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  InvoicePresetInputBuilder() {
    InvoicePresetInput._defaults(this);
  }

  InvoicePresetInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _invoiceType = $v.invoiceType;
      _issuerName = $v.issuerName;
      _sourceSystem = $v.sourceSystem;
      _invoicingMethod = $v.invoicingMethod;
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InvoicePresetInput other) {
    _$v = other as _$InvoicePresetInput;
  }

  @override
  void update(void Function(InvoicePresetInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvoicePresetInput build() => _build();

  _$InvoicePresetInput _build() {
    final _$result = _$v ??
        _$InvoicePresetInput._(
          invoiceType: BuiltValueNullFieldError.checkNotNull(
              invoiceType, r'InvoicePresetInput', 'invoiceType'),
          issuerName: BuiltValueNullFieldError.checkNotNull(
              issuerName, r'InvoicePresetInput', 'issuerName'),
          sourceSystem: BuiltValueNullFieldError.checkNotNull(
              sourceSystem, r'InvoicePresetInput', 'sourceSystem'),
          invoicingMethod: BuiltValueNullFieldError.checkNotNull(
              invoicingMethod, r'InvoicePresetInput', 'invoicingMethod'),
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'InvoicePresetInput', 'lockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
