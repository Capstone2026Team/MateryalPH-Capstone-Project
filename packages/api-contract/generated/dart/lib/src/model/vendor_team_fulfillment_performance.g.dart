// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_fulfillment_performance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTeamFulfillmentPerformance
    extends VendorTeamFulfillmentPerformance {
  @override
  final int assigned;
  @override
  final int active;
  @override
  final int handovers;
  @override
  final int onTime;
  @override
  final int onTimeMeasured;
  @override
  final int milestones;
  @override
  final int proofs;
  @override
  final int vehicleIssues;
  @override
  final int conversations;
  @override
  final int messages;
  @override
  final int awaitingReply;
  @override
  final VendorTeamReplyTime reply;

  factory _$VendorTeamFulfillmentPerformance(
          [void Function(VendorTeamFulfillmentPerformanceBuilder)? updates]) =>
      (VendorTeamFulfillmentPerformanceBuilder()..update(updates))._build();

  _$VendorTeamFulfillmentPerformance._(
      {required this.assigned,
      required this.active,
      required this.handovers,
      required this.onTime,
      required this.onTimeMeasured,
      required this.milestones,
      required this.proofs,
      required this.vehicleIssues,
      required this.conversations,
      required this.messages,
      required this.awaitingReply,
      required this.reply})
      : super._();
  @override
  VendorTeamFulfillmentPerformance rebuild(
          void Function(VendorTeamFulfillmentPerformanceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamFulfillmentPerformanceBuilder toBuilder() =>
      VendorTeamFulfillmentPerformanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamFulfillmentPerformance &&
        assigned == other.assigned &&
        active == other.active &&
        handovers == other.handovers &&
        onTime == other.onTime &&
        onTimeMeasured == other.onTimeMeasured &&
        milestones == other.milestones &&
        proofs == other.proofs &&
        vehicleIssues == other.vehicleIssues &&
        conversations == other.conversations &&
        messages == other.messages &&
        awaitingReply == other.awaitingReply &&
        reply == other.reply;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, assigned.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, handovers.hashCode);
    _$hash = $jc(_$hash, onTime.hashCode);
    _$hash = $jc(_$hash, onTimeMeasured.hashCode);
    _$hash = $jc(_$hash, milestones.hashCode);
    _$hash = $jc(_$hash, proofs.hashCode);
    _$hash = $jc(_$hash, vehicleIssues.hashCode);
    _$hash = $jc(_$hash, conversations.hashCode);
    _$hash = $jc(_$hash, messages.hashCode);
    _$hash = $jc(_$hash, awaitingReply.hashCode);
    _$hash = $jc(_$hash, reply.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTeamFulfillmentPerformance')
          ..add('assigned', assigned)
          ..add('active', active)
          ..add('handovers', handovers)
          ..add('onTime', onTime)
          ..add('onTimeMeasured', onTimeMeasured)
          ..add('milestones', milestones)
          ..add('proofs', proofs)
          ..add('vehicleIssues', vehicleIssues)
          ..add('conversations', conversations)
          ..add('messages', messages)
          ..add('awaitingReply', awaitingReply)
          ..add('reply', reply))
        .toString();
  }
}

class VendorTeamFulfillmentPerformanceBuilder
    implements
        Builder<VendorTeamFulfillmentPerformance,
            VendorTeamFulfillmentPerformanceBuilder> {
  _$VendorTeamFulfillmentPerformance? _$v;

  int? _assigned;
  int? get assigned => _$this._assigned;
  set assigned(int? assigned) => _$this._assigned = assigned;

  int? _active;
  int? get active => _$this._active;
  set active(int? active) => _$this._active = active;

  int? _handovers;
  int? get handovers => _$this._handovers;
  set handovers(int? handovers) => _$this._handovers = handovers;

  int? _onTime;
  int? get onTime => _$this._onTime;
  set onTime(int? onTime) => _$this._onTime = onTime;

  int? _onTimeMeasured;
  int? get onTimeMeasured => _$this._onTimeMeasured;
  set onTimeMeasured(int? onTimeMeasured) =>
      _$this._onTimeMeasured = onTimeMeasured;

  int? _milestones;
  int? get milestones => _$this._milestones;
  set milestones(int? milestones) => _$this._milestones = milestones;

  int? _proofs;
  int? get proofs => _$this._proofs;
  set proofs(int? proofs) => _$this._proofs = proofs;

  int? _vehicleIssues;
  int? get vehicleIssues => _$this._vehicleIssues;
  set vehicleIssues(int? vehicleIssues) =>
      _$this._vehicleIssues = vehicleIssues;

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

  VendorTeamFulfillmentPerformanceBuilder() {
    VendorTeamFulfillmentPerformance._defaults(this);
  }

  VendorTeamFulfillmentPerformanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assigned = $v.assigned;
      _active = $v.active;
      _handovers = $v.handovers;
      _onTime = $v.onTime;
      _onTimeMeasured = $v.onTimeMeasured;
      _milestones = $v.milestones;
      _proofs = $v.proofs;
      _vehicleIssues = $v.vehicleIssues;
      _conversations = $v.conversations;
      _messages = $v.messages;
      _awaitingReply = $v.awaitingReply;
      _reply = $v.reply.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTeamFulfillmentPerformance other) {
    _$v = other as _$VendorTeamFulfillmentPerformance;
  }

  @override
  void update(void Function(VendorTeamFulfillmentPerformanceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamFulfillmentPerformance build() => _build();

  _$VendorTeamFulfillmentPerformance _build() {
    _$VendorTeamFulfillmentPerformance _$result;
    try {
      _$result = _$v ??
          _$VendorTeamFulfillmentPerformance._(
            assigned: BuiltValueNullFieldError.checkNotNull(
                assigned, r'VendorTeamFulfillmentPerformance', 'assigned'),
            active: BuiltValueNullFieldError.checkNotNull(
                active, r'VendorTeamFulfillmentPerformance', 'active'),
            handovers: BuiltValueNullFieldError.checkNotNull(
                handovers, r'VendorTeamFulfillmentPerformance', 'handovers'),
            onTime: BuiltValueNullFieldError.checkNotNull(
                onTime, r'VendorTeamFulfillmentPerformance', 'onTime'),
            onTimeMeasured: BuiltValueNullFieldError.checkNotNull(
                onTimeMeasured,
                r'VendorTeamFulfillmentPerformance',
                'onTimeMeasured'),
            milestones: BuiltValueNullFieldError.checkNotNull(
                milestones, r'VendorTeamFulfillmentPerformance', 'milestones'),
            proofs: BuiltValueNullFieldError.checkNotNull(
                proofs, r'VendorTeamFulfillmentPerformance', 'proofs'),
            vehicleIssues: BuiltValueNullFieldError.checkNotNull(vehicleIssues,
                r'VendorTeamFulfillmentPerformance', 'vehicleIssues'),
            conversations: BuiltValueNullFieldError.checkNotNull(conversations,
                r'VendorTeamFulfillmentPerformance', 'conversations'),
            messages: BuiltValueNullFieldError.checkNotNull(
                messages, r'VendorTeamFulfillmentPerformance', 'messages'),
            awaitingReply: BuiltValueNullFieldError.checkNotNull(awaitingReply,
                r'VendorTeamFulfillmentPerformance', 'awaitingReply'),
            reply: reply.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reply';
        reply.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorTeamFulfillmentPerformance', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
