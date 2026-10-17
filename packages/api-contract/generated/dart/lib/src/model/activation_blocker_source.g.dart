// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activation_blocker_source.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ActivationBlockerSource extends ActivationBlockerSource {
  @override
  final String? type;
  @override
  final String? label;
  @override
  final int? revision;
  @override
  final String? status;
  @override
  final DateTime? updatedAt;

  factory _$ActivationBlockerSource(
          [void Function(ActivationBlockerSourceBuilder)? updates]) =>
      (ActivationBlockerSourceBuilder()..update(updates))._build();

  _$ActivationBlockerSource._(
      {this.type, this.label, this.revision, this.status, this.updatedAt})
      : super._();
  @override
  ActivationBlockerSource rebuild(
          void Function(ActivationBlockerSourceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ActivationBlockerSourceBuilder toBuilder() =>
      ActivationBlockerSourceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ActivationBlockerSource &&
        type == other.type &&
        label == other.label &&
        revision == other.revision &&
        status == other.status &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, revision.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ActivationBlockerSource')
          ..add('type', type)
          ..add('label', label)
          ..add('revision', revision)
          ..add('status', status)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ActivationBlockerSourceBuilder
    implements
        Builder<ActivationBlockerSource, ActivationBlockerSourceBuilder> {
  _$ActivationBlockerSource? _$v;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  int? _revision;
  int? get revision => _$this._revision;
  set revision(int? revision) => _$this._revision = revision;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ActivationBlockerSourceBuilder() {
    ActivationBlockerSource._defaults(this);
  }

  ActivationBlockerSourceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _label = $v.label;
      _revision = $v.revision;
      _status = $v.status;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ActivationBlockerSource other) {
    _$v = other as _$ActivationBlockerSource;
  }

  @override
  void update(void Function(ActivationBlockerSourceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ActivationBlockerSource build() => _build();

  _$ActivationBlockerSource _build() {
    final _$result = _$v ??
        _$ActivationBlockerSource._(
          type: type,
          label: label,
          revision: revision,
          status: status,
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
