// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_account_deletion_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorAccountDeletionRequestConfirmationEnum
    _$vendorAccountDeletionRequestConfirmationEnum_DELETE =
    const VendorAccountDeletionRequestConfirmationEnum._('DELETE');

VendorAccountDeletionRequestConfirmationEnum
    _$vendorAccountDeletionRequestConfirmationEnumValueOf(String name) {
  switch (name) {
    case 'DELETE':
      return _$vendorAccountDeletionRequestConfirmationEnum_DELETE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorAccountDeletionRequestConfirmationEnum>
    _$vendorAccountDeletionRequestConfirmationEnumValues = BuiltSet<
        VendorAccountDeletionRequestConfirmationEnum>(const <VendorAccountDeletionRequestConfirmationEnum>[
  _$vendorAccountDeletionRequestConfirmationEnum_DELETE,
]);

Serializer<VendorAccountDeletionRequestConfirmationEnum>
    _$vendorAccountDeletionRequestConfirmationEnumSerializer =
    _$VendorAccountDeletionRequestConfirmationEnumSerializer();

class _$VendorAccountDeletionRequestConfirmationEnumSerializer
    implements
        PrimitiveSerializer<VendorAccountDeletionRequestConfirmationEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DELETE': 'DELETE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DELETE': 'DELETE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorAccountDeletionRequestConfirmationEnum
  ];
  @override
  final String wireName = 'VendorAccountDeletionRequestConfirmationEnum';

  @override
  Object serialize(Serializers serializers,
          VendorAccountDeletionRequestConfirmationEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorAccountDeletionRequestConfirmationEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorAccountDeletionRequestConfirmationEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorAccountDeletionRequest extends VendorAccountDeletionRequest {
  @override
  final VendorAccountDeletionRequestConfirmationEnum confirmation;

  factory _$VendorAccountDeletionRequest(
          [void Function(VendorAccountDeletionRequestBuilder)? updates]) =>
      (VendorAccountDeletionRequestBuilder()..update(updates))._build();

  _$VendorAccountDeletionRequest._({required this.confirmation}) : super._();
  @override
  VendorAccountDeletionRequest rebuild(
          void Function(VendorAccountDeletionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorAccountDeletionRequestBuilder toBuilder() =>
      VendorAccountDeletionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorAccountDeletionRequest &&
        confirmation == other.confirmation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, confirmation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorAccountDeletionRequest')
          ..add('confirmation', confirmation))
        .toString();
  }
}

class VendorAccountDeletionRequestBuilder
    implements
        Builder<VendorAccountDeletionRequest,
            VendorAccountDeletionRequestBuilder> {
  _$VendorAccountDeletionRequest? _$v;

  VendorAccountDeletionRequestConfirmationEnum? _confirmation;
  VendorAccountDeletionRequestConfirmationEnum? get confirmation =>
      _$this._confirmation;
  set confirmation(
          VendorAccountDeletionRequestConfirmationEnum? confirmation) =>
      _$this._confirmation = confirmation;

  VendorAccountDeletionRequestBuilder() {
    VendorAccountDeletionRequest._defaults(this);
  }

  VendorAccountDeletionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _confirmation = $v.confirmation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorAccountDeletionRequest other) {
    _$v = other as _$VendorAccountDeletionRequest;
  }

  @override
  void update(void Function(VendorAccountDeletionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorAccountDeletionRequest build() => _build();

  _$VendorAccountDeletionRequest _build() {
    final _$result = _$v ??
        _$VendorAccountDeletionRequest._(
          confirmation: BuiltValueNullFieldError.checkNotNull(
              confirmation, r'VendorAccountDeletionRequest', 'confirmation'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
