// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_onboarding_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuyerOnboardingUpdateActionEnum _$buyerOnboardingUpdateActionEnum_SAVE =
    const BuyerOnboardingUpdateActionEnum._('SAVE');
const BuyerOnboardingUpdateActionEnum
    _$buyerOnboardingUpdateActionEnum_COMPLETE =
    const BuyerOnboardingUpdateActionEnum._('COMPLETE');
const BuyerOnboardingUpdateActionEnum _$buyerOnboardingUpdateActionEnum_SKIP =
    const BuyerOnboardingUpdateActionEnum._('SKIP');

BuyerOnboardingUpdateActionEnum _$buyerOnboardingUpdateActionEnumValueOf(
    String name) {
  switch (name) {
    case 'SAVE':
      return _$buyerOnboardingUpdateActionEnum_SAVE;
    case 'COMPLETE':
      return _$buyerOnboardingUpdateActionEnum_COMPLETE;
    case 'SKIP':
      return _$buyerOnboardingUpdateActionEnum_SKIP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerOnboardingUpdateActionEnum>
    _$buyerOnboardingUpdateActionEnumValues = BuiltSet<
        BuyerOnboardingUpdateActionEnum>(const <BuyerOnboardingUpdateActionEnum>[
  _$buyerOnboardingUpdateActionEnum_SAVE,
  _$buyerOnboardingUpdateActionEnum_COMPLETE,
  _$buyerOnboardingUpdateActionEnum_SKIP,
]);

Serializer<BuyerOnboardingUpdateActionEnum>
    _$buyerOnboardingUpdateActionEnumSerializer =
    _$BuyerOnboardingUpdateActionEnumSerializer();

class _$BuyerOnboardingUpdateActionEnumSerializer
    implements PrimitiveSerializer<BuyerOnboardingUpdateActionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SAVE': 'SAVE',
    'COMPLETE': 'COMPLETE',
    'SKIP': 'SKIP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SAVE': 'SAVE',
    'COMPLETE': 'COMPLETE',
    'SKIP': 'SKIP',
  };

  @override
  final Iterable<Type> types = const <Type>[BuyerOnboardingUpdateActionEnum];
  @override
  final String wireName = 'BuyerOnboardingUpdateActionEnum';

  @override
  Object serialize(
          Serializers serializers, BuyerOnboardingUpdateActionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerOnboardingUpdateActionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerOnboardingUpdateActionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerOnboardingUpdate extends BuyerOnboardingUpdate {
  @override
  final int lockVersion;
  @override
  final BuyerOnboardingUpdateActionEnum action;
  @override
  final String? companyName;
  @override
  final String? positionTitle;
  @override
  final BuyerIndustryClassification? industryClassification;
  @override
  final String? industryOtherLabel;
  @override
  final BuiltList<String>? preferredCategoryIds;

  factory _$BuyerOnboardingUpdate(
          [void Function(BuyerOnboardingUpdateBuilder)? updates]) =>
      (BuyerOnboardingUpdateBuilder()..update(updates))._build();

  _$BuyerOnboardingUpdate._(
      {required this.lockVersion,
      required this.action,
      this.companyName,
      this.positionTitle,
      this.industryClassification,
      this.industryOtherLabel,
      this.preferredCategoryIds})
      : super._();
  @override
  BuyerOnboardingUpdate rebuild(
          void Function(BuyerOnboardingUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerOnboardingUpdateBuilder toBuilder() =>
      BuyerOnboardingUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerOnboardingUpdate &&
        lockVersion == other.lockVersion &&
        action == other.action &&
        companyName == other.companyName &&
        positionTitle == other.positionTitle &&
        industryClassification == other.industryClassification &&
        industryOtherLabel == other.industryOtherLabel &&
        preferredCategoryIds == other.preferredCategoryIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, positionTitle.hashCode);
    _$hash = $jc(_$hash, industryClassification.hashCode);
    _$hash = $jc(_$hash, industryOtherLabel.hashCode);
    _$hash = $jc(_$hash, preferredCategoryIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerOnboardingUpdate')
          ..add('lockVersion', lockVersion)
          ..add('action', action)
          ..add('companyName', companyName)
          ..add('positionTitle', positionTitle)
          ..add('industryClassification', industryClassification)
          ..add('industryOtherLabel', industryOtherLabel)
          ..add('preferredCategoryIds', preferredCategoryIds))
        .toString();
  }
}

class BuyerOnboardingUpdateBuilder
    implements Builder<BuyerOnboardingUpdate, BuyerOnboardingUpdateBuilder> {
  _$BuyerOnboardingUpdate? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  BuyerOnboardingUpdateActionEnum? _action;
  BuyerOnboardingUpdateActionEnum? get action => _$this._action;
  set action(BuyerOnboardingUpdateActionEnum? action) =>
      _$this._action = action;

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

  BuyerOnboardingUpdateBuilder() {
    BuyerOnboardingUpdate._defaults(this);
  }

  BuyerOnboardingUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _action = $v.action;
      _companyName = $v.companyName;
      _positionTitle = $v.positionTitle;
      _industryClassification = $v.industryClassification;
      _industryOtherLabel = $v.industryOtherLabel;
      _preferredCategoryIds = $v.preferredCategoryIds?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerOnboardingUpdate other) {
    _$v = other as _$BuyerOnboardingUpdate;
  }

  @override
  void update(void Function(BuyerOnboardingUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerOnboardingUpdate build() => _build();

  _$BuyerOnboardingUpdate _build() {
    _$BuyerOnboardingUpdate _$result;
    try {
      _$result = _$v ??
          _$BuyerOnboardingUpdate._(
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'BuyerOnboardingUpdate', 'lockVersion'),
            action: BuiltValueNullFieldError.checkNotNull(
                action, r'BuyerOnboardingUpdate', 'action'),
            companyName: companyName,
            positionTitle: positionTitle,
            industryClassification: industryClassification,
            industryOtherLabel: industryOtherLabel,
            preferredCategoryIds: _preferredCategoryIds?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'preferredCategoryIds';
        _preferredCategoryIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BuyerOnboardingUpdate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
