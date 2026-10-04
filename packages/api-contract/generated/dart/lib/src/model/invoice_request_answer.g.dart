// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_request_answer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const InvoiceRequestAnswerActionEnum _$invoiceRequestAnswerActionEnum_RETURN =
    const InvoiceRequestAnswerActionEnum._('RETURN');
const InvoiceRequestAnswerActionEnum _$invoiceRequestAnswerActionEnum_CLOSE =
    const InvoiceRequestAnswerActionEnum._('CLOSE');

InvoiceRequestAnswerActionEnum _$invoiceRequestAnswerActionEnumValueOf(
    String name) {
  switch (name) {
    case 'RETURN':
      return _$invoiceRequestAnswerActionEnum_RETURN;
    case 'CLOSE':
      return _$invoiceRequestAnswerActionEnum_CLOSE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InvoiceRequestAnswerActionEnum>
    _$invoiceRequestAnswerActionEnumValues = BuiltSet<
        InvoiceRequestAnswerActionEnum>(const <InvoiceRequestAnswerActionEnum>[
  _$invoiceRequestAnswerActionEnum_RETURN,
  _$invoiceRequestAnswerActionEnum_CLOSE,
]);

Serializer<InvoiceRequestAnswerActionEnum>
    _$invoiceRequestAnswerActionEnumSerializer =
    _$InvoiceRequestAnswerActionEnumSerializer();

class _$InvoiceRequestAnswerActionEnumSerializer
    implements PrimitiveSerializer<InvoiceRequestAnswerActionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'RETURN': 'RETURN',
    'CLOSE': 'CLOSE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'RETURN': 'RETURN',
    'CLOSE': 'CLOSE',
  };

  @override
  final Iterable<Type> types = const <Type>[InvoiceRequestAnswerActionEnum];
  @override
  final String wireName = 'InvoiceRequestAnswerActionEnum';

  @override
  Object serialize(
          Serializers serializers, InvoiceRequestAnswerActionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InvoiceRequestAnswerActionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InvoiceRequestAnswerActionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InvoiceRequestAnswer extends InvoiceRequestAnswer {
  @override
  final InvoiceRequestAnswerActionEnum action;
  @override
  final String? reason;

  factory _$InvoiceRequestAnswer(
          [void Function(InvoiceRequestAnswerBuilder)? updates]) =>
      (InvoiceRequestAnswerBuilder()..update(updates))._build();

  _$InvoiceRequestAnswer._({required this.action, this.reason}) : super._();
  @override
  InvoiceRequestAnswer rebuild(
          void Function(InvoiceRequestAnswerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvoiceRequestAnswerBuilder toBuilder() =>
      InvoiceRequestAnswerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvoiceRequestAnswer &&
        action == other.action &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InvoiceRequestAnswer')
          ..add('action', action)
          ..add('reason', reason))
        .toString();
  }
}

class InvoiceRequestAnswerBuilder
    implements Builder<InvoiceRequestAnswer, InvoiceRequestAnswerBuilder> {
  _$InvoiceRequestAnswer? _$v;

  InvoiceRequestAnswerActionEnum? _action;
  InvoiceRequestAnswerActionEnum? get action => _$this._action;
  set action(InvoiceRequestAnswerActionEnum? action) => _$this._action = action;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  InvoiceRequestAnswerBuilder() {
    InvoiceRequestAnswer._defaults(this);
  }

  InvoiceRequestAnswerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _action = $v.action;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InvoiceRequestAnswer other) {
    _$v = other as _$InvoiceRequestAnswer;
  }

  @override
  void update(void Function(InvoiceRequestAnswerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvoiceRequestAnswer build() => _build();

  _$InvoiceRequestAnswer _build() {
    final _$result = _$v ??
        _$InvoiceRequestAnswer._(
          action: BuiltValueNullFieldError.checkNotNull(
              action, r'InvoiceRequestAnswer', 'action'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
