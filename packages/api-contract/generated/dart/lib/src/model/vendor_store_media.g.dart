// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_store_media.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorStoreMediaKindEnum _$vendorStoreMediaKindEnum_LOGO =
    const VendorStoreMediaKindEnum._('LOGO');
const VendorStoreMediaKindEnum _$vendorStoreMediaKindEnum_BANNER =
    const VendorStoreMediaKindEnum._('BANNER');
const VendorStoreMediaKindEnum _$vendorStoreMediaKindEnum_PROMOTIONAL =
    const VendorStoreMediaKindEnum._('PROMOTIONAL');

VendorStoreMediaKindEnum _$vendorStoreMediaKindEnumValueOf(String name) {
  switch (name) {
    case 'LOGO':
      return _$vendorStoreMediaKindEnum_LOGO;
    case 'BANNER':
      return _$vendorStoreMediaKindEnum_BANNER;
    case 'PROMOTIONAL':
      return _$vendorStoreMediaKindEnum_PROMOTIONAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorStoreMediaKindEnum> _$vendorStoreMediaKindEnumValues =
    BuiltSet<VendorStoreMediaKindEnum>(const <VendorStoreMediaKindEnum>[
  _$vendorStoreMediaKindEnum_LOGO,
  _$vendorStoreMediaKindEnum_BANNER,
  _$vendorStoreMediaKindEnum_PROMOTIONAL,
]);

Serializer<VendorStoreMediaKindEnum> _$vendorStoreMediaKindEnumSerializer =
    _$VendorStoreMediaKindEnumSerializer();

class _$VendorStoreMediaKindEnumSerializer
    implements PrimitiveSerializer<VendorStoreMediaKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'LOGO': 'LOGO',
    'BANNER': 'BANNER',
    'PROMOTIONAL': 'PROMOTIONAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'LOGO': 'LOGO',
    'BANNER': 'BANNER',
    'PROMOTIONAL': 'PROMOTIONAL',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorStoreMediaKindEnum];
  @override
  final String wireName = 'VendorStoreMediaKindEnum';

  @override
  Object serialize(Serializers serializers, VendorStoreMediaKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorStoreMediaKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorStoreMediaKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorStoreMedia extends VendorStoreMedia {
  @override
  final String id;
  @override
  final VendorStoreMediaKindEnum kind;
  @override
  final String altText;
  @override
  final String reviewStatus;
  @override
  final String scanState;

  factory _$VendorStoreMedia(
          [void Function(VendorStoreMediaBuilder)? updates]) =>
      (VendorStoreMediaBuilder()..update(updates))._build();

  _$VendorStoreMedia._(
      {required this.id,
      required this.kind,
      required this.altText,
      required this.reviewStatus,
      required this.scanState})
      : super._();
  @override
  VendorStoreMedia rebuild(void Function(VendorStoreMediaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorStoreMediaBuilder toBuilder() =>
      VendorStoreMediaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorStoreMedia &&
        id == other.id &&
        kind == other.kind &&
        altText == other.altText &&
        reviewStatus == other.reviewStatus &&
        scanState == other.scanState;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, altText.hashCode);
    _$hash = $jc(_$hash, reviewStatus.hashCode);
    _$hash = $jc(_$hash, scanState.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorStoreMedia')
          ..add('id', id)
          ..add('kind', kind)
          ..add('altText', altText)
          ..add('reviewStatus', reviewStatus)
          ..add('scanState', scanState))
        .toString();
  }
}

class VendorStoreMediaBuilder
    implements Builder<VendorStoreMedia, VendorStoreMediaBuilder> {
  _$VendorStoreMedia? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  VendorStoreMediaKindEnum? _kind;
  VendorStoreMediaKindEnum? get kind => _$this._kind;
  set kind(VendorStoreMediaKindEnum? kind) => _$this._kind = kind;

  String? _altText;
  String? get altText => _$this._altText;
  set altText(String? altText) => _$this._altText = altText;

  String? _reviewStatus;
  String? get reviewStatus => _$this._reviewStatus;
  set reviewStatus(String? reviewStatus) => _$this._reviewStatus = reviewStatus;

  String? _scanState;
  String? get scanState => _$this._scanState;
  set scanState(String? scanState) => _$this._scanState = scanState;

  VendorStoreMediaBuilder() {
    VendorStoreMedia._defaults(this);
  }

  VendorStoreMediaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _kind = $v.kind;
      _altText = $v.altText;
      _reviewStatus = $v.reviewStatus;
      _scanState = $v.scanState;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorStoreMedia other) {
    _$v = other as _$VendorStoreMedia;
  }

  @override
  void update(void Function(VendorStoreMediaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorStoreMedia build() => _build();

  _$VendorStoreMedia _build() {
    final _$result = _$v ??
        _$VendorStoreMedia._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'VendorStoreMedia', 'id'),
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'VendorStoreMedia', 'kind'),
          altText: BuiltValueNullFieldError.checkNotNull(
              altText, r'VendorStoreMedia', 'altText'),
          reviewStatus: BuiltValueNullFieldError.checkNotNull(
              reviewStatus, r'VendorStoreMedia', 'reviewStatus'),
          scanState: BuiltValueNullFieldError.checkNotNull(
              scanState, r'VendorStoreMedia', 'scanState'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
