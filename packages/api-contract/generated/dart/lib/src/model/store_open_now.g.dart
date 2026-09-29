// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_open_now.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const StoreOpenNowStatusEnum _$storeOpenNowStatusEnum_OPEN =
    const StoreOpenNowStatusEnum._('OPEN');
const StoreOpenNowStatusEnum _$storeOpenNowStatusEnum_CLOSED =
    const StoreOpenNowStatusEnum._('CLOSED');
const StoreOpenNowStatusEnum _$storeOpenNowStatusEnum_UNAVAILABLE =
    const StoreOpenNowStatusEnum._('UNAVAILABLE');

StoreOpenNowStatusEnum _$storeOpenNowStatusEnumValueOf(String name) {
  switch (name) {
    case 'OPEN':
      return _$storeOpenNowStatusEnum_OPEN;
    case 'CLOSED':
      return _$storeOpenNowStatusEnum_CLOSED;
    case 'UNAVAILABLE':
      return _$storeOpenNowStatusEnum_UNAVAILABLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<StoreOpenNowStatusEnum> _$storeOpenNowStatusEnumValues =
    BuiltSet<StoreOpenNowStatusEnum>(const <StoreOpenNowStatusEnum>[
  _$storeOpenNowStatusEnum_OPEN,
  _$storeOpenNowStatusEnum_CLOSED,
  _$storeOpenNowStatusEnum_UNAVAILABLE,
]);

const StoreOpenNowBasisEnum _$storeOpenNowBasisEnum_SAVED_SCHEDULE =
    const StoreOpenNowBasisEnum._('SAVED_SCHEDULE');
const StoreOpenNowBasisEnum _$storeOpenNowBasisEnum_DATE_OVERRIDE =
    const StoreOpenNowBasisEnum._('DATE_OVERRIDE');

StoreOpenNowBasisEnum _$storeOpenNowBasisEnumValueOf(String name) {
  switch (name) {
    case 'SAVED_SCHEDULE':
      return _$storeOpenNowBasisEnum_SAVED_SCHEDULE;
    case 'DATE_OVERRIDE':
      return _$storeOpenNowBasisEnum_DATE_OVERRIDE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<StoreOpenNowBasisEnum> _$storeOpenNowBasisEnumValues =
    BuiltSet<StoreOpenNowBasisEnum>(const <StoreOpenNowBasisEnum>[
  _$storeOpenNowBasisEnum_SAVED_SCHEDULE,
  _$storeOpenNowBasisEnum_DATE_OVERRIDE,
]);

Serializer<StoreOpenNowStatusEnum> _$storeOpenNowStatusEnumSerializer =
    _$StoreOpenNowStatusEnumSerializer();
Serializer<StoreOpenNowBasisEnum> _$storeOpenNowBasisEnumSerializer =
    _$StoreOpenNowBasisEnumSerializer();

class _$StoreOpenNowStatusEnumSerializer
    implements PrimitiveSerializer<StoreOpenNowStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OPEN': 'OPEN',
    'CLOSED': 'CLOSED',
    'UNAVAILABLE': 'UNAVAILABLE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OPEN': 'OPEN',
    'CLOSED': 'CLOSED',
    'UNAVAILABLE': 'UNAVAILABLE',
  };

  @override
  final Iterable<Type> types = const <Type>[StoreOpenNowStatusEnum];
  @override
  final String wireName = 'StoreOpenNowStatusEnum';

  @override
  Object serialize(Serializers serializers, StoreOpenNowStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  StoreOpenNowStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      StoreOpenNowStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$StoreOpenNowBasisEnumSerializer
    implements PrimitiveSerializer<StoreOpenNowBasisEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SAVED_SCHEDULE': 'SAVED_SCHEDULE',
    'DATE_OVERRIDE': 'DATE_OVERRIDE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SAVED_SCHEDULE': 'SAVED_SCHEDULE',
    'DATE_OVERRIDE': 'DATE_OVERRIDE',
  };

  @override
  final Iterable<Type> types = const <Type>[StoreOpenNowBasisEnum];
  @override
  final String wireName = 'StoreOpenNowBasisEnum';

  @override
  Object serialize(Serializers serializers, StoreOpenNowBasisEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  StoreOpenNowBasisEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      StoreOpenNowBasisEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$StoreOpenNow extends StoreOpenNow {
  @override
  final StoreOpenNowStatusEnum status;
  @override
  final String? closesAt;
  @override
  final StoreNextOpening? nextOpening;
  @override
  final StoreOpenNowBasisEnum basis;

  factory _$StoreOpenNow([void Function(StoreOpenNowBuilder)? updates]) =>
      (StoreOpenNowBuilder()..update(updates))._build();

  _$StoreOpenNow._(
      {required this.status,
      this.closesAt,
      this.nextOpening,
      required this.basis})
      : super._();
  @override
  StoreOpenNow rebuild(void Function(StoreOpenNowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StoreOpenNowBuilder toBuilder() => StoreOpenNowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StoreOpenNow &&
        status == other.status &&
        closesAt == other.closesAt &&
        nextOpening == other.nextOpening &&
        basis == other.basis;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, closesAt.hashCode);
    _$hash = $jc(_$hash, nextOpening.hashCode);
    _$hash = $jc(_$hash, basis.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StoreOpenNow')
          ..add('status', status)
          ..add('closesAt', closesAt)
          ..add('nextOpening', nextOpening)
          ..add('basis', basis))
        .toString();
  }
}

class StoreOpenNowBuilder
    implements Builder<StoreOpenNow, StoreOpenNowBuilder> {
  _$StoreOpenNow? _$v;

  StoreOpenNowStatusEnum? _status;
  StoreOpenNowStatusEnum? get status => _$this._status;
  set status(StoreOpenNowStatusEnum? status) => _$this._status = status;

  String? _closesAt;
  String? get closesAt => _$this._closesAt;
  set closesAt(String? closesAt) => _$this._closesAt = closesAt;

  StoreNextOpeningBuilder? _nextOpening;
  StoreNextOpeningBuilder get nextOpening =>
      _$this._nextOpening ??= StoreNextOpeningBuilder();
  set nextOpening(StoreNextOpeningBuilder? nextOpening) =>
      _$this._nextOpening = nextOpening;

  StoreOpenNowBasisEnum? _basis;
  StoreOpenNowBasisEnum? get basis => _$this._basis;
  set basis(StoreOpenNowBasisEnum? basis) => _$this._basis = basis;

  StoreOpenNowBuilder() {
    StoreOpenNow._defaults(this);
  }

  StoreOpenNowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _closesAt = $v.closesAt;
      _nextOpening = $v.nextOpening?.toBuilder();
      _basis = $v.basis;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StoreOpenNow other) {
    _$v = other as _$StoreOpenNow;
  }

  @override
  void update(void Function(StoreOpenNowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StoreOpenNow build() => _build();

  _$StoreOpenNow _build() {
    _$StoreOpenNow _$result;
    try {
      _$result = _$v ??
          _$StoreOpenNow._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'StoreOpenNow', 'status'),
            closesAt: closesAt,
            nextOpening: _nextOpening?.build(),
            basis: BuiltValueNullFieldError.checkNotNull(
                basis, r'StoreOpenNow', 'basis'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'nextOpening';
        _nextOpening?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'StoreOpenNow', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
