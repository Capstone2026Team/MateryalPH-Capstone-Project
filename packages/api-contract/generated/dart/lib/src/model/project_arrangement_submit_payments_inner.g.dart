// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_arrangement_submit_payments_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum
    _$projectArrangementSubmitPaymentsInnerPaymentMethodEnum_ONLINE =
    const ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum._('ONLINE');
const ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum
    _$projectArrangementSubmitPaymentsInnerPaymentMethodEnum_CASH_ON_DELIVERY =
    const ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum._(
        'CASH_ON_DELIVERY');
const ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum
    _$projectArrangementSubmitPaymentsInnerPaymentMethodEnum_IN_STORE =
    const ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum._('IN_STORE');

ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum
    _$projectArrangementSubmitPaymentsInnerPaymentMethodEnumValueOf(
        String name) {
  switch (name) {
    case 'ONLINE':
      return _$projectArrangementSubmitPaymentsInnerPaymentMethodEnum_ONLINE;
    case 'CASH_ON_DELIVERY':
      return _$projectArrangementSubmitPaymentsInnerPaymentMethodEnum_CASH_ON_DELIVERY;
    case 'IN_STORE':
      return _$projectArrangementSubmitPaymentsInnerPaymentMethodEnum_IN_STORE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum>
    _$projectArrangementSubmitPaymentsInnerPaymentMethodEnumValues = BuiltSet<
        ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum>(const <ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum>[
  _$projectArrangementSubmitPaymentsInnerPaymentMethodEnum_ONLINE,
  _$projectArrangementSubmitPaymentsInnerPaymentMethodEnum_CASH_ON_DELIVERY,
  _$projectArrangementSubmitPaymentsInnerPaymentMethodEnum_IN_STORE,
]);

Serializer<ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum>
    _$projectArrangementSubmitPaymentsInnerPaymentMethodEnumSerializer =
    _$ProjectArrangementSubmitPaymentsInnerPaymentMethodEnumSerializer();

class _$ProjectArrangementSubmitPaymentsInnerPaymentMethodEnumSerializer
    implements
        PrimitiveSerializer<
            ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ONLINE': 'ONLINE',
    'CASH_ON_DELIVERY': 'CASH_ON_DELIVERY',
    'IN_STORE': 'IN_STORE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ONLINE': 'ONLINE',
    'CASH_ON_DELIVERY': 'CASH_ON_DELIVERY',
    'IN_STORE': 'IN_STORE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum
  ];
  @override
  final String wireName =
      'ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum';

  @override
  Object serialize(Serializers serializers,
          ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectArrangementSubmitPaymentsInner
    extends ProjectArrangementSubmitPaymentsInner {
  @override
  final String vendorId;
  @override
  final ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum paymentMethod;

  factory _$ProjectArrangementSubmitPaymentsInner(
          [void Function(ProjectArrangementSubmitPaymentsInnerBuilder)?
              updates]) =>
      (ProjectArrangementSubmitPaymentsInnerBuilder()..update(updates))
          ._build();

  _$ProjectArrangementSubmitPaymentsInner._(
      {required this.vendorId, required this.paymentMethod})
      : super._();
  @override
  ProjectArrangementSubmitPaymentsInner rebuild(
          void Function(ProjectArrangementSubmitPaymentsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectArrangementSubmitPaymentsInnerBuilder toBuilder() =>
      ProjectArrangementSubmitPaymentsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectArrangementSubmitPaymentsInner &&
        vendorId == other.vendorId &&
        paymentMethod == other.paymentMethod;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, paymentMethod.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ProjectArrangementSubmitPaymentsInner')
          ..add('vendorId', vendorId)
          ..add('paymentMethod', paymentMethod))
        .toString();
  }
}

class ProjectArrangementSubmitPaymentsInnerBuilder
    implements
        Builder<ProjectArrangementSubmitPaymentsInner,
            ProjectArrangementSubmitPaymentsInnerBuilder> {
  _$ProjectArrangementSubmitPaymentsInner? _$v;

  String? _vendorId;
  String? get vendorId => _$this._vendorId;
  set vendorId(String? vendorId) => _$this._vendorId = vendorId;

  ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum? _paymentMethod;
  ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum? get paymentMethod =>
      _$this._paymentMethod;
  set paymentMethod(
          ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum?
              paymentMethod) =>
      _$this._paymentMethod = paymentMethod;

  ProjectArrangementSubmitPaymentsInnerBuilder() {
    ProjectArrangementSubmitPaymentsInner._defaults(this);
  }

  ProjectArrangementSubmitPaymentsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vendorId = $v.vendorId;
      _paymentMethod = $v.paymentMethod;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectArrangementSubmitPaymentsInner other) {
    _$v = other as _$ProjectArrangementSubmitPaymentsInner;
  }

  @override
  void update(
      void Function(ProjectArrangementSubmitPaymentsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectArrangementSubmitPaymentsInner build() => _build();

  _$ProjectArrangementSubmitPaymentsInner _build() {
    final _$result = _$v ??
        _$ProjectArrangementSubmitPaymentsInner._(
          vendorId: BuiltValueNullFieldError.checkNotNull(
              vendorId, r'ProjectArrangementSubmitPaymentsInner', 'vendorId'),
          paymentMethod: BuiltValueNullFieldError.checkNotNull(paymentMethod,
              r'ProjectArrangementSubmitPaymentsInner', 'paymentMethod'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
