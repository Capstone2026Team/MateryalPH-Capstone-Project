// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_setup_complete.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorSetupCompleteCommissionTermsAcceptedEnum
    _$vendorSetupCompleteCommissionTermsAcceptedEnum_true_ =
    const VendorSetupCompleteCommissionTermsAcceptedEnum._('true_');

VendorSetupCompleteCommissionTermsAcceptedEnum
    _$vendorSetupCompleteCommissionTermsAcceptedEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$vendorSetupCompleteCommissionTermsAcceptedEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorSetupCompleteCommissionTermsAcceptedEnum>
    _$vendorSetupCompleteCommissionTermsAcceptedEnumValues = BuiltSet<
        VendorSetupCompleteCommissionTermsAcceptedEnum>(const <VendorSetupCompleteCommissionTermsAcceptedEnum>[
  _$vendorSetupCompleteCommissionTermsAcceptedEnum_true_,
]);

Serializer<VendorSetupCompleteCommissionTermsAcceptedEnum>
    _$vendorSetupCompleteCommissionTermsAcceptedEnumSerializer =
    _$VendorSetupCompleteCommissionTermsAcceptedEnumSerializer();

class _$VendorSetupCompleteCommissionTermsAcceptedEnumSerializer
    implements
        PrimitiveSerializer<VendorSetupCompleteCommissionTermsAcceptedEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorSetupCompleteCommissionTermsAcceptedEnum
  ];
  @override
  final String wireName = 'VendorSetupCompleteCommissionTermsAcceptedEnum';

  @override
  Object serialize(Serializers serializers,
          VendorSetupCompleteCommissionTermsAcceptedEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorSetupCompleteCommissionTermsAcceptedEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorSetupCompleteCommissionTermsAcceptedEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorSetupComplete extends VendorSetupComplete {
  @override
  final int organizationLockVersion;
  @override
  final VendorSetupCompleteCommissionTermsAcceptedEnum commissionTermsAccepted;

  factory _$VendorSetupComplete(
          [void Function(VendorSetupCompleteBuilder)? updates]) =>
      (VendorSetupCompleteBuilder()..update(updates))._build();

  _$VendorSetupComplete._(
      {required this.organizationLockVersion,
      required this.commissionTermsAccepted})
      : super._();
  @override
  VendorSetupComplete rebuild(
          void Function(VendorSetupCompleteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorSetupCompleteBuilder toBuilder() =>
      VendorSetupCompleteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorSetupComplete &&
        organizationLockVersion == other.organizationLockVersion &&
        commissionTermsAccepted == other.commissionTermsAccepted;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, organizationLockVersion.hashCode);
    _$hash = $jc(_$hash, commissionTermsAccepted.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorSetupComplete')
          ..add('organizationLockVersion', organizationLockVersion)
          ..add('commissionTermsAccepted', commissionTermsAccepted))
        .toString();
  }
}

class VendorSetupCompleteBuilder
    implements Builder<VendorSetupComplete, VendorSetupCompleteBuilder> {
  _$VendorSetupComplete? _$v;

  int? _organizationLockVersion;
  int? get organizationLockVersion => _$this._organizationLockVersion;
  set organizationLockVersion(int? organizationLockVersion) =>
      _$this._organizationLockVersion = organizationLockVersion;

  VendorSetupCompleteCommissionTermsAcceptedEnum? _commissionTermsAccepted;
  VendorSetupCompleteCommissionTermsAcceptedEnum? get commissionTermsAccepted =>
      _$this._commissionTermsAccepted;
  set commissionTermsAccepted(
          VendorSetupCompleteCommissionTermsAcceptedEnum?
              commissionTermsAccepted) =>
      _$this._commissionTermsAccepted = commissionTermsAccepted;

  VendorSetupCompleteBuilder() {
    VendorSetupComplete._defaults(this);
  }

  VendorSetupCompleteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _organizationLockVersion = $v.organizationLockVersion;
      _commissionTermsAccepted = $v.commissionTermsAccepted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorSetupComplete other) {
    _$v = other as _$VendorSetupComplete;
  }

  @override
  void update(void Function(VendorSetupCompleteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorSetupComplete build() => _build();

  _$VendorSetupComplete _build() {
    final _$result = _$v ??
        _$VendorSetupComplete._(
          organizationLockVersion: BuiltValueNullFieldError.checkNotNull(
              organizationLockVersion,
              r'VendorSetupComplete',
              'organizationLockVersion'),
          commissionTermsAccepted: BuiltValueNullFieldError.checkNotNull(
              commissionTermsAccepted,
              r'VendorSetupComplete',
              'commissionTermsAccepted'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
