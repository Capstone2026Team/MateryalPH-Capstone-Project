// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_work_package_attachment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatWorkPackageAttachment extends ChatWorkPackageAttachment {
  @override
  final String? inquiryId;
  @override
  final String? orderId;
  @override
  final int? orderLockVersion;
  @override
  final BuiltMap<String, JsonObject?> reference;
  @override
  final bool canPrepareQuotation;

  factory _$ChatWorkPackageAttachment(
          [void Function(ChatWorkPackageAttachmentBuilder)? updates]) =>
      (ChatWorkPackageAttachmentBuilder()..update(updates))._build();

  _$ChatWorkPackageAttachment._(
      {this.inquiryId,
      this.orderId,
      this.orderLockVersion,
      required this.reference,
      required this.canPrepareQuotation})
      : super._();
  @override
  ChatWorkPackageAttachment rebuild(
          void Function(ChatWorkPackageAttachmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatWorkPackageAttachmentBuilder toBuilder() =>
      ChatWorkPackageAttachmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatWorkPackageAttachment &&
        inquiryId == other.inquiryId &&
        orderId == other.orderId &&
        orderLockVersion == other.orderLockVersion &&
        reference == other.reference &&
        canPrepareQuotation == other.canPrepareQuotation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, inquiryId.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, orderLockVersion.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, canPrepareQuotation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatWorkPackageAttachment')
          ..add('inquiryId', inquiryId)
          ..add('orderId', orderId)
          ..add('orderLockVersion', orderLockVersion)
          ..add('reference', reference)
          ..add('canPrepareQuotation', canPrepareQuotation))
        .toString();
  }
}

class ChatWorkPackageAttachmentBuilder
    implements
        Builder<ChatWorkPackageAttachment, ChatWorkPackageAttachmentBuilder> {
  _$ChatWorkPackageAttachment? _$v;

  String? _inquiryId;
  String? get inquiryId => _$this._inquiryId;
  set inquiryId(String? inquiryId) => _$this._inquiryId = inquiryId;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  int? _orderLockVersion;
  int? get orderLockVersion => _$this._orderLockVersion;
  set orderLockVersion(int? orderLockVersion) =>
      _$this._orderLockVersion = orderLockVersion;

  MapBuilder<String, JsonObject?>? _reference;
  MapBuilder<String, JsonObject?> get reference =>
      _$this._reference ??= MapBuilder<String, JsonObject?>();
  set reference(MapBuilder<String, JsonObject?>? reference) =>
      _$this._reference = reference;

  bool? _canPrepareQuotation;
  bool? get canPrepareQuotation => _$this._canPrepareQuotation;
  set canPrepareQuotation(bool? canPrepareQuotation) =>
      _$this._canPrepareQuotation = canPrepareQuotation;

  ChatWorkPackageAttachmentBuilder() {
    ChatWorkPackageAttachment._defaults(this);
  }

  ChatWorkPackageAttachmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _inquiryId = $v.inquiryId;
      _orderId = $v.orderId;
      _orderLockVersion = $v.orderLockVersion;
      _reference = $v.reference.toBuilder();
      _canPrepareQuotation = $v.canPrepareQuotation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatWorkPackageAttachment other) {
    _$v = other as _$ChatWorkPackageAttachment;
  }

  @override
  void update(void Function(ChatWorkPackageAttachmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatWorkPackageAttachment build() => _build();

  _$ChatWorkPackageAttachment _build() {
    _$ChatWorkPackageAttachment _$result;
    try {
      _$result = _$v ??
          _$ChatWorkPackageAttachment._(
            inquiryId: inquiryId,
            orderId: orderId,
            orderLockVersion: orderLockVersion,
            reference: reference.build(),
            canPrepareQuotation: BuiltValueNullFieldError.checkNotNull(
                canPrepareQuotation,
                r'ChatWorkPackageAttachment',
                'canPrepareQuotation'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reference';
        reference.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChatWorkPackageAttachment', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
