// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_draft_vendor_group.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProjectDraftVendorGroupFulfillmentMethodEnum
    _$projectDraftVendorGroupFulfillmentMethodEnum_DELIVERY =
    const ProjectDraftVendorGroupFulfillmentMethodEnum._('DELIVERY');
const ProjectDraftVendorGroupFulfillmentMethodEnum
    _$projectDraftVendorGroupFulfillmentMethodEnum_PICKUP =
    const ProjectDraftVendorGroupFulfillmentMethodEnum._('PICKUP');

ProjectDraftVendorGroupFulfillmentMethodEnum
    _$projectDraftVendorGroupFulfillmentMethodEnumValueOf(String name) {
  switch (name) {
    case 'DELIVERY':
      return _$projectDraftVendorGroupFulfillmentMethodEnum_DELIVERY;
    case 'PICKUP':
      return _$projectDraftVendorGroupFulfillmentMethodEnum_PICKUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectDraftVendorGroupFulfillmentMethodEnum>
    _$projectDraftVendorGroupFulfillmentMethodEnumValues = BuiltSet<
        ProjectDraftVendorGroupFulfillmentMethodEnum>(const <ProjectDraftVendorGroupFulfillmentMethodEnum>[
  _$projectDraftVendorGroupFulfillmentMethodEnum_DELIVERY,
  _$projectDraftVendorGroupFulfillmentMethodEnum_PICKUP,
]);

const ProjectDraftVendorGroupFulfillmentOptionsEnum
    _$projectDraftVendorGroupFulfillmentOptionsEnum_DELIVERY =
    const ProjectDraftVendorGroupFulfillmentOptionsEnum._('DELIVERY');
const ProjectDraftVendorGroupFulfillmentOptionsEnum
    _$projectDraftVendorGroupFulfillmentOptionsEnum_PICKUP =
    const ProjectDraftVendorGroupFulfillmentOptionsEnum._('PICKUP');

ProjectDraftVendorGroupFulfillmentOptionsEnum
    _$projectDraftVendorGroupFulfillmentOptionsEnumValueOf(String name) {
  switch (name) {
    case 'DELIVERY':
      return _$projectDraftVendorGroupFulfillmentOptionsEnum_DELIVERY;
    case 'PICKUP':
      return _$projectDraftVendorGroupFulfillmentOptionsEnum_PICKUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectDraftVendorGroupFulfillmentOptionsEnum>
    _$projectDraftVendorGroupFulfillmentOptionsEnumValues = BuiltSet<
        ProjectDraftVendorGroupFulfillmentOptionsEnum>(const <ProjectDraftVendorGroupFulfillmentOptionsEnum>[
  _$projectDraftVendorGroupFulfillmentOptionsEnum_DELIVERY,
  _$projectDraftVendorGroupFulfillmentOptionsEnum_PICKUP,
]);

Serializer<ProjectDraftVendorGroupFulfillmentMethodEnum>
    _$projectDraftVendorGroupFulfillmentMethodEnumSerializer =
    _$ProjectDraftVendorGroupFulfillmentMethodEnumSerializer();
Serializer<ProjectDraftVendorGroupFulfillmentOptionsEnum>
    _$projectDraftVendorGroupFulfillmentOptionsEnumSerializer =
    _$ProjectDraftVendorGroupFulfillmentOptionsEnumSerializer();

class _$ProjectDraftVendorGroupFulfillmentMethodEnumSerializer
    implements
        PrimitiveSerializer<ProjectDraftVendorGroupFulfillmentMethodEnum> {
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
    ProjectDraftVendorGroupFulfillmentMethodEnum
  ];
  @override
  final String wireName = 'ProjectDraftVendorGroupFulfillmentMethodEnum';

  @override
  Object serialize(Serializers serializers,
          ProjectDraftVendorGroupFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectDraftVendorGroupFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectDraftVendorGroupFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectDraftVendorGroupFulfillmentOptionsEnumSerializer
    implements
        PrimitiveSerializer<ProjectDraftVendorGroupFulfillmentOptionsEnum> {
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
    ProjectDraftVendorGroupFulfillmentOptionsEnum
  ];
  @override
  final String wireName = 'ProjectDraftVendorGroupFulfillmentOptionsEnum';

  @override
  Object serialize(Serializers serializers,
          ProjectDraftVendorGroupFulfillmentOptionsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectDraftVendorGroupFulfillmentOptionsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectDraftVendorGroupFulfillmentOptionsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectDraftVendorGroup extends ProjectDraftVendorGroup {
  @override
  final String vendorId;
  @override
  final String storeName;
  @override
  final BuiltList<ProjectSeparatePurchase> items;
  @override
  final int materialsCentavos;
  @override
  final ProjectDraftVendorGroupFulfillmentMethodEnum fulfillmentMethod;
  @override
  final BuiltList<ProjectDraftVendorGroupFulfillmentOptionsEnum>?
      fulfillmentOptions;
  @override
  final BuiltMap<String, JsonObject?>? delivery;
  @override
  final BuiltList<ProjectPaymentMethod> paymentMethods;
  @override
  final BuiltList<String> issues;
  @override
  final String draftFingerprint;
  @override
  final int? deliveryCentavos;
  @override
  final int? projectedTotalCentavos;

  factory _$ProjectDraftVendorGroup(
          [void Function(ProjectDraftVendorGroupBuilder)? updates]) =>
      (ProjectDraftVendorGroupBuilder()..update(updates))._build();

  _$ProjectDraftVendorGroup._(
      {required this.vendorId,
      required this.storeName,
      required this.items,
      required this.materialsCentavos,
      required this.fulfillmentMethod,
      this.fulfillmentOptions,
      this.delivery,
      required this.paymentMethods,
      required this.issues,
      required this.draftFingerprint,
      this.deliveryCentavos,
      this.projectedTotalCentavos})
      : super._();
  @override
  ProjectDraftVendorGroup rebuild(
          void Function(ProjectDraftVendorGroupBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectDraftVendorGroupBuilder toBuilder() =>
      ProjectDraftVendorGroupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectDraftVendorGroup &&
        vendorId == other.vendorId &&
        storeName == other.storeName &&
        items == other.items &&
        materialsCentavos == other.materialsCentavos &&
        fulfillmentMethod == other.fulfillmentMethod &&
        fulfillmentOptions == other.fulfillmentOptions &&
        delivery == other.delivery &&
        paymentMethods == other.paymentMethods &&
        issues == other.issues &&
        draftFingerprint == other.draftFingerprint &&
        deliveryCentavos == other.deliveryCentavos &&
        projectedTotalCentavos == other.projectedTotalCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, storeName.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, materialsCentavos.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, fulfillmentOptions.hashCode);
    _$hash = $jc(_$hash, delivery.hashCode);
    _$hash = $jc(_$hash, paymentMethods.hashCode);
    _$hash = $jc(_$hash, issues.hashCode);
    _$hash = $jc(_$hash, draftFingerprint.hashCode);
    _$hash = $jc(_$hash, deliveryCentavos.hashCode);
    _$hash = $jc(_$hash, projectedTotalCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectDraftVendorGroup')
          ..add('vendorId', vendorId)
          ..add('storeName', storeName)
          ..add('items', items)
          ..add('materialsCentavos', materialsCentavos)
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('fulfillmentOptions', fulfillmentOptions)
          ..add('delivery', delivery)
          ..add('paymentMethods', paymentMethods)
          ..add('issues', issues)
          ..add('draftFingerprint', draftFingerprint)
          ..add('deliveryCentavos', deliveryCentavos)
          ..add('projectedTotalCentavos', projectedTotalCentavos))
        .toString();
  }
}

class ProjectDraftVendorGroupBuilder
    implements
        Builder<ProjectDraftVendorGroup, ProjectDraftVendorGroupBuilder> {
  _$ProjectDraftVendorGroup? _$v;

  String? _vendorId;
  String? get vendorId => _$this._vendorId;
  set vendorId(String? vendorId) => _$this._vendorId = vendorId;

  String? _storeName;
  String? get storeName => _$this._storeName;
  set storeName(String? storeName) => _$this._storeName = storeName;

  ListBuilder<ProjectSeparatePurchase>? _items;
  ListBuilder<ProjectSeparatePurchase> get items =>
      _$this._items ??= ListBuilder<ProjectSeparatePurchase>();
  set items(ListBuilder<ProjectSeparatePurchase>? items) =>
      _$this._items = items;

  int? _materialsCentavos;
  int? get materialsCentavos => _$this._materialsCentavos;
  set materialsCentavos(int? materialsCentavos) =>
      _$this._materialsCentavos = materialsCentavos;

  ProjectDraftVendorGroupFulfillmentMethodEnum? _fulfillmentMethod;
  ProjectDraftVendorGroupFulfillmentMethodEnum? get fulfillmentMethod =>
      _$this._fulfillmentMethod;
  set fulfillmentMethod(
          ProjectDraftVendorGroupFulfillmentMethodEnum? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  ListBuilder<ProjectDraftVendorGroupFulfillmentOptionsEnum>?
      _fulfillmentOptions;
  ListBuilder<ProjectDraftVendorGroupFulfillmentOptionsEnum>
      get fulfillmentOptions => _$this._fulfillmentOptions ??=
          ListBuilder<ProjectDraftVendorGroupFulfillmentOptionsEnum>();
  set fulfillmentOptions(
          ListBuilder<ProjectDraftVendorGroupFulfillmentOptionsEnum>?
              fulfillmentOptions) =>
      _$this._fulfillmentOptions = fulfillmentOptions;

  MapBuilder<String, JsonObject?>? _delivery;
  MapBuilder<String, JsonObject?> get delivery =>
      _$this._delivery ??= MapBuilder<String, JsonObject?>();
  set delivery(MapBuilder<String, JsonObject?>? delivery) =>
      _$this._delivery = delivery;

  ListBuilder<ProjectPaymentMethod>? _paymentMethods;
  ListBuilder<ProjectPaymentMethod> get paymentMethods =>
      _$this._paymentMethods ??= ListBuilder<ProjectPaymentMethod>();
  set paymentMethods(ListBuilder<ProjectPaymentMethod>? paymentMethods) =>
      _$this._paymentMethods = paymentMethods;

  ListBuilder<String>? _issues;
  ListBuilder<String> get issues => _$this._issues ??= ListBuilder<String>();
  set issues(ListBuilder<String>? issues) => _$this._issues = issues;

  String? _draftFingerprint;
  String? get draftFingerprint => _$this._draftFingerprint;
  set draftFingerprint(String? draftFingerprint) =>
      _$this._draftFingerprint = draftFingerprint;

  int? _deliveryCentavos;
  int? get deliveryCentavos => _$this._deliveryCentavos;
  set deliveryCentavos(int? deliveryCentavos) =>
      _$this._deliveryCentavos = deliveryCentavos;

  int? _projectedTotalCentavos;
  int? get projectedTotalCentavos => _$this._projectedTotalCentavos;
  set projectedTotalCentavos(int? projectedTotalCentavos) =>
      _$this._projectedTotalCentavos = projectedTotalCentavos;

  ProjectDraftVendorGroupBuilder() {
    ProjectDraftVendorGroup._defaults(this);
  }

  ProjectDraftVendorGroupBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vendorId = $v.vendorId;
      _storeName = $v.storeName;
      _items = $v.items.toBuilder();
      _materialsCentavos = $v.materialsCentavos;
      _fulfillmentMethod = $v.fulfillmentMethod;
      _fulfillmentOptions = $v.fulfillmentOptions?.toBuilder();
      _delivery = $v.delivery?.toBuilder();
      _paymentMethods = $v.paymentMethods.toBuilder();
      _issues = $v.issues.toBuilder();
      _draftFingerprint = $v.draftFingerprint;
      _deliveryCentavos = $v.deliveryCentavos;
      _projectedTotalCentavos = $v.projectedTotalCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectDraftVendorGroup other) {
    _$v = other as _$ProjectDraftVendorGroup;
  }

  @override
  void update(void Function(ProjectDraftVendorGroupBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectDraftVendorGroup build() => _build();

  _$ProjectDraftVendorGroup _build() {
    _$ProjectDraftVendorGroup _$result;
    try {
      _$result = _$v ??
          _$ProjectDraftVendorGroup._(
            vendorId: BuiltValueNullFieldError.checkNotNull(
                vendorId, r'ProjectDraftVendorGroup', 'vendorId'),
            storeName: BuiltValueNullFieldError.checkNotNull(
                storeName, r'ProjectDraftVendorGroup', 'storeName'),
            items: items.build(),
            materialsCentavos: BuiltValueNullFieldError.checkNotNull(
                materialsCentavos,
                r'ProjectDraftVendorGroup',
                'materialsCentavos'),
            fulfillmentMethod: BuiltValueNullFieldError.checkNotNull(
                fulfillmentMethod,
                r'ProjectDraftVendorGroup',
                'fulfillmentMethod'),
            fulfillmentOptions: _fulfillmentOptions?.build(),
            delivery: _delivery?.build(),
            paymentMethods: paymentMethods.build(),
            issues: issues.build(),
            draftFingerprint: BuiltValueNullFieldError.checkNotNull(
                draftFingerprint,
                r'ProjectDraftVendorGroup',
                'draftFingerprint'),
            deliveryCentavos: deliveryCentavos,
            projectedTotalCentavos: projectedTotalCentavos,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();

        _$failedField = 'fulfillmentOptions';
        _fulfillmentOptions?.build();
        _$failedField = 'delivery';
        _delivery?.build();
        _$failedField = 'paymentMethods';
        paymentMethods.build();
        _$failedField = 'issues';
        issues.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectDraftVendorGroup', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
