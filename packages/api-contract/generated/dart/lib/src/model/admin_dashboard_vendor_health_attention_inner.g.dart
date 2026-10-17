// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_vendor_health_attention_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDashboardVendorHealthAttentionInnerClass_Enum
    _$adminDashboardVendorHealthAttentionInnerClassEnum_BELOW_WATCH_LEVEL =
    const AdminDashboardVendorHealthAttentionInnerClass_Enum._(
        'BELOW_WATCH_LEVEL');
const AdminDashboardVendorHealthAttentionInnerClass_Enum
    _$adminDashboardVendorHealthAttentionInnerClassEnum_WATCH =
    const AdminDashboardVendorHealthAttentionInnerClass_Enum._('WATCH');

AdminDashboardVendorHealthAttentionInnerClass_Enum
    _$adminDashboardVendorHealthAttentionInnerClassEnumValueOf(String name) {
  switch (name) {
    case 'BELOW_WATCH_LEVEL':
      return _$adminDashboardVendorHealthAttentionInnerClassEnum_BELOW_WATCH_LEVEL;
    case 'WATCH':
      return _$adminDashboardVendorHealthAttentionInnerClassEnum_WATCH;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDashboardVendorHealthAttentionInnerClass_Enum>
    _$adminDashboardVendorHealthAttentionInnerClassEnumValues = BuiltSet<
        AdminDashboardVendorHealthAttentionInnerClass_Enum>(const <AdminDashboardVendorHealthAttentionInnerClass_Enum>[
  _$adminDashboardVendorHealthAttentionInnerClassEnum_BELOW_WATCH_LEVEL,
  _$adminDashboardVendorHealthAttentionInnerClassEnum_WATCH,
]);

Serializer<AdminDashboardVendorHealthAttentionInnerClass_Enum>
    _$adminDashboardVendorHealthAttentionInnerClassEnumSerializer =
    _$AdminDashboardVendorHealthAttentionInnerClass_EnumSerializer();

class _$AdminDashboardVendorHealthAttentionInnerClass_EnumSerializer
    implements
        PrimitiveSerializer<
            AdminDashboardVendorHealthAttentionInnerClass_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BELOW_WATCH_LEVEL': 'BELOW_WATCH_LEVEL',
    'WATCH': 'WATCH',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BELOW_WATCH_LEVEL': 'BELOW_WATCH_LEVEL',
    'WATCH': 'WATCH',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDashboardVendorHealthAttentionInnerClass_Enum
  ];
  @override
  final String wireName = 'AdminDashboardVendorHealthAttentionInnerClass_Enum';

  @override
  Object serialize(Serializers serializers,
          AdminDashboardVendorHealthAttentionInnerClass_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminDashboardVendorHealthAttentionInnerClass_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminDashboardVendorHealthAttentionInnerClass_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminDashboardVendorHealthAttentionInner
    extends AdminDashboardVendorHealthAttentionInner {
  @override
  final String vendorId;
  @override
  final String storeName;
  @override
  final AdminDashboardVendorHealthAttentionInnerClass_Enum class_;
  @override
  final String label;
  @override
  final String? vps;
  @override
  final String? ohs;
  @override
  final BuiltList<String> reasons;

  factory _$AdminDashboardVendorHealthAttentionInner(
          [void Function(AdminDashboardVendorHealthAttentionInnerBuilder)?
              updates]) =>
      (AdminDashboardVendorHealthAttentionInnerBuilder()..update(updates))
          ._build();

  _$AdminDashboardVendorHealthAttentionInner._(
      {required this.vendorId,
      required this.storeName,
      required this.class_,
      required this.label,
      this.vps,
      this.ohs,
      required this.reasons})
      : super._();
  @override
  AdminDashboardVendorHealthAttentionInner rebuild(
          void Function(AdminDashboardVendorHealthAttentionInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardVendorHealthAttentionInnerBuilder toBuilder() =>
      AdminDashboardVendorHealthAttentionInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardVendorHealthAttentionInner &&
        vendorId == other.vendorId &&
        storeName == other.storeName &&
        class_ == other.class_ &&
        label == other.label &&
        vps == other.vps &&
        ohs == other.ohs &&
        reasons == other.reasons;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, storeName.hashCode);
    _$hash = $jc(_$hash, class_.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, vps.hashCode);
    _$hash = $jc(_$hash, ohs.hashCode);
    _$hash = $jc(_$hash, reasons.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminDashboardVendorHealthAttentionInner')
          ..add('vendorId', vendorId)
          ..add('storeName', storeName)
          ..add('class_', class_)
          ..add('label', label)
          ..add('vps', vps)
          ..add('ohs', ohs)
          ..add('reasons', reasons))
        .toString();
  }
}

class AdminDashboardVendorHealthAttentionInnerBuilder
    implements
        Builder<AdminDashboardVendorHealthAttentionInner,
            AdminDashboardVendorHealthAttentionInnerBuilder> {
  _$AdminDashboardVendorHealthAttentionInner? _$v;

  String? _vendorId;
  String? get vendorId => _$this._vendorId;
  set vendorId(String? vendorId) => _$this._vendorId = vendorId;

  String? _storeName;
  String? get storeName => _$this._storeName;
  set storeName(String? storeName) => _$this._storeName = storeName;

  AdminDashboardVendorHealthAttentionInnerClass_Enum? _class_;
  AdminDashboardVendorHealthAttentionInnerClass_Enum? get class_ =>
      _$this._class_;
  set class_(AdminDashboardVendorHealthAttentionInnerClass_Enum? class_) =>
      _$this._class_ = class_;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _vps;
  String? get vps => _$this._vps;
  set vps(String? vps) => _$this._vps = vps;

  String? _ohs;
  String? get ohs => _$this._ohs;
  set ohs(String? ohs) => _$this._ohs = ohs;

  ListBuilder<String>? _reasons;
  ListBuilder<String> get reasons => _$this._reasons ??= ListBuilder<String>();
  set reasons(ListBuilder<String>? reasons) => _$this._reasons = reasons;

  AdminDashboardVendorHealthAttentionInnerBuilder() {
    AdminDashboardVendorHealthAttentionInner._defaults(this);
  }

  AdminDashboardVendorHealthAttentionInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vendorId = $v.vendorId;
      _storeName = $v.storeName;
      _class_ = $v.class_;
      _label = $v.label;
      _vps = $v.vps;
      _ohs = $v.ohs;
      _reasons = $v.reasons.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardVendorHealthAttentionInner other) {
    _$v = other as _$AdminDashboardVendorHealthAttentionInner;
  }

  @override
  void update(
      void Function(AdminDashboardVendorHealthAttentionInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardVendorHealthAttentionInner build() => _build();

  _$AdminDashboardVendorHealthAttentionInner _build() {
    _$AdminDashboardVendorHealthAttentionInner _$result;
    try {
      _$result = _$v ??
          _$AdminDashboardVendorHealthAttentionInner._(
            vendorId: BuiltValueNullFieldError.checkNotNull(vendorId,
                r'AdminDashboardVendorHealthAttentionInner', 'vendorId'),
            storeName: BuiltValueNullFieldError.checkNotNull(storeName,
                r'AdminDashboardVendorHealthAttentionInner', 'storeName'),
            class_: BuiltValueNullFieldError.checkNotNull(
                class_, r'AdminDashboardVendorHealthAttentionInner', 'class_'),
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'AdminDashboardVendorHealthAttentionInner', 'label'),
            vps: vps,
            ohs: ohs,
            reasons: reasons.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reasons';
        reasons.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminDashboardVendorHealthAttentionInner',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
