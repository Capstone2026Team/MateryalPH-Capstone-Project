// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_flag_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ReviewFlagRequestReasonCodeEnum
    _$reviewFlagRequestReasonCodeEnum_OFFENSIVE =
    const ReviewFlagRequestReasonCodeEnum._('OFFENSIVE');
const ReviewFlagRequestReasonCodeEnum
    _$reviewFlagRequestReasonCodeEnum_PERSONAL_INFORMATION =
    const ReviewFlagRequestReasonCodeEnum._('PERSONAL_INFORMATION');
const ReviewFlagRequestReasonCodeEnum _$reviewFlagRequestReasonCodeEnum_SPAM =
    const ReviewFlagRequestReasonCodeEnum._('SPAM');
const ReviewFlagRequestReasonCodeEnum
    _$reviewFlagRequestReasonCodeEnum_IRRELEVANT =
    const ReviewFlagRequestReasonCodeEnum._('IRRELEVANT');
const ReviewFlagRequestReasonCodeEnum
    _$reviewFlagRequestReasonCodeEnum_CONFLICT_OF_INTEREST =
    const ReviewFlagRequestReasonCodeEnum._('CONFLICT_OF_INTEREST');
const ReviewFlagRequestReasonCodeEnum
    _$reviewFlagRequestReasonCodeEnum_FALSE_CLAIM =
    const ReviewFlagRequestReasonCodeEnum._('FALSE_CLAIM');
const ReviewFlagRequestReasonCodeEnum _$reviewFlagRequestReasonCodeEnum_OTHER =
    const ReviewFlagRequestReasonCodeEnum._('OTHER');

ReviewFlagRequestReasonCodeEnum _$reviewFlagRequestReasonCodeEnumValueOf(
    String name) {
  switch (name) {
    case 'OFFENSIVE':
      return _$reviewFlagRequestReasonCodeEnum_OFFENSIVE;
    case 'PERSONAL_INFORMATION':
      return _$reviewFlagRequestReasonCodeEnum_PERSONAL_INFORMATION;
    case 'SPAM':
      return _$reviewFlagRequestReasonCodeEnum_SPAM;
    case 'IRRELEVANT':
      return _$reviewFlagRequestReasonCodeEnum_IRRELEVANT;
    case 'CONFLICT_OF_INTEREST':
      return _$reviewFlagRequestReasonCodeEnum_CONFLICT_OF_INTEREST;
    case 'FALSE_CLAIM':
      return _$reviewFlagRequestReasonCodeEnum_FALSE_CLAIM;
    case 'OTHER':
      return _$reviewFlagRequestReasonCodeEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ReviewFlagRequestReasonCodeEnum>
    _$reviewFlagRequestReasonCodeEnumValues = BuiltSet<
        ReviewFlagRequestReasonCodeEnum>(const <ReviewFlagRequestReasonCodeEnum>[
  _$reviewFlagRequestReasonCodeEnum_OFFENSIVE,
  _$reviewFlagRequestReasonCodeEnum_PERSONAL_INFORMATION,
  _$reviewFlagRequestReasonCodeEnum_SPAM,
  _$reviewFlagRequestReasonCodeEnum_IRRELEVANT,
  _$reviewFlagRequestReasonCodeEnum_CONFLICT_OF_INTEREST,
  _$reviewFlagRequestReasonCodeEnum_FALSE_CLAIM,
  _$reviewFlagRequestReasonCodeEnum_OTHER,
]);

Serializer<ReviewFlagRequestReasonCodeEnum>
    _$reviewFlagRequestReasonCodeEnumSerializer =
    _$ReviewFlagRequestReasonCodeEnumSerializer();

class _$ReviewFlagRequestReasonCodeEnumSerializer
    implements PrimitiveSerializer<ReviewFlagRequestReasonCodeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OFFENSIVE': 'OFFENSIVE',
    'PERSONAL_INFORMATION': 'PERSONAL_INFORMATION',
    'SPAM': 'SPAM',
    'IRRELEVANT': 'IRRELEVANT',
    'CONFLICT_OF_INTEREST': 'CONFLICT_OF_INTEREST',
    'FALSE_CLAIM': 'FALSE_CLAIM',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OFFENSIVE': 'OFFENSIVE',
    'PERSONAL_INFORMATION': 'PERSONAL_INFORMATION',
    'SPAM': 'SPAM',
    'IRRELEVANT': 'IRRELEVANT',
    'CONFLICT_OF_INTEREST': 'CONFLICT_OF_INTEREST',
    'FALSE_CLAIM': 'FALSE_CLAIM',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[ReviewFlagRequestReasonCodeEnum];
  @override
  final String wireName = 'ReviewFlagRequestReasonCodeEnum';

  @override
  Object serialize(
          Serializers serializers, ReviewFlagRequestReasonCodeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReviewFlagRequestReasonCodeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReviewFlagRequestReasonCodeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReviewFlagRequest extends ReviewFlagRequest {
  @override
  final ReviewFlagRequestReasonCodeEnum reasonCode;
  @override
  final String? details;

  factory _$ReviewFlagRequest(
          [void Function(ReviewFlagRequestBuilder)? updates]) =>
      (ReviewFlagRequestBuilder()..update(updates))._build();

  _$ReviewFlagRequest._({required this.reasonCode, this.details}) : super._();
  @override
  ReviewFlagRequest rebuild(void Function(ReviewFlagRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReviewFlagRequestBuilder toBuilder() =>
      ReviewFlagRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReviewFlagRequest &&
        reasonCode == other.reasonCode &&
        details == other.details;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reasonCode.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReviewFlagRequest')
          ..add('reasonCode', reasonCode)
          ..add('details', details))
        .toString();
  }
}

class ReviewFlagRequestBuilder
    implements Builder<ReviewFlagRequest, ReviewFlagRequestBuilder> {
  _$ReviewFlagRequest? _$v;

  ReviewFlagRequestReasonCodeEnum? _reasonCode;
  ReviewFlagRequestReasonCodeEnum? get reasonCode => _$this._reasonCode;
  set reasonCode(ReviewFlagRequestReasonCodeEnum? reasonCode) =>
      _$this._reasonCode = reasonCode;

  String? _details;
  String? get details => _$this._details;
  set details(String? details) => _$this._details = details;

  ReviewFlagRequestBuilder() {
    ReviewFlagRequest._defaults(this);
  }

  ReviewFlagRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reasonCode = $v.reasonCode;
      _details = $v.details;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReviewFlagRequest other) {
    _$v = other as _$ReviewFlagRequest;
  }

  @override
  void update(void Function(ReviewFlagRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReviewFlagRequest build() => _build();

  _$ReviewFlagRequest _build() {
    final _$result = _$v ??
        _$ReviewFlagRequest._(
          reasonCode: BuiltValueNullFieldError.checkNotNull(
              reasonCode, r'ReviewFlagRequest', 'reasonCode'),
          details: details,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
