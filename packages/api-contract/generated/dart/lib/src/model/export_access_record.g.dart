// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_access_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExportAccessRecord extends ExportAccessRecord {
  @override
  final String action;
  @override
  final String occurredAt;

  factory _$ExportAccessRecord(
          [void Function(ExportAccessRecordBuilder)? updates]) =>
      (ExportAccessRecordBuilder()..update(updates))._build();

  _$ExportAccessRecord._({required this.action, required this.occurredAt})
      : super._();
  @override
  ExportAccessRecord rebuild(
          void Function(ExportAccessRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExportAccessRecordBuilder toBuilder() =>
      ExportAccessRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExportAccessRecord &&
        action == other.action &&
        occurredAt == other.occurredAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExportAccessRecord')
          ..add('action', action)
          ..add('occurredAt', occurredAt))
        .toString();
  }
}

class ExportAccessRecordBuilder
    implements Builder<ExportAccessRecord, ExportAccessRecordBuilder> {
  _$ExportAccessRecord? _$v;

  String? _action;
  String? get action => _$this._action;
  set action(String? action) => _$this._action = action;

  String? _occurredAt;
  String? get occurredAt => _$this._occurredAt;
  set occurredAt(String? occurredAt) => _$this._occurredAt = occurredAt;

  ExportAccessRecordBuilder() {
    ExportAccessRecord._defaults(this);
  }

  ExportAccessRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _action = $v.action;
      _occurredAt = $v.occurredAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExportAccessRecord other) {
    _$v = other as _$ExportAccessRecord;
  }

  @override
  void update(void Function(ExportAccessRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExportAccessRecord build() => _build();

  _$ExportAccessRecord _build() {
    final _$result = _$v ??
        _$ExportAccessRecord._(
          action: BuiltValueNullFieldError.checkNotNull(
              action, r'ExportAccessRecord', 'action'),
          occurredAt: BuiltValueNullFieldError.checkNotNull(
              occurredAt, r'ExportAccessRecord', 'occurredAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
