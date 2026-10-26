// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_buyer_profile_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DirectoryBuyerProfileProfile extends DirectoryBuyerProfileProfile {
  @override
  final String? avatarUrl;
  @override
  final String email;
  @override
  final bool emailVerified;
  @override
  final String? mobile;
  @override
  final String buyerType;
  @override
  final String? companyName;
  @override
  final String? positionTitle;
  @override
  final String? industry;
  @override
  final String? area;
  @override
  final String onboardingStatus;
  @override
  final DateTime joinedAt;
  @override
  final DateTime? deletedAt;
  @override
  final DateTime? commerceRestrictedUntil;

  factory _$DirectoryBuyerProfileProfile(
          [void Function(DirectoryBuyerProfileProfileBuilder)? updates]) =>
      (DirectoryBuyerProfileProfileBuilder()..update(updates))._build();

  _$DirectoryBuyerProfileProfile._(
      {this.avatarUrl,
      required this.email,
      required this.emailVerified,
      this.mobile,
      required this.buyerType,
      this.companyName,
      this.positionTitle,
      this.industry,
      this.area,
      required this.onboardingStatus,
      required this.joinedAt,
      this.deletedAt,
      this.commerceRestrictedUntil})
      : super._();
  @override
  DirectoryBuyerProfileProfile rebuild(
          void Function(DirectoryBuyerProfileProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryBuyerProfileProfileBuilder toBuilder() =>
      DirectoryBuyerProfileProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryBuyerProfileProfile &&
        avatarUrl == other.avatarUrl &&
        email == other.email &&
        emailVerified == other.emailVerified &&
        mobile == other.mobile &&
        buyerType == other.buyerType &&
        companyName == other.companyName &&
        positionTitle == other.positionTitle &&
        industry == other.industry &&
        area == other.area &&
        onboardingStatus == other.onboardingStatus &&
        joinedAt == other.joinedAt &&
        deletedAt == other.deletedAt &&
        commerceRestrictedUntil == other.commerceRestrictedUntil;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, avatarUrl.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, emailVerified.hashCode);
    _$hash = $jc(_$hash, mobile.hashCode);
    _$hash = $jc(_$hash, buyerType.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, positionTitle.hashCode);
    _$hash = $jc(_$hash, industry.hashCode);
    _$hash = $jc(_$hash, area.hashCode);
    _$hash = $jc(_$hash, onboardingStatus.hashCode);
    _$hash = $jc(_$hash, joinedAt.hashCode);
    _$hash = $jc(_$hash, deletedAt.hashCode);
    _$hash = $jc(_$hash, commerceRestrictedUntil.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectoryBuyerProfileProfile')
          ..add('avatarUrl', avatarUrl)
          ..add('email', email)
          ..add('emailVerified', emailVerified)
          ..add('mobile', mobile)
          ..add('buyerType', buyerType)
          ..add('companyName', companyName)
          ..add('positionTitle', positionTitle)
          ..add('industry', industry)
          ..add('area', area)
          ..add('onboardingStatus', onboardingStatus)
          ..add('joinedAt', joinedAt)
          ..add('deletedAt', deletedAt)
          ..add('commerceRestrictedUntil', commerceRestrictedUntil))
        .toString();
  }
}

class DirectoryBuyerProfileProfileBuilder
    implements
        Builder<DirectoryBuyerProfileProfile,
            DirectoryBuyerProfileProfileBuilder> {
  _$DirectoryBuyerProfileProfile? _$v;

  String? _avatarUrl;
  String? get avatarUrl => _$this._avatarUrl;
  set avatarUrl(String? avatarUrl) => _$this._avatarUrl = avatarUrl;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  bool? _emailVerified;
  bool? get emailVerified => _$this._emailVerified;
  set emailVerified(bool? emailVerified) =>
      _$this._emailVerified = emailVerified;

  String? _mobile;
  String? get mobile => _$this._mobile;
  set mobile(String? mobile) => _$this._mobile = mobile;

  String? _buyerType;
  String? get buyerType => _$this._buyerType;
  set buyerType(String? buyerType) => _$this._buyerType = buyerType;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  String? _positionTitle;
  String? get positionTitle => _$this._positionTitle;
  set positionTitle(String? positionTitle) =>
      _$this._positionTitle = positionTitle;

  String? _industry;
  String? get industry => _$this._industry;
  set industry(String? industry) => _$this._industry = industry;

  String? _area;
  String? get area => _$this._area;
  set area(String? area) => _$this._area = area;

  String? _onboardingStatus;
  String? get onboardingStatus => _$this._onboardingStatus;
  set onboardingStatus(String? onboardingStatus) =>
      _$this._onboardingStatus = onboardingStatus;

  DateTime? _joinedAt;
  DateTime? get joinedAt => _$this._joinedAt;
  set joinedAt(DateTime? joinedAt) => _$this._joinedAt = joinedAt;

  DateTime? _deletedAt;
  DateTime? get deletedAt => _$this._deletedAt;
  set deletedAt(DateTime? deletedAt) => _$this._deletedAt = deletedAt;

  DateTime? _commerceRestrictedUntil;
  DateTime? get commerceRestrictedUntil => _$this._commerceRestrictedUntil;
  set commerceRestrictedUntil(DateTime? commerceRestrictedUntil) =>
      _$this._commerceRestrictedUntil = commerceRestrictedUntil;

  DirectoryBuyerProfileProfileBuilder() {
    DirectoryBuyerProfileProfile._defaults(this);
  }

  DirectoryBuyerProfileProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _avatarUrl = $v.avatarUrl;
      _email = $v.email;
      _emailVerified = $v.emailVerified;
      _mobile = $v.mobile;
      _buyerType = $v.buyerType;
      _companyName = $v.companyName;
      _positionTitle = $v.positionTitle;
      _industry = $v.industry;
      _area = $v.area;
      _onboardingStatus = $v.onboardingStatus;
      _joinedAt = $v.joinedAt;
      _deletedAt = $v.deletedAt;
      _commerceRestrictedUntil = $v.commerceRestrictedUntil;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectoryBuyerProfileProfile other) {
    _$v = other as _$DirectoryBuyerProfileProfile;
  }

  @override
  void update(void Function(DirectoryBuyerProfileProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryBuyerProfileProfile build() => _build();

  _$DirectoryBuyerProfileProfile _build() {
    final _$result = _$v ??
        _$DirectoryBuyerProfileProfile._(
          avatarUrl: avatarUrl,
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'DirectoryBuyerProfileProfile', 'email'),
          emailVerified: BuiltValueNullFieldError.checkNotNull(
              emailVerified, r'DirectoryBuyerProfileProfile', 'emailVerified'),
          mobile: mobile,
          buyerType: BuiltValueNullFieldError.checkNotNull(
              buyerType, r'DirectoryBuyerProfileProfile', 'buyerType'),
          companyName: companyName,
          positionTitle: positionTitle,
          industry: industry,
          area: area,
          onboardingStatus: BuiltValueNullFieldError.checkNotNull(
              onboardingStatus,
              r'DirectoryBuyerProfileProfile',
              'onboardingStatus'),
          joinedAt: BuiltValueNullFieldError.checkNotNull(
              joinedAt, r'DirectoryBuyerProfileProfile', 'joinedAt'),
          deletedAt: deletedAt,
          commerceRestrictedUntil: commerceRestrictedUntil,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
