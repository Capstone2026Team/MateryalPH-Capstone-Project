// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buy_again_skipped_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuyAgainSkippedLineReasonCodeEnum
    _$buyAgainSkippedLineReasonCodeEnum_LISTING_UNAVAILABLE =
    const BuyAgainSkippedLineReasonCodeEnum._('LISTING_UNAVAILABLE');
const BuyAgainSkippedLineReasonCodeEnum
    _$buyAgainSkippedLineReasonCodeEnum_OUTSIDE_SELECTED_RADIUS =
    const BuyAgainSkippedLineReasonCodeEnum._('OUTSIDE_SELECTED_RADIUS');
const BuyAgainSkippedLineReasonCodeEnum
    _$buyAgainSkippedLineReasonCodeEnum_STORE_ON_VACATION =
    const BuyAgainSkippedLineReasonCodeEnum._('STORE_ON_VACATION');
const BuyAgainSkippedLineReasonCodeEnum
    _$buyAgainSkippedLineReasonCodeEnum_QUANTITY_INVALID =
    const BuyAgainSkippedLineReasonCodeEnum._('QUANTITY_INVALID');
const BuyAgainSkippedLineReasonCodeEnum
    _$buyAgainSkippedLineReasonCodeEnum_QUANTITY_UNAVAILABLE =
    const BuyAgainSkippedLineReasonCodeEnum._('QUANTITY_UNAVAILABLE');
const BuyAgainSkippedLineReasonCodeEnum
    _$buyAgainSkippedLineReasonCodeEnum_CART_FULL =
    const BuyAgainSkippedLineReasonCodeEnum._('CART_FULL');

BuyAgainSkippedLineReasonCodeEnum _$buyAgainSkippedLineReasonCodeEnumValueOf(
    String name) {
  switch (name) {
    case 'LISTING_UNAVAILABLE':
      return _$buyAgainSkippedLineReasonCodeEnum_LISTING_UNAVAILABLE;
    case 'OUTSIDE_SELECTED_RADIUS':
      return _$buyAgainSkippedLineReasonCodeEnum_OUTSIDE_SELECTED_RADIUS;
    case 'STORE_ON_VACATION':
      return _$buyAgainSkippedLineReasonCodeEnum_STORE_ON_VACATION;
    case 'QUANTITY_INVALID':
      return _$buyAgainSkippedLineReasonCodeEnum_QUANTITY_INVALID;
    case 'QUANTITY_UNAVAILABLE':
      return _$buyAgainSkippedLineReasonCodeEnum_QUANTITY_UNAVAILABLE;
    case 'CART_FULL':
      return _$buyAgainSkippedLineReasonCodeEnum_CART_FULL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyAgainSkippedLineReasonCodeEnum>
    _$buyAgainSkippedLineReasonCodeEnumValues = BuiltSet<
        BuyAgainSkippedLineReasonCodeEnum>(const <BuyAgainSkippedLineReasonCodeEnum>[
  _$buyAgainSkippedLineReasonCodeEnum_LISTING_UNAVAILABLE,
  _$buyAgainSkippedLineReasonCodeEnum_OUTSIDE_SELECTED_RADIUS,
  _$buyAgainSkippedLineReasonCodeEnum_STORE_ON_VACATION,
  _$buyAgainSkippedLineReasonCodeEnum_QUANTITY_INVALID,
  _$buyAgainSkippedLineReasonCodeEnum_QUANTITY_UNAVAILABLE,
  _$buyAgainSkippedLineReasonCodeEnum_CART_FULL,
]);

Serializer<BuyAgainSkippedLineReasonCodeEnum>
    _$buyAgainSkippedLineReasonCodeEnumSerializer =
    _$BuyAgainSkippedLineReasonCodeEnumSerializer();

class _$BuyAgainSkippedLineReasonCodeEnumSerializer
    implements PrimitiveSerializer<BuyAgainSkippedLineReasonCodeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'LISTING_UNAVAILABLE': 'LISTING_UNAVAILABLE',
    'OUTSIDE_SELECTED_RADIUS': 'OUTSIDE_SELECTED_RADIUS',
    'STORE_ON_VACATION': 'STORE_ON_VACATION',
    'QUANTITY_INVALID': 'QUANTITY_INVALID',
    'QUANTITY_UNAVAILABLE': 'QUANTITY_UNAVAILABLE',
    'CART_FULL': 'CART_FULL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'LISTING_UNAVAILABLE': 'LISTING_UNAVAILABLE',
    'OUTSIDE_SELECTED_RADIUS': 'OUTSIDE_SELECTED_RADIUS',
    'STORE_ON_VACATION': 'STORE_ON_VACATION',
    'QUANTITY_INVALID': 'QUANTITY_INVALID',
    'QUANTITY_UNAVAILABLE': 'QUANTITY_UNAVAILABLE',
    'CART_FULL': 'CART_FULL',
  };

  @override
  final Iterable<Type> types = const <Type>[BuyAgainSkippedLineReasonCodeEnum];
  @override
  final String wireName = 'BuyAgainSkippedLineReasonCodeEnum';

  @override
  Object serialize(
          Serializers serializers, BuyAgainSkippedLineReasonCodeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyAgainSkippedLineReasonCodeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyAgainSkippedLineReasonCodeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyAgainSkippedLine extends BuyAgainSkippedLine {
  @override
  final String displayName;
  @override
  final BuyAgainSkippedLineReasonCodeEnum reasonCode;
  @override
  final String message;

  factory _$BuyAgainSkippedLine(
          [void Function(BuyAgainSkippedLineBuilder)? updates]) =>
      (BuyAgainSkippedLineBuilder()..update(updates))._build();

  _$BuyAgainSkippedLine._(
      {required this.displayName,
      required this.reasonCode,
      required this.message})
      : super._();
  @override
  BuyAgainSkippedLine rebuild(
          void Function(BuyAgainSkippedLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyAgainSkippedLineBuilder toBuilder() =>
      BuyAgainSkippedLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyAgainSkippedLine &&
        displayName == other.displayName &&
        reasonCode == other.reasonCode &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, reasonCode.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyAgainSkippedLine')
          ..add('displayName', displayName)
          ..add('reasonCode', reasonCode)
          ..add('message', message))
        .toString();
  }
}

class BuyAgainSkippedLineBuilder
    implements Builder<BuyAgainSkippedLine, BuyAgainSkippedLineBuilder> {
  _$BuyAgainSkippedLine? _$v;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  BuyAgainSkippedLineReasonCodeEnum? _reasonCode;
  BuyAgainSkippedLineReasonCodeEnum? get reasonCode => _$this._reasonCode;
  set reasonCode(BuyAgainSkippedLineReasonCodeEnum? reasonCode) =>
      _$this._reasonCode = reasonCode;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  BuyAgainSkippedLineBuilder() {
    BuyAgainSkippedLine._defaults(this);
  }

  BuyAgainSkippedLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayName = $v.displayName;
      _reasonCode = $v.reasonCode;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyAgainSkippedLine other) {
    _$v = other as _$BuyAgainSkippedLine;
  }

  @override
  void update(void Function(BuyAgainSkippedLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyAgainSkippedLine build() => _build();

  _$BuyAgainSkippedLine _build() {
    final _$result = _$v ??
        _$BuyAgainSkippedLine._(
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'BuyAgainSkippedLine', 'displayName'),
          reasonCode: BuiltValueNullFieldError.checkNotNull(
              reasonCode, r'BuyAgainSkippedLine', 'reasonCode'),
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'BuyAgainSkippedLine', 'message'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
