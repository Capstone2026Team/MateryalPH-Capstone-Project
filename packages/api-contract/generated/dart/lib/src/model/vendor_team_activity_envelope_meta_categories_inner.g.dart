// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_activity_envelope_meta_categories_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum
    _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_SALES =
    const VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum._('SALES');
const VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum
    _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_INVENTORY =
    const VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum._(
        'INVENTORY');
const VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum
    _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_FULFILLMENT =
    const VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum._(
        'FULFILLMENT');
const VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum
    _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_DISPUTES =
    const VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum._(
        'DISPUTES');
const VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum
    _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_TEAM =
    const VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum._('TEAM');
const VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum
    _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_OTHER =
    const VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum._('OTHER');

VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum
    _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnumValueOf(
        String name) {
  switch (name) {
    case 'SALES':
      return _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_SALES;
    case 'INVENTORY':
      return _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_INVENTORY;
    case 'FULFILLMENT':
      return _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_FULFILLMENT;
    case 'DISPUTES':
      return _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_DISPUTES;
    case 'TEAM':
      return _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_TEAM;
    case 'OTHER':
      return _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum>
    _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnumValues =
    BuiltSet<
        VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum>(const <VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum>[
  _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_SALES,
  _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_INVENTORY,
  _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_FULFILLMENT,
  _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_DISPUTES,
  _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_TEAM,
  _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_OTHER,
]);

Serializer<VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum>
    _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnumSerializer =
    _$VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnumSerializer();

class _$VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnumSerializer
    implements
        PrimitiveSerializer<
            VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SALES': 'SALES',
    'INVENTORY': 'INVENTORY',
    'FULFILLMENT': 'FULFILLMENT',
    'DISPUTES': 'DISPUTES',
    'TEAM': 'TEAM',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SALES': 'SALES',
    'INVENTORY': 'INVENTORY',
    'FULFILLMENT': 'FULFILLMENT',
    'DISPUTES': 'DISPUTES',
    'TEAM': 'TEAM',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum
  ];
  @override
  final String wireName =
      'VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum';

  @override
  Object serialize(Serializers serializers,
          VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorTeamActivityEnvelopeMetaCategoriesInner
    extends VendorTeamActivityEnvelopeMetaCategoriesInner {
  @override
  final VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum category;
  @override
  final int count;

  factory _$VendorTeamActivityEnvelopeMetaCategoriesInner(
          [void Function(VendorTeamActivityEnvelopeMetaCategoriesInnerBuilder)?
              updates]) =>
      (VendorTeamActivityEnvelopeMetaCategoriesInnerBuilder()..update(updates))
          ._build();

  _$VendorTeamActivityEnvelopeMetaCategoriesInner._(
      {required this.category, required this.count})
      : super._();
  @override
  VendorTeamActivityEnvelopeMetaCategoriesInner rebuild(
          void Function(VendorTeamActivityEnvelopeMetaCategoriesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamActivityEnvelopeMetaCategoriesInnerBuilder toBuilder() =>
      VendorTeamActivityEnvelopeMetaCategoriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamActivityEnvelopeMetaCategoriesInner &&
        category == other.category &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'VendorTeamActivityEnvelopeMetaCategoriesInner')
          ..add('category', category)
          ..add('count', count))
        .toString();
  }
}

class VendorTeamActivityEnvelopeMetaCategoriesInnerBuilder
    implements
        Builder<VendorTeamActivityEnvelopeMetaCategoriesInner,
            VendorTeamActivityEnvelopeMetaCategoriesInnerBuilder> {
  _$VendorTeamActivityEnvelopeMetaCategoriesInner? _$v;

  VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum? _category;
  VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum? get category =>
      _$this._category;
  set category(
          VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum?
              category) =>
      _$this._category = category;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  VendorTeamActivityEnvelopeMetaCategoriesInnerBuilder() {
    VendorTeamActivityEnvelopeMetaCategoriesInner._defaults(this);
  }

  VendorTeamActivityEnvelopeMetaCategoriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTeamActivityEnvelopeMetaCategoriesInner other) {
    _$v = other as _$VendorTeamActivityEnvelopeMetaCategoriesInner;
  }

  @override
  void update(
      void Function(VendorTeamActivityEnvelopeMetaCategoriesInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamActivityEnvelopeMetaCategoriesInner build() => _build();

  _$VendorTeamActivityEnvelopeMetaCategoriesInner _build() {
    final _$result = _$v ??
        _$VendorTeamActivityEnvelopeMetaCategoriesInner._(
          category: BuiltValueNullFieldError.checkNotNull(category,
              r'VendorTeamActivityEnvelopeMetaCategoriesInner', 'category'),
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'VendorTeamActivityEnvelopeMetaCategoriesInner', 'count'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
