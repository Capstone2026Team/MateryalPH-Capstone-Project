// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_category.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SupportCategory _$GENERAL_INQUIRY =
    const SupportCategory._('GENERAL_INQUIRY');
const SupportCategory _$TECHNICAL_ISSUE =
    const SupportCategory._('TECHNICAL_ISSUE');
const SupportCategory _$ACCOUNT_CONCERN =
    const SupportCategory._('ACCOUNT_CONCERN');
const SupportCategory _$VERIFICATION_ISSUE =
    const SupportCategory._('VERIFICATION_ISSUE');
const SupportCategory _$PAYMENT_CONCERN =
    const SupportCategory._('PAYMENT_CONCERN');
const SupportCategory _$ORDER_CONCERN =
    const SupportCategory._('ORDER_CONCERN');
const SupportCategory _$COMPLAINT = const SupportCategory._('COMPLAINT');
const SupportCategory _$FEEDBACK_SUGGESTION =
    const SupportCategory._('FEEDBACK_SUGGESTION');
const SupportCategory _$OTHER = const SupportCategory._('OTHER');

SupportCategory _$valueOf(String name) {
  switch (name) {
    case 'GENERAL_INQUIRY':
      return _$GENERAL_INQUIRY;
    case 'TECHNICAL_ISSUE':
      return _$TECHNICAL_ISSUE;
    case 'ACCOUNT_CONCERN':
      return _$ACCOUNT_CONCERN;
    case 'VERIFICATION_ISSUE':
      return _$VERIFICATION_ISSUE;
    case 'PAYMENT_CONCERN':
      return _$PAYMENT_CONCERN;
    case 'ORDER_CONCERN':
      return _$ORDER_CONCERN;
    case 'COMPLAINT':
      return _$COMPLAINT;
    case 'FEEDBACK_SUGGESTION':
      return _$FEEDBACK_SUGGESTION;
    case 'OTHER':
      return _$OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SupportCategory> _$values =
    BuiltSet<SupportCategory>(const <SupportCategory>[
  _$GENERAL_INQUIRY,
  _$TECHNICAL_ISSUE,
  _$ACCOUNT_CONCERN,
  _$VERIFICATION_ISSUE,
  _$PAYMENT_CONCERN,
  _$ORDER_CONCERN,
  _$COMPLAINT,
  _$FEEDBACK_SUGGESTION,
  _$OTHER,
]);

class _$SupportCategoryMeta {
  const _$SupportCategoryMeta();
  SupportCategory get GENERAL_INQUIRY => _$GENERAL_INQUIRY;
  SupportCategory get TECHNICAL_ISSUE => _$TECHNICAL_ISSUE;
  SupportCategory get ACCOUNT_CONCERN => _$ACCOUNT_CONCERN;
  SupportCategory get VERIFICATION_ISSUE => _$VERIFICATION_ISSUE;
  SupportCategory get PAYMENT_CONCERN => _$PAYMENT_CONCERN;
  SupportCategory get ORDER_CONCERN => _$ORDER_CONCERN;
  SupportCategory get COMPLAINT => _$COMPLAINT;
  SupportCategory get FEEDBACK_SUGGESTION => _$FEEDBACK_SUGGESTION;
  SupportCategory get OTHER => _$OTHER;
  SupportCategory valueOf(String name) => _$valueOf(name);
  BuiltSet<SupportCategory> get values => _$values;
}

abstract class _$SupportCategoryMixin {
  // ignore: non_constant_identifier_names
  _$SupportCategoryMeta get SupportCategory => const _$SupportCategoryMeta();
}

Serializer<SupportCategory> _$supportCategorySerializer =
    _$SupportCategorySerializer();

class _$SupportCategorySerializer
    implements PrimitiveSerializer<SupportCategory> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'GENERAL_INQUIRY': 'GENERAL_INQUIRY',
    'TECHNICAL_ISSUE': 'TECHNICAL_ISSUE',
    'ACCOUNT_CONCERN': 'ACCOUNT_CONCERN',
    'VERIFICATION_ISSUE': 'VERIFICATION_ISSUE',
    'PAYMENT_CONCERN': 'PAYMENT_CONCERN',
    'ORDER_CONCERN': 'ORDER_CONCERN',
    'COMPLAINT': 'COMPLAINT',
    'FEEDBACK_SUGGESTION': 'FEEDBACK_SUGGESTION',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'GENERAL_INQUIRY': 'GENERAL_INQUIRY',
    'TECHNICAL_ISSUE': 'TECHNICAL_ISSUE',
    'ACCOUNT_CONCERN': 'ACCOUNT_CONCERN',
    'VERIFICATION_ISSUE': 'VERIFICATION_ISSUE',
    'PAYMENT_CONCERN': 'PAYMENT_CONCERN',
    'ORDER_CONCERN': 'ORDER_CONCERN',
    'COMPLAINT': 'COMPLAINT',
    'FEEDBACK_SUGGESTION': 'FEEDBACK_SUGGESTION',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[SupportCategory];
  @override
  final String wireName = 'SupportCategory';

  @override
  Object serialize(Serializers serializers, SupportCategory object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SupportCategory deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SupportCategory.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
