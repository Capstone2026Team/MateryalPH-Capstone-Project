// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_arrangement_edit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProjectArrangementEditFulfillmentMethodEnum
    _$projectArrangementEditFulfillmentMethodEnum_DELIVERY =
    const ProjectArrangementEditFulfillmentMethodEnum._('DELIVERY');
const ProjectArrangementEditFulfillmentMethodEnum
    _$projectArrangementEditFulfillmentMethodEnum_PICKUP =
    const ProjectArrangementEditFulfillmentMethodEnum._('PICKUP');

ProjectArrangementEditFulfillmentMethodEnum
    _$projectArrangementEditFulfillmentMethodEnumValueOf(String name) {
  switch (name) {
    case 'DELIVERY':
      return _$projectArrangementEditFulfillmentMethodEnum_DELIVERY;
    case 'PICKUP':
      return _$projectArrangementEditFulfillmentMethodEnum_PICKUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectArrangementEditFulfillmentMethodEnum>
    _$projectArrangementEditFulfillmentMethodEnumValues = BuiltSet<
        ProjectArrangementEditFulfillmentMethodEnum>(const <ProjectArrangementEditFulfillmentMethodEnum>[
  _$projectArrangementEditFulfillmentMethodEnum_DELIVERY,
  _$projectArrangementEditFulfillmentMethodEnum_PICKUP,
]);

const ProjectArrangementEditMethodEnum
    _$projectArrangementEditMethodEnum_DELIVERY =
    const ProjectArrangementEditMethodEnum._('DELIVERY');
const ProjectArrangementEditMethodEnum
    _$projectArrangementEditMethodEnum_PICKUP =
    const ProjectArrangementEditMethodEnum._('PICKUP');

ProjectArrangementEditMethodEnum _$projectArrangementEditMethodEnumValueOf(
    String name) {
  switch (name) {
    case 'DELIVERY':
      return _$projectArrangementEditMethodEnum_DELIVERY;
    case 'PICKUP':
      return _$projectArrangementEditMethodEnum_PICKUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectArrangementEditMethodEnum>
    _$projectArrangementEditMethodEnumValues = BuiltSet<
        ProjectArrangementEditMethodEnum>(const <ProjectArrangementEditMethodEnum>[
  _$projectArrangementEditMethodEnum_DELIVERY,
  _$projectArrangementEditMethodEnum_PICKUP,
]);

Serializer<ProjectArrangementEditFulfillmentMethodEnum>
    _$projectArrangementEditFulfillmentMethodEnumSerializer =
    _$ProjectArrangementEditFulfillmentMethodEnumSerializer();
Serializer<ProjectArrangementEditMethodEnum>
    _$projectArrangementEditMethodEnumSerializer =
    _$ProjectArrangementEditMethodEnumSerializer();

class _$ProjectArrangementEditFulfillmentMethodEnumSerializer
    implements
        PrimitiveSerializer<ProjectArrangementEditFulfillmentMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DELIVERY': 'DELIVERY',
    'PICKUP': 'PICKUP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DELIVERY': 'DELIVERY',
    'PICKUP': 'PICKUP',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ProjectArrangementEditFulfillmentMethodEnum
  ];
  @override
  final String wireName = 'ProjectArrangementEditFulfillmentMethodEnum';

  @override
  Object serialize(Serializers serializers,
          ProjectArrangementEditFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectArrangementEditFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectArrangementEditFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectArrangementEditMethodEnumSerializer
    implements PrimitiveSerializer<ProjectArrangementEditMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DELIVERY': 'DELIVERY',
    'PICKUP': 'PICKUP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DELIVERY': 'DELIVERY',
    'PICKUP': 'PICKUP',
  };

  @override
  final Iterable<Type> types = const <Type>[ProjectArrangementEditMethodEnum];
  @override
  final String wireName = 'ProjectArrangementEditMethodEnum';

  @override
  Object serialize(
          Serializers serializers, ProjectArrangementEditMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectArrangementEditMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectArrangementEditMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectArrangementEdit extends ProjectArrangementEdit {
  @override
  final int version;
  @override
  final String? vendorId;
  @override
  final String? lineId;
  @override
  final String? itemId;
  @override
  final String? variantId;
  @override
  final String? priceVersionId;
  @override
  final String? optionId;
  @override
  final ProjectArrangementEditFulfillmentMethodEnum? fulfillmentMethod;
  @override
  final ProjectArrangementEditMethodEnum? method;
  @override
  final bool? remove;
  @override
  final bool? replaceItem;

  factory _$ProjectArrangementEdit(
          [void Function(ProjectArrangementEditBuilder)? updates]) =>
      (ProjectArrangementEditBuilder()..update(updates))._build();

  _$ProjectArrangementEdit._(
      {required this.version,
      this.vendorId,
      this.lineId,
      this.itemId,
      this.variantId,
      this.priceVersionId,
      this.optionId,
      this.fulfillmentMethod,
      this.method,
      this.remove,
      this.replaceItem})
      : super._();
  @override
  ProjectArrangementEdit rebuild(
          void Function(ProjectArrangementEditBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectArrangementEditBuilder toBuilder() =>
      ProjectArrangementEditBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectArrangementEdit &&
        version == other.version &&
        vendorId == other.vendorId &&
        lineId == other.lineId &&
        itemId == other.itemId &&
        variantId == other.variantId &&
        priceVersionId == other.priceVersionId &&
        optionId == other.optionId &&
        fulfillmentMethod == other.fulfillmentMethod &&
        method == other.method &&
        remove == other.remove &&
        replaceItem == other.replaceItem;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, lineId.hashCode);
    _$hash = $jc(_$hash, itemId.hashCode);
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jc(_$hash, priceVersionId.hashCode);
    _$hash = $jc(_$hash, optionId.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, remove.hashCode);
    _$hash = $jc(_$hash, replaceItem.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectArrangementEdit')
          ..add('version', version)
          ..add('vendorId', vendorId)
          ..add('lineId', lineId)
          ..add('itemId', itemId)
          ..add('variantId', variantId)
          ..add('priceVersionId', priceVersionId)
          ..add('optionId', optionId)
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('method', method)
          ..add('remove', remove)
          ..add('replaceItem', replaceItem))
        .toString();
  }
}

class ProjectArrangementEditBuilder
    implements Builder<ProjectArrangementEdit, ProjectArrangementEditBuilder> {
  _$ProjectArrangementEdit? _$v;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  String? _vendorId;
  String? get vendorId => _$this._vendorId;
  set vendorId(String? vendorId) => _$this._vendorId = vendorId;

  String? _lineId;
  String? get lineId => _$this._lineId;
  set lineId(String? lineId) => _$this._lineId = lineId;

  String? _itemId;
  String? get itemId => _$this._itemId;
  set itemId(String? itemId) => _$this._itemId = itemId;

  String? _variantId;
  String? get variantId => _$this._variantId;
  set variantId(String? variantId) => _$this._variantId = variantId;

  String? _priceVersionId;
  String? get priceVersionId => _$this._priceVersionId;
  set priceVersionId(String? priceVersionId) =>
      _$this._priceVersionId = priceVersionId;

  String? _optionId;
  String? get optionId => _$this._optionId;
  set optionId(String? optionId) => _$this._optionId = optionId;

  ProjectArrangementEditFulfillmentMethodEnum? _fulfillmentMethod;
  ProjectArrangementEditFulfillmentMethodEnum? get fulfillmentMethod =>
      _$this._fulfillmentMethod;
  set fulfillmentMethod(
          ProjectArrangementEditFulfillmentMethodEnum? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  ProjectArrangementEditMethodEnum? _method;
  ProjectArrangementEditMethodEnum? get method => _$this._method;
  set method(ProjectArrangementEditMethodEnum? method) =>
      _$this._method = method;

  bool? _remove;
  bool? get remove => _$this._remove;
  set remove(bool? remove) => _$this._remove = remove;

  bool? _replaceItem;
  bool? get replaceItem => _$this._replaceItem;
  set replaceItem(bool? replaceItem) => _$this._replaceItem = replaceItem;

  ProjectArrangementEditBuilder() {
    ProjectArrangementEdit._defaults(this);
  }

  ProjectArrangementEditBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _version = $v.version;
      _vendorId = $v.vendorId;
      _lineId = $v.lineId;
      _itemId = $v.itemId;
      _variantId = $v.variantId;
      _priceVersionId = $v.priceVersionId;
      _optionId = $v.optionId;
      _fulfillmentMethod = $v.fulfillmentMethod;
      _method = $v.method;
      _remove = $v.remove;
      _replaceItem = $v.replaceItem;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectArrangementEdit other) {
    _$v = other as _$ProjectArrangementEdit;
  }

  @override
  void update(void Function(ProjectArrangementEditBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectArrangementEdit build() => _build();

  _$ProjectArrangementEdit _build() {
    final _$result = _$v ??
        _$ProjectArrangementEdit._(
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'ProjectArrangementEdit', 'version'),
          vendorId: vendorId,
          lineId: lineId,
          itemId: itemId,
          variantId: variantId,
          priceVersionId: priceVersionId,
          optionId: optionId,
          fulfillmentMethod: fulfillmentMethod,
          method: method,
          remove: remove,
          replaceItem: replaceItem,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
