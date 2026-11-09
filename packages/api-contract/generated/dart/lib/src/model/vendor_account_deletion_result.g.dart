// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_account_deletion_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorAccountDeletionResultSignInRequiredEnum
    _$vendorAccountDeletionResultSignInRequiredEnum_true_ =
    const VendorAccountDeletionResultSignInRequiredEnum._('true_');

VendorAccountDeletionResultSignInRequiredEnum
    _$vendorAccountDeletionResultSignInRequiredEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$vendorAccountDeletionResultSignInRequiredEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorAccountDeletionResultSignInRequiredEnum>
    _$vendorAccountDeletionResultSignInRequiredEnumValues = BuiltSet<
        VendorAccountDeletionResultSignInRequiredEnum>(const <VendorAccountDeletionResultSignInRequiredEnum>[
  _$vendorAccountDeletionResultSignInRequiredEnum_true_,
]);

Serializer<VendorAccountDeletionResultSignInRequiredEnum>
    _$vendorAccountDeletionResultSignInRequiredEnumSerializer =
    _$VendorAccountDeletionResultSignInRequiredEnumSerializer();

class _$VendorAccountDeletionResultSignInRequiredEnumSerializer
    implements
        PrimitiveSerializer<VendorAccountDeletionResultSignInRequiredEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorAccountDeletionResultSignInRequiredEnum
  ];
  @override
  final String wireName = 'VendorAccountDeletionResultSignInRequiredEnum';

  @override
  Object serialize(Serializers serializers,
          VendorAccountDeletionResultSignInRequiredEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorAccountDeletionResultSignInRequiredEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorAccountDeletionResultSignInRequiredEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorAccountDeletionResult extends VendorAccountDeletionResult {
  @override
  final String reference;
  @override
  final DateTime deletedAt;
  @override
  final VendorAccountDeletionResultSignInRequiredEnum signInRequired;

  factory _$VendorAccountDeletionResult(
          [void Function(VendorAccountDeletionResultBuilder)? updates]) =>
      (VendorAccountDeletionResultBuilder()..update(updates))._build();

  _$VendorAccountDeletionResult._(
      {required this.reference,
      required this.deletedAt,
      required this.signInRequired})
      : super._();
  @override
  VendorAccountDeletionResult rebuild(
          void Function(VendorAccountDeletionResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorAccountDeletionResultBuilder toBuilder() =>
      VendorAccountDeletionResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorAccountDeletionResult &&
        reference == other.reference &&
        deletedAt == other.deletedAt &&
        signInRequired == other.signInRequired;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, deletedAt.hashCode);
    _$hash = $jc(_$hash, signInRequired.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorAccountDeletionResult')
          ..add('reference', reference)
          ..add('deletedAt', deletedAt)
          ..add('signInRequired', signInRequired))
        .toString();
  }
}

class VendorAccountDeletionResultBuilder
    implements
        Builder<VendorAccountDeletionResult,
            VendorAccountDeletionResultBuilder> {
  _$VendorAccountDeletionResult? _$v;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  DateTime? _deletedAt;
  DateTime? get deletedAt => _$this._deletedAt;
  set deletedAt(DateTime? deletedAt) => _$this._deletedAt = deletedAt;

  VendorAccountDeletionResultSignInRequiredEnum? _signInRequired;
  VendorAccountDeletionResultSignInRequiredEnum? get signInRequired =>
      _$this._signInRequired;
  set signInRequired(
          VendorAccountDeletionResultSignInRequiredEnum? signInRequired) =>
      _$this._signInRequired = signInRequired;

  VendorAccountDeletionResultBuilder() {
    VendorAccountDeletionResult._defaults(this);
  }

  VendorAccountDeletionResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reference = $v.reference;
      _deletedAt = $v.deletedAt;
      _signInRequired = $v.signInRequired;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorAccountDeletionResult other) {
    _$v = other as _$VendorAccountDeletionResult;
  }

  @override
  void update(void Function(VendorAccountDeletionResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorAccountDeletionResult build() => _build();

  _$VendorAccountDeletionResult _build() {
    final _$result = _$v ??
        _$VendorAccountDeletionResult._(
          reference: BuiltValueNullFieldError.checkNotNull(
              reference, r'VendorAccountDeletionResult', 'reference'),
          deletedAt: BuiltValueNullFieldError.checkNotNull(
              deletedAt, r'VendorAccountDeletionResult', 'deletedAt'),
          signInRequired: BuiltValueNullFieldError.checkNotNull(
              signInRequired, r'VendorAccountDeletionResult', 'signInRequired'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
