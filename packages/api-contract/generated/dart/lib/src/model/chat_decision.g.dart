// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_decision.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ChatDecisionPaymentMethodEnum _$chatDecisionPaymentMethodEnum_ONLINE =
    const ChatDecisionPaymentMethodEnum._('ONLINE');
const ChatDecisionPaymentMethodEnum
    _$chatDecisionPaymentMethodEnum_CASH_ON_DELIVERY =
    const ChatDecisionPaymentMethodEnum._('CASH_ON_DELIVERY');
const ChatDecisionPaymentMethodEnum _$chatDecisionPaymentMethodEnum_IN_STORE =
    const ChatDecisionPaymentMethodEnum._('IN_STORE');

ChatDecisionPaymentMethodEnum _$chatDecisionPaymentMethodEnumValueOf(
    String name) {
  switch (name) {
    case 'ONLINE':
      return _$chatDecisionPaymentMethodEnum_ONLINE;
    case 'CASH_ON_DELIVERY':
      return _$chatDecisionPaymentMethodEnum_CASH_ON_DELIVERY;
    case 'IN_STORE':
      return _$chatDecisionPaymentMethodEnum_IN_STORE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ChatDecisionPaymentMethodEnum>
    _$chatDecisionPaymentMethodEnumValues = BuiltSet<
        ChatDecisionPaymentMethodEnum>(const <ChatDecisionPaymentMethodEnum>[
  _$chatDecisionPaymentMethodEnum_ONLINE,
  _$chatDecisionPaymentMethodEnum_CASH_ON_DELIVERY,
  _$chatDecisionPaymentMethodEnum_IN_STORE,
]);

Serializer<ChatDecisionPaymentMethodEnum>
    _$chatDecisionPaymentMethodEnumSerializer =
    _$ChatDecisionPaymentMethodEnumSerializer();

class _$ChatDecisionPaymentMethodEnumSerializer
    implements PrimitiveSerializer<ChatDecisionPaymentMethodEnum> {
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
  final Iterable<Type> types = const <Type>[ChatDecisionPaymentMethodEnum];
  @override
  final String wireName = 'ChatDecisionPaymentMethodEnum';

  @override
  Object serialize(
          Serializers serializers, ChatDecisionPaymentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ChatDecisionPaymentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ChatDecisionPaymentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ChatDecision extends ChatDecision {
  @override
  final ChatDecisionPaymentMethodEnum? paymentMethod;
  @override
  final String? budgetOverrideReason;
  @override
  final String versionId;
  @override
  final String? contentHash;
  @override
  final String? reason;
  @override
  final bool? nrpcAcknowledged;
  @override
  final String? nrpcTermsVersionId;

  factory _$ChatDecision([void Function(ChatDecisionBuilder)? updates]) =>
      (ChatDecisionBuilder()..update(updates))._build();

  _$ChatDecision._(
      {this.paymentMethod,
      this.budgetOverrideReason,
      required this.versionId,
      this.contentHash,
      this.reason,
      this.nrpcAcknowledged,
      this.nrpcTermsVersionId})
      : super._();
  @override
  ChatDecision rebuild(void Function(ChatDecisionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatDecisionBuilder toBuilder() => ChatDecisionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatDecision &&
        paymentMethod == other.paymentMethod &&
        budgetOverrideReason == other.budgetOverrideReason &&
        versionId == other.versionId &&
        contentHash == other.contentHash &&
        reason == other.reason &&
        nrpcAcknowledged == other.nrpcAcknowledged &&
        nrpcTermsVersionId == other.nrpcTermsVersionId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, paymentMethod.hashCode);
    _$hash = $jc(_$hash, budgetOverrideReason.hashCode);
    _$hash = $jc(_$hash, versionId.hashCode);
    _$hash = $jc(_$hash, contentHash.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, nrpcAcknowledged.hashCode);
    _$hash = $jc(_$hash, nrpcTermsVersionId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatDecision')
          ..add('paymentMethod', paymentMethod)
          ..add('budgetOverrideReason', budgetOverrideReason)
          ..add('versionId', versionId)
          ..add('contentHash', contentHash)
          ..add('reason', reason)
          ..add('nrpcAcknowledged', nrpcAcknowledged)
          ..add('nrpcTermsVersionId', nrpcTermsVersionId))
        .toString();
  }
}

class ChatDecisionBuilder
    implements Builder<ChatDecision, ChatDecisionBuilder> {
  _$ChatDecision? _$v;

  ChatDecisionPaymentMethodEnum? _paymentMethod;
  ChatDecisionPaymentMethodEnum? get paymentMethod => _$this._paymentMethod;
  set paymentMethod(ChatDecisionPaymentMethodEnum? paymentMethod) =>
      _$this._paymentMethod = paymentMethod;

  String? _budgetOverrideReason;
  String? get budgetOverrideReason => _$this._budgetOverrideReason;
  set budgetOverrideReason(String? budgetOverrideReason) =>
      _$this._budgetOverrideReason = budgetOverrideReason;

  String? _versionId;
  String? get versionId => _$this._versionId;
  set versionId(String? versionId) => _$this._versionId = versionId;

  String? _contentHash;
  String? get contentHash => _$this._contentHash;
  set contentHash(String? contentHash) => _$this._contentHash = contentHash;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  bool? _nrpcAcknowledged;
  bool? get nrpcAcknowledged => _$this._nrpcAcknowledged;
  set nrpcAcknowledged(bool? nrpcAcknowledged) =>
      _$this._nrpcAcknowledged = nrpcAcknowledged;

  String? _nrpcTermsVersionId;
  String? get nrpcTermsVersionId => _$this._nrpcTermsVersionId;
  set nrpcTermsVersionId(String? nrpcTermsVersionId) =>
      _$this._nrpcTermsVersionId = nrpcTermsVersionId;

  ChatDecisionBuilder() {
    ChatDecision._defaults(this);
  }

  ChatDecisionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _paymentMethod = $v.paymentMethod;
      _budgetOverrideReason = $v.budgetOverrideReason;
      _versionId = $v.versionId;
      _contentHash = $v.contentHash;
      _reason = $v.reason;
      _nrpcAcknowledged = $v.nrpcAcknowledged;
      _nrpcTermsVersionId = $v.nrpcTermsVersionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatDecision other) {
    _$v = other as _$ChatDecision;
  }

  @override
  void update(void Function(ChatDecisionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatDecision build() => _build();

  _$ChatDecision _build() {
    final _$result = _$v ??
        _$ChatDecision._(
          paymentMethod: paymentMethod,
          budgetOverrideReason: budgetOverrideReason,
          versionId: BuiltValueNullFieldError.checkNotNull(
              versionId, r'ChatDecision', 'versionId'),
          contentHash: contentHash,
          reason: reason,
          nrpcAcknowledged: nrpcAcknowledged,
          nrpcTermsVersionId: nrpcTermsVersionId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
