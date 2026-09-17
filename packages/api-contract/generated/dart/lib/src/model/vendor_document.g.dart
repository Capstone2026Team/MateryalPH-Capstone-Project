// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_document.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorDocumentScanStateEnum _$vendorDocumentScanStateEnum_PENDING =
    const VendorDocumentScanStateEnum._('PENDING');
const VendorDocumentScanStateEnum _$vendorDocumentScanStateEnum_CLEAN =
    const VendorDocumentScanStateEnum._('CLEAN');
const VendorDocumentScanStateEnum _$vendorDocumentScanStateEnum_REJECTED =
    const VendorDocumentScanStateEnum._('REJECTED');

VendorDocumentScanStateEnum _$vendorDocumentScanStateEnumValueOf(String name) {
  switch (name) {
    case 'PENDING':
      return _$vendorDocumentScanStateEnum_PENDING;
    case 'CLEAN':
      return _$vendorDocumentScanStateEnum_CLEAN;
    case 'REJECTED':
      return _$vendorDocumentScanStateEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorDocumentScanStateEnum>
    _$vendorDocumentScanStateEnumValues =
    BuiltSet<VendorDocumentScanStateEnum>(const <VendorDocumentScanStateEnum>[
  _$vendorDocumentScanStateEnum_PENDING,
  _$vendorDocumentScanStateEnum_CLEAN,
  _$vendorDocumentScanStateEnum_REJECTED,
]);

Serializer<VendorDocumentScanStateEnum>
    _$vendorDocumentScanStateEnumSerializer =
    _$VendorDocumentScanStateEnumSerializer();

class _$VendorDocumentScanStateEnumSerializer
    implements PrimitiveSerializer<VendorDocumentScanStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING': 'PENDING',
    'CLEAN': 'CLEAN',
    'REJECTED': 'REJECTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING': 'PENDING',
    'CLEAN': 'CLEAN',
    'REJECTED': 'REJECTED',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorDocumentScanStateEnum];
  @override
  final String wireName = 'VendorDocumentScanStateEnum';

  @override
  Object serialize(Serializers serializers, VendorDocumentScanStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorDocumentScanStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorDocumentScanStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorDocument extends VendorDocument {
  @override
  final String id;
  @override
  final String requirementKey;
  @override
  final int version;
  @override
  final VendorDocumentScanStateEnum scanState;

  factory _$VendorDocument([void Function(VendorDocumentBuilder)? updates]) =>
      (VendorDocumentBuilder()..update(updates))._build();

  _$VendorDocument._(
      {required this.id,
      required this.requirementKey,
      required this.version,
      required this.scanState})
      : super._();
  @override
  VendorDocument rebuild(void Function(VendorDocumentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDocumentBuilder toBuilder() => VendorDocumentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDocument &&
        id == other.id &&
        requirementKey == other.requirementKey &&
        version == other.version &&
        scanState == other.scanState;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, requirementKey.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, scanState.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDocument')
          ..add('id', id)
          ..add('requirementKey', requirementKey)
          ..add('version', version)
          ..add('scanState', scanState))
        .toString();
  }
}

class VendorDocumentBuilder
    implements Builder<VendorDocument, VendorDocumentBuilder> {
  _$VendorDocument? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _requirementKey;
  String? get requirementKey => _$this._requirementKey;
  set requirementKey(String? requirementKey) =>
      _$this._requirementKey = requirementKey;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  VendorDocumentScanStateEnum? _scanState;
  VendorDocumentScanStateEnum? get scanState => _$this._scanState;
  set scanState(VendorDocumentScanStateEnum? scanState) =>
      _$this._scanState = scanState;

  VendorDocumentBuilder() {
    VendorDocument._defaults(this);
  }

  VendorDocumentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _requirementKey = $v.requirementKey;
      _version = $v.version;
      _scanState = $v.scanState;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDocument other) {
    _$v = other as _$VendorDocument;
  }

  @override
  void update(void Function(VendorDocumentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDocument build() => _build();

  _$VendorDocument _build() {
    final _$result = _$v ??
        _$VendorDocument._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'VendorDocument', 'id'),
          requirementKey: BuiltValueNullFieldError.checkNotNull(
              requirementKey, r'VendorDocument', 'requirementKey'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'VendorDocument', 'version'),
          scanState: BuiltValueNullFieldError.checkNotNull(
              scanState, r'VendorDocument', 'scanState'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
