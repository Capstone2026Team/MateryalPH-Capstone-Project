// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_commission_acceptance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorCommissionAcceptanceAcceptedEnum
    _$vendorCommissionAcceptanceAcceptedEnum_true_ =
    const VendorCommissionAcceptanceAcceptedEnum._('true_');

VendorCommissionAcceptanceAcceptedEnum
    _$vendorCommissionAcceptanceAcceptedEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$vendorCommissionAcceptanceAcceptedEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorCommissionAcceptanceAcceptedEnum>
    _$vendorCommissionAcceptanceAcceptedEnumValues = BuiltSet<
        VendorCommissionAcceptanceAcceptedEnum>(const <VendorCommissionAcceptanceAcceptedEnum>[
  _$vendorCommissionAcceptanceAcceptedEnum_true_,
]);

Serializer<VendorCommissionAcceptanceAcceptedEnum>
    _$vendorCommissionAcceptanceAcceptedEnumSerializer =
    _$VendorCommissionAcceptanceAcceptedEnumSerializer();

class _$VendorCommissionAcceptanceAcceptedEnumSerializer
    implements PrimitiveSerializer<VendorCommissionAcceptanceAcceptedEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorCommissionAcceptanceAcceptedEnum
  ];
  @override
  final String wireName = 'VendorCommissionAcceptanceAcceptedEnum';

  @override
  Object serialize(Serializers serializers,
          VendorCommissionAcceptanceAcceptedEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorCommissionAcceptanceAcceptedEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorCommissionAcceptanceAcceptedEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorCommissionAcceptance extends VendorCommissionAcceptance {
  @override
  final int organizationLockVersion;
  @override
  final String agreementVersionId;
  @override
  final VendorCommissionAcceptanceAcceptedEnum accepted;

  factory _$VendorCommissionAcceptance(
          [void Function(VendorCommissionAcceptanceBuilder)? updates]) =>
      (VendorCommissionAcceptanceBuilder()..update(updates))._build();

  _$VendorCommissionAcceptance._(
      {required this.organizationLockVersion,
      required this.agreementVersionId,
      required this.accepted})
      : super._();
  @override
  VendorCommissionAcceptance rebuild(
          void Function(VendorCommissionAcceptanceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorCommissionAcceptanceBuilder toBuilder() =>
      VendorCommissionAcceptanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorCommissionAcceptance &&
        organizationLockVersion == other.organizationLockVersion &&
        agreementVersionId == other.agreementVersionId &&
        accepted == other.accepted;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, organizationLockVersion.hashCode);
    _$hash = $jc(_$hash, agreementVersionId.hashCode);
    _$hash = $jc(_$hash, accepted.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorCommissionAcceptance')
          ..add('organizationLockVersion', organizationLockVersion)
          ..add('agreementVersionId', agreementVersionId)
          ..add('accepted', accepted))
        .toString();
  }
}

class VendorCommissionAcceptanceBuilder
    implements
        Builder<VendorCommissionAcceptance, VendorCommissionAcceptanceBuilder> {
  _$VendorCommissionAcceptance? _$v;

  int? _organizationLockVersion;
  int? get organizationLockVersion => _$this._organizationLockVersion;
  set organizationLockVersion(int? organizationLockVersion) =>
      _$this._organizationLockVersion = organizationLockVersion;

  String? _agreementVersionId;
  String? get agreementVersionId => _$this._agreementVersionId;
  set agreementVersionId(String? agreementVersionId) =>
      _$this._agreementVersionId = agreementVersionId;

  VendorCommissionAcceptanceAcceptedEnum? _accepted;
  VendorCommissionAcceptanceAcceptedEnum? get accepted => _$this._accepted;
  set accepted(VendorCommissionAcceptanceAcceptedEnum? accepted) =>
      _$this._accepted = accepted;

  VendorCommissionAcceptanceBuilder() {
    VendorCommissionAcceptance._defaults(this);
  }

  VendorCommissionAcceptanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _organizationLockVersion = $v.organizationLockVersion;
      _agreementVersionId = $v.agreementVersionId;
      _accepted = $v.accepted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorCommissionAcceptance other) {
    _$v = other as _$VendorCommissionAcceptance;
  }

  @override
  void update(void Function(VendorCommissionAcceptanceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorCommissionAcceptance build() => _build();

  _$VendorCommissionAcceptance _build() {
    final _$result = _$v ??
        _$VendorCommissionAcceptance._(
          organizationLockVersion: BuiltValueNullFieldError.checkNotNull(
              organizationLockVersion,
              r'VendorCommissionAcceptance',
              'organizationLockVersion'),
          agreementVersionId: BuiltValueNullFieldError.checkNotNull(
              agreementVersionId,
              r'VendorCommissionAcceptance',
              'agreementVersionId'),
          accepted: BuiltValueNullFieldError.checkNotNull(
              accepted, r'VendorCommissionAcceptance', 'accepted'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
