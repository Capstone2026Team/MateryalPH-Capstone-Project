// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_place_attribute.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GooglePlaceAttribute extends GooglePlaceAttribute {
  @override
  final String label;
  @override
  final bool available;

  factory _$GooglePlaceAttribute(
          [void Function(GooglePlaceAttributeBuilder)? updates]) =>
      (GooglePlaceAttributeBuilder()..update(updates))._build();

  _$GooglePlaceAttribute._({required this.label, required this.available})
      : super._();
  @override
  GooglePlaceAttribute rebuild(
          void Function(GooglePlaceAttributeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GooglePlaceAttributeBuilder toBuilder() =>
      GooglePlaceAttributeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GooglePlaceAttribute &&
        label == other.label &&
        available == other.available;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GooglePlaceAttribute')
          ..add('label', label)
          ..add('available', available))
        .toString();
  }
}

class GooglePlaceAttributeBuilder
    implements Builder<GooglePlaceAttribute, GooglePlaceAttributeBuilder> {
  _$GooglePlaceAttribute? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  GooglePlaceAttributeBuilder() {
    GooglePlaceAttribute._defaults(this);
  }

  GooglePlaceAttributeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _available = $v.available;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GooglePlaceAttribute other) {
    _$v = other as _$GooglePlaceAttribute;
  }

  @override
  void update(void Function(GooglePlaceAttributeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GooglePlaceAttribute build() => _build();

  _$GooglePlaceAttribute _build() {
    final _$result = _$v ??
        _$GooglePlaceAttribute._(
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'GooglePlaceAttribute', 'label'),
          available: BuiltValueNullFieldError.checkNotNull(
              available, r'GooglePlaceAttribute', 'available'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
