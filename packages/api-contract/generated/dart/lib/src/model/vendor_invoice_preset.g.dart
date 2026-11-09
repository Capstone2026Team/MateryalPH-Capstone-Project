// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_invoice_preset.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorInvoicePresetInvoiceTypeEnum
    _$vendorInvoicePresetInvoiceTypeEnum_VENDOR_GOODS_INVOICE =
    const VendorInvoicePresetInvoiceTypeEnum._('VENDOR_GOODS_INVOICE');
const VendorInvoicePresetInvoiceTypeEnum
    _$vendorInvoicePresetInvoiceTypeEnum_VENDOR_ADJUSTMENT_DOCUMENT =
    const VendorInvoicePresetInvoiceTypeEnum._('VENDOR_ADJUSTMENT_DOCUMENT');

VendorInvoicePresetInvoiceTypeEnum _$vendorInvoicePresetInvoiceTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'VENDOR_GOODS_INVOICE':
      return _$vendorInvoicePresetInvoiceTypeEnum_VENDOR_GOODS_INVOICE;
    case 'VENDOR_ADJUSTMENT_DOCUMENT':
      return _$vendorInvoicePresetInvoiceTypeEnum_VENDOR_ADJUSTMENT_DOCUMENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorInvoicePresetInvoiceTypeEnum>
    _$vendorInvoicePresetInvoiceTypeEnumValues = BuiltSet<
        VendorInvoicePresetInvoiceTypeEnum>(const <VendorInvoicePresetInvoiceTypeEnum>[
  _$vendorInvoicePresetInvoiceTypeEnum_VENDOR_GOODS_INVOICE,
  _$vendorInvoicePresetInvoiceTypeEnum_VENDOR_ADJUSTMENT_DOCUMENT,
]);

const VendorInvoicePresetSourceSystemEnum
    _$vendorInvoicePresetSourceSystemEnum_REGISTERED_CAS =
    const VendorInvoicePresetSourceSystemEnum._('REGISTERED_CAS');
const VendorInvoicePresetSourceSystemEnum
    _$vendorInvoicePresetSourceSystemEnum_BIR_EIS =
    const VendorInvoicePresetSourceSystemEnum._('BIR_EIS');
const VendorInvoicePresetSourceSystemEnum
    _$vendorInvoicePresetSourceSystemEnum_LOOSE_LEAF_OR_PRINTED =
    const VendorInvoicePresetSourceSystemEnum._('LOOSE_LEAF_OR_PRINTED');
const VendorInvoicePresetSourceSystemEnum
    _$vendorInvoicePresetSourceSystemEnum_OTHER_REGISTERED =
    const VendorInvoicePresetSourceSystemEnum._('OTHER_REGISTERED');

