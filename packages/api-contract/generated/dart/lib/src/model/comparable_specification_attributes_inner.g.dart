// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comparable_specification_attributes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ComparableSpecificationAttributesInner
    extends ComparableSpecificationAttributesInner {
  @override
  final String key;
  @override
  final String value;

  factory _$ComparableSpecificationAttributesInner(
          [void Function(ComparableSpecificationAttributesInnerBuilder)?
              updates]) =>
      (ComparableSpecificationAttributesInnerBuilder()..update(updates))
          ._build();

  _$ComparableSpecificationAttributesInner._(
      {required this.key, required this.value})
      : super._();
  @override
  ComparableSpecificationAttributesInner rebuild(
          void Function(ComparableSpecificationAttributesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComparableSpecificationAttributesInnerBuilder toBuilder() =>
      ComparableSpecificationAttributesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComparableSpecificationAttributesInner &&
        key == other.key &&
        value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ComparableSpecificationAttributesInner')
          ..add('key', key)
          ..add('value', value))
        .toString();
  }
}

class ComparableSpecificationAttributesInnerBuilder
    implements
        Builder<ComparableSpecificationAttributesInner,
            ComparableSpecificationAttributesInnerBuilder> {
  _$ComparableSpecificationAttributesInner? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  ComparableSpecificationAttributesInnerBuilder() {
    ComparableSpecificationAttributesInner._defaults(this);
  }

  ComparableSpecificationAttributesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComparableSpecificationAttributesInner other) {
    _$v = other as _$ComparableSpecificationAttributesInner;
  }

  @override
  void update(
      void Function(ComparableSpecificationAttributesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComparableSpecificationAttributesInner build() => _build();

  _$ComparableSpecificationAttributesInner _build() {
    final _$result = _$v ??
        _$ComparableSpecificationAttributesInner._(
          key: BuiltValueNullFieldError.checkNotNull(
              key, r'ComparableSpecificationAttributesInner', 'key'),
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'ComparableSpecificationAttributesInner', 'value'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
