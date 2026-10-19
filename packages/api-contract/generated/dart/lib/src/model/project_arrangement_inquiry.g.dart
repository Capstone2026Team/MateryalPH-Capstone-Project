// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_arrangement_inquiry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectArrangementInquiry extends ProjectArrangementInquiry {
  @override
  final int version;

  factory _$ProjectArrangementInquiry(
          [void Function(ProjectArrangementInquiryBuilder)? updates]) =>
      (ProjectArrangementInquiryBuilder()..update(updates))._build();

  _$ProjectArrangementInquiry._({required this.version}) : super._();
  @override
  ProjectArrangementInquiry rebuild(
          void Function(ProjectArrangementInquiryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectArrangementInquiryBuilder toBuilder() =>
      ProjectArrangementInquiryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectArrangementInquiry && version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectArrangementInquiry')
          ..add('version', version))
        .toString();
  }
}

class ProjectArrangementInquiryBuilder
    implements
        Builder<ProjectArrangementInquiry, ProjectArrangementInquiryBuilder> {
  _$ProjectArrangementInquiry? _$v;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  ProjectArrangementInquiryBuilder() {
    ProjectArrangementInquiry._defaults(this);
  }

  ProjectArrangementInquiryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectArrangementInquiry other) {
    _$v = other as _$ProjectArrangementInquiry;
  }

  @override
  void update(void Function(ProjectArrangementInquiryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectArrangementInquiry build() => _build();

  _$ProjectArrangementInquiry _build() {
    final _$result = _$v ??
        _$ProjectArrangementInquiry._(
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'ProjectArrangementInquiry', 'version'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
