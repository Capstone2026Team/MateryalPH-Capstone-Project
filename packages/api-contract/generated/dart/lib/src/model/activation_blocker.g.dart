// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activation_blocker.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ActivationBlockerCategoryEnum _$activationBlockerCategoryEnum_ACCOUNT =
    const ActivationBlockerCategoryEnum._('ACCOUNT');
const ActivationBlockerCategoryEnum _$activationBlockerCategoryEnum_TERMS =
    const ActivationBlockerCategoryEnum._('TERMS');
const ActivationBlockerCategoryEnum _$activationBlockerCategoryEnum_AUTHORITY =
    const ActivationBlockerCategoryEnum._('AUTHORITY');
const ActivationBlockerCategoryEnum _$activationBlockerCategoryEnum_TAX =
    const ActivationBlockerCategoryEnum._('TAX');
const ActivationBlockerCategoryEnum _$activationBlockerCategoryEnum_MEDIA =
    const ActivationBlockerCategoryEnum._('MEDIA');
const ActivationBlockerCategoryEnum _$activationBlockerCategoryEnum_HOURS =
    const ActivationBlockerCategoryEnum._('HOURS');
const ActivationBlockerCategoryEnum _$activationBlockerCategoryEnum_SETUP =
    const ActivationBlockerCategoryEnum._('SETUP');
const ActivationBlockerCategoryEnum _$activationBlockerCategoryEnum_DELIVERY =
    const ActivationBlockerCategoryEnum._('DELIVERY');
const ActivationBlockerCategoryEnum
    _$activationBlockerCategoryEnum_PROVIDER_CAPABILITY =
    const ActivationBlockerCategoryEnum._('PROVIDER_CAPABILITY');
const ActivationBlockerCategoryEnum _$activationBlockerCategoryEnum_HOLD =
    const ActivationBlockerCategoryEnum._('HOLD');
const ActivationBlockerCategoryEnum
    _$activationBlockerCategoryEnum_VERIFICATION =
    const ActivationBlockerCategoryEnum._('VERIFICATION');

ActivationBlockerCategoryEnum _$activationBlockerCategoryEnumValueOf(
    String name) {
  switch (name) {
    case 'ACCOUNT':
      return _$activationBlockerCategoryEnum_ACCOUNT;
    case 'TERMS':
      return _$activationBlockerCategoryEnum_TERMS;
    case 'AUTHORITY':
      return _$activationBlockerCategoryEnum_AUTHORITY;
    case 'TAX':
      return _$activationBlockerCategoryEnum_TAX;
    case 'MEDIA':
      return _$activationBlockerCategoryEnum_MEDIA;
    case 'HOURS':
      return _$activationBlockerCategoryEnum_HOURS;
    case 'SETUP':
      return _$activationBlockerCategoryEnum_SETUP;
    case 'DELIVERY':
      return _$activationBlockerCategoryEnum_DELIVERY;
    case 'PROVIDER_CAPABILITY':
      return _$activationBlockerCategoryEnum_PROVIDER_CAPABILITY;
    case 'HOLD':
      return _$activationBlockerCategoryEnum_HOLD;
    case 'VERIFICATION':
      return _$activationBlockerCategoryEnum_VERIFICATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ActivationBlockerCategoryEnum>
    _$activationBlockerCategoryEnumValues = BuiltSet<
        ActivationBlockerCategoryEnum>(const <ActivationBlockerCategoryEnum>[
  _$activationBlockerCategoryEnum_ACCOUNT,
  _$activationBlockerCategoryEnum_TERMS,
  _$activationBlockerCategoryEnum_AUTHORITY,
  _$activationBlockerCategoryEnum_TAX,
  _$activationBlockerCategoryEnum_MEDIA,
  _$activationBlockerCategoryEnum_HOURS,
  _$activationBlockerCategoryEnum_SETUP,
  _$activationBlockerCategoryEnum_DELIVERY,
  _$activationBlockerCategoryEnum_PROVIDER_CAPABILITY,
  _$activationBlockerCategoryEnum_HOLD,
  _$activationBlockerCategoryEnum_VERIFICATION,
]);

Serializer<ActivationBlockerCategoryEnum>
    _$activationBlockerCategoryEnumSerializer =
    _$ActivationBlockerCategoryEnumSerializer();

class _$ActivationBlockerCategoryEnumSerializer
    implements PrimitiveSerializer<ActivationBlockerCategoryEnum> {
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
  final Iterable<Type> types = const <Type>[ActivationBlockerCategoryEnum];
  @override
  final String wireName = 'ActivationBlockerCategoryEnum';

  @override
  Object serialize(
          Serializers serializers, ActivationBlockerCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ActivationBlockerCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ActivationBlockerCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ActivationBlocker extends ActivationBlocker {
  @override
  final String key;
  @override
  final int condition;
  @override
  final String reason;
  @override
  final ActivationBlockerCategoryEnum category;
  @override
  final ActivationBlockerSource source_;

  factory _$ActivationBlocker(
          [void Function(ActivationBlockerBuilder)? updates]) =>
      (ActivationBlockerBuilder()..update(updates))._build();

  _$ActivationBlocker._(
      {required this.key,
      required this.condition,
      required this.reason,
      required this.category,
      required this.source_})
      : super._();
  @override
  ActivationBlocker rebuild(void Function(ActivationBlockerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ActivationBlockerBuilder toBuilder() =>
      ActivationBlockerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ActivationBlocker &&
        key == other.key &&
        condition == other.condition &&
        reason == other.reason &&
        category == other.category &&
        source_ == other.source_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, condition.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ActivationBlocker')
          ..add('key', key)
          ..add('condition', condition)
          ..add('reason', reason)
          ..add('category', category)
          ..add('source_', source_))
        .toString();
  }
}

class ActivationBlockerBuilder
    implements Builder<ActivationBlocker, ActivationBlockerBuilder> {
  _$ActivationBlocker? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  int? _condition;
  int? get condition => _$this._condition;
  set condition(int? condition) => _$this._condition = condition;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  ActivationBlockerCategoryEnum? _category;
  ActivationBlockerCategoryEnum? get category => _$this._category;
  set category(ActivationBlockerCategoryEnum? category) =>
      _$this._category = category;

  ActivationBlockerSourceBuilder? _source_;
  ActivationBlockerSourceBuilder get source_ =>
      _$this._source_ ??= ActivationBlockerSourceBuilder();
  set source_(ActivationBlockerSourceBuilder? source_) =>
      _$this._source_ = source_;

  ActivationBlockerBuilder() {
    ActivationBlocker._defaults(this);
  }

  ActivationBlockerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _condition = $v.condition;
      _reason = $v.reason;
      _category = $v.category;
      _source_ = $v.source_.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ActivationBlocker other) {
    _$v = other as _$ActivationBlocker;
  }

  @override
  void update(void Function(ActivationBlockerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ActivationBlocker build() => _build();

  _$ActivationBlocker _build() {
    _$ActivationBlocker _$result;
    try {
      _$result = _$v ??
          _$ActivationBlocker._(
            key: BuiltValueNullFieldError.checkNotNull(
                key, r'ActivationBlocker', 'key'),
            condition: BuiltValueNullFieldError.checkNotNull(
                condition, r'ActivationBlocker', 'condition'),
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'ActivationBlocker', 'reason'),
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'ActivationBlocker', 'category'),
            source_: source_.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'source_';
        source_.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ActivationBlocker', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