VendorInvoicePresetSourceSystemEnum
    _$vendorInvoicePresetSourceSystemEnumValueOf(String name) {
  switch (name) {
    case 'REGISTERED_CAS':
      return _$vendorInvoicePresetSourceSystemEnum_REGISTERED_CAS;
    case 'BIR_EIS':
      return _$vendorInvoicePresetSourceSystemEnum_BIR_EIS;
    case 'LOOSE_LEAF_OR_PRINTED':
      return _$vendorInvoicePresetSourceSystemEnum_LOOSE_LEAF_OR_PRINTED;
    case 'OTHER_REGISTERED':
      return _$vendorInvoicePresetSourceSystemEnum_OTHER_REGISTERED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorInvoicePresetSourceSystemEnum>
    _$vendorInvoicePresetSourceSystemEnumValues = BuiltSet<
        VendorInvoicePresetSourceSystemEnum>(const <VendorInvoicePresetSourceSystemEnum>[
  _$vendorInvoicePresetSourceSystemEnum_REGISTERED_CAS,
  _$vendorInvoicePresetSourceSystemEnum_BIR_EIS,
  _$vendorInvoicePresetSourceSystemEnum_LOOSE_LEAF_OR_PRINTED,
  _$vendorInvoicePresetSourceSystemEnum_OTHER_REGISTERED,
]);

const VendorInvoicePresetInvoicingMethodEnum
    _$vendorInvoicePresetInvoicingMethodEnum_ELECTRONIC =
    const VendorInvoicePresetInvoicingMethodEnum._('ELECTRONIC');
const VendorInvoicePresetInvoicingMethodEnum
    _$vendorInvoicePresetInvoicingMethodEnum_COMPUTERIZED =
    const VendorInvoicePresetInvoicingMethodEnum._('COMPUTERIZED');
const VendorInvoicePresetInvoicingMethodEnum
    _$vendorInvoicePresetInvoicingMethodEnum_MANUAL =
    const VendorInvoicePresetInvoicingMethodEnum._('MANUAL');

VendorInvoicePresetInvoicingMethodEnum
    _$vendorInvoicePresetInvoicingMethodEnumValueOf(String name) {
  switch (name) {
    case 'ELECTRONIC':
      return _$vendorInvoicePresetInvoicingMethodEnum_ELECTRONIC;
    case 'COMPUTERIZED':
      return _$vendorInvoicePresetInvoicingMethodEnum_COMPUTERIZED;
    case 'MANUAL':
      return _$vendorInvoicePresetInvoicingMethodEnum_MANUAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorInvoicePresetInvoicingMethodEnum>
    _$vendorInvoicePresetInvoicingMethodEnumValues = BuiltSet<
        VendorInvoicePresetInvoicingMethodEnum>(const <VendorInvoicePresetInvoicingMethodEnum>[
  _$vendorInvoicePresetInvoicingMethodEnum_ELECTRONIC,
  _$vendorInvoicePresetInvoicingMethodEnum_COMPUTERIZED,
  _$vendorInvoicePresetInvoicingMethodEnum_MANUAL,
]);

const VendorInvoicePresetDateModeEnum _$vendorInvoicePresetDateModeEnum_TODAY =
    const VendorInvoicePresetDateModeEnum._('TODAY');

VendorInvoicePresetDateModeEnum _$vendorInvoicePresetDateModeEnumValueOf(
    String name) {
  switch (name) {
    case 'TODAY':
      return _$vendorInvoicePresetDateModeEnum_TODAY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorInvoicePresetDateModeEnum>
    _$vendorInvoicePresetDateModeEnumValues = BuiltSet<
        VendorInvoicePresetDateModeEnum>(const <VendorInvoicePresetDateModeEnum>[
  _$vendorInvoicePresetDateModeEnum_TODAY,
]);

Serializer<VendorInvoicePresetInvoiceTypeEnum>
    _$vendorInvoicePresetInvoiceTypeEnumSerializer =
    _$VendorInvoicePresetInvoiceTypeEnumSerializer();
Serializer<VendorInvoicePresetSourceSystemEnum>
    _$vendorInvoicePresetSourceSystemEnumSerializer =
    _$VendorInvoicePresetSourceSystemEnumSerializer();
Serializer<VendorInvoicePresetInvoicingMethodEnum>
    _$vendorInvoicePresetInvoicingMethodEnumSerializer =
    _$VendorInvoicePresetInvoicingMethodEnumSerializer();
Serializer<VendorInvoicePresetDateModeEnum>
    _$vendorInvoicePresetDateModeEnumSerializer =
    _$VendorInvoicePresetDateModeEnumSerializer();

class _$VendorInvoicePresetInvoiceTypeEnumSerializer
    implements PrimitiveSerializer<VendorInvoicePresetInvoiceTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VENDOR_GOODS_INVOICE': 'VENDOR_GOODS_INVOICE',
    'VENDOR_ADJUSTMENT_DOCUMENT': 'VENDOR_ADJUSTMENT_DOCUMENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VENDOR_GOODS_INVOICE': 'VENDOR_GOODS_INVOICE',
    'VENDOR_ADJUSTMENT_DOCUMENT': 'VENDOR_ADJUSTMENT_DOCUMENT',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorInvoicePresetInvoiceTypeEnum];
  @override
  final String wireName = 'VendorInvoicePresetInvoiceTypeEnum';

  @override
  Object serialize(
          Serializers serializers, VendorInvoicePresetInvoiceTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorInvoicePresetInvoiceTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorInvoicePresetInvoiceTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorInvoicePresetSourceSystemEnumSerializer
    implements PrimitiveSerializer<VendorInvoicePresetSourceSystemEnum> {
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
  final Iterable<Type> types = const <Type>[
    VendorInvoicePresetSourceSystemEnum
  ];
  @override
  final String wireName = 'VendorInvoicePresetSourceSystemEnum';

  @override
  Object serialize(
          Serializers serializers, VendorInvoicePresetSourceSystemEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorInvoicePresetSourceSystemEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorInvoicePresetSourceSystemEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorInvoicePresetInvoicingMethodEnumSerializer
    implements PrimitiveSerializer<VendorInvoicePresetInvoicingMethodEnum> {
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
    VendorInvoicePresetInvoicingMethodEnum
  ];
  @override
  final String wireName = 'VendorInvoicePresetInvoicingMethodEnum';

  @override
  Object serialize(Serializers serializers,
          VendorInvoicePresetInvoicingMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorInvoicePresetInvoicingMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorInvoicePresetInvoicingMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorInvoicePresetDateModeEnumSerializer
    implements PrimitiveSerializer<VendorInvoicePresetDateModeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'TODAY': 'TODAY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TODAY': 'TODAY',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorInvoicePresetDateModeEnum];
  @override
  final String wireName = 'VendorInvoicePresetDateModeEnum';

  @override
  Object serialize(
          Serializers serializers, VendorInvoicePresetDateModeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorInvoicePresetDateModeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorInvoicePresetDateModeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorInvoicePreset extends VendorInvoicePreset {
  @override
  final VendorInvoicePresetInvoiceTypeEnum invoiceType;
  @override
  final String issuerName;
  @override
  final VendorInvoicePresetSourceSystemEnum sourceSystem;
  @override
  final VendorInvoicePresetInvoicingMethodEnum invoicingMethod;
  @override
  final int lockVersion;
  @override
  final VendorInvoicePresetDateModeEnum dateMode;

  factory _$VendorInvoicePreset(
          [void Function(VendorInvoicePresetBuilder)? updates]) =>
      (VendorInvoicePresetBuilder()..update(updates))._build();

  _$VendorInvoicePreset._(
      {required this.invoiceType,
      required this.issuerName,
      required this.sourceSystem,
      required this.invoicingMethod,
      required this.lockVersion,
      required this.dateMode})
      : super._();
  @override
  VendorInvoicePreset rebuild(
          void Function(VendorInvoicePresetBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorInvoicePresetBuilder toBuilder() =>
      VendorInvoicePresetBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorInvoicePreset &&
        invoiceType == other.invoiceType &&
        issuerName == other.issuerName &&
        sourceSystem == other.sourceSystem &&
        invoicingMethod == other.invoicingMethod &&
        lockVersion == other.lockVersion &&
        dateMode == other.dateMode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, invoiceType.hashCode);
    _$hash = $jc(_$hash, issuerName.hashCode);
    _$hash = $jc(_$hash, sourceSystem.hashCode);
    _$hash = $jc(_$hash, invoicingMethod.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, dateMode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorInvoicePreset')
          ..add('invoiceType', invoiceType)
          ..add('issuerName', issuerName)
          ..add('sourceSystem', sourceSystem)
          ..add('invoicingMethod', invoicingMethod)
          ..add('lockVersion', lockVersion)
          ..add('dateMode', dateMode))
        .toString();
  }
}

class VendorInvoicePresetBuilder
    implements Builder<VendorInvoicePreset, VendorInvoicePresetBuilder> {
  _$VendorInvoicePreset? _$v;

  VendorInvoicePresetInvoiceTypeEnum? _invoiceType;
  VendorInvoicePresetInvoiceTypeEnum? get invoiceType => _$this._invoiceType;
  set invoiceType(VendorInvoicePresetInvoiceTypeEnum? invoiceType) =>
      _$this._invoiceType = invoiceType;

  String? _issuerName;
  String? get issuerName => _$this._issuerName;
  set issuerName(String? issuerName) => _$this._issuerName = issuerName;

  VendorInvoicePresetSourceSystemEnum? _sourceSystem;
  VendorInvoicePresetSourceSystemEnum? get sourceSystem => _$this._sourceSystem;
  set sourceSystem(VendorInvoicePresetSourceSystemEnum? sourceSystem) =>
      _$this._sourceSystem = sourceSystem;

  VendorInvoicePresetInvoicingMethodEnum? _invoicingMethod;
  VendorInvoicePresetInvoicingMethodEnum? get invoicingMethod =>
      _$this._invoicingMethod;
  set invoicingMethod(
          VendorInvoicePresetInvoicingMethodEnum? invoicingMethod) =>
      _$this._invoicingMethod = invoicingMethod;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  VendorInvoicePresetDateModeEnum? _dateMode;
  VendorInvoicePresetDateModeEnum? get dateMode => _$this._dateMode;
  set dateMode(VendorInvoicePresetDateModeEnum? dateMode) =>
      _$this._dateMode = dateMode;

  VendorInvoicePresetBuilder() {
    VendorInvoicePreset._defaults(this);
  }

  VendorInvoicePresetBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _invoiceType = $v.invoiceType;
      _issuerName = $v.issuerName;
      _sourceSystem = $v.sourceSystem;
      _invoicingMethod = $v.invoicingMethod;
      _lockVersion = $v.lockVersion;
      _dateMode = $v.dateMode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorInvoicePreset other) {
    _$v = other as _$VendorInvoicePreset;
  }

  @override
  void update(void Function(VendorInvoicePresetBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorInvoicePreset build() => _build();

  _$VendorInvoicePreset _build() {
    final _$result = _$v ??
        _$VendorInvoicePreset._(
          invoiceType: BuiltValueNullFieldError.checkNotNull(
              invoiceType, r'VendorInvoicePreset', 'invoiceType'),
          issuerName: BuiltValueNullFieldError.checkNotNull(
              issuerName, r'VendorInvoicePreset', 'issuerName'),
          sourceSystem: BuiltValueNullFieldError.checkNotNull(
              sourceSystem, r'VendorInvoicePreset', 'sourceSystem'),
          invoicingMethod: BuiltValueNullFieldError.checkNotNull(
              invoicingMethod, r'VendorInvoicePreset', 'invoicingMethod'),
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'VendorInvoicePreset', 'lockVersion'),
          dateMode: BuiltValueNullFieldError.checkNotNull(
              dateMode, r'VendorInvoicePreset', 'dateMode'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
