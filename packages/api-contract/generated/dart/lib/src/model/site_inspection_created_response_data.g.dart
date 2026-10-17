// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_inspection_created_response_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SiteInspectionCreatedResponseData
    extends SiteInspectionCreatedResponseData {
  @override
  final String id;
  @override
  final String conversationId;

  factory _$SiteInspectionCreatedResponseData(
          [void Function(SiteInspectionCreatedResponseDataBuilder)? updates]) =>
      (SiteInspectionCreatedResponseDataBuilder()..update(updates))._build();

  _$SiteInspectionCreatedResponseData._(
      {required this.id, required this.conversationId})
      : super._();
  @override
  SiteInspectionCreatedResponseData rebuild(
          void Function(SiteInspectionCreatedResponseDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SiteInspectionCreatedResponseDataBuilder toBuilder() =>
      SiteInspectionCreatedResponseDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SiteInspectionCreatedResponseData &&
        id == other.id &&
        conversationId == other.conversationId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, conversationId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SiteInspectionCreatedResponseData')
          ..add('id', id)
          ..add('conversationId', conversationId))
        .toString();
  }
}

class SiteInspectionCreatedResponseDataBuilder
    implements
        Builder<SiteInspectionCreatedResponseData,
            SiteInspectionCreatedResponseDataBuilder> {
  _$SiteInspectionCreatedResponseData? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _conversationId;
  String? get conversationId => _$this._conversationId;
  set conversationId(String? conversationId) =>
      _$this._conversationId = conversationId;

  SiteInspectionCreatedResponseDataBuilder() {
    SiteInspectionCreatedResponseData._defaults(this);
  }

  SiteInspectionCreatedResponseDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _conversationId = $v.conversationId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SiteInspectionCreatedResponseData other) {
    _$v = other as _$SiteInspectionCreatedResponseData;
  }

  @override
  void update(
      void Function(SiteInspectionCreatedResponseDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SiteInspectionCreatedResponseData build() => _build();

  _$SiteInspectionCreatedResponseData _build() {
    final _$result = _$v ??
        _$SiteInspectionCreatedResponseData._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'SiteInspectionCreatedResponseData', 'id'),
          conversationId: BuiltValueNullFieldError.checkNotNull(conversationId,
              r'SiteInspectionCreatedResponseData', 'conversationId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
