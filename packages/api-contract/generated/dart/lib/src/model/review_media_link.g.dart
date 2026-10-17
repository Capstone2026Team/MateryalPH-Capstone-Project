// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_media_link.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ReviewMediaLinkContentTypeEnum
    _$reviewMediaLinkContentTypeEnum_imageSlashJpeg =
    const ReviewMediaLinkContentTypeEnum._('imageSlashJpeg');
const ReviewMediaLinkContentTypeEnum
    _$reviewMediaLinkContentTypeEnum_imageSlashPng =
    const ReviewMediaLinkContentTypeEnum._('imageSlashPng');
const ReviewMediaLinkContentTypeEnum
    _$reviewMediaLinkContentTypeEnum_videoSlashMp4 =
    const ReviewMediaLinkContentTypeEnum._('videoSlashMp4');
const ReviewMediaLinkContentTypeEnum
    _$reviewMediaLinkContentTypeEnum_videoSlashQuicktime =
    const ReviewMediaLinkContentTypeEnum._('videoSlashQuicktime');

ReviewMediaLinkContentTypeEnum _$reviewMediaLinkContentTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'imageSlashJpeg':
      return _$reviewMediaLinkContentTypeEnum_imageSlashJpeg;
    case 'imageSlashPng':
      return _$reviewMediaLinkContentTypeEnum_imageSlashPng;
    case 'videoSlashMp4':
      return _$reviewMediaLinkContentTypeEnum_videoSlashMp4;
    case 'videoSlashQuicktime':
      return _$reviewMediaLinkContentTypeEnum_videoSlashQuicktime;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ReviewMediaLinkContentTypeEnum>
    _$reviewMediaLinkContentTypeEnumValues = BuiltSet<
        ReviewMediaLinkContentTypeEnum>(const <ReviewMediaLinkContentTypeEnum>[
  _$reviewMediaLinkContentTypeEnum_imageSlashJpeg,
  _$reviewMediaLinkContentTypeEnum_imageSlashPng,
  _$reviewMediaLinkContentTypeEnum_videoSlashMp4,
  _$reviewMediaLinkContentTypeEnum_videoSlashQuicktime,
]);

Serializer<ReviewMediaLinkContentTypeEnum>
    _$reviewMediaLinkContentTypeEnumSerializer =
    _$ReviewMediaLinkContentTypeEnumSerializer();

class _$ReviewMediaLinkContentTypeEnumSerializer
    implements PrimitiveSerializer<ReviewMediaLinkContentTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'imageSlashJpeg': 'image/jpeg',
    'imageSlashPng': 'image/png',
    'videoSlashMp4': 'video/mp4',
    'videoSlashQuicktime': 'video/quicktime',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'image/jpeg': 'imageSlashJpeg',
    'image/png': 'imageSlashPng',
    'video/mp4': 'videoSlashMp4',
    'video/quicktime': 'videoSlashQuicktime',
  };

  @override
  final Iterable<Type> types = const <Type>[ReviewMediaLinkContentTypeEnum];
  @override
  final String wireName = 'ReviewMediaLinkContentTypeEnum';

  @override
  Object serialize(
          Serializers serializers, ReviewMediaLinkContentTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReviewMediaLinkContentTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReviewMediaLinkContentTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReviewMediaLink extends ReviewMediaLink {
  @override
  final String id;
  @override
  final String url;
  @override
  final DateTime expiresAt;
  @override
  final ReviewMediaLinkContentTypeEnum? contentType;
  @override
  final int? byteSize;

  factory _$ReviewMediaLink([void Function(ReviewMediaLinkBuilder)? updates]) =>
      (ReviewMediaLinkBuilder()..update(updates))._build();

  _$ReviewMediaLink._(
      {required this.id,
      required this.url,
      required this.expiresAt,
      this.contentType,
      this.byteSize})
      : super._();
  @override
  ReviewMediaLink rebuild(void Function(ReviewMediaLinkBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReviewMediaLinkBuilder toBuilder() => ReviewMediaLinkBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReviewMediaLink &&
        id == other.id &&
        url == other.url &&
        expiresAt == other.expiresAt &&
        contentType == other.contentType &&
        byteSize == other.byteSize;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, byteSize.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReviewMediaLink')
          ..add('id', id)
          ..add('url', url)
          ..add('expiresAt', expiresAt)
          ..add('contentType', contentType)
          ..add('byteSize', byteSize))
        .toString();
  }
}

class ReviewMediaLinkBuilder
    implements Builder<ReviewMediaLink, ReviewMediaLinkBuilder> {
  _$ReviewMediaLink? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  ReviewMediaLinkContentTypeEnum? _contentType;
  ReviewMediaLinkContentTypeEnum? get contentType => _$this._contentType;
  set contentType(ReviewMediaLinkContentTypeEnum? contentType) =>
      _$this._contentType = contentType;

  int? _byteSize;
  int? get byteSize => _$this._byteSize;
  set byteSize(int? byteSize) => _$this._byteSize = byteSize;

  ReviewMediaLinkBuilder() {
    ReviewMediaLink._defaults(this);
  }

  ReviewMediaLinkBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _url = $v.url;
      _expiresAt = $v.expiresAt;
      _contentType = $v.contentType;
      _byteSize = $v.byteSize;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReviewMediaLink other) {
    _$v = other as _$ReviewMediaLink;
  }

  @override
  void update(void Function(ReviewMediaLinkBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReviewMediaLink build() => _build();

  _$ReviewMediaLink _build() {
    final _$result = _$v ??
        _$ReviewMediaLink._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ReviewMediaLink', 'id'),
          url: BuiltValueNullFieldError.checkNotNull(
              url, r'ReviewMediaLink', 'url'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'ReviewMediaLink', 'expiresAt'),
          contentType: contentType,
          byteSize: byteSize,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
