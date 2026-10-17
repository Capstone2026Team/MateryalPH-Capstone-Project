// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_action.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DashboardActionKeyEnum _$dashboardActionKeyEnum_ORDER_CONFIRMATION =
    const DashboardActionKeyEnum._('ORDER_CONFIRMATION');
const DashboardActionKeyEnum _$dashboardActionKeyEnum_FULFILLMENT_OVERDUE =
    const DashboardActionKeyEnum._('FULFILLMENT_OVERDUE');
const DashboardActionKeyEnum _$dashboardActionKeyEnum_FULFILLMENT_DUE_TODAY =
    const DashboardActionKeyEnum._('FULFILLMENT_DUE_TODAY');
const DashboardActionKeyEnum _$dashboardActionKeyEnum_ASSIGNED_FULFILLMENT =
    const DashboardActionKeyEnum._('ASSIGNED_FULFILLMENT');
const DashboardActionKeyEnum _$dashboardActionKeyEnum_DISPUTE_RESPONSE =
    const DashboardActionKeyEnum._('DISPUTE_RESPONSE');
const DashboardActionKeyEnum _$dashboardActionKeyEnum_OUT_OF_STOCK =
    const DashboardActionKeyEnum._('OUT_OF_STOCK');
const DashboardActionKeyEnum _$dashboardActionKeyEnum_LIMITED_STOCK =
    const DashboardActionKeyEnum._('LIMITED_STOCK');

