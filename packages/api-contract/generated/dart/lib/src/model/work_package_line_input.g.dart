// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_package_line_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkPackageLineInput extends WorkPackageLineInput {
  @override
  final String materialId;
  @override
  final String name;
  @override
  final String unitId;
  @override
  final String quantity;
  @override
  final BuiltMap<String, String> specifications;
  @override
  final String? preferredBrand;

  factory _$WorkPackageLineInput(
          [void Function(WorkPackageLineInputBuilder)? updates]) =>
      (WorkPackageLineInputBuilder()..update(updates))._build();

  _$WorkPackageLineInput._(
      {required this.materialId,
      required this.name,
      required this.unitId,
      required this.quantity,
      required this.specifications,
      this.preferredBrand})
      : super._();
  @override
  WorkPackageLineInput rebuild(
          void Function(WorkPackageLineInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkPackageLineInputBuilder toBuilder() =>
      WorkPackageLineInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkPackageLineInput &&
        materialId == other.materialId &&
        name == other.name &&
        unitId == other.unitId &&
        quantity == other.quantity &&
        specifications == other.specifications &&
        preferredBrand == other.preferredBrand;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, materialId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, unitId.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, specifications.hashCode);
    _$hash = $jc(_$hash, preferredBrand.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkPackageLineInput')
          ..add('materialId', materialId)
          ..add('name', name)
          ..add('unitId', unitId)
          ..add('quantity', quantity)
          ..add('specifications', specifications)
          ..add('preferredBrand', preferredBrand))
        .toString();
  }
}

class WorkPackageLineInputBuilder
    implements Builder<WorkPackageLineInput, WorkPackageLineInputBuilder> {
  _$WorkPackageLineInput? _$v;

  String? _materialId;
  String? get materialId => _$this._materialId;
  set materialId(String? materialId) => _$this._materialId = materialId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _unitId;
  String? get unitId => _$this._unitId;
  set unitId(String? unitId) => _$this._unitId = unitId;

  String? _quantity;
  String? get quantity => _$this._quantity;
  set quantity(String? quantity) => _$this._quantity = quantity;

  MapBuilder<String, String>? _specifications;
  MapBuilder<String, String> get specifications =>
      _$this._specifications ??= MapBuilder<String, String>();
  set specifications(MapBuilder<String, String>? specifications) =>
      _$this._specifications = specifications;

  String? _preferredBrand;
  String? get preferredBrand => _$this._preferredBrand;
  set preferredBrand(String? preferredBrand) =>
      _$this._preferredBrand = preferredBrand;

  WorkPackageLineInputBuilder() {
    WorkPackageLineInput._defaults(this);
  }

  WorkPackageLineInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _materialId = $v.materialId;
      _name = $v.name;
      _unitId = $v.unitId;
      _quantity = $v.quantity;
      _specifications = $v.specifications.toBuilder();
      _preferredBrand = $v.preferredBrand;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkPackageLineInput other) {
    _$v = other as _$WorkPackageLineInput;
  }

  @override
  void update(void Function(WorkPackageLineInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkPackageLineInput build() => _build();

  _$WorkPackageLineInput _build() {
    _$WorkPackageLineInput _$result;
    try {
      _$result = _$v ??
          _$WorkPackageLineInput._(
            materialId: BuiltValueNullFieldError.checkNotNull(
                materialId, r'WorkPackageLineInput', 'materialId'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'WorkPackageLineInput', 'name'),
            unitId: BuiltValueNullFieldError.checkNotNull(
                unitId, r'WorkPackageLineInput', 'unitId'),
            quantity: BuiltValueNullFieldError.checkNotNull(
                quantity, r'WorkPackageLineInput', 'quantity'),
            specifications: specifications.build(),
            preferredBrand: preferredBrand,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'specifications';
        specifications.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WorkPackageLineInput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
