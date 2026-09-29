// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comparable_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ComparableStatusStatusEnum _$comparableStatusStatusEnum_COMPARABLE =
    const ComparableStatusStatusEnum._('COMPARABLE');
const ComparableStatusStatusEnum
    _$comparableStatusStatusEnum_NOT_YET_COMPARABLE =
    const ComparableStatusStatusEnum._('NOT_YET_COMPARABLE');

ComparableStatusStatusEnum _$comparableStatusStatusEnumValueOf(String name) {
  switch (name) {
    case 'COMPARABLE':
      return _$comparableStatusStatusEnum_COMPARABLE;
    case 'NOT_YET_COMPARABLE':
      return _$comparableStatusStatusEnum_NOT_YET_COMPARABLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ComparableStatusStatusEnum> _$comparableStatusStatusEnumValues =
    BuiltSet<ComparableStatusStatusEnum>(const <ComparableStatusStatusEnum>[
  _$comparableStatusStatusEnum_COMPARABLE,
  _$comparableStatusStatusEnum_NOT_YET_COMPARABLE,
]);

Serializer<ComparableStatusStatusEnum> _$comparableStatusStatusEnumSerializer =
    _$ComparableStatusStatusEnumSerializer();

class _$ComparableStatusStatusEnumSerializer
    implements PrimitiveSerializer<ComparableStatusStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'COMPARABLE': 'COMPARABLE',
    'NOT_YET_COMPARABLE': 'NOT_YET_COMPARABLE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'COMPARABLE': 'COMPARABLE',
    'NOT_YET_COMPARABLE': 'NOT_YET_COMPARABLE',
  };

  @override
  final Iterable<Type> types = const <Type>[ComparableStatusStatusEnum];
  @override
  final String wireName = 'ComparableStatusStatusEnum';

  @override
  Object serialize(Serializers serializers, ComparableStatusStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ComparableStatusStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ComparableStatusStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ComparableStatus extends ComparableStatus {
  @override
  final ComparableStatusStatusEnum status;
  @override
  final String? normalizedUnitPrice;
  @override
  final String? canonicalUnitCode;

  factory _$ComparableStatus(
          [void Function(ComparableStatusBuilder)? updates]) =>
      (ComparableStatusBuilder()..update(updates))._build();

  _$ComparableStatus._(
      {required this.status, this.normalizedUnitPrice, this.canonicalUnitCode})
      : super._();
  @override
  ComparableStatus rebuild(void Function(ComparableStatusBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComparableStatusBuilder toBuilder() =>
      ComparableStatusBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComparableStatus &&
        status == other.status &&
        normalizedUnitPrice == other.normalizedUnitPrice &&
        canonicalUnitCode == other.canonicalUnitCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, normalizedUnitPrice.hashCode);
    _$hash = $jc(_$hash, canonicalUnitCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ComparableStatus')
          ..add('status', status)
          ..add('normalizedUnitPrice', normalizedUnitPrice)
          ..add('canonicalUnitCode', canonicalUnitCode))
        .toString();
  }
}

class ComparableStatusBuilder
    implements Builder<ComparableStatus, ComparableStatusBuilder> {
  _$ComparableStatus? _$v;

  ComparableStatusStatusEnum? _status;
  ComparableStatusStatusEnum? get status => _$this._status;
  set status(ComparableStatusStatusEnum? status) => _$this._status = status;

  String? _normalizedUnitPrice;
  String? get normalizedUnitPrice => _$this._normalizedUnitPrice;
  set normalizedUnitPrice(String? normalizedUnitPrice) =>
      _$this._normalizedUnitPrice = normalizedUnitPrice;

  String? _canonicalUnitCode;
  String? get canonicalUnitCode => _$this._canonicalUnitCode;
  set canonicalUnitCode(String? canonicalUnitCode) =>
      _$this._canonicalUnitCode = canonicalUnitCode;

  ComparableStatusBuilder() {
    ComparableStatus._defaults(this);
  }

  ComparableStatusBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _normalizedUnitPrice = $v.normalizedUnitPrice;
      _canonicalUnitCode = $v.canonicalUnitCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComparableStatus other) {
    _$v = other as _$ComparableStatus;
  }

  @override
  void update(void Function(ComparableStatusBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComparableStatus build() => _build();

  _$ComparableStatus _build() {
    final _$result = _$v ??
        _$ComparableStatus._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ComparableStatus', 'status'),
          normalizedUnitPrice: normalizedUnitPrice,
          canonicalUnitCode: canonicalUnitCode,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
