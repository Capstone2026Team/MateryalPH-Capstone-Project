// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_marketplace_disclosure.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDashboardMarketplaceDisclosureMethodEnum
    _$adminDashboardMarketplaceDisclosureMethodEnum_ROLL_UP_TO_PARENT =
    const AdminDashboardMarketplaceDisclosureMethodEnum._('ROLL_UP_TO_PARENT');

AdminDashboardMarketplaceDisclosureMethodEnum
    _$adminDashboardMarketplaceDisclosureMethodEnumValueOf(String name) {
  switch (name) {
    case 'ROLL_UP_TO_PARENT':
      return _$adminDashboardMarketplaceDisclosureMethodEnum_ROLL_UP_TO_PARENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDashboardMarketplaceDisclosureMethodEnum>
    _$adminDashboardMarketplaceDisclosureMethodEnumValues = BuiltSet<
        AdminDashboardMarketplaceDisclosureMethodEnum>(const <AdminDashboardMarketplaceDisclosureMethodEnum>[
  _$adminDashboardMarketplaceDisclosureMethodEnum_ROLL_UP_TO_PARENT,
]);

Serializer<AdminDashboardMarketplaceDisclosureMethodEnum>
    _$adminDashboardMarketplaceDisclosureMethodEnumSerializer =
    _$AdminDashboardMarketplaceDisclosureMethodEnumSerializer();

class _$AdminDashboardMarketplaceDisclosureMethodEnumSerializer
    implements
        PrimitiveSerializer<AdminDashboardMarketplaceDisclosureMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ROLL_UP_TO_PARENT': 'ROLL_UP_TO_PARENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ROLL_UP_TO_PARENT': 'ROLL_UP_TO_PARENT',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDashboardMarketplaceDisclosureMethodEnum
  ];
  @override
  final String wireName = 'AdminDashboardMarketplaceDisclosureMethodEnum';

  @override
  Object serialize(Serializers serializers,
          AdminDashboardMarketplaceDisclosureMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminDashboardMarketplaceDisclosureMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminDashboardMarketplaceDisclosureMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminDashboardMarketplaceDisclosure
    extends AdminDashboardMarketplaceDisclosure {
  @override
  final int minimumPersons;
  @override
  final AdminDashboardMarketplaceDisclosureMethodEnum method;
  @override
  final String description;

  factory _$AdminDashboardMarketplaceDisclosure(
          [void Function(AdminDashboardMarketplaceDisclosureBuilder)?
              updates]) =>
      (AdminDashboardMarketplaceDisclosureBuilder()..update(updates))._build();

  _$AdminDashboardMarketplaceDisclosure._(
      {required this.minimumPersons,
      required this.method,
      required this.description})
      : super._();
  @override
  AdminDashboardMarketplaceDisclosure rebuild(
          void Function(AdminDashboardMarketplaceDisclosureBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardMarketplaceDisclosureBuilder toBuilder() =>
      AdminDashboardMarketplaceDisclosureBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardMarketplaceDisclosure &&
        minimumPersons == other.minimumPersons &&
        method == other.method &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, minimumPersons.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardMarketplaceDisclosure')
          ..add('minimumPersons', minimumPersons)
          ..add('method', method)
          ..add('description', description))
        .toString();
  }
}

class AdminDashboardMarketplaceDisclosureBuilder
    implements
        Builder<AdminDashboardMarketplaceDisclosure,
            AdminDashboardMarketplaceDisclosureBuilder> {
  _$AdminDashboardMarketplaceDisclosure? _$v;

  int? _minimumPersons;
  int? get minimumPersons => _$this._minimumPersons;
  set minimumPersons(int? minimumPersons) =>
      _$this._minimumPersons = minimumPersons;

  AdminDashboardMarketplaceDisclosureMethodEnum? _method;
  AdminDashboardMarketplaceDisclosureMethodEnum? get method => _$this._method;
  set method(AdminDashboardMarketplaceDisclosureMethodEnum? method) =>
      _$this._method = method;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  AdminDashboardMarketplaceDisclosureBuilder() {
    AdminDashboardMarketplaceDisclosure._defaults(this);
  }

  AdminDashboardMarketplaceDisclosureBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _minimumPersons = $v.minimumPersons;
      _method = $v.method;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardMarketplaceDisclosure other) {
    _$v = other as _$AdminDashboardMarketplaceDisclosure;
  }

  @override
  void update(
      void Function(AdminDashboardMarketplaceDisclosureBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardMarketplaceDisclosure build() => _build();

  _$AdminDashboardMarketplaceDisclosure _build() {
    final _$result = _$v ??
        _$AdminDashboardMarketplaceDisclosure._(
          minimumPersons: BuiltValueNullFieldError.checkNotNull(minimumPersons,
              r'AdminDashboardMarketplaceDisclosure', 'minimumPersons'),
          method: BuiltValueNullFieldError.checkNotNull(
              method, r'AdminDashboardMarketplaceDisclosure', 'method'),
          description: BuiltValueNullFieldError.checkNotNull(description,
              r'AdminDashboardMarketplaceDisclosure', 'description'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
