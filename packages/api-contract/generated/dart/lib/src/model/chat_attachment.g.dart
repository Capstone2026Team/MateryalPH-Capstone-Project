// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_attachment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ChatAttachmentScanStateEnum _$chatAttachmentScanStateEnum_PENDING =
    const ChatAttachmentScanStateEnum._('PENDING');
const ChatAttachmentScanStateEnum _$chatAttachmentScanStateEnum_CLEAN =
    const ChatAttachmentScanStateEnum._('CLEAN');
const ChatAttachmentScanStateEnum _$chatAttachmentScanStateEnum_REJECTED =
    const ChatAttachmentScanStateEnum._('REJECTED');
const ChatAttachmentScanStateEnum _$chatAttachmentScanStateEnum_FAILED =
    const ChatAttachmentScanStateEnum._('FAILED');

ChatAttachmentScanStateEnum _$chatAttachmentScanStateEnumValueOf(String name) {
  switch (name) {
    case 'PENDING':
      return _$chatAttachmentScanStateEnum_PENDING;
    case 'CLEAN':
      return _$chatAttachmentScanStateEnum_CLEAN;
    case 'REJECTED':
      return _$chatAttachmentScanStateEnum_REJECTED;
    case 'FAILED':
      return _$chatAttachmentScanStateEnum_FAILED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ChatAttachmentScanStateEnum>
    _$chatAttachmentScanStateEnumValues =
    BuiltSet<ChatAttachmentScanStateEnum>(const <ChatAttachmentScanStateEnum>[
  _$chatAttachmentScanStateEnum_PENDING,
  _$chatAttachmentScanStateEnum_CLEAN,
  _$chatAttachmentScanStateEnum_REJECTED,
  _$chatAttachmentScanStateEnum_FAILED,
]);

Serializer<ChatAttachmentScanStateEnum>
    _$chatAttachmentScanStateEnumSerializer =
    _$ChatAttachmentScanStateEnumSerializer();

class _$ChatAttachmentScanStateEnumSerializer
    implements PrimitiveSerializer<ChatAttachmentScanStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING': 'PENDING',
    'CLEAN': 'CLEAN',
    'REJECTED': 'REJECTED',
    'FAILED': 'FAILED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING': 'PENDING',
    'CLEAN': 'CLEAN',
    'REJECTED': 'REJECTED',
    'FAILED': 'FAILED',
  };

  @override
  final Iterable<Type> types = const <Type>[ChatAttachmentScanStateEnum];
  @override
  final String wireName = 'ChatAttachmentScanStateEnum';

  @override
  Object serialize(Serializers serializers, ChatAttachmentScanStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ChatAttachmentScanStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ChatAttachmentScanStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ChatAttachment extends ChatAttachment {
  @override
  final String id;
  @override
  final String displayName;
  @override
  final String mediaType;
  @override
  final int sizeBytes;
  @override
  final ChatAttachmentScanStateEnum scanState;

  factory _$ChatAttachment([void Function(ChatAttachmentBuilder)? updates]) =>
      (ChatAttachmentBuilder()..update(updates))._build();

  _$ChatAttachment._(
      {required this.id,
      required this.displayName,
      required this.mediaType,
      required this.sizeBytes,
      required this.scanState})
      : super._();
  @override
  ChatAttachment rebuild(void Function(ChatAttachmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatAttachmentBuilder toBuilder() => ChatAttachmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatAttachment &&
        id == other.id &&
        displayName == other.displayName &&
        mediaType == other.mediaType &&
        sizeBytes == other.sizeBytes &&
        scanState == other.scanState;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, mediaType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jc(_$hash, scanState.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatAttachment')
          ..add('id', id)
          ..add('displayName', displayName)
          ..add('mediaType', mediaType)
          ..add('sizeBytes', sizeBytes)
          ..add('scanState', scanState))
        .toString();
  }
}

class ChatAttachmentBuilder
    implements Builder<ChatAttachment, ChatAttachmentBuilder> {
  _$ChatAttachment? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _mediaType;
  String? get mediaType => _$this._mediaType;
  set mediaType(String? mediaType) => _$this._mediaType = mediaType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  ChatAttachmentScanStateEnum? _scanState;
  ChatAttachmentScanStateEnum? get scanState => _$this._scanState;
  set scanState(ChatAttachmentScanStateEnum? scanState) =>
      _$this._scanState = scanState;

  ChatAttachmentBuilder() {
    ChatAttachment._defaults(this);
  }

  ChatAttachmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _displayName = $v.displayName;
      _mediaType = $v.mediaType;
      _sizeBytes = $v.sizeBytes;
      _scanState = $v.scanState;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatAttachment other) {
    _$v = other as _$ChatAttachment;
  }

  @override
  void update(void Function(ChatAttachmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatAttachment build() => _build();

  _$ChatAttachment _build() {
    final _$result = _$v ??
        _$ChatAttachment._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ChatAttachment', 'id'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'ChatAttachment', 'displayName'),
          mediaType: BuiltValueNullFieldError.checkNotNull(
              mediaType, r'ChatAttachment', 'mediaType'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
              sizeBytes, r'ChatAttachment', 'sizeBytes'),
          scanState: BuiltValueNullFieldError.checkNotNull(
              scanState, r'ChatAttachment', 'scanState'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
