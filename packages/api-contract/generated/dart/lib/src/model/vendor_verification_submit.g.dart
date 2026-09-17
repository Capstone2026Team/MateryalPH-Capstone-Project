// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_verification_submit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorVerificationSubmitPrivacyAcknowledgedEnum
    _$vendorVerificationSubmitPrivacyAcknowledgedEnum_true_ =
    const VendorVerificationSubmitPrivacyAcknowledgedEnum._('true_');

VendorVerificationSubmitPrivacyAcknowledgedEnum
    _$vendorVerificationSubmitPrivacyAcknowledgedEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$vendorVerificationSubmitPrivacyAcknowledgedEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorVerificationSubmitPrivacyAcknowledgedEnum>
    _$vendorVerificationSubmitPrivacyAcknowledgedEnumValues = BuiltSet<
        VendorVerificationSubmitPrivacyAcknowledgedEnum>(const <VendorVerificationSubmitPrivacyAcknowledgedEnum>[
  _$vendorVerificationSubmitPrivacyAcknowledgedEnum_true_,
]);

Serializer<VendorVerificationSubmitPrivacyAcknowledgedEnum>
    _$vendorVerificationSubmitPrivacyAcknowledgedEnumSerializer =
    _$VendorVerificationSubmitPrivacyAcknowledgedEnumSerializer();

class _$VendorVerificationSubmitPrivacyAcknowledgedEnumSerializer
    implements
        PrimitiveSerializer<VendorVerificationSubmitPrivacyAcknowledgedEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorVerificationSubmitPrivacyAcknowledgedEnum
  ];
  @override
  final String wireName = 'VendorVerificationSubmitPrivacyAcknowledgedEnum';

  @override
  Object serialize(Serializers serializers,
          VendorVerificationSubmitPrivacyAcknowledgedEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorVerificationSubmitPrivacyAcknowledgedEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorVerificationSubmitPrivacyAcknowledgedEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorVerificationSubmit extends VendorVerificationSubmit {
  @override
  final int lockVersion;
  @override
  final VendorVerificationSubmitPrivacyAcknowledgedEnum privacyAcknowledged;

  factory _$VendorVerificationSubmit(
          [void Function(VendorVerificationSubmitBuilder)? updates]) =>
      (VendorVerificationSubmitBuilder()..update(updates))._build();

  _$VendorVerificationSubmit._(
      {required this.lockVersion, required this.privacyAcknowledged})
      : super._();
  @override
  VendorVerificationSubmit rebuild(
          void Function(VendorVerificationSubmitBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorVerificationSubmitBuilder toBuilder() =>
      VendorVerificationSubmitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorVerificationSubmit &&
        lockVersion == other.lockVersion &&
        privacyAcknowledged == other.privacyAcknowledged;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, privacyAcknowledged.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorVerificationSubmit')
          ..add('lockVersion', lockVersion)
          ..add('privacyAcknowledged', privacyAcknowledged))
        .toString();
  }
}

class VendorVerificationSubmitBuilder
    implements
        Builder<VendorVerificationSubmit, VendorVerificationSubmitBuilder> {
  _$VendorVerificationSubmit? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  VendorVerificationSubmitPrivacyAcknowledgedEnum? _privacyAcknowledged;
  VendorVerificationSubmitPrivacyAcknowledgedEnum? get privacyAcknowledged =>
      _$this._privacyAcknowledged;
  set privacyAcknowledged(
          VendorVerificationSubmitPrivacyAcknowledgedEnum?
              privacyAcknowledged) =>
      _$this._privacyAcknowledged = privacyAcknowledged;

  VendorVerificationSubmitBuilder() {
    VendorVerificationSubmit._defaults(this);
  }

  VendorVerificationSubmitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _privacyAcknowledged = $v.privacyAcknowledged;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorVerificationSubmit other) {
    _$v = other as _$VendorVerificationSubmit;
  }

  @override
  void update(void Function(VendorVerificationSubmitBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorVerificationSubmit build() => _build();

  _$VendorVerificationSubmit _build() {
    final _$result = _$v ??
        _$VendorVerificationSubmit._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'VendorVerificationSubmit', 'lockVersion'),
          privacyAcknowledged: BuiltValueNullFieldError.checkNotNull(
              privacyAcknowledged,
              r'VendorVerificationSubmit',
              'privacyAcknowledged'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
