// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_commercial_version.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderCommercialVersionKindEnum
    _$orderCommercialVersionKindEnum_SUBMITTED =
    const OrderCommercialVersionKindEnum._('SUBMITTED');
const OrderCommercialVersionKindEnum
    _$orderCommercialVersionKindEnum_VENDOR_CONFIRMED =
    const OrderCommercialVersionKindEnum._('VENDOR_CONFIRMED');
const OrderCommercialVersionKindEnum
    _$orderCommercialVersionKindEnum_AUTO_ACCEPTED =
    const OrderCommercialVersionKindEnum._('AUTO_ACCEPTED');

OrderCommercialVersionKindEnum _$orderCommercialVersionKindEnumValueOf(
    String name) {
  switch (name) {
    case 'SUBMITTED':
      return _$orderCommercialVersionKindEnum_SUBMITTED;
    case 'VENDOR_CONFIRMED':
      return _$orderCommercialVersionKindEnum_VENDOR_CONFIRMED;
    case 'AUTO_ACCEPTED':
      return _$orderCommercialVersionKindEnum_AUTO_ACCEPTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderCommercialVersionKindEnum>
    _$orderCommercialVersionKindEnumValues = BuiltSet<
        OrderCommercialVersionKindEnum>(const <OrderCommercialVersionKindEnum>[
  _$orderCommercialVersionKindEnum_SUBMITTED,
  _$orderCommercialVersionKindEnum_VENDOR_CONFIRMED,
  _$orderCommercialVersionKindEnum_AUTO_ACCEPTED,
]);

Serializer<OrderCommercialVersionKindEnum>
    _$orderCommercialVersionKindEnumSerializer =
    _$OrderCommercialVersionKindEnumSerializer();

class _$OrderCommercialVersionKindEnumSerializer
    implements PrimitiveSerializer<OrderCommercialVersionKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SUBMITTED': 'SUBMITTED',
    'VENDOR_CONFIRMED': 'VENDOR_CONFIRMED',
    'AUTO_ACCEPTED': 'AUTO_ACCEPTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SUBMITTED': 'SUBMITTED',
    'VENDOR_CONFIRMED': 'VENDOR_CONFIRMED',
    'AUTO_ACCEPTED': 'AUTO_ACCEPTED',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderCommercialVersionKindEnum];
  @override
  final String wireName = 'OrderCommercialVersionKindEnum';

  @override
  Object serialize(
          Serializers serializers, OrderCommercialVersionKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderCommercialVersionKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderCommercialVersionKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderCommercialVersion extends OrderCommercialVersion {
  @override
  final int current;
  @override
  final int? accepted;
  @override
  final OrderCommercialVersionKindEnum? kind;
  @override
  final String? contentHash;
  @override
  final DateTime? recordedAt;

  factory _$OrderCommercialVersion(
          [void Function(OrderCommercialVersionBuilder)? updates]) =>
      (OrderCommercialVersionBuilder()..update(updates))._build();

  _$OrderCommercialVersion._(
      {required this.current,
      this.accepted,
      this.kind,
      this.contentHash,
      this.recordedAt})
      : super._();
  @override
  OrderCommercialVersion rebuild(
          void Function(OrderCommercialVersionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderCommercialVersionBuilder toBuilder() =>
      OrderCommercialVersionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderCommercialVersion &&
        current == other.current &&
        accepted == other.accepted &&
        kind == other.kind &&
        contentHash == other.contentHash &&
        recordedAt == other.recordedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, current.hashCode);
    _$hash = $jc(_$hash, accepted.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, contentHash.hashCode);
    _$hash = $jc(_$hash, recordedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderCommercialVersion')
          ..add('current', current)
          ..add('accepted', accepted)
          ..add('kind', kind)
          ..add('contentHash', contentHash)
          ..add('recordedAt', recordedAt))
        .toString();
  }
}

class OrderCommercialVersionBuilder
    implements Builder<OrderCommercialVersion, OrderCommercialVersionBuilder> {
  _$OrderCommercialVersion? _$v;

  int? _current;
  int? get current => _$this._current;
  set current(int? current) => _$this._current = current;

  int? _accepted;
  int? get accepted => _$this._accepted;
  set accepted(int? accepted) => _$this._accepted = accepted;

  OrderCommercialVersionKindEnum? _kind;
  OrderCommercialVersionKindEnum? get kind => _$this._kind;
  set kind(OrderCommercialVersionKindEnum? kind) => _$this._kind = kind;

  String? _contentHash;
  String? get contentHash => _$this._contentHash;
  set contentHash(String? contentHash) => _$this._contentHash = contentHash;

  DateTime? _recordedAt;
  DateTime? get recordedAt => _$this._recordedAt;
  set recordedAt(DateTime? recordedAt) => _$this._recordedAt = recordedAt;

  OrderCommercialVersionBuilder() {
    OrderCommercialVersion._defaults(this);
  }

  OrderCommercialVersionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _current = $v.current;
      _accepted = $v.accepted;
      _kind = $v.kind;
      _contentHash = $v.contentHash;
      _recordedAt = $v.recordedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderCommercialVersion other) {
    _$v = other as _$OrderCommercialVersion;
  }

  @override
  void update(void Function(OrderCommercialVersionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderCommercialVersion build() => _build();

  _$OrderCommercialVersion _build() {
    final _$result = _$v ??
        _$OrderCommercialVersion._(
          current: BuiltValueNullFieldError.checkNotNull(
              current, r'OrderCommercialVersion', 'current'),
          accepted: accepted,
          kind: kind,
          contentHash: contentHash,
          recordedAt: recordedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
