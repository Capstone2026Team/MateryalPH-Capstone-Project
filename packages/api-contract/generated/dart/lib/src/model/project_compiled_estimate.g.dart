// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_compiled_estimate.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectCompiledEstimate extends ProjectCompiledEstimate {
  @override
  final String id;
  @override
  final String versionId;
  @override
  final String createdAt;
  @override
  final String expiresAt;
  @override
  final String state;
  @override
  final BuiltMap<String, JsonObject?> context;

  factory _$ProjectCompiledEstimate(
          [void Function(ProjectCompiledEstimateBuilder)? updates]) =>
      (ProjectCompiledEstimateBuilder()..update(updates))._build();

  _$ProjectCompiledEstimate._(
      {required this.id,
      required this.versionId,
      required this.createdAt,
      required this.expiresAt,
      required this.state,
      required this.context})
      : super._();
  @override
  ProjectCompiledEstimate rebuild(
          void Function(ProjectCompiledEstimateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectCompiledEstimateBuilder toBuilder() =>
      ProjectCompiledEstimateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectCompiledEstimate &&
        id == other.id &&
        versionId == other.versionId &&
        createdAt == other.createdAt &&
        expiresAt == other.expiresAt &&
        state == other.state &&
        context == other.context;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, versionId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, context.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectCompiledEstimate')
          ..add('id', id)
          ..add('versionId', versionId)
          ..add('createdAt', createdAt)
          ..add('expiresAt', expiresAt)
          ..add('state', state)
          ..add('context', context))
        .toString();
  }
}

class ProjectCompiledEstimateBuilder
    implements
        Builder<ProjectCompiledEstimate, ProjectCompiledEstimateBuilder> {
  _$ProjectCompiledEstimate? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _versionId;
  String? get versionId => _$this._versionId;
  set versionId(String? versionId) => _$this._versionId = versionId;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _expiresAt;
  String? get expiresAt => _$this._expiresAt;
  set expiresAt(String? expiresAt) => _$this._expiresAt = expiresAt;

  String? _state;
  String? get state => _$this._state;
  set state(String? state) => _$this._state = state;

  MapBuilder<String, JsonObject?>? _context;
  MapBuilder<String, JsonObject?> get context =>
      _$this._context ??= MapBuilder<String, JsonObject?>();
  set context(MapBuilder<String, JsonObject?>? context) =>
      _$this._context = context;

  ProjectCompiledEstimateBuilder() {
    ProjectCompiledEstimate._defaults(this);
  }

  ProjectCompiledEstimateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _versionId = $v.versionId;
      _createdAt = $v.createdAt;
      _expiresAt = $v.expiresAt;
      _state = $v.state;
      _context = $v.context.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectCompiledEstimate other) {
    _$v = other as _$ProjectCompiledEstimate;
  }

  @override
  void update(void Function(ProjectCompiledEstimateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectCompiledEstimate build() => _build();

  _$ProjectCompiledEstimate _build() {
    _$ProjectCompiledEstimate _$result;
    try {
      _$result = _$v ??
          _$ProjectCompiledEstimate._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ProjectCompiledEstimate', 'id'),
            versionId: BuiltValueNullFieldError.checkNotNull(
                versionId, r'ProjectCompiledEstimate', 'versionId'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'ProjectCompiledEstimate', 'createdAt'),
            expiresAt: BuiltValueNullFieldError.checkNotNull(
                expiresAt, r'ProjectCompiledEstimate', 'expiresAt'),
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'ProjectCompiledEstimate', 'state'),
            context: context.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'context';
        context.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectCompiledEstimate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
