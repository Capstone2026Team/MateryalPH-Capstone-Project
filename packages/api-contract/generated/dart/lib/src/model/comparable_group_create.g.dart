// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comparable_group_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ComparableGroupCreate extends ComparableGroupCreate {
  @override
  final String materialId;
  @override
  final String code;
  @override
  final String displayName;
  @override
  final String? brand;
  @override
  final String? model;
  @override
  final BuiltMap<String, String> specification;
  @override
  final String canonicalUnitId;
  @override
  final String? conversionVersion;

  factory _$ComparableGroupCreate(
          [void Function(ComparableGroupCreateBuilder)? updates]) =>
      (ComparableGroupCreateBuilder()..update(updates))._build();

  _$ComparableGroupCreate._(
      {required this.materialId,
      required this.code,
      required this.displayName,
      this.brand,
      this.model,
      required this.specification,
      required this.canonicalUnitId,
      this.conversionVersion})
      : super._();
  @override
  ComparableGroupCreate rebuild(
          void Function(ComparableGroupCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComparableGroupCreateBuilder toBuilder() =>
      ComparableGroupCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComparableGroupCreate &&
        materialId == other.materialId &&
        code == other.code &&
        displayName == other.displayName &&
        brand == other.brand &&
        model == other.model &&
        specification == other.specification &&
        canonicalUnitId == other.canonicalUnitId &&
        conversionVersion == other.conversionVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, materialId.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, model.hashCode);
    _$hash = $jc(_$hash, specification.hashCode);
    _$hash = $jc(_$hash, canonicalUnitId.hashCode);
    _$hash = $jc(_$hash, conversionVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ComparableGroupCreate')
          ..add('materialId', materialId)
          ..add('code', code)
          ..add('displayName', displayName)
          ..add('brand', brand)
          ..add('model', model)
          ..add('specification', specification)
          ..add('canonicalUnitId', canonicalUnitId)
          ..add('conversionVersion', conversionVersion))
        .toString();
  }
}

class ComparableGroupCreateBuilder
    implements Builder<ComparableGroupCreate, ComparableGroupCreateBuilder> {
  _$ComparableGroupCreate? _$v;

  String? _materialId;
  String? get materialId => _$this._materialId;
  set materialId(String? materialId) => _$this._materialId = materialId;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _brand;
  String? get brand => _$this._brand;
  set brand(String? brand) => _$this._brand = brand;

  String? _model;
  String? get model => _$this._model;
  set model(String? model) => _$this._model = model;

  MapBuilder<String, String>? _specification;
  MapBuilder<String, String> get specification =>
      _$this._specification ??= MapBuilder<String, String>();
  set specification(MapBuilder<String, String>? specification) =>
      _$this._specification = specification;

  String? _canonicalUnitId;
  String? get canonicalUnitId => _$this._canonicalUnitId;
  set canonicalUnitId(String? canonicalUnitId) =>
      _$this._canonicalUnitId = canonicalUnitId;

  String? _conversionVersion;
  String? get conversionVersion => _$this._conversionVersion;
  set conversionVersion(String? conversionVersion) =>
      _$this._conversionVersion = conversionVersion;

  ComparableGroupCreateBuilder() {
    ComparableGroupCreate._defaults(this);
  }

  ComparableGroupCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _materialId = $v.materialId;
      _code = $v.code;
      _displayName = $v.displayName;
      _brand = $v.brand;
      _model = $v.model;
      _specification = $v.specification.toBuilder();
      _canonicalUnitId = $v.canonicalUnitId;
      _conversionVersion = $v.conversionVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComparableGroupCreate other) {
    _$v = other as _$ComparableGroupCreate;
  }

  @override
  void update(void Function(ComparableGroupCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComparableGroupCreate build() => _build();

  _$ComparableGroupCreate _build() {
    _$ComparableGroupCreate _$result;
    try {
      _$result = _$v ??
          _$ComparableGroupCreate._(
            materialId: BuiltValueNullFieldError.checkNotNull(
                materialId, r'ComparableGroupCreate', 'materialId'),
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'ComparableGroupCreate', 'code'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'ComparableGroupCreate', 'displayName'),
            brand: brand,
            model: model,
            specification: specification.build(),
            canonicalUnitId: BuiltValueNullFieldError.checkNotNull(
                canonicalUnitId, r'ComparableGroupCreate', 'canonicalUnitId'),
            conversionVersion: conversionVersion,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'specification';
        specification.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ComparableGroupCreate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
