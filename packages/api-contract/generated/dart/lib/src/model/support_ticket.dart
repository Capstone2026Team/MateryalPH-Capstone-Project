//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/support_status.dart';
import 'package:materyalph_api_client/src/model/support_user_type.dart';
import 'package:materyalph_api_client/src/model/support_category.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'support_ticket.g.dart';

/// SupportTicket
///
/// Properties:
/// * [id]
/// * [ticketNumber]
/// * [fullName]
/// * [email]
/// * [userType]
/// * [category]
/// * [subject]
/// * [referenceType]
/// * [reference]
/// * [status]
/// * [assignedAdminId]
/// * [assignedAdminName]
/// * [lockVersion]
/// * [createdAt]
/// * [updatedAt]
@BuiltValue()
abstract class SupportTicket implements Built<SupportTicket, SupportTicketBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'ticket_number')
  String get ticketNumber;

  @BuiltValueField(wireName: r'full_name')
  String get fullName;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'user_type')
  SupportUserType get userType;
  // enum userTypeEnum {  BUYER,  VENDOR,  GUEST,  };

  @BuiltValueField(wireName: r'category')
  SupportCategory get category;
  // enum categoryEnum {  GENERAL_INQUIRY,  TECHNICAL_ISSUE,  ACCOUNT_CONCERN,  VERIFICATION_ISSUE,  PAYMENT_CONCERN,  ORDER_CONCERN,  COMPLAINT,  FEEDBACK_SUGGESTION,  OTHER,  };

  @BuiltValueField(wireName: r'subject')
  String get subject;

  @BuiltValueField(wireName: r'reference_type')
  String? get referenceType;

  @BuiltValueField(wireName: r'reference')
  String? get reference;

  @BuiltValueField(wireName: r'status')
  SupportStatus get status;
  // enum statusEnum {  OPEN,  IN_PROGRESS,  WAITING_FOR_USER,  RESOLVED,  CLOSED,  };

  @BuiltValueField(wireName: r'assigned_admin_id')
  String? get assignedAdminId;

  @BuiltValueField(wireName: r'assigned_admin_name')
  String? get assignedAdminName;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  SupportTicket._();

  factory SupportTicket([void updates(SupportTicketBuilder b)]) = _$SupportTicket;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SupportTicketBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SupportTicket> get serializer => _$SupportTicketSerializer();
}

class _$SupportTicketSerializer implements PrimitiveSerializer<SupportTicket> {
  @override
  final Iterable<Type> types = const [SupportTicket, _$SupportTicket];

  @override
  final String wireName = r'SupportTicket';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SupportTicket object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'ticket_number';
    yield serializers.serialize(
      object.ticketNumber,
      specifiedType: const FullType(String),
    );
    yield r'full_name';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'user_type';
    yield serializers.serialize(
      object.userType,
      specifiedType: const FullType(SupportUserType),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(SupportCategory),
    );
    yield r'subject';
    yield serializers.serialize(
      object.subject,
      specifiedType: const FullType(String),
    );
    yield r'reference_type';
    yield object.referenceType == null ? null : serializers.serialize(
      object.referenceType,
      specifiedType: const FullType.nullable(String),
    );
    yield r'reference';
    yield object.reference == null ? null : serializers.serialize(
      object.reference,
      specifiedType: const FullType.nullable(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(SupportStatus),
    );
    yield r'assigned_admin_id';
    yield object.assignedAdminId == null ? null : serializers.serialize(
      object.assignedAdminId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'assigned_admin_name';
    yield object.assignedAdminName == null ? null : serializers.serialize(
      object.assignedAdminName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SupportTicket object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SupportTicketBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'ticket_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ticketNumber = valueDes;
          break;
        case r'full_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullName = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'user_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SupportUserType),
          ) as SupportUserType;
          result.userType = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SupportCategory),
          ) as SupportCategory;
          result.category = valueDes;
          break;
        case r'subject':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subject = valueDes;
          break;
        case r'reference_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.referenceType = valueDes;
          break;
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reference = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SupportStatus),
          ) as SupportStatus;
          result.status = valueDes;
          break;
        case r'assigned_admin_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.assignedAdminId = valueDes;
          break;
        case r'assigned_admin_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.assignedAdminName = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SupportTicket deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SupportTicketBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