DashboardActionKeyEnum _$dashboardActionKeyEnumValueOf(String name) {
  switch (name) {
    case 'ORDER_CONFIRMATION':
      return _$dashboardActionKeyEnum_ORDER_CONFIRMATION;
    case 'FULFILLMENT_OVERDUE':
      return _$dashboardActionKeyEnum_FULFILLMENT_OVERDUE;
    case 'FULFILLMENT_DUE_TODAY':
      return _$dashboardActionKeyEnum_FULFILLMENT_DUE_TODAY;
    case 'ASSIGNED_FULFILLMENT':
      return _$dashboardActionKeyEnum_ASSIGNED_FULFILLMENT;
    case 'DISPUTE_RESPONSE':
      return _$dashboardActionKeyEnum_DISPUTE_RESPONSE;
    case 'OUT_OF_STOCK':
      return _$dashboardActionKeyEnum_OUT_OF_STOCK;
    case 'LIMITED_STOCK':
      return _$dashboardActionKeyEnum_LIMITED_STOCK;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DashboardActionKeyEnum> _$dashboardActionKeyEnumValues =
    BuiltSet<DashboardActionKeyEnum>(const <DashboardActionKeyEnum>[
  _$dashboardActionKeyEnum_ORDER_CONFIRMATION,
  _$dashboardActionKeyEnum_FULFILLMENT_OVERDUE,
  _$dashboardActionKeyEnum_FULFILLMENT_DUE_TODAY,
  _$dashboardActionKeyEnum_ASSIGNED_FULFILLMENT,
  _$dashboardActionKeyEnum_DISPUTE_RESPONSE,
  _$dashboardActionKeyEnum_OUT_OF_STOCK,
  _$dashboardActionKeyEnum_LIMITED_STOCK,
]);

const DashboardActionSeverityEnum _$dashboardActionSeverityEnum_ACTION =
    const DashboardActionSeverityEnum._('ACTION');
const DashboardActionSeverityEnum _$dashboardActionSeverityEnum_ALERT =
    const DashboardActionSeverityEnum._('ALERT');

DashboardActionSeverityEnum _$dashboardActionSeverityEnumValueOf(String name) {
  switch (name) {
    case 'ACTION':
      return _$dashboardActionSeverityEnum_ACTION;
    case 'ALERT':
      return _$dashboardActionSeverityEnum_ALERT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DashboardActionSeverityEnum>
    _$dashboardActionSeverityEnumValues =
    BuiltSet<DashboardActionSeverityEnum>(const <DashboardActionSeverityEnum>[
  _$dashboardActionSeverityEnum_ACTION,
  _$dashboardActionSeverityEnum_ALERT,
]);

Serializer<DashboardActionKeyEnum> _$dashboardActionKeyEnumSerializer =
    _$DashboardActionKeyEnumSerializer();
Serializer<DashboardActionSeverityEnum>
    _$dashboardActionSeverityEnumSerializer =
    _$DashboardActionSeverityEnumSerializer();

class _$DashboardActionKeyEnumSerializer
    implements PrimitiveSerializer<DashboardActionKeyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ORDER_CONFIRMATION': 'ORDER_CONFIRMATION',
    'FULFILLMENT_OVERDUE': 'FULFILLMENT_OVERDUE',
    'FULFILLMENT_DUE_TODAY': 'FULFILLMENT_DUE_TODAY',
    'ASSIGNED_FULFILLMENT': 'ASSIGNED_FULFILLMENT',
    'DISPUTE_RESPONSE': 'DISPUTE_RESPONSE',
    'OUT_OF_STOCK': 'OUT_OF_STOCK',
    'LIMITED_STOCK': 'LIMITED_STOCK',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ORDER_CONFIRMATION': 'ORDER_CONFIRMATION',
    'FULFILLMENT_OVERDUE': 'FULFILLMENT_OVERDUE',
    'FULFILLMENT_DUE_TODAY': 'FULFILLMENT_DUE_TODAY',
    'ASSIGNED_FULFILLMENT': 'ASSIGNED_FULFILLMENT',
    'DISPUTE_RESPONSE': 'DISPUTE_RESPONSE',
    'OUT_OF_STOCK': 'OUT_OF_STOCK',
    'LIMITED_STOCK': 'LIMITED_STOCK',
  };

  @override
  final Iterable<Type> types = const <Type>[DashboardActionKeyEnum];
  @override
  final String wireName = 'DashboardActionKeyEnum';

  @override
  Object serialize(Serializers serializers, DashboardActionKeyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DashboardActionKeyEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DashboardActionKeyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DashboardActionSeverityEnumSerializer
    implements PrimitiveSerializer<DashboardActionSeverityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTION': 'ACTION',
    'ALERT': 'ALERT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTION': 'ACTION',
    'ALERT': 'ALERT',
  };

  @override
  final Iterable<Type> types = const <Type>[DashboardActionSeverityEnum];
  @override
  final String wireName = 'DashboardActionSeverityEnum';

  @override
  Object serialize(Serializers serializers, DashboardActionSeverityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DashboardActionSeverityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DashboardActionSeverityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DashboardAction extends DashboardAction {
  @override
  final DashboardActionKeyEnum key;
  @override
  final String label;
  @override
  final int count;
  @override
  final DashboardActionSeverityEnum severity;
  @override
  final String href;
  @override
  final String? detail;

  factory _$DashboardAction([void Function(DashboardActionBuilder)? updates]) =>
      (DashboardActionBuilder()..update(updates))._build();

  _$DashboardAction._(
      {required this.key,
      required this.label,
      required this.count,
      required this.severity,
      required this.href,
      this.detail})
      : super._();
  @override
  DashboardAction rebuild(void Function(DashboardActionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardActionBuilder toBuilder() => DashboardActionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardAction &&
        key == other.key &&
        label == other.label &&
        count == other.count &&
        severity == other.severity &&
        href == other.href &&
        detail == other.detail;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, severity.hashCode);
    _$hash = $jc(_$hash, href.hashCode);
    _$hash = $jc(_$hash, detail.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DashboardAction')
          ..add('key', key)
          ..add('label', label)
          ..add('count', count)
          ..add('severity', severity)
          ..add('href', href)
          ..add('detail', detail))
        .toString();
  }
}

class DashboardActionBuilder
    implements Builder<DashboardAction, DashboardActionBuilder> {
  _$DashboardAction? _$v;

  DashboardActionKeyEnum? _key;
  DashboardActionKeyEnum? get key => _$this._key;
  set key(DashboardActionKeyEnum? key) => _$this._key = key;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  DashboardActionSeverityEnum? _severity;
  DashboardActionSeverityEnum? get severity => _$this._severity;
  set severity(DashboardActionSeverityEnum? severity) =>
      _$this._severity = severity;

  String? _href;
  String? get href => _$this._href;
  set href(String? href) => _$this._href = href;

  String? _detail;
  String? get detail => _$this._detail;
  set detail(String? detail) => _$this._detail = detail;

  DashboardActionBuilder() {
    DashboardAction._defaults(this);
  }

  DashboardActionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _label = $v.label;
      _count = $v.count;
      _severity = $v.severity;
      _href = $v.href;
      _detail = $v.detail;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DashboardAction other) {
    _$v = other as _$DashboardAction;
  }

  @override
  void update(void Function(DashboardActionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DashboardAction build() => _build();

  _$DashboardAction _build() {
    final _$result = _$v ??
        _$DashboardAction._(
          key: BuiltValueNullFieldError.checkNotNull(
              key, r'DashboardAction', 'key'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'DashboardAction', 'label'),
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'DashboardAction', 'count'),
          severity: BuiltValueNullFieldError.checkNotNull(
              severity, r'DashboardAction', 'severity'),
          href: BuiltValueNullFieldError.checkNotNull(
              href, r'DashboardAction', 'href'),
          detail: detail,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
