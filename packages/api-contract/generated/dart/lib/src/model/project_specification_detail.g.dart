// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_specification_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectSpecificationDetail extends ProjectSpecificationDetail {
  @override
  final String code;
  @override
  final String label;
  @override
  final String value;
  @override
  final String? unitCode;

  factory _$ProjectSpecificationDetail(
          [void Function(ProjectSpecificationDetailBuilder)? updates]) =>
      (ProjectSpecificationDetailBuilder()..update(updates))._build();

  _$ProjectSpecificationDetail._(
      {required this.code,
      required this.label,
      required this.value,
      this.unitCode})
      : super._();
  @override
  ProjectSpecificationDetail rebuild(
          void Function(ProjectSpecificationDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectSpecificationDetailBuilder toBuilder() =>
      ProjectSpecificationDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectSpecificationDetail &&
        code == other.code &&
        label == other.label &&
        value == other.value &&
        unitCode == other.unitCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, unitCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectSpecificationDetail')
          ..add('code', code)
          ..add('label', label)
          ..add('value', value)
          ..add('unitCode', unitCode))
        .toString();
  }
}

class ProjectSpecificationDetailBuilder
    implements
        Builder<ProjectSpecificationDetail, ProjectSpecificationDetailBuilder> {
  _$ProjectSpecificationDetail? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  String? _unitCode;
  String? get unitCode => _$this._unitCode;
  set unitCode(String? unitCode) => _$this._unitCode = unitCode;

  ProjectSpecificationDetailBuilder() {
    ProjectSpecificationDetail._defaults(this);
  }

  ProjectSpecificationDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _label = $v.label;
      _value = $v.value;
      _unitCode = $v.unitCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectSpecificationDetail other) {
    _$v = other as _$ProjectSpecificationDetail;
  }

  @override
  void update(void Function(ProjectSpecificationDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectSpecificationDetail build() => _build();

  _$ProjectSpecificationDetail _build() {
    final _$result = _$v ??
        _$ProjectSpecificationDetail._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'ProjectSpecificationDetail', 'code'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'ProjectSpecificationDetail', 'label'),
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'ProjectSpecificationDetail', 'value'),
          unitCode: unitCode,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
