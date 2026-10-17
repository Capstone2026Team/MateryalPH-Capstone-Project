// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_package_budget_estimate_line_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkPackageBudgetEstimateLineInput
    extends WorkPackageBudgetEstimateLineInput {
  @override
  final String? materialId;
  @override
  final String unitId;
  @override
  final String quantity;
  @override
  final String? preferredBrand;
  @override
  final BuiltMap<String, String> specifications;

  factory _$WorkPackageBudgetEstimateLineInput(
          [void Function(WorkPackageBudgetEstimateLineInputBuilder)?
              updates]) =>
      (WorkPackageBudgetEstimateLineInputBuilder()..update(updates))._build();

  _$WorkPackageBudgetEstimateLineInput._(
      {this.materialId,
      required this.unitId,
      required this.quantity,
      this.preferredBrand,
      required this.specifications})
      : super._();
  @override
  WorkPackageBudgetEstimateLineInput rebuild(
          void Function(WorkPackageBudgetEstimateLineInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkPackageBudgetEstimateLineInputBuilder toBuilder() =>
      WorkPackageBudgetEstimateLineInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkPackageBudgetEstimateLineInput &&
        materialId == other.materialId &&
        unitId == other.unitId &&
        quantity == other.quantity &&
        preferredBrand == other.preferredBrand &&
        specifications == other.specifications;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, materialId.hashCode);
    _$hash = $jc(_$hash, unitId.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, preferredBrand.hashCode);
    _$hash = $jc(_$hash, specifications.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkPackageBudgetEstimateLineInput')
          ..add('materialId', materialId)
          ..add('unitId', unitId)
          ..add('quantity', quantity)
          ..add('preferredBrand', preferredBrand)
          ..add('specifications', specifications))
        .toString();
  }
}

class WorkPackageBudgetEstimateLineInputBuilder
    implements
        Builder<WorkPackageBudgetEstimateLineInput,
            WorkPackageBudgetEstimateLineInputBuilder> {
  _$WorkPackageBudgetEstimateLineInput? _$v;

  String? _materialId;
  String? get materialId => _$this._materialId;
  set materialId(String? materialId) => _$this._materialId = materialId;

  String? _unitId;
  String? get unitId => _$this._unitId;
  set unitId(String? unitId) => _$this._unitId = unitId;

  String? _quantity;
  String? get quantity => _$this._quantity;
  set quantity(String? quantity) => _$this._quantity = quantity;

  String? _preferredBrand;
  String? get preferredBrand => _$this._preferredBrand;
  set preferredBrand(String? preferredBrand) =>
      _$this._preferredBrand = preferredBrand;

  MapBuilder<String, String>? _specifications;
  MapBuilder<String, String> get specifications =>
      _$this._specifications ??= MapBuilder<String, String>();
  set specifications(MapBuilder<String, String>? specifications) =>
      _$this._specifications = specifications;

  WorkPackageBudgetEstimateLineInputBuilder() {
    WorkPackageBudgetEstimateLineInput._defaults(this);
  }

  WorkPackageBudgetEstimateLineInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _materialId = $v.materialId;
      _unitId = $v.unitId;
      _quantity = $v.quantity;
      _preferredBrand = $v.preferredBrand;
      _specifications = $v.specifications.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkPackageBudgetEstimateLineInput other) {
    _$v = other as _$WorkPackageBudgetEstimateLineInput;
  }

  @override
  void update(
      void Function(WorkPackageBudgetEstimateLineInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkPackageBudgetEstimateLineInput build() => _build();

  _$WorkPackageBudgetEstimateLineInput _build() {
    _$WorkPackageBudgetEstimateLineInput _$result;
    try {
      _$result = _$v ??
          _$WorkPackageBudgetEstimateLineInput._(
            materialId: materialId,
            unitId: BuiltValueNullFieldError.checkNotNull(
                unitId, r'WorkPackageBudgetEstimateLineInput', 'unitId'),
            quantity: BuiltValueNullFieldError.checkNotNull(
                quantity, r'WorkPackageBudgetEstimateLineInput', 'quantity'),
            preferredBrand: preferredBrand,
            specifications: specifications.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'specifications';
        specifications.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WorkPackageBudgetEstimateLineInput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
