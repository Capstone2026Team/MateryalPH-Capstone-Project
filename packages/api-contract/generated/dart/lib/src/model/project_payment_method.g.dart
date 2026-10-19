// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_payment_method.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProjectPaymentMethodMethodEnum _$projectPaymentMethodMethodEnum_ONLINE =
    const ProjectPaymentMethodMethodEnum._('ONLINE');
const ProjectPaymentMethodMethodEnum
    _$projectPaymentMethodMethodEnum_CASH_ON_DELIVERY =
    const ProjectPaymentMethodMethodEnum._('CASH_ON_DELIVERY');
const ProjectPaymentMethodMethodEnum _$projectPaymentMethodMethodEnum_IN_STORE =
    const ProjectPaymentMethodMethodEnum._('IN_STORE');

ProjectPaymentMethodMethodEnum _$projectPaymentMethodMethodEnumValueOf(
    String name) {
  switch (name) {
    case 'ONLINE':
      return _$projectPaymentMethodMethodEnum_ONLINE;
    case 'CASH_ON_DELIVERY':
      return _$projectPaymentMethodMethodEnum_CASH_ON_DELIVERY;
    case 'IN_STORE':
      return _$projectPaymentMethodMethodEnum_IN_STORE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectPaymentMethodMethodEnum>
    _$projectPaymentMethodMethodEnumValues = BuiltSet<
        ProjectPaymentMethodMethodEnum>(const <ProjectPaymentMethodMethodEnum>[
  _$projectPaymentMethodMethodEnum_ONLINE,
  _$projectPaymentMethodMethodEnum_CASH_ON_DELIVERY,
  _$projectPaymentMethodMethodEnum_IN_STORE,
]);

Serializer<ProjectPaymentMethodMethodEnum>
    _$projectPaymentMethodMethodEnumSerializer =
    _$ProjectPaymentMethodMethodEnumSerializer();

class _$ProjectPaymentMethodMethodEnumSerializer
    implements PrimitiveSerializer<ProjectPaymentMethodMethodEnum> {
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
  final Iterable<Type> types = const <Type>[ProjectPaymentMethodMethodEnum];
  @override
  final String wireName = 'ProjectPaymentMethodMethodEnum';

  @override
  Object serialize(
          Serializers serializers, ProjectPaymentMethodMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectPaymentMethodMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectPaymentMethodMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectPaymentMethod extends ProjectPaymentMethod {
  @override
  final ProjectPaymentMethodMethodEnum method;
  @override
  final bool available;
  @override
  final String? reason;

  factory _$ProjectPaymentMethod(
          [void Function(ProjectPaymentMethodBuilder)? updates]) =>
      (ProjectPaymentMethodBuilder()..update(updates))._build();

  _$ProjectPaymentMethod._(
      {required this.method, required this.available, this.reason})
      : super._();
  @override
  ProjectPaymentMethod rebuild(
          void Function(ProjectPaymentMethodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectPaymentMethodBuilder toBuilder() =>
      ProjectPaymentMethodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectPaymentMethod &&
        method == other.method &&
        available == other.available &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectPaymentMethod')
          ..add('method', method)
          ..add('available', available)
          ..add('reason', reason))
        .toString();
  }
}

class ProjectPaymentMethodBuilder
    implements Builder<ProjectPaymentMethod, ProjectPaymentMethodBuilder> {
  _$ProjectPaymentMethod? _$v;

  ProjectPaymentMethodMethodEnum? _method;
  ProjectPaymentMethodMethodEnum? get method => _$this._method;
  set method(ProjectPaymentMethodMethodEnum? method) => _$this._method = method;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  ProjectPaymentMethodBuilder() {
    ProjectPaymentMethod._defaults(this);
  }

  ProjectPaymentMethodBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _method = $v.method;
      _available = $v.available;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectPaymentMethod other) {
    _$v = other as _$ProjectPaymentMethod;
  }

  @override
  void update(void Function(ProjectPaymentMethodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectPaymentMethod build() => _build();

  _$ProjectPaymentMethod _build() {
    final _$result = _$v ??
        _$ProjectPaymentMethod._(
          method: BuiltValueNullFieldError.checkNotNull(
              method, r'ProjectPaymentMethod', 'method'),
          available: BuiltValueNullFieldError.checkNotNull(
              available, r'ProjectPaymentMethod', 'available'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
