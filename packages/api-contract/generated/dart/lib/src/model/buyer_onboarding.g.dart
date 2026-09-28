// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_onboarding.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuyerOnboardingStatusEnum _$buyerOnboardingStatusEnum_NOT_STARTED =
    const BuyerOnboardingStatusEnum._('NOT_STARTED');
const BuyerOnboardingStatusEnum _$buyerOnboardingStatusEnum_SKIPPED =
    const BuyerOnboardingStatusEnum._('SKIPPED');
const BuyerOnboardingStatusEnum _$buyerOnboardingStatusEnum_COMPLETED =
    const BuyerOnboardingStatusEnum._('COMPLETED');

BuyerOnboardingStatusEnum _$buyerOnboardingStatusEnumValueOf(String name) {
  switch (name) {
    case 'NOT_STARTED':
      return _$buyerOnboardingStatusEnum_NOT_STARTED;
    case 'SKIPPED':
      return _$buyerOnboardingStatusEnum_SKIPPED;
    case 'COMPLETED':
      return _$buyerOnboardingStatusEnum_COMPLETED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerOnboardingStatusEnum> _$buyerOnboardingStatusEnumValues =
    BuiltSet<BuyerOnboardingStatusEnum>(const <BuyerOnboardingStatusEnum>[
  _$buyerOnboardingStatusEnum_NOT_STARTED,
  _$buyerOnboardingStatusEnum_SKIPPED,
  _$buyerOnboardingStatusEnum_COMPLETED,
]);

Serializer<BuyerOnboardingStatusEnum> _$buyerOnboardingStatusEnumSerializer =
    _$BuyerOnboardingStatusEnumSerializer();

class _$BuyerOnboardingStatusEnumSerializer
    implements PrimitiveSerializer<BuyerOnboardingStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NOT_STARTED': 'NOT_STARTED',
    'SKIPPED': 'SKIPPED',
    'COMPLETED': 'COMPLETED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NOT_STARTED': 'NOT_STARTED',
    'SKIPPED': 'SKIPPED',
    'COMPLETED': 'COMPLETED',
  };

  @override
  final Iterable<Type> types = const <Type>[BuyerOnboardingStatusEnum];
  @override
  final String wireName = 'BuyerOnboardingStatusEnum';

  @override
  Object serialize(Serializers serializers, BuyerOnboardingStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerOnboardingStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerOnboardingStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerOnboarding extends BuyerOnboarding {
  @override
  final BuyerOnboardingStatusEnum status;
  @override
  final DateTime? completedAt;
  @override
  final String buyerType;
  @override
  final String? companyName;
  @override
  final String? positionTitle;
  @override
  final BuyerIndustryClassification? industryClassification;
  @override
  final String? industryOtherLabel;
  @override
  final BuiltList<String> preferredCategoryIds;
  @override
  final RadiusKm discoveryRadiusKm;
  @override
  final bool hasPrimaryLocation;
  @override
  final int lockVersion;
  @override
  final BuiltList<MaterialCategoryOption> categories;
  @override
  final BuiltList<BuyerIndustryClassification> industries;

  factory _$BuyerOnboarding([void Function(BuyerOnboardingBuilder)? updates]) =>
      (BuyerOnboardingBuilder()..update(updates))._build();

  _$BuyerOnboarding._(
      {required this.status,
      this.completedAt,
      required this.buyerType,
      this.companyName,
      this.positionTitle,
      this.industryClassification,
      this.industryOtherLabel,
      required this.preferredCategoryIds,
      required this.discoveryRadiusKm,
      required this.hasPrimaryLocation,
      required this.lockVersion,
      required this.categories,
      required this.industries})
      : super._();
  @override
  BuyerOnboarding rebuild(void Function(BuyerOnboardingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerOnboardingBuilder toBuilder() => BuyerOnboardingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerOnboarding &&
        status == other.status &&
        completedAt == other.completedAt &&
        buyerType == other.buyerType &&
        companyName == other.companyName &&
        positionTitle == other.positionTitle &&
        industryClassification == other.industryClassification &&
        industryOtherLabel == other.industryOtherLabel &&
        preferredCategoryIds == other.preferredCategoryIds &&
        discoveryRadiusKm == other.discoveryRadiusKm &&
        hasPrimaryLocation == other.hasPrimaryLocation &&
        lockVersion == other.lockVersion &&
        categories == other.categories &&
        industries == other.industries;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, completedAt.hashCode);
    _$hash = $jc(_$hash, buyerType.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, positionTitle.hashCode);
    _$hash = $jc(_$hash, industryClassification.hashCode);
    _$hash = $jc(_$hash, industryOtherLabel.hashCode);
    _$hash = $jc(_$hash, preferredCategoryIds.hashCode);
    _$hash = $jc(_$hash, discoveryRadiusKm.hashCode);
    _$hash = $jc(_$hash, hasPrimaryLocation.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jc(_$hash, industries.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerOnboarding')
          ..add('status', status)
          ..add('completedAt', completedAt)
          ..add('buyerType', buyerType)
          ..add('companyName', companyName)
          ..add('positionTitle', positionTitle)
          ..add('industryClassification', industryClassification)
          ..add('industryOtherLabel', industryOtherLabel)
          ..add('preferredCategoryIds', preferredCategoryIds)
          ..add('discoveryRadiusKm', discoveryRadiusKm)
          ..add('hasPrimaryLocation', hasPrimaryLocation)
          ..add('lockVersion', lockVersion)
          ..add('categories', categories)
          ..add('industries', industries))
        .toString();
  }
}

class BuyerOnboardingBuilder
    implements Builder<BuyerOnboarding, BuyerOnboardingBuilder> {
  _$BuyerOnboarding? _$v;

  BuyerOnboardingStatusEnum? _status;
  BuyerOnboardingStatusEnum? get status => _$this._status;
  set status(BuyerOnboardingStatusEnum? status) => _$this._status = status;

  DateTime? _completedAt;
  DateTime? get completedAt => _$this._completedAt;
  set completedAt(DateTime? completedAt) => _$this._completedAt = completedAt;

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

  BuyerIndustryClassification? _industryClassification;
  BuyerIndustryClassification? get industryClassification =>
      _$this._industryClassification;
  set industryClassification(
          BuyerIndustryClassification? industryClassification) =>
      _$this._industryClassification = industryClassification;

  String? _industryOtherLabel;
  String? get industryOtherLabel => _$this._industryOtherLabel;
  set industryOtherLabel(String? industryOtherLabel) =>
      _$this._industryOtherLabel = industryOtherLabel;

  ListBuilder<String>? _preferredCategoryIds;
  ListBuilder<String> get preferredCategoryIds =>
      _$this._preferredCategoryIds ??= ListBuilder<String>();
  set preferredCategoryIds(ListBuilder<String>? preferredCategoryIds) =>
      _$this._preferredCategoryIds = preferredCategoryIds;

  RadiusKm? _discoveryRadiusKm;
  RadiusKm? get discoveryRadiusKm => _$this._discoveryRadiusKm;
  set discoveryRadiusKm(RadiusKm? discoveryRadiusKm) =>
      _$this._discoveryRadiusKm = discoveryRadiusKm;

  bool? _hasPrimaryLocation;
  bool? get hasPrimaryLocation => _$this._hasPrimaryLocation;
  set hasPrimaryLocation(bool? hasPrimaryLocation) =>
      _$this._hasPrimaryLocation = hasPrimaryLocation;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  ListBuilder<MaterialCategoryOption>? _categories;
  ListBuilder<MaterialCategoryOption> get categories =>
      _$this._categories ??= ListBuilder<MaterialCategoryOption>();
  set categories(ListBuilder<MaterialCategoryOption>? categories) =>
      _$this._categories = categories;

  ListBuilder<BuyerIndustryClassification>? _industries;
  ListBuilder<BuyerIndustryClassification> get industries =>
      _$this._industries ??= ListBuilder<BuyerIndustryClassification>();
  set industries(ListBuilder<BuyerIndustryClassification>? industries) =>
      _$this._industries = industries;

  BuyerOnboardingBuilder() {
    BuyerOnboarding._defaults(this);
  }

  BuyerOnboardingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _completedAt = $v.completedAt;
      _buyerType = $v.buyerType;
      _companyName = $v.companyName;
      _positionTitle = $v.positionTitle;
      _industryClassification = $v.industryClassification;
      _industryOtherLabel = $v.industryOtherLabel;
      _preferredCategoryIds = $v.preferredCategoryIds.toBuilder();
      _discoveryRadiusKm = $v.discoveryRadiusKm;
      _hasPrimaryLocation = $v.hasPrimaryLocation;
      _lockVersion = $v.lockVersion;
      _categories = $v.categories.toBuilder();
      _industries = $v.industries.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerOnboarding other) {
    _$v = other as _$BuyerOnboarding;
  }

  @override
  void update(void Function(BuyerOnboardingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerOnboarding build() => _build();

  _$BuyerOnboarding _build() {
    _$BuyerOnboarding _$result;
    try {
      _$result = _$v ??
          _$BuyerOnboarding._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'BuyerOnboarding', 'status'),
            completedAt: completedAt,
            buyerType: BuiltValueNullFieldError.checkNotNull(
                buyerType, r'BuyerOnboarding', 'buyerType'),
            companyName: companyName,
            positionTitle: positionTitle,
            industryClassification: industryClassification,
            industryOtherLabel: industryOtherLabel,
            preferredCategoryIds: preferredCategoryIds.build(),
            discoveryRadiusKm: BuiltValueNullFieldError.checkNotNull(
                discoveryRadiusKm, r'BuyerOnboarding', 'discoveryRadiusKm'),
            hasPrimaryLocation: BuiltValueNullFieldError.checkNotNull(
                hasPrimaryLocation, r'BuyerOnboarding', 'hasPrimaryLocation'),
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'BuyerOnboarding', 'lockVersion'),
            categories: categories.build(),
            industries: industries.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'preferredCategoryIds';
        preferredCategoryIds.build();

        _$failedField = 'categories';
        categories.build();
        _$failedField = 'industries';
        industries.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BuyerOnboarding', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
