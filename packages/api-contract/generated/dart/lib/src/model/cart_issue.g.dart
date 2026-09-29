// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_issue.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CartIssueSeverityEnum _$cartIssueSeverityEnum_BLOCKING =
    const CartIssueSeverityEnum._('BLOCKING');
const CartIssueSeverityEnum _$cartIssueSeverityEnum_ACTION_REQUIRED =
    const CartIssueSeverityEnum._('ACTION_REQUIRED');
const CartIssueSeverityEnum _$cartIssueSeverityEnum_INFO =
    const CartIssueSeverityEnum._('INFO');

CartIssueSeverityEnum _$cartIssueSeverityEnumValueOf(String name) {
  switch (name) {
    case 'BLOCKING':
      return _$cartIssueSeverityEnum_BLOCKING;
    case 'ACTION_REQUIRED':
      return _$cartIssueSeverityEnum_ACTION_REQUIRED;
    case 'INFO':
      return _$cartIssueSeverityEnum_INFO;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CartIssueSeverityEnum> _$cartIssueSeverityEnumValues =
    BuiltSet<CartIssueSeverityEnum>(const <CartIssueSeverityEnum>[
  _$cartIssueSeverityEnum_BLOCKING,
  _$cartIssueSeverityEnum_ACTION_REQUIRED,
  _$cartIssueSeverityEnum_INFO,
]);

Serializer<CartIssueSeverityEnum> _$cartIssueSeverityEnumSerializer =
    _$CartIssueSeverityEnumSerializer();

class _$CartIssueSeverityEnumSerializer
    implements PrimitiveSerializer<CartIssueSeverityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BLOCKING': 'BLOCKING',
    'ACTION_REQUIRED': 'ACTION_REQUIRED',
    'INFO': 'INFO',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BLOCKING': 'BLOCKING',
    'ACTION_REQUIRED': 'ACTION_REQUIRED',
    'INFO': 'INFO',
  };

  @override
  final Iterable<Type> types = const <Type>[CartIssueSeverityEnum];
  @override
  final String wireName = 'CartIssueSeverityEnum';

  @override
  Object serialize(Serializers serializers, CartIssueSeverityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CartIssueSeverityEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CartIssueSeverityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CartIssue extends CartIssue {
  @override
  final String code;
  @override
  final CartIssueSeverityEnum severity;
  @override
  final String message;

  factory _$CartIssue([void Function(CartIssueBuilder)? updates]) =>
      (CartIssueBuilder()..update(updates))._build();

  _$CartIssue._(
      {required this.code, required this.severity, required this.message})
      : super._();
  @override
  CartIssue rebuild(void Function(CartIssueBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CartIssueBuilder toBuilder() => CartIssueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CartIssue &&
        code == other.code &&
        severity == other.severity &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, severity.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CartIssue')
          ..add('code', code)
          ..add('severity', severity)
          ..add('message', message))
        .toString();
  }
}

class CartIssueBuilder implements Builder<CartIssue, CartIssueBuilder> {
  _$CartIssue? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  CartIssueSeverityEnum? _severity;
  CartIssueSeverityEnum? get severity => _$this._severity;
  set severity(CartIssueSeverityEnum? severity) => _$this._severity = severity;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  CartIssueBuilder() {
    CartIssue._defaults(this);
  }

  CartIssueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _severity = $v.severity;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CartIssue other) {
    _$v = other as _$CartIssue;
  }

  @override
  void update(void Function(CartIssueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CartIssue build() => _build();

  _$CartIssue _build() {
    final _$result = _$v ??
        _$CartIssue._(
          code:
              BuiltValueNullFieldError.checkNotNull(code, r'CartIssue', 'code'),
          severity: BuiltValueNullFieldError.checkNotNull(
              severity, r'CartIssue', 'severity'),
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'CartIssue', 'message'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
