// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activation_restrictions.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ActivationRestrictionsCategoriesEnum
    _$activationRestrictionsCategoriesEnum_ACCOUNT =
    const ActivationRestrictionsCategoriesEnum._('ACCOUNT');
const ActivationRestrictionsCategoriesEnum
    _$activationRestrictionsCategoriesEnum_TERMS =
    const ActivationRestrictionsCategoriesEnum._('TERMS');
const ActivationRestrictionsCategoriesEnum
    _$activationRestrictionsCategoriesEnum_AUTHORITY =
    const ActivationRestrictionsCategoriesEnum._('AUTHORITY');
const ActivationRestrictionsCategoriesEnum
    _$activationRestrictionsCategoriesEnum_TAX =
    const ActivationRestrictionsCategoriesEnum._('TAX');
const ActivationRestrictionsCategoriesEnum
    _$activationRestrictionsCategoriesEnum_MEDIA =
    const ActivationRestrictionsCategoriesEnum._('MEDIA');
const ActivationRestrictionsCategoriesEnum
    _$activationRestrictionsCategoriesEnum_HOURS =
    const ActivationRestrictionsCategoriesEnum._('HOURS');
const ActivationRestrictionsCategoriesEnum
    _$activationRestrictionsCategoriesEnum_SETUP =
    const ActivationRestrictionsCategoriesEnum._('SETUP');
const ActivationRestrictionsCategoriesEnum
    _$activationRestrictionsCategoriesEnum_DELIVERY =
    const ActivationRestrictionsCategoriesEnum._('DELIVERY');
const ActivationRestrictionsCategoriesEnum
    _$activationRestrictionsCategoriesEnum_PROVIDER_CAPABILITY =
    const ActivationRestrictionsCategoriesEnum._('PROVIDER_CAPABILITY');
const ActivationRestrictionsCategoriesEnum
    _$activationRestrictionsCategoriesEnum_HOLD =
    const ActivationRestrictionsCategoriesEnum._('HOLD');
const ActivationRestrictionsCategoriesEnum
    _$activationRestrictionsCategoriesEnum_VERIFICATION =
    const ActivationRestrictionsCategoriesEnum._('VERIFICATION');

