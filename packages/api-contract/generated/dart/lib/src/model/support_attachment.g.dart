// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_attachment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportAttachment extends SupportAttachment {
  @override
  final String id;
  @override
  final String originalName;
  @override
  final String contentType;
  @override
  final int byteSize;

  factory _$SupportAttachment(
          [void Function(SupportAttachmentBuilder)? updates]) =>
      (SupportAttachmentBuilder()..update(updates))._build();

  _$SupportAttachment._(
      {required this.id,
      required this.originalName,
      required this.contentType,
      required this.byteSize})
      : super._();
  @override
  SupportAttachment rebuild(void Function(SupportAttachmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportAttachmentBuilder toBuilder() =>
      SupportAttachmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportAttachment &&
        id == other.id &&
        originalName == other.originalName &&
        contentType == other.contentType &&
        byteSize == other.byteSize;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, originalName.hashCode);
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, byteSize.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SupportAttachment')
          ..add('id', id)
          ..add('originalName', originalName)
          ..add('contentType', contentType)
          ..add('byteSize', byteSize))
        .toString();
  }
}

class SupportAttachmentBuilder
    implements Builder<SupportAttachment, SupportAttachmentBuilder> {
  _$SupportAttachment? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _originalName;
  String? get originalName => _$this._originalName;
  set originalName(String? originalName) => _$this._originalName = originalName;

  String? _contentType;
  String? get contentType => _$this._contentType;
  set contentType(String? contentType) => _$this._contentType = contentType;

  int? _byteSize;
  int? get byteSize => _$this._byteSize;
  set byteSize(int? byteSize) => _$this._byteSize = byteSize;

  SupportAttachmentBuilder() {
    SupportAttachment._defaults(this);
  }

  SupportAttachmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _originalName = $v.originalName;
      _contentType = $v.contentType;
      _byteSize = $v.byteSize;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupportAttachment other) {
    _$v = other as _$SupportAttachment;
  }

  @override
  void update(void Function(SupportAttachmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportAttachment build() => _build();

  _$SupportAttachment _build() {
    final _$result = _$v ??
        _$SupportAttachment._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'SupportAttachment', 'id'),
          originalName: BuiltValueNullFieldError.checkNotNull(
              originalName, r'SupportAttachment', 'originalName'),
          contentType: BuiltValueNullFieldError.checkNotNull(
              contentType, r'SupportAttachment', 'contentType'),
          byteSize: BuiltValueNullFieldError.checkNotNull(
              byteSize, r'SupportAttachment', 'byteSize'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
