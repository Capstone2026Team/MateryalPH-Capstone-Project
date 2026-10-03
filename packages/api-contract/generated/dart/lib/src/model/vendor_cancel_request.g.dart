// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_cancel_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorCancelRequestReasonCodeEnum
    _$vendorCancelRequestReasonCodeEnum_STOCK_FAILURE =
    const VendorCancelRequestReasonCodeEnum._('STOCK_FAILURE');
const VendorCancelRequestReasonCodeEnum
    _$vendorCancelRequestReasonCodeEnum_OPERATIONAL_INABILITY =
    const VendorCancelRequestReasonCodeEnum._('OPERATIONAL_INABILITY');
const VendorCancelRequestReasonCodeEnum
    _$vendorCancelRequestReasonCodeEnum_DELIVERY_INABILITY =
    const VendorCancelRequestReasonCodeEnum._('DELIVERY_INABILITY');
const VendorCancelRequestReasonCodeEnum
    _$vendorCancelRequestReasonCodeEnum_COMPLIANCE_RESTRICTION =
    const VendorCancelRequestReasonCodeEnum._('COMPLIANCE_RESTRICTION');
const VendorCancelRequestReasonCodeEnum
    _$vendorCancelRequestReasonCodeEnum_ACCOUNT_RESTRICTION =
    const VendorCancelRequestReasonCodeEnum._('ACCOUNT_RESTRICTION');
const VendorCancelRequestReasonCodeEnum
    _$vendorCancelRequestReasonCodeEnum_BUYER_AGREEMENT =
    const VendorCancelRequestReasonCodeEnum._('BUYER_AGREEMENT');
const VendorCancelRequestReasonCodeEnum
    _$vendorCancelRequestReasonCodeEnum_OTHER =
    const VendorCancelRequestReasonCodeEnum._('OTHER');

VendorCancelRequestReasonCodeEnum _$vendorCancelRequestReasonCodeEnumValueOf(
    String name) {
  switch (name) {
    case 'STOCK_FAILURE':
      return _$vendorCancelRequestReasonCodeEnum_STOCK_FAILURE;
    case 'OPERATIONAL_INABILITY':
      return _$vendorCancelRequestReasonCodeEnum_OPERATIONAL_INABILITY;
    case 'DELIVERY_INABILITY':
      return _$vendorCancelRequestReasonCodeEnum_DELIVERY_INABILITY;
    case 'COMPLIANCE_RESTRICTION':
      return _$vendorCancelRequestReasonCodeEnum_COMPLIANCE_RESTRICTION;
    case 'ACCOUNT_RESTRICTION':
      return _$vendorCancelRequestReasonCodeEnum_ACCOUNT_RESTRICTION;
    case 'BUYER_AGREEMENT':
      return _$vendorCancelRequestReasonCodeEnum_BUYER_AGREEMENT;
    case 'OTHER':
      return _$vendorCancelRequestReasonCodeEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorCancelRequestReasonCodeEnum>
    _$vendorCancelRequestReasonCodeEnumValues = BuiltSet<
        VendorCancelRequestReasonCodeEnum>(const <VendorCancelRequestReasonCodeEnum>[
  _$vendorCancelRequestReasonCodeEnum_STOCK_FAILURE,
  _$vendorCancelRequestReasonCodeEnum_OPERATIONAL_INABILITY,
  _$vendorCancelRequestReasonCodeEnum_DELIVERY_INABILITY,
  _$vendorCancelRequestReasonCodeEnum_COMPLIANCE_RESTRICTION,
  _$vendorCancelRequestReasonCodeEnum_ACCOUNT_RESTRICTION,
  _$vendorCancelRequestReasonCodeEnum_BUYER_AGREEMENT,
  _$vendorCancelRequestReasonCodeEnum_OTHER,
]);

Serializer<VendorCancelRequestReasonCodeEnum>
    _$vendorCancelRequestReasonCodeEnumSerializer =
    _$VendorCancelRequestReasonCodeEnumSerializer();

class _$VendorCancelRequestReasonCodeEnumSerializer
    implements PrimitiveSerializer<VendorCancelRequestReasonCodeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'STOCK_FAILURE': 'STOCK_FAILURE',
    'OPERATIONAL_INABILITY': 'OPERATIONAL_INABILITY',
    'DELIVERY_INABILITY': 'DELIVERY_INABILITY',
    'COMPLIANCE_RESTRICTION': 'COMPLIANCE_RESTRICTION',
    'ACCOUNT_RESTRICTION': 'ACCOUNT_RESTRICTION',
    'BUYER_AGREEMENT': 'BUYER_AGREEMENT',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'STOCK_FAILURE': 'STOCK_FAILURE',
    'OPERATIONAL_INABILITY': 'OPERATIONAL_INABILITY',
    'DELIVERY_INABILITY': 'DELIVERY_INABILITY',
    'COMPLIANCE_RESTRICTION': 'COMPLIANCE_RESTRICTION',
    'ACCOUNT_RESTRICTION': 'ACCOUNT_RESTRICTION',
    'BUYER_AGREEMENT': 'BUYER_AGREEMENT',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorCancelRequestReasonCodeEnum];
  @override
  final String wireName = 'VendorCancelRequestReasonCodeEnum';

  @override
  Object serialize(
          Serializers serializers, VendorCancelRequestReasonCodeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorCancelRequestReasonCodeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorCancelRequestReasonCodeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorCancelRequest extends VendorCancelRequest {
  @override
  final int lockVersion;
  @override
  final VendorCancelRequestReasonCodeEnum reasonCode;
  @override
  final String reason;

  factory _$VendorCancelRequest(
          [void Function(VendorCancelRequestBuilder)? updates]) =>
      (VendorCancelRequestBuilder()..update(updates))._build();

  _$VendorCancelRequest._(
      {required this.lockVersion,
      required this.reasonCode,
      required this.reason})
      : super._();
  @override
  VendorCancelRequest rebuild(
          void Function(VendorCancelRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorCancelRequestBuilder toBuilder() =>
      VendorCancelRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorCancelRequest &&
        lockVersion == other.lockVersion &&
        reasonCode == other.reasonCode &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, reasonCode.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorCancelRequest')
          ..add('lockVersion', lockVersion)
          ..add('reasonCode', reasonCode)
          ..add('reason', reason))
        .toString();
  }
}

class VendorCancelRequestBuilder
    implements Builder<VendorCancelRequest, VendorCancelRequestBuilder> {
  _$VendorCancelRequest? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  VendorCancelRequestReasonCodeEnum? _reasonCode;
  VendorCancelRequestReasonCodeEnum? get reasonCode => _$this._reasonCode;
  set reasonCode(VendorCancelRequestReasonCodeEnum? reasonCode) =>
      _$this._reasonCode = reasonCode;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  VendorCancelRequestBuilder() {
    VendorCancelRequest._defaults(this);
  }

  VendorCancelRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _reasonCode = $v.reasonCode;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorCancelRequest other) {
    _$v = other as _$VendorCancelRequest;
  }

  @override
  void update(void Function(VendorCancelRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorCancelRequest build() => _build();

  _$VendorCancelRequest _build() {
    final _$result = _$v ??
        _$VendorCancelRequest._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'VendorCancelRequest', 'lockVersion'),
          reasonCode: BuiltValueNullFieldError.checkNotNull(
              reasonCode, r'VendorCancelRequest', 'reasonCode'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'VendorCancelRequest', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
