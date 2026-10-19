// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_vendor_selection_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProjectVendorSelectionRequestFulfillmentMethodEnum
    _$projectVendorSelectionRequestFulfillmentMethodEnum_PICKUP =
    const ProjectVendorSelectionRequestFulfillmentMethodEnum._('PICKUP');
const ProjectVendorSelectionRequestFulfillmentMethodEnum
    _$projectVendorSelectionRequestFulfillmentMethodEnum_DELIVERY =
    const ProjectVendorSelectionRequestFulfillmentMethodEnum._('DELIVERY');

ProjectVendorSelectionRequestFulfillmentMethodEnum
    _$projectVendorSelectionRequestFulfillmentMethodEnumValueOf(String name) {
  switch (name) {
    case 'PICKUP':
      return _$projectVendorSelectionRequestFulfillmentMethodEnum_PICKUP;
    case 'DELIVERY':
      return _$projectVendorSelectionRequestFulfillmentMethodEnum_DELIVERY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectVendorSelectionRequestFulfillmentMethodEnum>
    _$projectVendorSelectionRequestFulfillmentMethodEnumValues = BuiltSet<
        ProjectVendorSelectionRequestFulfillmentMethodEnum>(const <ProjectVendorSelectionRequestFulfillmentMethodEnum>[
  _$projectVendorSelectionRequestFulfillmentMethodEnum_PICKUP,
  _$projectVendorSelectionRequestFulfillmentMethodEnum_DELIVERY,
]);

const ProjectVendorSelectionRequestPaymentMethodEnum
    _$projectVendorSelectionRequestPaymentMethodEnum_ONLINE =
    const ProjectVendorSelectionRequestPaymentMethodEnum._('ONLINE');
const ProjectVendorSelectionRequestPaymentMethodEnum
    _$projectVendorSelectionRequestPaymentMethodEnum_CASH_ON_DELIVERY =
    const ProjectVendorSelectionRequestPaymentMethodEnum._('CASH_ON_DELIVERY');
const ProjectVendorSelectionRequestPaymentMethodEnum
    _$projectVendorSelectionRequestPaymentMethodEnum_IN_STORE =
    const ProjectVendorSelectionRequestPaymentMethodEnum._('IN_STORE');

ProjectVendorSelectionRequestPaymentMethodEnum
    _$projectVendorSelectionRequestPaymentMethodEnumValueOf(String name) {
  switch (name) {
    case 'ONLINE':
      return _$projectVendorSelectionRequestPaymentMethodEnum_ONLINE;
    case 'CASH_ON_DELIVERY':
      return _$projectVendorSelectionRequestPaymentMethodEnum_CASH_ON_DELIVERY;
    case 'IN_STORE':
      return _$projectVendorSelectionRequestPaymentMethodEnum_IN_STORE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectVendorSelectionRequestPaymentMethodEnum>
    _$projectVendorSelectionRequestPaymentMethodEnumValues = BuiltSet<
        ProjectVendorSelectionRequestPaymentMethodEnum>(const <ProjectVendorSelectionRequestPaymentMethodEnum>[
  _$projectVendorSelectionRequestPaymentMethodEnum_ONLINE,
  _$projectVendorSelectionRequestPaymentMethodEnum_CASH_ON_DELIVERY,
  _$projectVendorSelectionRequestPaymentMethodEnum_IN_STORE,
]);

Serializer<ProjectVendorSelectionRequestFulfillmentMethodEnum>
    _$projectVendorSelectionRequestFulfillmentMethodEnumSerializer =
    _$ProjectVendorSelectionRequestFulfillmentMethodEnumSerializer();
Serializer<ProjectVendorSelectionRequestPaymentMethodEnum>
    _$projectVendorSelectionRequestPaymentMethodEnumSerializer =
    _$ProjectVendorSelectionRequestPaymentMethodEnumSerializer();

class _$ProjectVendorSelectionRequestFulfillmentMethodEnumSerializer
    implements
        PrimitiveSerializer<
            ProjectVendorSelectionRequestFulfillmentMethodEnum> {
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
    ProjectVendorSelectionRequestFulfillmentMethodEnum
  ];
  @override
  final String wireName = 'ProjectVendorSelectionRequestFulfillmentMethodEnum';

  @override
  Object serialize(Serializers serializers,
          ProjectVendorSelectionRequestFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectVendorSelectionRequestFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectVendorSelectionRequestFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectVendorSelectionRequestPaymentMethodEnumSerializer
    implements
        PrimitiveSerializer<ProjectVendorSelectionRequestPaymentMethodEnum> {
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
    ProjectVendorSelectionRequestPaymentMethodEnum
  ];
  @override
  final String wireName = 'ProjectVendorSelectionRequestPaymentMethodEnum';

  @override
  Object serialize(Serializers serializers,
          ProjectVendorSelectionRequestPaymentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectVendorSelectionRequestPaymentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectVendorSelectionRequestPaymentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectVendorSelectionRequest extends ProjectVendorSelectionRequest {
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

  factory _$ProjectVendorSelectionRequest(
          [void Function(ProjectVendorSelectionRequestBuilder)? updates]) =>
      (ProjectVendorSelectionRequestBuilder()..update(updates))._build();

  _$ProjectVendorSelectionRequest._(
      {required this.lockVersion,
      required this.candidateId,
      this.note,
      this.budgetOverrideReason,
      this.selections,
      this.fulfillmentMethod,
      this.paymentMethod})
      : super._();
  @override
  ProjectVendorSelectionRequest rebuild(
          void Function(ProjectVendorSelectionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectVendorSelectionRequestBuilder toBuilder() =>
      ProjectVendorSelectionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectVendorSelectionRequest &&
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
    return (newBuiltValueToStringHelper(r'ProjectVendorSelectionRequest')
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

class ProjectVendorSelectionRequestBuilder
    implements
        Builder<ProjectVendorSelectionRequest,
            ProjectVendorSelectionRequestBuilder>,
        ProjectCandidateRequestBuilder {
  _$ProjectVendorSelectionRequest? _$v;

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

  ProjectVendorSelectionRequestBuilder() {
    ProjectVendorSelectionRequest._defaults(this);
  }

  ProjectVendorSelectionRequestBuilder get _$this {
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
  void replace(covariant ProjectVendorSelectionRequest other) {
    _$v = other as _$ProjectVendorSelectionRequest;
  }

  @override
  void update(void Function(ProjectVendorSelectionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectVendorSelectionRequest build() => _build();

  _$ProjectVendorSelectionRequest _build() {
    _$ProjectVendorSelectionRequest _$result;
    try {
      _$result = _$v ??
          _$ProjectVendorSelectionRequest._(
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'ProjectVendorSelectionRequest', 'lockVersion'),
            candidateId: BuiltValueNullFieldError.checkNotNull(
                candidateId, r'ProjectVendorSelectionRequest', 'candidateId'),
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
            r'ProjectVendorSelectionRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
