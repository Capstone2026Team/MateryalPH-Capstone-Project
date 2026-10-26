// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_material_unit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectMaterialUnit extends ProjectMaterialUnit {
  @override
  final QuantityPolicy? quantityPolicy;
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final int precision;

  factory _$ProjectMaterialUnit(
          [void Function(ProjectMaterialUnitBuilder)? updates]) =>
      (ProjectMaterialUnitBuilder()..update(updates))._build();

  _$ProjectMaterialUnit._(
      {this.quantityPolicy,
      required this.id,
      required this.code,
      required this.name,
      required this.precision})
      : super._();
  @override
  ProjectMaterialUnit rebuild(
          void Function(ProjectMaterialUnitBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectMaterialUnitBuilder toBuilder() =>
      ProjectMaterialUnitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectMaterialUnit &&
        quantityPolicy == other.quantityPolicy &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        precision == other.precision;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, quantityPolicy.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, precision.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectMaterialUnit')
          ..add('quantityPolicy', quantityPolicy)
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('precision', precision))
        .toString();
  }
}

class ProjectMaterialUnitBuilder
    implements Builder<ProjectMaterialUnit, ProjectMaterialUnitBuilder> {
  _$ProjectMaterialUnit? _$v;

  QuantityPolicyBuilder? _quantityPolicy;
  QuantityPolicyBuilder get quantityPolicy =>
      _$this._quantityPolicy ??= QuantityPolicyBuilder();
  set quantityPolicy(QuantityPolicyBuilder? quantityPolicy) =>
      _$this._quantityPolicy = quantityPolicy;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _precision;
  int? get precision => _$this._precision;
  set precision(int? precision) => _$this._precision = precision;

  ProjectMaterialUnitBuilder() {
    ProjectMaterialUnit._defaults(this);
  }

  ProjectMaterialUnitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _quantityPolicy = $v.quantityPolicy?.toBuilder();
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _precision = $v.precision;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectMaterialUnit other) {
    _$v = other as _$ProjectMaterialUnit;
  }

  @override
  void update(void Function(ProjectMaterialUnitBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectMaterialUnit build() => _build();

  _$ProjectMaterialUnit _build() {
    _$ProjectMaterialUnit _$result;
    try {
      _$result = _$v ??
          _$ProjectMaterialUnit._(
            quantityPolicy: _quantityPolicy?.build(),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ProjectMaterialUnit', 'id'),
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'ProjectMaterialUnit', 'code'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'ProjectMaterialUnit', 'name'),
            precision: BuiltValueNullFieldError.checkNotNull(
                precision, r'ProjectMaterialUnit', 'precision'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'quantityPolicy';
        _quantityPolicy?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectMaterialUnit', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
