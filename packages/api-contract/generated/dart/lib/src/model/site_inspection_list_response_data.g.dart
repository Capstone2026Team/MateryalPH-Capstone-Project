// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_inspection_list_response_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SiteInspectionListResponseData extends SiteInspectionListResponseData {
  @override
  final BuiltList<SiteInspection> siteInspections;

  factory _$SiteInspectionListResponseData(
          [void Function(SiteInspectionListResponseDataBuilder)? updates]) =>
      (SiteInspectionListResponseDataBuilder()..update(updates))._build();

  _$SiteInspectionListResponseData._({required this.siteInspections})
      : super._();
  @override
  SiteInspectionListResponseData rebuild(
          void Function(SiteInspectionListResponseDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SiteInspectionListResponseDataBuilder toBuilder() =>
      SiteInspectionListResponseDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SiteInspectionListResponseData &&
        siteInspections == other.siteInspections;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, siteInspections.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SiteInspectionListResponseData')
          ..add('siteInspections', siteInspections))
        .toString();
  }
}

class SiteInspectionListResponseDataBuilder
    implements
        Builder<SiteInspectionListResponseData,
            SiteInspectionListResponseDataBuilder> {
  _$SiteInspectionListResponseData? _$v;

  ListBuilder<SiteInspection>? _siteInspections;
  ListBuilder<SiteInspection> get siteInspections =>
      _$this._siteInspections ??= ListBuilder<SiteInspection>();
  set siteInspections(ListBuilder<SiteInspection>? siteInspections) =>
      _$this._siteInspections = siteInspections;

  SiteInspectionListResponseDataBuilder() {
    SiteInspectionListResponseData._defaults(this);
  }

  SiteInspectionListResponseDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _siteInspections = $v.siteInspections.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SiteInspectionListResponseData other) {
    _$v = other as _$SiteInspectionListResponseData;
  }

  @override
  void update(void Function(SiteInspectionListResponseDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SiteInspectionListResponseData build() => _build();

  _$SiteInspectionListResponseData _build() {
    _$SiteInspectionListResponseData _$result;
    try {
      _$result = _$v ??
          _$SiteInspectionListResponseData._(
            siteInspections: siteInspections.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'siteInspections';
        siteInspections.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SiteInspectionListResponseData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
