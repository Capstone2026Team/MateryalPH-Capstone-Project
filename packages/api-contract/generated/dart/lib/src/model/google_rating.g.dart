// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_rating.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GoogleRatingSource_Enum _$googleRatingSourceEnum_GOOGLE =
    const GoogleRatingSource_Enum._('GOOGLE');

GoogleRatingSource_Enum _$googleRatingSourceEnumValueOf(String name) {
  switch (name) {
    case 'GOOGLE':
      return _$googleRatingSourceEnum_GOOGLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GoogleRatingSource_Enum> _$googleRatingSourceEnumValues =
    BuiltSet<GoogleRatingSource_Enum>(const <GoogleRatingSource_Enum>[
  _$googleRatingSourceEnum_GOOGLE,
]);

Serializer<GoogleRatingSource_Enum> _$googleRatingSourceEnumSerializer =
    _$GoogleRatingSource_EnumSerializer();

class _$GoogleRatingSource_EnumSerializer
    implements PrimitiveSerializer<GoogleRatingSource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'GOOGLE': 'GOOGLE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'GOOGLE': 'GOOGLE',
  };

  @override
  final Iterable<Type> types = const <Type>[GoogleRatingSource_Enum];
  @override
  final String wireName = 'GoogleRatingSource_Enum';

  @override
  Object serialize(Serializers serializers, GoogleRatingSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GoogleRatingSource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GoogleRatingSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GoogleRating extends GoogleRating {
  @override
  final GoogleRatingSource_Enum source_;
  @override
  final String label;
  @override
  final String value;
  @override
  final int? count;

  factory _$GoogleRating([void Function(GoogleRatingBuilder)? updates]) =>
      (GoogleRatingBuilder()..update(updates))._build();

  _$GoogleRating._(
      {required this.source_,
      required this.label,
      required this.value,
      this.count})
      : super._();
  @override
  GoogleRating rebuild(void Function(GoogleRatingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoogleRatingBuilder toBuilder() => GoogleRatingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoogleRating &&
        source_ == other.source_ &&
        label == other.label &&
        value == other.value &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoogleRating')
          ..add('source_', source_)
          ..add('label', label)
          ..add('value', value)
          ..add('count', count))
        .toString();
  }
}

class GoogleRatingBuilder
    implements Builder<GoogleRating, GoogleRatingBuilder> {
  _$GoogleRating? _$v;

  GoogleRatingSource_Enum? _source_;
  GoogleRatingSource_Enum? get source_ => _$this._source_;
  set source_(GoogleRatingSource_Enum? source_) => _$this._source_ = source_;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  GoogleRatingBuilder() {
    GoogleRating._defaults(this);
  }

  GoogleRatingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _source_ = $v.source_;
      _label = $v.label;
      _value = $v.value;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoogleRating other) {
    _$v = other as _$GoogleRating;
  }

  @override
  void update(void Function(GoogleRatingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoogleRating build() => _build();

  _$GoogleRating _build() {
    final _$result = _$v ??
        _$GoogleRating._(
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'GoogleRating', 'source_'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'GoogleRating', 'label'),
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'GoogleRating', 'value'),
          count: count,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
