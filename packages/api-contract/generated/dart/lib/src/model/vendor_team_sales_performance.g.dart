// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_sales_performance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTeamSalesPerformance extends VendorTeamSalesPerformance {
  @override
  final int orders;
  @override
  final int completed;
  @override
  final int cancelled;
  @override
  final int? valueCentavos;
  @override
  final int conversations;
  @override
  final int messages;
  @override
  final int awaitingReply;
  @override
  final VendorTeamReplyTime reply;

  factory _$VendorTeamSalesPerformance(
          [void Function(VendorTeamSalesPerformanceBuilder)? updates]) =>
      (VendorTeamSalesPerformanceBuilder()..update(updates))._build();

  _$VendorTeamSalesPerformance._(
      {required this.orders,
      required this.completed,
      required this.cancelled,
      this.valueCentavos,
      required this.conversations,
      required this.messages,
      required this.awaitingReply,
      required this.reply})
      : super._();
  @override
  VendorTeamSalesPerformance rebuild(
          void Function(VendorTeamSalesPerformanceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamSalesPerformanceBuilder toBuilder() =>
      VendorTeamSalesPerformanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamSalesPerformance &&
        orders == other.orders &&
        completed == other.completed &&
        cancelled == other.cancelled &&
        valueCentavos == other.valueCentavos &&
        conversations == other.conversations &&
        messages == other.messages &&
        awaitingReply == other.awaitingReply &&
        reply == other.reply;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, completed.hashCode);
    _$hash = $jc(_$hash, cancelled.hashCode);
    _$hash = $jc(_$hash, valueCentavos.hashCode);
    _$hash = $jc(_$hash, conversations.hashCode);
    _$hash = $jc(_$hash, messages.hashCode);
    _$hash = $jc(_$hash, awaitingReply.hashCode);
    _$hash = $jc(_$hash, reply.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTeamSalesPerformance')
          ..add('orders', orders)
          ..add('completed', completed)
          ..add('cancelled', cancelled)
          ..add('valueCentavos', valueCentavos)
          ..add('conversations', conversations)
          ..add('messages', messages)
          ..add('awaitingReply', awaitingReply)
          ..add('reply', reply))
        .toString();
  }
}

class VendorTeamSalesPerformanceBuilder
    implements
        Builder<VendorTeamSalesPerformance, VendorTeamSalesPerformanceBuilder> {
  _$VendorTeamSalesPerformance? _$v;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  int? _completed;
  int? get completed => _$this._completed;
  set completed(int? completed) => _$this._completed = completed;

  int? _cancelled;
  int? get cancelled => _$this._cancelled;
  set cancelled(int? cancelled) => _$this._cancelled = cancelled;

  int? _valueCentavos;
  int? get valueCentavos => _$this._valueCentavos;
  set valueCentavos(int? valueCentavos) =>
      _$this._valueCentavos = valueCentavos;

  int? _conversations;
  int? get conversations => _$this._conversations;
  set conversations(int? conversations) =>
      _$this._conversations = conversations;

  int? _messages;
  int? get messages => _$this._messages;
  set messages(int? messages) => _$this._messages = messages;

  int? _awaitingReply;
  int? get awaitingReply => _$this._awaitingReply;
  set awaitingReply(int? awaitingReply) =>
      _$this._awaitingReply = awaitingReply;

  VendorTeamReplyTimeBuilder? _reply;
  VendorTeamReplyTimeBuilder get reply =>
      _$this._reply ??= VendorTeamReplyTimeBuilder();
  set reply(VendorTeamReplyTimeBuilder? reply) => _$this._reply = reply;

  VendorTeamSalesPerformanceBuilder() {
    VendorTeamSalesPerformance._defaults(this);
  }

  VendorTeamSalesPerformanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orders = $v.orders;
      _completed = $v.completed;
      _cancelled = $v.cancelled;
      _valueCentavos = $v.valueCentavos;
      _conversations = $v.conversations;
      _messages = $v.messages;
      _awaitingReply = $v.awaitingReply;
      _reply = $v.reply.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTeamSalesPerformance other) {
    _$v = other as _$VendorTeamSalesPerformance;
  }

  @override
  void update(void Function(VendorTeamSalesPerformanceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamSalesPerformance build() => _build();

  _$VendorTeamSalesPerformance _build() {
    _$VendorTeamSalesPerformance _$result;
    try {
      _$result = _$v ??
          _$VendorTeamSalesPerformance._(
            orders: BuiltValueNullFieldError.checkNotNull(
                orders, r'VendorTeamSalesPerformance', 'orders'),
            completed: BuiltValueNullFieldError.checkNotNull(
                completed, r'VendorTeamSalesPerformance', 'completed'),
            cancelled: BuiltValueNullFieldError.checkNotNull(
                cancelled, r'VendorTeamSalesPerformance', 'cancelled'),
            valueCentavos: valueCentavos,
            conversations: BuiltValueNullFieldError.checkNotNull(
                conversations, r'VendorTeamSalesPerformance', 'conversations'),
            messages: BuiltValueNullFieldError.checkNotNull(
                messages, r'VendorTeamSalesPerformance', 'messages'),
            awaitingReply: BuiltValueNullFieldError.checkNotNull(
                awaitingReply, r'VendorTeamSalesPerformance', 'awaitingReply'),
            reply: reply.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reply';
        reply.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorTeamSalesPerformance', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
