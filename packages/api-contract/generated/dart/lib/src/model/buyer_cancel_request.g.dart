// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_cancel_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuyerCancelRequestReasonCodeEnum
    _$buyerCancelRequestReasonCodeEnum_CHANGE_OF_REQUIREMENT =
    const BuyerCancelRequestReasonCodeEnum._('CHANGE_OF_REQUIREMENT');
const BuyerCancelRequestReasonCodeEnum
    _$buyerCancelRequestReasonCodeEnum_DUPLICATE_ORDER =
    const BuyerCancelRequestReasonCodeEnum._('DUPLICATE_ORDER');
const BuyerCancelRequestReasonCodeEnum
    _$buyerCancelRequestReasonCodeEnum_BUDGET_CHANGE =
    const BuyerCancelRequestReasonCodeEnum._('BUDGET_CHANGE');
const BuyerCancelRequestReasonCodeEnum
    _$buyerCancelRequestReasonCodeEnum_PROJECT_DELAY =
    const BuyerCancelRequestReasonCodeEnum._('PROJECT_DELAY');
const BuyerCancelRequestReasonCodeEnum
    _$buyerCancelRequestReasonCodeEnum_SCHEDULE_CONFLICT =
    const BuyerCancelRequestReasonCodeEnum._('SCHEDULE_CONFLICT');
const BuyerCancelRequestReasonCodeEnum
    _$buyerCancelRequestReasonCodeEnum_VENDOR_AGREEMENT =
    const BuyerCancelRequestReasonCodeEnum._('VENDOR_AGREEMENT');
const BuyerCancelRequestReasonCodeEnum
    _$buyerCancelRequestReasonCodeEnum_OTHER =
    const BuyerCancelRequestReasonCodeEnum._('OTHER');

BuyerCancelRequestReasonCodeEnum _$buyerCancelRequestReasonCodeEnumValueOf(
    String name) {
  switch (name) {
    case 'CHANGE_OF_REQUIREMENT':
      return _$buyerCancelRequestReasonCodeEnum_CHANGE_OF_REQUIREMENT;
    case 'DUPLICATE_ORDER':
      return _$buyerCancelRequestReasonCodeEnum_DUPLICATE_ORDER;
    case 'BUDGET_CHANGE':
      return _$buyerCancelRequestReasonCodeEnum_BUDGET_CHANGE;
    case 'PROJECT_DELAY':
      return _$buyerCancelRequestReasonCodeEnum_PROJECT_DELAY;
    case 'SCHEDULE_CONFLICT':
      return _$buyerCancelRequestReasonCodeEnum_SCHEDULE_CONFLICT;
    case 'VENDOR_AGREEMENT':
      return _$buyerCancelRequestReasonCodeEnum_VENDOR_AGREEMENT;
    case 'OTHER':
      return _$buyerCancelRequestReasonCodeEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerCancelRequestReasonCodeEnum>
    _$buyerCancelRequestReasonCodeEnumValues = BuiltSet<
        BuyerCancelRequestReasonCodeEnum>(const <BuyerCancelRequestReasonCodeEnum>[
  _$buyerCancelRequestReasonCodeEnum_CHANGE_OF_REQUIREMENT,
  _$buyerCancelRequestReasonCodeEnum_DUPLICATE_ORDER,
  _$buyerCancelRequestReasonCodeEnum_BUDGET_CHANGE,
  _$buyerCancelRequestReasonCodeEnum_PROJECT_DELAY,
  _$buyerCancelRequestReasonCodeEnum_SCHEDULE_CONFLICT,
  _$buyerCancelRequestReasonCodeEnum_VENDOR_AGREEMENT,
  _$buyerCancelRequestReasonCodeEnum_OTHER,
]);

Serializer<BuyerCancelRequestReasonCodeEnum>
    _$buyerCancelRequestReasonCodeEnumSerializer =
    _$BuyerCancelRequestReasonCodeEnumSerializer();

class _$BuyerCancelRequestReasonCodeEnumSerializer
    implements PrimitiveSerializer<BuyerCancelRequestReasonCodeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CHANGE_OF_REQUIREMENT': 'CHANGE_OF_REQUIREMENT',
    'DUPLICATE_ORDER': 'DUPLICATE_ORDER',
    'BUDGET_CHANGE': 'BUDGET_CHANGE',
    'PROJECT_DELAY': 'PROJECT_DELAY',
    'SCHEDULE_CONFLICT': 'SCHEDULE_CONFLICT',
    'VENDOR_AGREEMENT': 'VENDOR_AGREEMENT',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CHANGE_OF_REQUIREMENT': 'CHANGE_OF_REQUIREMENT',
    'DUPLICATE_ORDER': 'DUPLICATE_ORDER',
    'BUDGET_CHANGE': 'BUDGET_CHANGE',
    'PROJECT_DELAY': 'PROJECT_DELAY',
    'SCHEDULE_CONFLICT': 'SCHEDULE_CONFLICT',
    'VENDOR_AGREEMENT': 'VENDOR_AGREEMENT',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[BuyerCancelRequestReasonCodeEnum];
  @override
  final String wireName = 'BuyerCancelRequestReasonCodeEnum';

  @override
  Object serialize(
          Serializers serializers, BuyerCancelRequestReasonCodeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerCancelRequestReasonCodeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerCancelRequestReasonCodeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerCancelRequest extends BuyerCancelRequest {
  @override
  final int lockVersion;
  @override
  final BuyerCancelRequestReasonCodeEnum? reasonCode;
  @override
  final String? reason;

  factory _$BuyerCancelRequest(
          [void Function(BuyerCancelRequestBuilder)? updates]) =>
      (BuyerCancelRequestBuilder()..update(updates))._build();

  _$BuyerCancelRequest._(
      {required this.lockVersion, this.reasonCode, this.reason})
      : super._();
  @override
  BuyerCancelRequest rebuild(
          void Function(BuyerCancelRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerCancelRequestBuilder toBuilder() =>
      BuyerCancelRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerCancelRequest &&
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
    return (newBuiltValueToStringHelper(r'BuyerCancelRequest')
          ..add('lockVersion', lockVersion)
          ..add('reasonCode', reasonCode)
          ..add('reason', reason))
        .toString();
  }
}

class BuyerCancelRequestBuilder
    implements Builder<BuyerCancelRequest, BuyerCancelRequestBuilder> {
  _$BuyerCancelRequest? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  BuyerCancelRequestReasonCodeEnum? _reasonCode;
  BuyerCancelRequestReasonCodeEnum? get reasonCode => _$this._reasonCode;
  set reasonCode(BuyerCancelRequestReasonCodeEnum? reasonCode) =>
      _$this._reasonCode = reasonCode;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  BuyerCancelRequestBuilder() {
    BuyerCancelRequest._defaults(this);
  }

  BuyerCancelRequestBuilder get _$this {
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
  void replace(BuyerCancelRequest other) {
    _$v = other as _$BuyerCancelRequest;
  }

  @override
  void update(void Function(BuyerCancelRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerCancelRequest build() => _build();

  _$BuyerCancelRequest _build() {
    final _$result = _$v ??
        _$BuyerCancelRequest._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'BuyerCancelRequest', 'lockVersion'),
          reasonCode: reasonCode,
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
