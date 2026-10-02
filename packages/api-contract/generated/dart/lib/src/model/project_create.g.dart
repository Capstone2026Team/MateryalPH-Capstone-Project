// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectCreate extends ProjectCreate {
  @override
  final String name;
  @override
  final int budgetCentavos;
  @override
  final String startsOn;
  @override
  final String endsOn;
  @override
  final String locationId;

  factory _$ProjectCreate([void Function(ProjectCreateBuilder)? updates]) =>
      (ProjectCreateBuilder()..update(updates))._build();

  _$ProjectCreate._(
      {required this.name,
      required this.budgetCentavos,
      required this.startsOn,
      required this.endsOn,
      required this.locationId})
      : super._();
  @override
  ProjectCreate rebuild(void Function(ProjectCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectCreateBuilder toBuilder() => ProjectCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectCreate &&
        name == other.name &&
        budgetCentavos == other.budgetCentavos &&
        startsOn == other.startsOn &&
        endsOn == other.endsOn &&
        locationId == other.locationId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, budgetCentavos.hashCode);
    _$hash = $jc(_$hash, startsOn.hashCode);
    _$hash = $jc(_$hash, endsOn.hashCode);
    _$hash = $jc(_$hash, locationId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectCreate')
          ..add('name', name)
          ..add('budgetCentavos', budgetCentavos)
          ..add('startsOn', startsOn)
          ..add('endsOn', endsOn)
          ..add('locationId', locationId))
        .toString();
  }
}

class ProjectCreateBuilder
    implements Builder<ProjectCreate, ProjectCreateBuilder> {
  _$ProjectCreate? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _budgetCentavos;
  int? get budgetCentavos => _$this._budgetCentavos;
  set budgetCentavos(int? budgetCentavos) =>
      _$this._budgetCentavos = budgetCentavos;

  String? _startsOn;
  String? get startsOn => _$this._startsOn;
  set startsOn(String? startsOn) => _$this._startsOn = startsOn;

  String? _endsOn;
  String? get endsOn => _$this._endsOn;
  set endsOn(String? endsOn) => _$this._endsOn = endsOn;

  String? _locationId;
  String? get locationId => _$this._locationId;
  set locationId(String? locationId) => _$this._locationId = locationId;

  ProjectCreateBuilder() {
    ProjectCreate._defaults(this);
  }

  ProjectCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _budgetCentavos = $v.budgetCentavos;
      _startsOn = $v.startsOn;
      _endsOn = $v.endsOn;
      _locationId = $v.locationId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectCreate other) {
    _$v = other as _$ProjectCreate;
  }

  @override
  void update(void Function(ProjectCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectCreate build() => _build();

  _$ProjectCreate _build() {
    final _$result = _$v ??
        _$ProjectCreate._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ProjectCreate', 'name'),
          budgetCentavos: BuiltValueNullFieldError.checkNotNull(
              budgetCentavos, r'ProjectCreate', 'budgetCentavos'),
          startsOn: BuiltValueNullFieldError.checkNotNull(
              startsOn, r'ProjectCreate', 'startsOn'),
          endsOn: BuiltValueNullFieldError.checkNotNull(
              endsOn, r'ProjectCreate', 'endsOn'),
          locationId: BuiltValueNullFieldError.checkNotNull(
              locationId, r'ProjectCreate', 'locationId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
