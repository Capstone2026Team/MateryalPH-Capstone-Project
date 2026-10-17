// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_vendor_health_segments.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDashboardVendorHealthSegmentsStateEnum
    _$adminDashboardVendorHealthSegmentsStateEnum_OK =
    const AdminDashboardVendorHealthSegmentsStateEnum._('OK');
const AdminDashboardVendorHealthSegmentsStateEnum
    _$adminDashboardVendorHealthSegmentsStateEnum_INSUFFICIENT_DATA =
    const AdminDashboardVendorHealthSegmentsStateEnum._('INSUFFICIENT_DATA');

AdminDashboardVendorHealthSegmentsStateEnum
    _$adminDashboardVendorHealthSegmentsStateEnumValueOf(String name) {
  switch (name) {
    case 'OK':
      return _$adminDashboardVendorHealthSegmentsStateEnum_OK;
    case 'INSUFFICIENT_DATA':
      return _$adminDashboardVendorHealthSegmentsStateEnum_INSUFFICIENT_DATA;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDashboardVendorHealthSegmentsStateEnum>
    _$adminDashboardVendorHealthSegmentsStateEnumValues = BuiltSet<
        AdminDashboardVendorHealthSegmentsStateEnum>(const <AdminDashboardVendorHealthSegmentsStateEnum>[
  _$adminDashboardVendorHealthSegmentsStateEnum_OK,
  _$adminDashboardVendorHealthSegmentsStateEnum_INSUFFICIENT_DATA,
]);

Serializer<AdminDashboardVendorHealthSegmentsStateEnum>
    _$adminDashboardVendorHealthSegmentsStateEnumSerializer =
    _$AdminDashboardVendorHealthSegmentsStateEnumSerializer();

class _$AdminDashboardVendorHealthSegmentsStateEnumSerializer
    implements
        PrimitiveSerializer<AdminDashboardVendorHealthSegmentsStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OK': 'OK',
    'INSUFFICIENT_DATA': 'INSUFFICIENT_DATA',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OK': 'OK',
    'INSUFFICIENT_DATA': 'INSUFFICIENT_DATA',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDashboardVendorHealthSegmentsStateEnum
  ];
  @override
  final String wireName = 'AdminDashboardVendorHealthSegmentsStateEnum';

  @override
  Object serialize(Serializers serializers,
          AdminDashboardVendorHealthSegmentsStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminDashboardVendorHealthSegmentsStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminDashboardVendorHealthSegmentsStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminDashboardVendorHealthSegments
    extends AdminDashboardVendorHealthSegments {
  @override
  final AdminDashboardVendorHealthSegmentsStateEnum state;
  @override
  final String? reason;
  @override
  final int considered;
  @override
  final BuiltList<String> features;
  @override
  final int? k;
  @override
  final num? silhouette;
  @override
  final BuiltList<AdminDashboardVendorHealthSegmentsSegmentsInner> segments;

  factory _$AdminDashboardVendorHealthSegments(
          [void Function(AdminDashboardVendorHealthSegmentsBuilder)?
              updates]) =>
      (AdminDashboardVendorHealthSegmentsBuilder()..update(updates))._build();

  _$AdminDashboardVendorHealthSegments._(
      {required this.state,
      this.reason,
      required this.considered,
      required this.features,
      this.k,
      this.silhouette,
      required this.segments})
      : super._();
  @override
  AdminDashboardVendorHealthSegments rebuild(
          void Function(AdminDashboardVendorHealthSegmentsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardVendorHealthSegmentsBuilder toBuilder() =>
      AdminDashboardVendorHealthSegmentsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardVendorHealthSegments &&
        state == other.state &&
        reason == other.reason &&
        considered == other.considered &&
        features == other.features &&
        k == other.k &&
        silhouette == other.silhouette &&
        segments == other.segments;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, considered.hashCode);
    _$hash = $jc(_$hash, features.hashCode);
    _$hash = $jc(_$hash, k.hashCode);
    _$hash = $jc(_$hash, silhouette.hashCode);
    _$hash = $jc(_$hash, segments.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardVendorHealthSegments')
          ..add('state', state)
          ..add('reason', reason)
          ..add('considered', considered)
          ..add('features', features)
          ..add('k', k)
          ..add('silhouette', silhouette)
          ..add('segments', segments))
        .toString();
  }
}

class AdminDashboardVendorHealthSegmentsBuilder
    implements
        Builder<AdminDashboardVendorHealthSegments,
            AdminDashboardVendorHealthSegmentsBuilder> {
  _$AdminDashboardVendorHealthSegments? _$v;

  AdminDashboardVendorHealthSegmentsStateEnum? _state;
  AdminDashboardVendorHealthSegmentsStateEnum? get state => _$this._state;
  set state(AdminDashboardVendorHealthSegmentsStateEnum? state) =>
      _$this._state = state;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  int? _considered;
  int? get considered => _$this._considered;
  set considered(int? considered) => _$this._considered = considered;

  ListBuilder<String>? _features;
  ListBuilder<String> get features =>
      _$this._features ??= ListBuilder<String>();
  set features(ListBuilder<String>? features) => _$this._features = features;

  int? _k;
  int? get k => _$this._k;
  set k(int? k) => _$this._k = k;

  num? _silhouette;
  num? get silhouette => _$this._silhouette;
  set silhouette(num? silhouette) => _$this._silhouette = silhouette;

  ListBuilder<AdminDashboardVendorHealthSegmentsSegmentsInner>? _segments;
  ListBuilder<AdminDashboardVendorHealthSegmentsSegmentsInner> get segments =>
      _$this._segments ??=
          ListBuilder<AdminDashboardVendorHealthSegmentsSegmentsInner>();
  set segments(
          ListBuilder<AdminDashboardVendorHealthSegmentsSegmentsInner>?
              segments) =>
      _$this._segments = segments;

  AdminDashboardVendorHealthSegmentsBuilder() {
    AdminDashboardVendorHealthSegments._defaults(this);
  }

  AdminDashboardVendorHealthSegmentsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _state = $v.state;
      _reason = $v.reason;
      _considered = $v.considered;
      _features = $v.features.toBuilder();
      _k = $v.k;
      _silhouette = $v.silhouette;
      _segments = $v.segments.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardVendorHealthSegments other) {
    _$v = other as _$AdminDashboardVendorHealthSegments;
  }

  @override
  void update(
      void Function(AdminDashboardVendorHealthSegmentsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardVendorHealthSegments build() => _build();

  _$AdminDashboardVendorHealthSegments _build() {
    _$AdminDashboardVendorHealthSegments _$result;
    try {
      _$result = _$v ??
          _$AdminDashboardVendorHealthSegments._(
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'AdminDashboardVendorHealthSegments', 'state'),
            reason: reason,
            considered: BuiltValueNullFieldError.checkNotNull(considered,
                r'AdminDashboardVendorHealthSegments', 'considered'),
            features: features.build(),
            k: k,
            silhouette: silhouette,
            segments: segments.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'features';
        features.build();

        _$failedField = 'segments';
        segments.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminDashboardVendorHealthSegments', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
