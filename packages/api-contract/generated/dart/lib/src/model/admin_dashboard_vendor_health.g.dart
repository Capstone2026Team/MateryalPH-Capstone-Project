// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_vendor_health.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardVendorHealth extends AdminDashboardVendorHealth {
  @override
  final int total;
  @override
  final BuiltList<AdminDashboardVendorHealthClassesInner> classes;
  @override
  final BuiltList<AdminDashboardVendorHealthAttentionInner> attention;
  @override
  final AdminDashboardVendorHealthSegments segments;

  factory _$AdminDashboardVendorHealth(
          [void Function(AdminDashboardVendorHealthBuilder)? updates]) =>
      (AdminDashboardVendorHealthBuilder()..update(updates))._build();

  _$AdminDashboardVendorHealth._(
      {required this.total,
      required this.classes,
      required this.attention,
      required this.segments})
      : super._();
  @override
  AdminDashboardVendorHealth rebuild(
          void Function(AdminDashboardVendorHealthBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardVendorHealthBuilder toBuilder() =>
      AdminDashboardVendorHealthBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardVendorHealth &&
        total == other.total &&
        classes == other.classes &&
        attention == other.attention &&
        segments == other.segments;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, classes.hashCode);
    _$hash = $jc(_$hash, attention.hashCode);
    _$hash = $jc(_$hash, segments.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardVendorHealth')
          ..add('total', total)
          ..add('classes', classes)
          ..add('attention', attention)
          ..add('segments', segments))
        .toString();
  }
}

class AdminDashboardVendorHealthBuilder
    implements
        Builder<AdminDashboardVendorHealth, AdminDashboardVendorHealthBuilder> {
  _$AdminDashboardVendorHealth? _$v;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  ListBuilder<AdminDashboardVendorHealthClassesInner>? _classes;
  ListBuilder<AdminDashboardVendorHealthClassesInner> get classes =>
      _$this._classes ??= ListBuilder<AdminDashboardVendorHealthClassesInner>();
  set classes(ListBuilder<AdminDashboardVendorHealthClassesInner>? classes) =>
      _$this._classes = classes;

  ListBuilder<AdminDashboardVendorHealthAttentionInner>? _attention;
  ListBuilder<AdminDashboardVendorHealthAttentionInner> get attention =>
      _$this._attention ??=
          ListBuilder<AdminDashboardVendorHealthAttentionInner>();
  set attention(
          ListBuilder<AdminDashboardVendorHealthAttentionInner>? attention) =>
      _$this._attention = attention;

  AdminDashboardVendorHealthSegmentsBuilder? _segments;
  AdminDashboardVendorHealthSegmentsBuilder get segments =>
      _$this._segments ??= AdminDashboardVendorHealthSegmentsBuilder();
  set segments(AdminDashboardVendorHealthSegmentsBuilder? segments) =>
      _$this._segments = segments;

  AdminDashboardVendorHealthBuilder() {
    AdminDashboardVendorHealth._defaults(this);
  }

  AdminDashboardVendorHealthBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _total = $v.total;
      _classes = $v.classes.toBuilder();
      _attention = $v.attention.toBuilder();
      _segments = $v.segments.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardVendorHealth other) {
    _$v = other as _$AdminDashboardVendorHealth;
  }

  @override
  void update(void Function(AdminDashboardVendorHealthBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardVendorHealth build() => _build();

  _$AdminDashboardVendorHealth _build() {
    _$AdminDashboardVendorHealth _$result;
    try {
      _$result = _$v ??
          _$AdminDashboardVendorHealth._(
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminDashboardVendorHealth', 'total'),
            classes: classes.build(),
            attention: attention.build(),
            segments: segments.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'classes';
        classes.build();
        _$failedField = 'attention';
        attention.build();
        _$failedField = 'segments';
        segments.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminDashboardVendorHealth', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