ActivationRestrictionsCategoriesEnum
    _$activationRestrictionsCategoriesEnumValueOf(String name) {
  switch (name) {
    case 'ACCOUNT':
      return _$activationRestrictionsCategoriesEnum_ACCOUNT;
    case 'TERMS':
      return _$activationRestrictionsCategoriesEnum_TERMS;
    case 'AUTHORITY':
      return _$activationRestrictionsCategoriesEnum_AUTHORITY;
    case 'TAX':
      return _$activationRestrictionsCategoriesEnum_TAX;
    case 'MEDIA':
      return _$activationRestrictionsCategoriesEnum_MEDIA;
    case 'HOURS':
      return _$activationRestrictionsCategoriesEnum_HOURS;
    case 'SETUP':
      return _$activationRestrictionsCategoriesEnum_SETUP;
    case 'DELIVERY':
      return _$activationRestrictionsCategoriesEnum_DELIVERY;
    case 'PROVIDER_CAPABILITY':
      return _$activationRestrictionsCategoriesEnum_PROVIDER_CAPABILITY;
    case 'HOLD':
      return _$activationRestrictionsCategoriesEnum_HOLD;
    case 'VERIFICATION':
      return _$activationRestrictionsCategoriesEnum_VERIFICATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ActivationRestrictionsCategoriesEnum>
    _$activationRestrictionsCategoriesEnumValues = BuiltSet<
        ActivationRestrictionsCategoriesEnum>(const <ActivationRestrictionsCategoriesEnum>[
  _$activationRestrictionsCategoriesEnum_ACCOUNT,
  _$activationRestrictionsCategoriesEnum_TERMS,
  _$activationRestrictionsCategoriesEnum_AUTHORITY,
  _$activationRestrictionsCategoriesEnum_TAX,
  _$activationRestrictionsCategoriesEnum_MEDIA,
  _$activationRestrictionsCategoriesEnum_HOURS,
  _$activationRestrictionsCategoriesEnum_SETUP,
  _$activationRestrictionsCategoriesEnum_DELIVERY,
  _$activationRestrictionsCategoriesEnum_PROVIDER_CAPABILITY,
  _$activationRestrictionsCategoriesEnum_HOLD,
  _$activationRestrictionsCategoriesEnum_VERIFICATION,
]);

const ActivationRestrictionsOverrideAvailableEnum
    _$activationRestrictionsOverrideAvailableEnum_false_ =
    const ActivationRestrictionsOverrideAvailableEnum._('false_');

ActivationRestrictionsOverrideAvailableEnum
    _$activationRestrictionsOverrideAvailableEnumValueOf(String name) {
  switch (name) {
    case 'false_':
      return _$activationRestrictionsOverrideAvailableEnum_false_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ActivationRestrictionsOverrideAvailableEnum>
    _$activationRestrictionsOverrideAvailableEnumValues = BuiltSet<
        ActivationRestrictionsOverrideAvailableEnum>(const <ActivationRestrictionsOverrideAvailableEnum>[
  _$activationRestrictionsOverrideAvailableEnum_false_,
]);

Serializer<ActivationRestrictionsCategoriesEnum>
    _$activationRestrictionsCategoriesEnumSerializer =
    _$ActivationRestrictionsCategoriesEnumSerializer();
Serializer<ActivationRestrictionsOverrideAvailableEnum>
    _$activationRestrictionsOverrideAvailableEnumSerializer =
    _$ActivationRestrictionsOverrideAvailableEnumSerializer();

class _$ActivationRestrictionsCategoriesEnumSerializer
    implements PrimitiveSerializer<ActivationRestrictionsCategoriesEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACCOUNT': 'ACCOUNT',
    'TERMS': 'TERMS',
    'AUTHORITY': 'AUTHORITY',
    'TAX': 'TAX',
    'MEDIA': 'MEDIA',
    'HOURS': 'HOURS',
    'SETUP': 'SETUP',
    'DELIVERY': 'DELIVERY',
    'PROVIDER_CAPABILITY': 'PROVIDER_CAPABILITY',
    'HOLD': 'HOLD',
    'VERIFICATION': 'VERIFICATION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACCOUNT': 'ACCOUNT',
    'TERMS': 'TERMS',
    'AUTHORITY': 'AUTHORITY',
    'TAX': 'TAX',
    'MEDIA': 'MEDIA',
    'HOURS': 'HOURS',
    'SETUP': 'SETUP',
    'DELIVERY': 'DELIVERY',
    'PROVIDER_CAPABILITY': 'PROVIDER_CAPABILITY',
    'HOLD': 'HOLD',
    'VERIFICATION': 'VERIFICATION',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ActivationRestrictionsCategoriesEnum
  ];
  @override
  final String wireName = 'ActivationRestrictionsCategoriesEnum';

  @override
  Object serialize(
          Serializers serializers, ActivationRestrictionsCategoriesEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ActivationRestrictionsCategoriesEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ActivationRestrictionsCategoriesEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ActivationRestrictionsOverrideAvailableEnumSerializer
    implements
        PrimitiveSerializer<ActivationRestrictionsOverrideAvailableEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'false_': 'false',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'false': 'false_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ActivationRestrictionsOverrideAvailableEnum
  ];
  @override
  final String wireName = 'ActivationRestrictionsOverrideAvailableEnum';

  @override
  Object serialize(Serializers serializers,
          ActivationRestrictionsOverrideAvailableEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ActivationRestrictionsOverrideAvailableEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ActivationRestrictionsOverrideAvailableEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ActivationRestrictions extends ActivationRestrictions {
  @override
  final bool ready;
  @override
  final String status;
  @override
  final String ruleVersion;
  @override
  final DateTime evaluatedAt;
  @override
  final BuiltList<ActivationBlocker> blockers;
  @override
  final BuiltList<ActivationRestrictionsCategoriesEnum> categories;
  @override
  final BuiltList<String> notBlocking;
  @override
  final ActivationRestrictionsOverrideAvailableEnum overrideAvailable;

  factory _$ActivationRestrictions(
          [void Function(ActivationRestrictionsBuilder)? updates]) =>
      (ActivationRestrictionsBuilder()..update(updates))._build();

  _$ActivationRestrictions._(
      {required this.ready,
      required this.status,
      required this.ruleVersion,
      required this.evaluatedAt,
      required this.blockers,
      required this.categories,
      required this.notBlocking,
      required this.overrideAvailable})
      : super._();
  @override
  ActivationRestrictions rebuild(
          void Function(ActivationRestrictionsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ActivationRestrictionsBuilder toBuilder() =>
      ActivationRestrictionsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ActivationRestrictions &&
        ready == other.ready &&
        status == other.status &&
        ruleVersion == other.ruleVersion &&
        evaluatedAt == other.evaluatedAt &&
        blockers == other.blockers &&
        categories == other.categories &&
        notBlocking == other.notBlocking &&
        overrideAvailable == other.overrideAvailable;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ready.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, ruleVersion.hashCode);
    _$hash = $jc(_$hash, evaluatedAt.hashCode);
    _$hash = $jc(_$hash, blockers.hashCode);
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jc(_$hash, notBlocking.hashCode);
    _$hash = $jc(_$hash, overrideAvailable.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ActivationRestrictions')
          ..add('ready', ready)
          ..add('status', status)
          ..add('ruleVersion', ruleVersion)
          ..add('evaluatedAt', evaluatedAt)
          ..add('blockers', blockers)
          ..add('categories', categories)
          ..add('notBlocking', notBlocking)
          ..add('overrideAvailable', overrideAvailable))
        .toString();
  }
}

class ActivationRestrictionsBuilder
    implements Builder<ActivationRestrictions, ActivationRestrictionsBuilder> {
  _$ActivationRestrictions? _$v;

  bool? _ready;
  bool? get ready => _$this._ready;
  set ready(bool? ready) => _$this._ready = ready;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _ruleVersion;
  String? get ruleVersion => _$this._ruleVersion;
  set ruleVersion(String? ruleVersion) => _$this._ruleVersion = ruleVersion;

  DateTime? _evaluatedAt;
  DateTime? get evaluatedAt => _$this._evaluatedAt;
  set evaluatedAt(DateTime? evaluatedAt) => _$this._evaluatedAt = evaluatedAt;

  ListBuilder<ActivationBlocker>? _blockers;
  ListBuilder<ActivationBlocker> get blockers =>
      _$this._blockers ??= ListBuilder<ActivationBlocker>();
  set blockers(ListBuilder<ActivationBlocker>? blockers) =>
      _$this._blockers = blockers;

  ListBuilder<ActivationRestrictionsCategoriesEnum>? _categories;
  ListBuilder<ActivationRestrictionsCategoriesEnum> get categories =>
      _$this._categories ??=
          ListBuilder<ActivationRestrictionsCategoriesEnum>();
  set categories(
          ListBuilder<ActivationRestrictionsCategoriesEnum>? categories) =>
      _$this._categories = categories;

  ListBuilder<String>? _notBlocking;
  ListBuilder<String> get notBlocking =>
      _$this._notBlocking ??= ListBuilder<String>();
  set notBlocking(ListBuilder<String>? notBlocking) =>
      _$this._notBlocking = notBlocking;

  ActivationRestrictionsOverrideAvailableEnum? _overrideAvailable;
  ActivationRestrictionsOverrideAvailableEnum? get overrideAvailable =>
      _$this._overrideAvailable;
  set overrideAvailable(
          ActivationRestrictionsOverrideAvailableEnum? overrideAvailable) =>
      _$this._overrideAvailable = overrideAvailable;

  ActivationRestrictionsBuilder() {
    ActivationRestrictions._defaults(this);
  }

  ActivationRestrictionsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ready = $v.ready;
      _status = $v.status;
      _ruleVersion = $v.ruleVersion;
      _evaluatedAt = $v.evaluatedAt;
      _blockers = $v.blockers.toBuilder();
      _categories = $v.categories.toBuilder();
      _notBlocking = $v.notBlocking.toBuilder();
      _overrideAvailable = $v.overrideAvailable;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ActivationRestrictions other) {
    _$v = other as _$ActivationRestrictions;
  }

  @override
  void update(void Function(ActivationRestrictionsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ActivationRestrictions build() => _build();

  _$ActivationRestrictions _build() {
    _$ActivationRestrictions _$result;
    try {
      _$result = _$v ??
          _$ActivationRestrictions._(
            ready: BuiltValueNullFieldError.checkNotNull(
                ready, r'ActivationRestrictions', 'ready'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ActivationRestrictions', 'status'),
            ruleVersion: BuiltValueNullFieldError.checkNotNull(
                ruleVersion, r'ActivationRestrictions', 'ruleVersion'),
            evaluatedAt: BuiltValueNullFieldError.checkNotNull(
                evaluatedAt, r'ActivationRestrictions', 'evaluatedAt'),
            blockers: blockers.build(),
            categories: categories.build(),
            notBlocking: notBlocking.build(),
            overrideAvailable: BuiltValueNullFieldError.checkNotNull(
                overrideAvailable,
                r'ActivationRestrictions',
                'overrideAvailable'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'blockers';
        blockers.build();
        _$failedField = 'categories';
        categories.build();
        _$failedField = 'notBlocking';
        notBlocking.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ActivationRestrictions', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
