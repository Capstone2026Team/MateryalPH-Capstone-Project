// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_account_deletion_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuyerAccountDeletionRequestConfirmationEnum
    _$buyerAccountDeletionRequestConfirmationEnum_DELETE =
    const BuyerAccountDeletionRequestConfirmationEnum._('DELETE');

BuyerAccountDeletionRequestConfirmationEnum
    _$buyerAccountDeletionRequestConfirmationEnumValueOf(String name) {
  switch (name) {
    case 'DELETE':
      return _$buyerAccountDeletionRequestConfirmationEnum_DELETE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerAccountDeletionRequestConfirmationEnum>
    _$buyerAccountDeletionRequestConfirmationEnumValues = BuiltSet<
        BuyerAccountDeletionRequestConfirmationEnum>(const <BuyerAccountDeletionRequestConfirmationEnum>[
  _$buyerAccountDeletionRequestConfirmationEnum_DELETE,
]);

Serializer<BuyerAccountDeletionRequestConfirmationEnum>
    _$buyerAccountDeletionRequestConfirmationEnumSerializer =
    _$BuyerAccountDeletionRequestConfirmationEnumSerializer();

class _$BuyerAccountDeletionRequestConfirmationEnumSerializer
    implements
        PrimitiveSerializer<BuyerAccountDeletionRequestConfirmationEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DELETE': 'DELETE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DELETE': 'DELETE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    BuyerAccountDeletionRequestConfirmationEnum
  ];
  @override
  final String wireName = 'BuyerAccountDeletionRequestConfirmationEnum';

  @override
  Object serialize(Serializers serializers,
          BuyerAccountDeletionRequestConfirmationEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerAccountDeletionRequestConfirmationEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerAccountDeletionRequestConfirmationEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerAccountDeletionRequest extends BuyerAccountDeletionRequest {
  @override
  final BuyerAccountDeletionRequestConfirmationEnum confirmation;

  factory _$BuyerAccountDeletionRequest(
          [void Function(BuyerAccountDeletionRequestBuilder)? updates]) =>
      (BuyerAccountDeletionRequestBuilder()..update(updates))._build();

  _$BuyerAccountDeletionRequest._({required this.confirmation}) : super._();
  @override
  BuyerAccountDeletionRequest rebuild(
          void Function(BuyerAccountDeletionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerAccountDeletionRequestBuilder toBuilder() =>
      BuyerAccountDeletionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerAccountDeletionRequest &&
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
    return (newBuiltValueToStringHelper(r'BuyerAccountDeletionRequest')
          ..add('confirmation', confirmation))
        .toString();
  }
}

class BuyerAccountDeletionRequestBuilder
    implements
        Builder<BuyerAccountDeletionRequest,
            BuyerAccountDeletionRequestBuilder> {
  _$BuyerAccountDeletionRequest? _$v;

  BuyerAccountDeletionRequestConfirmationEnum? _confirmation;
  BuyerAccountDeletionRequestConfirmationEnum? get confirmation =>
      _$this._confirmation;
  set confirmation(BuyerAccountDeletionRequestConfirmationEnum? confirmation) =>
      _$this._confirmation = confirmation;

  BuyerAccountDeletionRequestBuilder() {
    BuyerAccountDeletionRequest._defaults(this);
  }

  BuyerAccountDeletionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _confirmation = $v.confirmation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerAccountDeletionRequest other) {
    _$v = other as _$BuyerAccountDeletionRequest;
  }

  @override
  void update(void Function(BuyerAccountDeletionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerAccountDeletionRequest build() => _build();

  _$BuyerAccountDeletionRequest _build() {
    final _$result = _$v ??
        _$BuyerAccountDeletionRequest._(
          confirmation: BuiltValueNullFieldError.checkNotNull(
              confirmation, r'BuyerAccountDeletionRequest', 'confirmation'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
