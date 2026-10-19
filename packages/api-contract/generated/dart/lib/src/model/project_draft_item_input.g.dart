// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_draft_item_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProjectDraftItemInputFulfillmentMethodEnum
    _$projectDraftItemInputFulfillmentMethodEnum_PICKUP =
    const ProjectDraftItemInputFulfillmentMethodEnum._('PICKUP');
const ProjectDraftItemInputFulfillmentMethodEnum
    _$projectDraftItemInputFulfillmentMethodEnum_DELIVERY =
    const ProjectDraftItemInputFulfillmentMethodEnum._('DELIVERY');

ProjectDraftItemInputFulfillmentMethodEnum
    _$projectDraftItemInputFulfillmentMethodEnumValueOf(String name) {
  switch (name) {
    case 'PICKUP':
      return _$projectDraftItemInputFulfillmentMethodEnum_PICKUP;
    case 'DELIVERY':
      return _$projectDraftItemInputFulfillmentMethodEnum_DELIVERY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectDraftItemInputFulfillmentMethodEnum>
    _$projectDraftItemInputFulfillmentMethodEnumValues = BuiltSet<
        ProjectDraftItemInputFulfillmentMethodEnum>(const <ProjectDraftItemInputFulfillmentMethodEnum>[
  _$projectDraftItemInputFulfillmentMethodEnum_PICKUP,
  _$projectDraftItemInputFulfillmentMethodEnum_DELIVERY,
]);

Serializer<ProjectDraftItemInputFulfillmentMethodEnum>
    _$projectDraftItemInputFulfillmentMethodEnumSerializer =
    _$ProjectDraftItemInputFulfillmentMethodEnumSerializer();

class _$ProjectDraftItemInputFulfillmentMethodEnumSerializer
    implements PrimitiveSerializer<ProjectDraftItemInputFulfillmentMethodEnum> {
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
    ProjectDraftItemInputFulfillmentMethodEnum
  ];
  @override
  final String wireName = 'ProjectDraftItemInputFulfillmentMethodEnum';

  @override
  Object serialize(Serializers serializers,
          ProjectDraftItemInputFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectDraftItemInputFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectDraftItemInputFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectDraftItemInput extends ProjectDraftItemInput {
  @override
  final int lockVersion;
  @override
  final String priceVersionId;
  @override
  final BuiltList<ProjectSpecificationSelection>? selections;
  @override
  final ProjectDraftItemInputFulfillmentMethodEnum? fulfillmentMethod;

  factory _$ProjectDraftItemInput(
          [void Function(ProjectDraftItemInputBuilder)? updates]) =>
      (ProjectDraftItemInputBuilder()..update(updates))._build();

  _$ProjectDraftItemInput._(
      {required this.lockVersion,
      required this.priceVersionId,
      this.selections,
      this.fulfillmentMethod})
      : super._();
  @override
  ProjectDraftItemInput rebuild(
          void Function(ProjectDraftItemInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectDraftItemInputBuilder toBuilder() =>
      ProjectDraftItemInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectDraftItemInput &&
        lockVersion == other.lockVersion &&
        priceVersionId == other.priceVersionId &&
        selections == other.selections &&
        fulfillmentMethod == other.fulfillmentMethod;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, priceVersionId.hashCode);
    _$hash = $jc(_$hash, selections.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectDraftItemInput')
          ..add('lockVersion', lockVersion)
          ..add('priceVersionId', priceVersionId)
          ..add('selections', selections)
          ..add('fulfillmentMethod', fulfillmentMethod))
        .toString();
  }
}

class ProjectDraftItemInputBuilder
    implements Builder<ProjectDraftItemInput, ProjectDraftItemInputBuilder> {
  _$ProjectDraftItemInput? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _priceVersionId;
  String? get priceVersionId => _$this._priceVersionId;
  set priceVersionId(String? priceVersionId) =>
      _$this._priceVersionId = priceVersionId;

  ListBuilder<ProjectSpecificationSelection>? _selections;
  ListBuilder<ProjectSpecificationSelection> get selections =>
      _$this._selections ??= ListBuilder<ProjectSpecificationSelection>();
  set selections(ListBuilder<ProjectSpecificationSelection>? selections) =>
      _$this._selections = selections;

  ProjectDraftItemInputFulfillmentMethodEnum? _fulfillmentMethod;
  ProjectDraftItemInputFulfillmentMethodEnum? get fulfillmentMethod =>
      _$this._fulfillmentMethod;
  set fulfillmentMethod(
          ProjectDraftItemInputFulfillmentMethodEnum? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  ProjectDraftItemInputBuilder() {
    ProjectDraftItemInput._defaults(this);
  }

  ProjectDraftItemInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _priceVersionId = $v.priceVersionId;
      _selections = $v.selections?.toBuilder();
      _fulfillmentMethod = $v.fulfillmentMethod;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectDraftItemInput other) {
    _$v = other as _$ProjectDraftItemInput;
  }

  @override
  void update(void Function(ProjectDraftItemInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectDraftItemInput build() => _build();

  _$ProjectDraftItemInput _build() {
    _$ProjectDraftItemInput _$result;
    try {
      _$result = _$v ??
          _$ProjectDraftItemInput._(
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'ProjectDraftItemInput', 'lockVersion'),
            priceVersionId: BuiltValueNullFieldError.checkNotNull(
                priceVersionId, r'ProjectDraftItemInput', 'priceVersionId'),
            selections: _selections?.build(),
            fulfillmentMethod: fulfillmentMethod,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'selections';
        _selections?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectDraftItemInput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
