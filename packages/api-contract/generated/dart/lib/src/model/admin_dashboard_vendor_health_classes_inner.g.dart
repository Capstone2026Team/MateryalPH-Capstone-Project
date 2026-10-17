// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_vendor_health_classes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDashboardVendorHealthClassesInnerKeyEnum
    _$adminDashboardVendorHealthClassesInnerKeyEnum_HEALTHY =
    const AdminDashboardVendorHealthClassesInnerKeyEnum._('HEALTHY');
const AdminDashboardVendorHealthClassesInnerKeyEnum
    _$adminDashboardVendorHealthClassesInnerKeyEnum_WATCH =
    const AdminDashboardVendorHealthClassesInnerKeyEnum._('WATCH');
const AdminDashboardVendorHealthClassesInnerKeyEnum
    _$adminDashboardVendorHealthClassesInnerKeyEnum_BELOW_WATCH_LEVEL =
    const AdminDashboardVendorHealthClassesInnerKeyEnum._('BELOW_WATCH_LEVEL');
const AdminDashboardVendorHealthClassesInnerKeyEnum
    _$adminDashboardVendorHealthClassesInnerKeyEnum_BUILDING_TRACK_RECORD =
    const AdminDashboardVendorHealthClassesInnerKeyEnum._(
        'BUILDING_TRACK_RECORD');

AdminDashboardVendorHealthClassesInnerKeyEnum
    _$adminDashboardVendorHealthClassesInnerKeyEnumValueOf(String name) {
  switch (name) {
    case 'HEALTHY':
      return _$adminDashboardVendorHealthClassesInnerKeyEnum_HEALTHY;
    case 'WATCH':
      return _$adminDashboardVendorHealthClassesInnerKeyEnum_WATCH;
    case 'BELOW_WATCH_LEVEL':
      return _$adminDashboardVendorHealthClassesInnerKeyEnum_BELOW_WATCH_LEVEL;
    case 'BUILDING_TRACK_RECORD':
      return _$adminDashboardVendorHealthClassesInnerKeyEnum_BUILDING_TRACK_RECORD;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDashboardVendorHealthClassesInnerKeyEnum>
    _$adminDashboardVendorHealthClassesInnerKeyEnumValues = BuiltSet<
        AdminDashboardVendorHealthClassesInnerKeyEnum>(const <AdminDashboardVendorHealthClassesInnerKeyEnum>[
  _$adminDashboardVendorHealthClassesInnerKeyEnum_HEALTHY,
  _$adminDashboardVendorHealthClassesInnerKeyEnum_WATCH,
  _$adminDashboardVendorHealthClassesInnerKeyEnum_BELOW_WATCH_LEVEL,
  _$adminDashboardVendorHealthClassesInnerKeyEnum_BUILDING_TRACK_RECORD,
]);

Serializer<AdminDashboardVendorHealthClassesInnerKeyEnum>
    _$adminDashboardVendorHealthClassesInnerKeyEnumSerializer =
    _$AdminDashboardVendorHealthClassesInnerKeyEnumSerializer();

class _$AdminDashboardVendorHealthClassesInnerKeyEnumSerializer
    implements
        PrimitiveSerializer<AdminDashboardVendorHealthClassesInnerKeyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'HEALTHY': 'HEALTHY',
    'WATCH': 'WATCH',
    'BELOW_WATCH_LEVEL': 'BELOW_WATCH_LEVEL',
    'BUILDING_TRACK_RECORD': 'BUILDING_TRACK_RECORD',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'HEALTHY': 'HEALTHY',
    'WATCH': 'WATCH',
    'BELOW_WATCH_LEVEL': 'BELOW_WATCH_LEVEL',
    'BUILDING_TRACK_RECORD': 'BUILDING_TRACK_RECORD',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDashboardVendorHealthClassesInnerKeyEnum
  ];
  @override
  final String wireName = 'AdminDashboardVendorHealthClassesInnerKeyEnum';

  @override
  Object serialize(Serializers serializers,
          AdminDashboardVendorHealthClassesInnerKeyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminDashboardVendorHealthClassesInnerKeyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminDashboardVendorHealthClassesInnerKeyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminDashboardVendorHealthClassesInner
    extends AdminDashboardVendorHealthClassesInner {
  @override
  final AdminDashboardVendorHealthClassesInnerKeyEnum key;
  @override
  final String label;
  @override
  final int count;

  factory _$AdminDashboardVendorHealthClassesInner(
          [void Function(AdminDashboardVendorHealthClassesInnerBuilder)?
              updates]) =>
      (AdminDashboardVendorHealthClassesInnerBuilder()..update(updates))
          ._build();

  _$AdminDashboardVendorHealthClassesInner._(
      {required this.key, required this.label, required this.count})
      : super._();
  @override
  AdminDashboardVendorHealthClassesInner rebuild(
          void Function(AdminDashboardVendorHealthClassesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardVendorHealthClassesInnerBuilder toBuilder() =>
      AdminDashboardVendorHealthClassesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardVendorHealthClassesInner &&
        key == other.key &&
        label == other.label &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminDashboardVendorHealthClassesInner')
          ..add('key', key)
          ..add('label', label)
          ..add('count', count))
        .toString();
  }
}

class AdminDashboardVendorHealthClassesInnerBuilder
    implements
        Builder<AdminDashboardVendorHealthClassesInner,
            AdminDashboardVendorHealthClassesInnerBuilder> {
  _$AdminDashboardVendorHealthClassesInner? _$v;

  AdminDashboardVendorHealthClassesInnerKeyEnum? _key;
  AdminDashboardVendorHealthClassesInnerKeyEnum? get key => _$this._key;
  set key(AdminDashboardVendorHealthClassesInnerKeyEnum? key) =>
      _$this._key = key;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  AdminDashboardVendorHealthClassesInnerBuilder() {
    AdminDashboardVendorHealthClassesInner._defaults(this);
  }

  AdminDashboardVendorHealthClassesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _label = $v.label;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardVendorHealthClassesInner other) {
    _$v = other as _$AdminDashboardVendorHealthClassesInner;
  }

  @override
  void update(
      void Function(AdminDashboardVendorHealthClassesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardVendorHealthClassesInner build() => _build();

  _$AdminDashboardVendorHealthClassesInner _build() {
    final _$result = _$v ??
        _$AdminDashboardVendorHealthClassesInner._(
          key: BuiltValueNullFieldError.checkNotNull(
              key, r'AdminDashboardVendorHealthClassesInner', 'key'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'AdminDashboardVendorHealthClassesInner', 'label'),
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'AdminDashboardVendorHealthClassesInner', 'count'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
