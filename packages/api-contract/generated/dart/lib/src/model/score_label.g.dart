// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_label.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ScoreLabelKindEnum _$scoreLabelKindEnum_VPS =
    const ScoreLabelKindEnum._('VPS');
const ScoreLabelKindEnum _$scoreLabelKindEnum_NEW_VENDOR =
    const ScoreLabelKindEnum._('NEW_VENDOR');
const ScoreLabelKindEnum _$scoreLabelKindEnum_DIRECTORY =
    const ScoreLabelKindEnum._('DIRECTORY');

ScoreLabelKindEnum _$scoreLabelKindEnumValueOf(String name) {
  switch (name) {
    case 'VPS':
      return _$scoreLabelKindEnum_VPS;
    case 'NEW_VENDOR':
      return _$scoreLabelKindEnum_NEW_VENDOR;
    case 'DIRECTORY':
      return _$scoreLabelKindEnum_DIRECTORY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ScoreLabelKindEnum> _$scoreLabelKindEnumValues =
    BuiltSet<ScoreLabelKindEnum>(const <ScoreLabelKindEnum>[
  _$scoreLabelKindEnum_VPS,
  _$scoreLabelKindEnum_NEW_VENDOR,
  _$scoreLabelKindEnum_DIRECTORY,
]);

Serializer<ScoreLabelKindEnum> _$scoreLabelKindEnumSerializer =
    _$ScoreLabelKindEnumSerializer();

class _$ScoreLabelKindEnumSerializer
    implements PrimitiveSerializer<ScoreLabelKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VPS': 'VPS',
    'NEW_VENDOR': 'NEW_VENDOR',
    'DIRECTORY': 'DIRECTORY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VPS': 'VPS',
    'NEW_VENDOR': 'NEW_VENDOR',
    'DIRECTORY': 'DIRECTORY',
  };

  @override
  final Iterable<Type> types = const <Type>[ScoreLabelKindEnum];
  @override
  final String wireName = 'ScoreLabelKindEnum';

  @override
  Object serialize(Serializers serializers, ScoreLabelKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ScoreLabelKindEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ScoreLabelKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ScoreLabel extends ScoreLabel {
  @override
  final ScoreLabelKindEnum kind;
  @override
  final String? value;
  @override
  final String text;

  factory _$ScoreLabel([void Function(ScoreLabelBuilder)? updates]) =>
      (ScoreLabelBuilder()..update(updates))._build();

  _$ScoreLabel._({required this.kind, this.value, required this.text})
      : super._();
  @override
  ScoreLabel rebuild(void Function(ScoreLabelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScoreLabelBuilder toBuilder() => ScoreLabelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScoreLabel &&
        kind == other.kind &&
        value == other.value &&
        text == other.text;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ScoreLabel')
          ..add('kind', kind)
          ..add('value', value)
          ..add('text', text))
        .toString();
  }
}

class ScoreLabelBuilder implements Builder<ScoreLabel, ScoreLabelBuilder> {
  _$ScoreLabel? _$v;

  ScoreLabelKindEnum? _kind;
  ScoreLabelKindEnum? get kind => _$this._kind;
  set kind(ScoreLabelKindEnum? kind) => _$this._kind = kind;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  ScoreLabelBuilder() {
    ScoreLabel._defaults(this);
  }

  ScoreLabelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _value = $v.value;
      _text = $v.text;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScoreLabel other) {
    _$v = other as _$ScoreLabel;
  }

  @override
  void update(void Function(ScoreLabelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScoreLabel build() => _build();

  _$ScoreLabel _build() {
    final _$result = _$v ??
        _$ScoreLabel._(
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'ScoreLabel', 'kind'),
          value: value,
          text: BuiltValueNullFieldError.checkNotNull(
              text, r'ScoreLabel', 'text'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
