// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_moderation_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ReviewModerationRequestActionEnum
    _$reviewModerationRequestActionEnum_DISMISS_FLAG =
    const ReviewModerationRequestActionEnum._('DISMISS_FLAG');
const ReviewModerationRequestActionEnum
    _$reviewModerationRequestActionEnum_REQUEST_CORRECTION =
    const ReviewModerationRequestActionEnum._('REQUEST_CORRECTION');
const ReviewModerationRequestActionEnum
    _$reviewModerationRequestActionEnum_HIDE_PENDING_REVIEW =
    const ReviewModerationRequestActionEnum._('HIDE_PENDING_REVIEW');
const ReviewModerationRequestActionEnum
    _$reviewModerationRequestActionEnum_REMOVE =
    const ReviewModerationRequestActionEnum._('REMOVE');
const ReviewModerationRequestActionEnum
    _$reviewModerationRequestActionEnum_RESTORE =
    const ReviewModerationRequestActionEnum._('RESTORE');

ReviewModerationRequestActionEnum _$reviewModerationRequestActionEnumValueOf(
    String name) {
  switch (name) {
    case 'DISMISS_FLAG':
      return _$reviewModerationRequestActionEnum_DISMISS_FLAG;
    case 'REQUEST_CORRECTION':
      return _$reviewModerationRequestActionEnum_REQUEST_CORRECTION;
    case 'HIDE_PENDING_REVIEW':
      return _$reviewModerationRequestActionEnum_HIDE_PENDING_REVIEW;
    case 'REMOVE':
      return _$reviewModerationRequestActionEnum_REMOVE;
    case 'RESTORE':
      return _$reviewModerationRequestActionEnum_RESTORE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ReviewModerationRequestActionEnum>
    _$reviewModerationRequestActionEnumValues = BuiltSet<
        ReviewModerationRequestActionEnum>(const <ReviewModerationRequestActionEnum>[
  _$reviewModerationRequestActionEnum_DISMISS_FLAG,
  _$reviewModerationRequestActionEnum_REQUEST_CORRECTION,
  _$reviewModerationRequestActionEnum_HIDE_PENDING_REVIEW,
  _$reviewModerationRequestActionEnum_REMOVE,
  _$reviewModerationRequestActionEnum_RESTORE,
]);

Serializer<ReviewModerationRequestActionEnum>
    _$reviewModerationRequestActionEnumSerializer =
    _$ReviewModerationRequestActionEnumSerializer();

class _$ReviewModerationRequestActionEnumSerializer
    implements PrimitiveSerializer<ReviewModerationRequestActionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DISMISS_FLAG': 'DISMISS_FLAG',
    'REQUEST_CORRECTION': 'REQUEST_CORRECTION',
    'HIDE_PENDING_REVIEW': 'HIDE_PENDING_REVIEW',
    'REMOVE': 'REMOVE',
    'RESTORE': 'RESTORE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DISMISS_FLAG': 'DISMISS_FLAG',
    'REQUEST_CORRECTION': 'REQUEST_CORRECTION',
    'HIDE_PENDING_REVIEW': 'HIDE_PENDING_REVIEW',
    'REMOVE': 'REMOVE',
    'RESTORE': 'RESTORE',
  };

  @override
  final Iterable<Type> types = const <Type>[ReviewModerationRequestActionEnum];
  @override
  final String wireName = 'ReviewModerationRequestActionEnum';

  @override
  Object serialize(
          Serializers serializers, ReviewModerationRequestActionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReviewModerationRequestActionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReviewModerationRequestActionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReviewModerationRequest extends ReviewModerationRequest {
  @override
  final ReviewModerationRequestActionEnum action;
  @override
  final String reason;
  @override
  final int lockVersion;

  factory _$ReviewModerationRequest(
          [void Function(ReviewModerationRequestBuilder)? updates]) =>
      (ReviewModerationRequestBuilder()..update(updates))._build();

  _$ReviewModerationRequest._(
      {required this.action, required this.reason, required this.lockVersion})
      : super._();
  @override
  ReviewModerationRequest rebuild(
          void Function(ReviewModerationRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReviewModerationRequestBuilder toBuilder() =>
      ReviewModerationRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReviewModerationRequest &&
        action == other.action &&
        reason == other.reason &&
        lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReviewModerationRequest')
          ..add('action', action)
          ..add('reason', reason)
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class ReviewModerationRequestBuilder
    implements
        Builder<ReviewModerationRequest, ReviewModerationRequestBuilder> {
  _$ReviewModerationRequest? _$v;

  ReviewModerationRequestActionEnum? _action;
  ReviewModerationRequestActionEnum? get action => _$this._action;
  set action(ReviewModerationRequestActionEnum? action) =>
      _$this._action = action;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  ReviewModerationRequestBuilder() {
    ReviewModerationRequest._defaults(this);
  }

  ReviewModerationRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _action = $v.action;
      _reason = $v.reason;
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReviewModerationRequest other) {
    _$v = other as _$ReviewModerationRequest;
  }

  @override
  void update(void Function(ReviewModerationRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReviewModerationRequest build() => _build();

  _$ReviewModerationRequest _build() {
    final _$result = _$v ??
        _$ReviewModerationRequest._(
          action: BuiltValueNullFieldError.checkNotNull(
              action, r'ReviewModerationRequest', 'action'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'ReviewModerationRequest', 'reason'),
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'ReviewModerationRequest', 'lockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
