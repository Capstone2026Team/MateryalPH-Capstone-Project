// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_orders_incoming_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorDashboardOrdersIncomingInnerProcurementTypeEnum
    _$vendorDashboardOrdersIncomingInnerProcurementTypeEnum_ITEM_BASED =
    const VendorDashboardOrdersIncomingInnerProcurementTypeEnum._('ITEM_BASED');
const VendorDashboardOrdersIncomingInnerProcurementTypeEnum
    _$vendorDashboardOrdersIncomingInnerProcurementTypeEnum_PROJECT_BASED =
    const VendorDashboardOrdersIncomingInnerProcurementTypeEnum._(
        'PROJECT_BASED');

VendorDashboardOrdersIncomingInnerProcurementTypeEnum
    _$vendorDashboardOrdersIncomingInnerProcurementTypeEnumValueOf(
        String name) {
  switch (name) {
    case 'ITEM_BASED':
      return _$vendorDashboardOrdersIncomingInnerProcurementTypeEnum_ITEM_BASED;
    case 'PROJECT_BASED':
      return _$vendorDashboardOrdersIncomingInnerProcurementTypeEnum_PROJECT_BASED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorDashboardOrdersIncomingInnerProcurementTypeEnum>
    _$vendorDashboardOrdersIncomingInnerProcurementTypeEnumValues = BuiltSet<
        VendorDashboardOrdersIncomingInnerProcurementTypeEnum>(const <VendorDashboardOrdersIncomingInnerProcurementTypeEnum>[
  _$vendorDashboardOrdersIncomingInnerProcurementTypeEnum_ITEM_BASED,
  _$vendorDashboardOrdersIncomingInnerProcurementTypeEnum_PROJECT_BASED,
]);

const VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum
    _$vendorDashboardOrdersIncomingInnerFulfillmentMethodEnum_DELIVERY =
    const VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum._('DELIVERY');
const VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum
    _$vendorDashboardOrdersIncomingInnerFulfillmentMethodEnum_PICKUP =
    const VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum._('PICKUP');

VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum
    _$vendorDashboardOrdersIncomingInnerFulfillmentMethodEnumValueOf(
        String name) {
  switch (name) {
    case 'DELIVERY':
      return _$vendorDashboardOrdersIncomingInnerFulfillmentMethodEnum_DELIVERY;
    case 'PICKUP':
      return _$vendorDashboardOrdersIncomingInnerFulfillmentMethodEnum_PICKUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum>
    _$vendorDashboardOrdersIncomingInnerFulfillmentMethodEnumValues = BuiltSet<
        VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum>(const <VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum>[
  _$vendorDashboardOrdersIncomingInnerFulfillmentMethodEnum_DELIVERY,
  _$vendorDashboardOrdersIncomingInnerFulfillmentMethodEnum_PICKUP,
]);

Serializer<VendorDashboardOrdersIncomingInnerProcurementTypeEnum>
    _$vendorDashboardOrdersIncomingInnerProcurementTypeEnumSerializer =
    _$VendorDashboardOrdersIncomingInnerProcurementTypeEnumSerializer();
Serializer<VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum>
    _$vendorDashboardOrdersIncomingInnerFulfillmentMethodEnumSerializer =
    _$VendorDashboardOrdersIncomingInnerFulfillmentMethodEnumSerializer();

class _$VendorDashboardOrdersIncomingInnerProcurementTypeEnumSerializer
    implements
        PrimitiveSerializer<
            VendorDashboardOrdersIncomingInnerProcurementTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ITEM_BASED': 'ITEM_BASED',
    'PROJECT_BASED': 'PROJECT_BASED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ITEM_BASED': 'ITEM_BASED',
    'PROJECT_BASED': 'PROJECT_BASED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorDashboardOrdersIncomingInnerProcurementTypeEnum
  ];
  @override
  final String wireName =
      'VendorDashboardOrdersIncomingInnerProcurementTypeEnum';

  @override
  Object serialize(Serializers serializers,
          VendorDashboardOrdersIncomingInnerProcurementTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorDashboardOrdersIncomingInnerProcurementTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorDashboardOrdersIncomingInnerProcurementTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorDashboardOrdersIncomingInnerFulfillmentMethodEnumSerializer
    implements
        PrimitiveSerializer<
            VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum> {
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
    VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum
  ];
  @override
  final String wireName =
      'VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum';

  @override
  Object serialize(Serializers serializers,
          VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorDashboardOrdersIncomingInner
    extends VendorDashboardOrdersIncomingInner {
  @override
  final String orderId;
  @override
  final String reference;
  @override
  final VendorDashboardOrdersIncomingInnerProcurementTypeEnum procurementType;
  @override
  final VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum
      fulfillmentMethod;
  @override
  final int lineCount;
  @override
  final int totalCentavos;
  @override
  final DateTime? submittedAt;
  @override
  final DateTime? dueAt;

  factory _$VendorDashboardOrdersIncomingInner(
          [void Function(VendorDashboardOrdersIncomingInnerBuilder)?
              updates]) =>
      (VendorDashboardOrdersIncomingInnerBuilder()..update(updates))._build();

  _$VendorDashboardOrdersIncomingInner._(
      {required this.orderId,
      required this.reference,
      required this.procurementType,
      required this.fulfillmentMethod,
      required this.lineCount,
      required this.totalCentavos,
      this.submittedAt,
      this.dueAt})
      : super._();
  @override
  VendorDashboardOrdersIncomingInner rebuild(
          void Function(VendorDashboardOrdersIncomingInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardOrdersIncomingInnerBuilder toBuilder() =>
      VendorDashboardOrdersIncomingInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardOrdersIncomingInner &&
        orderId == other.orderId &&
        reference == other.reference &&
        procurementType == other.procurementType &&
        fulfillmentMethod == other.fulfillmentMethod &&
        lineCount == other.lineCount &&
        totalCentavos == other.totalCentavos &&
        submittedAt == other.submittedAt &&
        dueAt == other.dueAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, procurementType.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, lineCount.hashCode);
    _$hash = $jc(_$hash, totalCentavos.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, dueAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDashboardOrdersIncomingInner')
          ..add('orderId', orderId)
          ..add('reference', reference)
          ..add('procurementType', procurementType)
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('lineCount', lineCount)
          ..add('totalCentavos', totalCentavos)
          ..add('submittedAt', submittedAt)
          ..add('dueAt', dueAt))
        .toString();
  }
}

class VendorDashboardOrdersIncomingInnerBuilder
    implements
        Builder<VendorDashboardOrdersIncomingInner,
            VendorDashboardOrdersIncomingInnerBuilder> {
  _$VendorDashboardOrdersIncomingInner? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  VendorDashboardOrdersIncomingInnerProcurementTypeEnum? _procurementType;
  VendorDashboardOrdersIncomingInnerProcurementTypeEnum? get procurementType =>
      _$this._procurementType;
  set procurementType(
          VendorDashboardOrdersIncomingInnerProcurementTypeEnum?
              procurementType) =>
      _$this._procurementType = procurementType;

  VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum? _fulfillmentMethod;
  VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum?
      get fulfillmentMethod => _$this._fulfillmentMethod;
  set fulfillmentMethod(
          VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum?
              fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  int? _lineCount;
  int? get lineCount => _$this._lineCount;
  set lineCount(int? lineCount) => _$this._lineCount = lineCount;

  int? _totalCentavos;
  int? get totalCentavos => _$this._totalCentavos;
  set totalCentavos(int? totalCentavos) =>
      _$this._totalCentavos = totalCentavos;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  DateTime? _dueAt;
  DateTime? get dueAt => _$this._dueAt;
  set dueAt(DateTime? dueAt) => _$this._dueAt = dueAt;

  VendorDashboardOrdersIncomingInnerBuilder() {
    VendorDashboardOrdersIncomingInner._defaults(this);
  }

  VendorDashboardOrdersIncomingInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _reference = $v.reference;
      _procurementType = $v.procurementType;
      _fulfillmentMethod = $v.fulfillmentMethod;
      _lineCount = $v.lineCount;
      _totalCentavos = $v.totalCentavos;
      _submittedAt = $v.submittedAt;
      _dueAt = $v.dueAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardOrdersIncomingInner other) {
    _$v = other as _$VendorDashboardOrdersIncomingInner;
  }

  @override
  void update(
      void Function(VendorDashboardOrdersIncomingInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardOrdersIncomingInner build() => _build();

  _$VendorDashboardOrdersIncomingInner _build() {
    final _$result = _$v ??
        _$VendorDashboardOrdersIncomingInner._(
          orderId: BuiltValueNullFieldError.checkNotNull(
              orderId, r'VendorDashboardOrdersIncomingInner', 'orderId'),
          reference: BuiltValueNullFieldError.checkNotNull(
              reference, r'VendorDashboardOrdersIncomingInner', 'reference'),
          procurementType: BuiltValueNullFieldError.checkNotNull(
              procurementType,
              r'VendorDashboardOrdersIncomingInner',
              'procurementType'),
          fulfillmentMethod: BuiltValueNullFieldError.checkNotNull(
              fulfillmentMethod,
              r'VendorDashboardOrdersIncomingInner',
              'fulfillmentMethod'),
          lineCount: BuiltValueNullFieldError.checkNotNull(
              lineCount, r'VendorDashboardOrdersIncomingInner', 'lineCount'),
          totalCentavos: BuiltValueNullFieldError.checkNotNull(totalCentavos,
              r'VendorDashboardOrdersIncomingInner', 'totalCentavos'),
          submittedAt: submittedAt,
          dueAt: dueAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
