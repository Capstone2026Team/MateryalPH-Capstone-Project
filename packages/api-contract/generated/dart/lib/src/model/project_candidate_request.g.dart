// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_candidate_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProjectCandidateRequestFulfillmentMethodEnum
    _$projectCandidateRequestFulfillmentMethodEnum_PICKUP =
    const ProjectCandidateRequestFulfillmentMethodEnum._('PICKUP');
const ProjectCandidateRequestFulfillmentMethodEnum
    _$projectCandidateRequestFulfillmentMethodEnum_DELIVERY =
    const ProjectCandidateRequestFulfillmentMethodEnum._('DELIVERY');

ProjectCandidateRequestFulfillmentMethodEnum
    _$projectCandidateRequestFulfillmentMethodEnumValueOf(String name) {
  switch (name) {
    case 'PICKUP':
      return _$projectCandidateRequestFulfillmentMethodEnum_PICKUP;
    case 'DELIVERY':
      return _$projectCandidateRequestFulfillmentMethodEnum_DELIVERY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectCandidateRequestFulfillmentMethodEnum>
    _$projectCandidateRequestFulfillmentMethodEnumValues = BuiltSet<
        ProjectCandidateRequestFulfillmentMethodEnum>(const <ProjectCandidateRequestFulfillmentMethodEnum>[
  _$projectCandidateRequestFulfillmentMethodEnum_PICKUP,
  _$projectCandidateRequestFulfillmentMethodEnum_DELIVERY,
]);

const ProjectCandidateRequestPaymentMethodEnum
    _$projectCandidateRequestPaymentMethodEnum_ONLINE =
    const ProjectCandidateRequestPaymentMethodEnum._('ONLINE');
const ProjectCandidateRequestPaymentMethodEnum
    _$projectCandidateRequestPaymentMethodEnum_CASH_ON_DELIVERY =
    const ProjectCandidateRequestPaymentMethodEnum._('CASH_ON_DELIVERY');
const ProjectCandidateRequestPaymentMethodEnum
    _$projectCandidateRequestPaymentMethodEnum_IN_STORE =
    const ProjectCandidateRequestPaymentMethodEnum._('IN_STORE');

ProjectCandidateRequestPaymentMethodEnum
    _$projectCandidateRequestPaymentMethodEnumValueOf(String name) {
  switch (name) {
    case 'ONLINE':
      return _$projectCandidateRequestPaymentMethodEnum_ONLINE;
    case 'CASH_ON_DELIVERY':
      return _$projectCandidateRequestPaymentMethodEnum_CASH_ON_DELIVERY;
    case 'IN_STORE':
      return _$projectCandidateRequestPaymentMethodEnum_IN_STORE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectCandidateRequestPaymentMethodEnum>
    _$projectCandidateRequestPaymentMethodEnumValues = BuiltSet<
        ProjectCandidateRequestPaymentMethodEnum>(const <ProjectCandidateRequestPaymentMethodEnum>[
  _$projectCandidateRequestPaymentMethodEnum_ONLINE,
  _$projectCandidateRequestPaymentMethodEnum_CASH_ON_DELIVERY,
  _$projectCandidateRequestPaymentMethodEnum_IN_STORE,
]);

Serializer<ProjectCandidateRequestFulfillmentMethodEnum>
    _$projectCandidateRequestFulfillmentMethodEnumSerializer =
    _$ProjectCandidateRequestFulfillmentMethodEnumSerializer();
Serializer<ProjectCandidateRequestPaymentMethodEnum>
    _$projectCandidateRequestPaymentMethodEnumSerializer =
    _$ProjectCandidateRequestPaymentMethodEnumSerializer();

class _$ProjectCandidateRequestFulfillmentMethodEnumSerializer
    implements
        PrimitiveSerializer<ProjectCandidateRequestFulfillmentMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PICKUP': 'PICKUP',
    'DELIVERY': 'DELIVERY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PICKUP': 'PICKUP',
    'DELIVERY': 'DELIVERY',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ProjectCandidateRequestFulfillmentMethodEnum
  ];
  @override
  final String wireName = 'ProjectCandidateRequestFulfillmentMethodEnum';

  @override
  Object serialize(Serializers serializers,
          ProjectCandidateRequestFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectCandidateRequestFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectCandidateRequestFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectCandidateRequestPaymentMethodEnumSerializer
    implements PrimitiveSerializer<ProjectCandidateRequestPaymentMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ONLINE': 'ONLINE',
    'CASH_ON_DELIVERY': 'CASH_ON_DELIVERY',
    'IN_STORE': 'IN_STORE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ONLINE': 'ONLINE',
    'CASH_ON_DELIVERY': 'CASH_ON_DELIVERY',
    'IN_STORE': 'IN_STORE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ProjectCandidateRequestPaymentMethodEnum
  ];
  @override
  final String wireName = 'ProjectCandidateRequestPaymentMethodEnum';

  @override
  Object serialize(Serializers serializers,
          ProjectCandidateRequestPaymentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectCandidateRequestPaymentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectCandidateRequestPaymentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

abstract class ProjectCandidateRequestBuilder {
  void replace(ProjectCandidateRequest other);
  void update(void Function(ProjectCandidateRequestBuilder) updates);
  int? get lockVersion;
  set lockVersion(int? lockVersion);

  String? get candidateId;
  set candidateId(String? candidateId);

  String? get note;
  set note(String? note);

  String? get budgetOverrideReason;
  set budgetOverrideReason(String? budgetOverrideReason);

  ListBuilder<ProjectSpecificationSelection> get selections;
  set selections(ListBuilder<ProjectSpecificationSelection>? selections);

  ProjectCandidateRequestFulfillmentMethodEnum? get fulfillmentMethod;
  set fulfillmentMethod(
      ProjectCandidateRequestFulfillmentMethodEnum? fulfillmentMethod);

  ProjectCandidateRequestPaymentMethodEnum? get paymentMethod;
  set paymentMethod(ProjectCandidateRequestPaymentMethodEnum? paymentMethod);
}

class _$$ProjectCandidateRequest extends $ProjectCandidateRequest {
  @override
  final int lockVersion;
  @override
  final String candidateId;
  @override
  final String? note;
  @override
  final String? budgetOverrideReason;
  @override
  final BuiltList<ProjectSpecificationSelection>? selections;
  @override
  final ProjectCandidateRequestFulfillmentMethodEnum? fulfillmentMethod;
  @override
  final ProjectCandidateRequestPaymentMethodEnum? paymentMethod;

  factory _$$ProjectCandidateRequest(
          [void Function($ProjectCandidateRequestBuilder)? updates]) =>
      ($ProjectCandidateRequestBuilder()..update(updates))._build();

  _$$ProjectCandidateRequest._(
      {required this.lockVersion,
      required this.candidateId,
      this.note,
      this.budgetOverrideReason,
      this.selections,
      this.fulfillmentMethod,
      this.paymentMethod})
      : super._();
  @override
  $ProjectCandidateRequest rebuild(
          void Function($ProjectCandidateRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  $ProjectCandidateRequestBuilder toBuilder() =>
      $ProjectCandidateRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is $ProjectCandidateRequest &&
        lockVersion == other.lockVersion &&
        candidateId == other.candidateId &&
        note == other.note &&
        budgetOverrideReason == other.budgetOverrideReason &&
        selections == other.selections &&
        fulfillmentMethod == other.fulfillmentMethod &&
        paymentMethod == other.paymentMethod;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, candidateId.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, budgetOverrideReason.hashCode);
    _$hash = $jc(_$hash, selections.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, paymentMethod.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'$ProjectCandidateRequest')
          ..add('lockVersion', lockVersion)
          ..add('candidateId', candidateId)
          ..add('note', note)
          ..add('budgetOverrideReason', budgetOverrideReason)
          ..add('selections', selections)
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('paymentMethod', paymentMethod))
        .toString();
  }
}

class $ProjectCandidateRequestBuilder
    implements
        Builder<$ProjectCandidateRequest, $ProjectCandidateRequestBuilder>,
        ProjectCandidateRequestBuilder {
  _$$ProjectCandidateRequest? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(covariant int? lockVersion) =>
      _$this._lockVersion = lockVersion;

  String? _candidateId;
  String? get candidateId => _$this._candidateId;
  set candidateId(covariant String? candidateId) =>
      _$this._candidateId = candidateId;

  String? _note;
  String? get note => _$this._note;
  set note(covariant String? note) => _$this._note = note;

  String? _budgetOverrideReason;
  String? get budgetOverrideReason => _$this._budgetOverrideReason;
  set budgetOverrideReason(covariant String? budgetOverrideReason) =>
      _$this._budgetOverrideReason = budgetOverrideReason;

  ListBuilder<ProjectSpecificationSelection>? _selections;
  ListBuilder<ProjectSpecificationSelection> get selections =>
      _$this._selections ??= ListBuilder<ProjectSpecificationSelection>();
  set selections(
          covariant ListBuilder<ProjectSpecificationSelection>? selections) =>
      _$this._selections = selections;

  ProjectCandidateRequestFulfillmentMethodEnum? _fulfillmentMethod;
  ProjectCandidateRequestFulfillmentMethodEnum? get fulfillmentMethod =>
      _$this._fulfillmentMethod;
  set fulfillmentMethod(
          covariant ProjectCandidateRequestFulfillmentMethodEnum?
              fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  ProjectCandidateRequestPaymentMethodEnum? _paymentMethod;
  ProjectCandidateRequestPaymentMethodEnum? get paymentMethod =>
      _$this._paymentMethod;
  set paymentMethod(
          covariant ProjectCandidateRequestPaymentMethodEnum? paymentMethod) =>
      _$this._paymentMethod = paymentMethod;

  $ProjectCandidateRequestBuilder() {
    $ProjectCandidateRequest._defaults(this);
  }

  $ProjectCandidateRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _candidateId = $v.candidateId;
      _note = $v.note;
      _budgetOverrideReason = $v.budgetOverrideReason;
      _selections = $v.selections?.toBuilder();
      _fulfillmentMethod = $v.fulfillmentMethod;
      _paymentMethod = $v.paymentMethod;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant $ProjectCandidateRequest other) {
    _$v = other as _$$ProjectCandidateRequest;
  }

  @override
  void update(void Function($ProjectCandidateRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  $ProjectCandidateRequest build() => _build();

  _$$ProjectCandidateRequest _build() {
    _$$ProjectCandidateRequest _$result;
    try {
      _$result = _$v ??
          _$$ProjectCandidateRequest._(
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'$ProjectCandidateRequest', 'lockVersion'),
            candidateId: BuiltValueNullFieldError.checkNotNull(
                candidateId, r'$ProjectCandidateRequest', 'candidateId'),
            note: note,
            budgetOverrideReason: budgetOverrideReason,
            selections: _selections?.build(),
            fulfillmentMethod: fulfillmentMethod,
            paymentMethod: paymentMethod,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'selections';
        _selections?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'$ProjectCandidateRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
