// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_attribution.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProviderAttributionProviderEnum _$providerAttributionProviderEnum_GOOGLE =
    const ProviderAttributionProviderEnum._('GOOGLE');

ProviderAttributionProviderEnum _$providerAttributionProviderEnumValueOf(
    String name) {
  switch (name) {
    case 'GOOGLE':
      return _$providerAttributionProviderEnum_GOOGLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProviderAttributionProviderEnum>
    _$providerAttributionProviderEnumValues = BuiltSet<
        ProviderAttributionProviderEnum>(const <ProviderAttributionProviderEnum>[
  _$providerAttributionProviderEnum_GOOGLE,
]);

Serializer<ProviderAttributionProviderEnum>
    _$providerAttributionProviderEnumSerializer =
    _$ProviderAttributionProviderEnumSerializer();

class _$ProviderAttributionProviderEnumSerializer
    implements PrimitiveSerializer<ProviderAttributionProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'GOOGLE': 'GOOGLE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'GOOGLE': 'GOOGLE',
  };

  @override
  final Iterable<Type> types = const <Type>[ProviderAttributionProviderEnum];
  @override
  final String wireName = 'ProviderAttributionProviderEnum';

  @override
  Object serialize(
          Serializers serializers, ProviderAttributionProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProviderAttributionProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProviderAttributionProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProviderAttribution extends ProviderAttribution {
  @override
  final ProviderAttributionProviderEnum provider;
  @override
  final String text;

  factory _$ProviderAttribution(
          [void Function(ProviderAttributionBuilder)? updates]) =>
      (ProviderAttributionBuilder()..update(updates))._build();

  _$ProviderAttribution._({required this.provider, required this.text})
      : super._();
  @override
  ProviderAttribution rebuild(
          void Function(ProviderAttributionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProviderAttributionBuilder toBuilder() =>
      ProviderAttributionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProviderAttribution &&
        provider == other.provider &&
        text == other.text;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProviderAttribution')
          ..add('provider', provider)
          ..add('text', text))
        .toString();
  }
}

class ProviderAttributionBuilder
    implements Builder<ProviderAttribution, ProviderAttributionBuilder> {
  _$ProviderAttribution? _$v;

  ProviderAttributionProviderEnum? _provider;
  ProviderAttributionProviderEnum? get provider => _$this._provider;
  set provider(ProviderAttributionProviderEnum? provider) =>
      _$this._provider = provider;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  ProviderAttributionBuilder() {
    ProviderAttribution._defaults(this);
  }

  ProviderAttributionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _provider = $v.provider;
      _text = $v.text;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProviderAttribution other) {
    _$v = other as _$ProviderAttribution;
  }

  @override
  void update(void Function(ProviderAttributionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProviderAttribution build() => _build();

  _$ProviderAttribution _build() {
    final _$result = _$v ??
        _$ProviderAttribution._(
          provider: BuiltValueNullFieldError.checkNotNull(
              provider, r'ProviderAttribution', 'provider'),
          text: BuiltValueNullFieldError.checkNotNull(
              text, r'ProviderAttribution', 'text'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
