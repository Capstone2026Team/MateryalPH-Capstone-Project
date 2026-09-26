// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_store_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicStoreSummary extends PublicStoreSummary {
  @override
  final String id;
  @override
  final bool vacationMode;
  @override
  final String publicStoreName;
  @override
  final String? description;

  factory _$PublicStoreSummary(
          [void Function(PublicStoreSummaryBuilder)? updates]) =>
      (PublicStoreSummaryBuilder()..update(updates))._build();

  _$PublicStoreSummary._(
      {required this.id,
      required this.vacationMode,
      required this.publicStoreName,
      this.description})
      : super._();
  @override
  PublicStoreSummary rebuild(
          void Function(PublicStoreSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicStoreSummaryBuilder toBuilder() =>
      PublicStoreSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicStoreSummary &&
        id == other.id &&
        vacationMode == other.vacationMode &&
        publicStoreName == other.publicStoreName &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, vacationMode.hashCode);
    _$hash = $jc(_$hash, publicStoreName.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicStoreSummary')
          ..add('id', id)
          ..add('vacationMode', vacationMode)
          ..add('publicStoreName', publicStoreName)
          ..add('description', description))
        .toString();
  }
}

class PublicStoreSummaryBuilder
    implements Builder<PublicStoreSummary, PublicStoreSummaryBuilder> {
  _$PublicStoreSummary? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  bool? _vacationMode;
  bool? get vacationMode => _$this._vacationMode;
  set vacationMode(bool? vacationMode) => _$this._vacationMode = vacationMode;

  String? _publicStoreName;
  String? get publicStoreName => _$this._publicStoreName;
  set publicStoreName(String? publicStoreName) =>
      _$this._publicStoreName = publicStoreName;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  PublicStoreSummaryBuilder() {
    PublicStoreSummary._defaults(this);
  }

  PublicStoreSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _vacationMode = $v.vacationMode;
      _publicStoreName = $v.publicStoreName;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicStoreSummary other) {
    _$v = other as _$PublicStoreSummary;
  }

  @override
  void update(void Function(PublicStoreSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicStoreSummary build() => _build();

  _$PublicStoreSummary _build() {
    final _$result = _$v ??
        _$PublicStoreSummary._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'PublicStoreSummary', 'id'),
          vacationMode: BuiltValueNullFieldError.checkNotNull(
              vacationMode, r'PublicStoreSummary', 'vacationMode'),
          publicStoreName: BuiltValueNullFieldError.checkNotNull(
              publicStoreName, r'PublicStoreSummary', 'publicStoreName'),
          description: description,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
