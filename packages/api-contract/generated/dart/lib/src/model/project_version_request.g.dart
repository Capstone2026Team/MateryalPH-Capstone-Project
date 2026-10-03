// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_version_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectVersionRequest extends ProjectVersionRequest {
  @override
  final int lockVersion;

  factory _$ProjectVersionRequest(
          [void Function(ProjectVersionRequestBuilder)? updates]) =>
      (ProjectVersionRequestBuilder()..update(updates))._build();

  _$ProjectVersionRequest._({required this.lockVersion}) : super._();
  @override
  ProjectVersionRequest rebuild(
          void Function(ProjectVersionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectVersionRequestBuilder toBuilder() =>
      ProjectVersionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectVersionRequest && lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectVersionRequest')
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class ProjectVersionRequestBuilder
    implements Builder<ProjectVersionRequest, ProjectVersionRequestBuilder> {
  _$ProjectVersionRequest? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  ProjectVersionRequestBuilder() {
    ProjectVersionRequest._defaults(this);
  }

  ProjectVersionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectVersionRequest other) {
    _$v = other as _$ProjectVersionRequest;
  }

  @override
  void update(void Function(ProjectVersionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectVersionRequest build() => _build();

  _$ProjectVersionRequest _build() {
    final _$result = _$v ??
        _$ProjectVersionRequest._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'ProjectVersionRequest', 'lockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
