// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comparable_specification.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ComparableSpecification extends ComparableSpecification {
  @override
  final String? brand;
  @override
  final String? model;
  @override
  final BuiltList<ComparableSpecificationAttributesInner> attributes;

  factory _$ComparableSpecification(
          [void Function(ComparableSpecificationBuilder)? updates]) =>
      (ComparableSpecificationBuilder()..update(updates))._build();

  _$ComparableSpecification._(
      {this.brand, this.model, required this.attributes})
      : super._();
  @override
  ComparableSpecification rebuild(
          void Function(ComparableSpecificationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComparableSpecificationBuilder toBuilder() =>
      ComparableSpecificationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComparableSpecification &&
        brand == other.brand &&
        model == other.model &&
        attributes == other.attributes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, model.hashCode);
    _$hash = $jc(_$hash, attributes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ComparableSpecification')
          ..add('brand', brand)
          ..add('model', model)
          ..add('attributes', attributes))
        .toString();
  }
}

class ComparableSpecificationBuilder
    implements
        Builder<ComparableSpecification, ComparableSpecificationBuilder> {
  _$ComparableSpecification? _$v;

  String? _brand;
  String? get brand => _$this._brand;
  set brand(String? brand) => _$this._brand = brand;

  String? _model;
  String? get model => _$this._model;
  set model(String? model) => _$this._model = model;

  ListBuilder<ComparableSpecificationAttributesInner>? _attributes;
  ListBuilder<ComparableSpecificationAttributesInner> get attributes =>
      _$this._attributes ??=
          ListBuilder<ComparableSpecificationAttributesInner>();
  set attributes(
          ListBuilder<ComparableSpecificationAttributesInner>? attributes) =>
      _$this._attributes = attributes;

  ComparableSpecificationBuilder() {
    ComparableSpecification._defaults(this);
  }

  ComparableSpecificationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _brand = $v.brand;
      _model = $v.model;
      _attributes = $v.attributes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComparableSpecification other) {
    _$v = other as _$ComparableSpecification;
  }

  @override
  void update(void Function(ComparableSpecificationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComparableSpecification build() => _build();

  _$ComparableSpecification _build() {
    _$ComparableSpecification _$result;
    try {
      _$result = _$v ??
          _$ComparableSpecification._(
            brand: brand,
            model: model,
            attributes: attributes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'attributes';
        attributes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ComparableSpecification', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
