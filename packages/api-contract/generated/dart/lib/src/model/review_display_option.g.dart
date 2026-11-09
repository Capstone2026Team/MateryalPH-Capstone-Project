// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_display_option.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ReviewDisplayOptionChoiceEnum _$reviewDisplayOptionChoiceEnum_FULL_NAME =
    const ReviewDisplayOptionChoiceEnum._('FULL_NAME');

ReviewDisplayOptionChoiceEnum _$reviewDisplayOptionChoiceEnumValueOf(
    String name) {
  switch (name) {
    case 'FULL_NAME':
      return _$reviewDisplayOptionChoiceEnum_FULL_NAME;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ReviewDisplayOptionChoiceEnum>
    _$reviewDisplayOptionChoiceEnumValues = BuiltSet<
        ReviewDisplayOptionChoiceEnum>(const <ReviewDisplayOptionChoiceEnum>[
  _$reviewDisplayOptionChoiceEnum_FULL_NAME,
]);

Serializer<ReviewDisplayOptionChoiceEnum>
    _$reviewDisplayOptionChoiceEnumSerializer =
    _$ReviewDisplayOptionChoiceEnumSerializer();

class _$ReviewDisplayOptionChoiceEnumSerializer
    implements PrimitiveSerializer<ReviewDisplayOptionChoiceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'FULL_NAME': 'FULL_NAME',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FULL_NAME': 'FULL_NAME',
  };

  @override
  final Iterable<Type> types = const <Type>[ReviewDisplayOptionChoiceEnum];
  @override
  final String wireName = 'ReviewDisplayOptionChoiceEnum';

  @override
  Object serialize(
          Serializers serializers, ReviewDisplayOptionChoiceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReviewDisplayOptionChoiceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReviewDisplayOptionChoiceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReviewDisplayOption extends ReviewDisplayOption {
  @override
  final ReviewDisplayOptionChoiceEnum choice;
  @override
  final String preview;

  factory _$ReviewDisplayOption(
          [void Function(ReviewDisplayOptionBuilder)? updates]) =>
      (ReviewDisplayOptionBuilder()..update(updates))._build();

  _$ReviewDisplayOption._({required this.choice, required this.preview})
      : super._();
  @override
  ReviewDisplayOption rebuild(
          void Function(ReviewDisplayOptionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReviewDisplayOptionBuilder toBuilder() =>
      ReviewDisplayOptionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReviewDisplayOption &&
        choice == other.choice &&
        preview == other.preview;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, choice.hashCode);
    _$hash = $jc(_$hash, preview.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReviewDisplayOption')
          ..add('choice', choice)
          ..add('preview', preview))
        .toString();
  }
}

class ReviewDisplayOptionBuilder
    implements Builder<ReviewDisplayOption, ReviewDisplayOptionBuilder> {
  _$ReviewDisplayOption? _$v;

  ReviewDisplayOptionChoiceEnum? _choice;
  ReviewDisplayOptionChoiceEnum? get choice => _$this._choice;
  set choice(ReviewDisplayOptionChoiceEnum? choice) => _$this._choice = choice;

  String? _preview;
  String? get preview => _$this._preview;
  set preview(String? preview) => _$this._preview = preview;

  ReviewDisplayOptionBuilder() {
    ReviewDisplayOption._defaults(this);
  }

  ReviewDisplayOptionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _choice = $v.choice;
      _preview = $v.preview;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReviewDisplayOption other) {
    _$v = other as _$ReviewDisplayOption;
  }

  @override
  void update(void Function(ReviewDisplayOptionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReviewDisplayOption build() => _build();

  _$ReviewDisplayOption _build() {
    final _$result = _$v ??
        _$ReviewDisplayOption._(
          choice: BuiltValueNullFieldError.checkNotNull(
              choice, r'ReviewDisplayOption', 'choice'),
          preview: BuiltValueNullFieldError.checkNotNull(
              preview, r'ReviewDisplayOption', 'preview'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
