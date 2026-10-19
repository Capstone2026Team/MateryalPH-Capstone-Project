// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_selection_preview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProjectSelectionPreviewFulfillmentMethodEnum
    _$projectSelectionPreviewFulfillmentMethodEnum_PICKUP =
    const ProjectSelectionPreviewFulfillmentMethodEnum._('PICKUP');
const ProjectSelectionPreviewFulfillmentMethodEnum
    _$projectSelectionPreviewFulfillmentMethodEnum_DELIVERY =
    const ProjectSelectionPreviewFulfillmentMethodEnum._('DELIVERY');

ProjectSelectionPreviewFulfillmentMethodEnum
    _$projectSelectionPreviewFulfillmentMethodEnumValueOf(String name) {
  switch (name) {
    case 'PICKUP':
      return _$projectSelectionPreviewFulfillmentMethodEnum_PICKUP;
    case 'DELIVERY':
      return _$projectSelectionPreviewFulfillmentMethodEnum_DELIVERY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectSelectionPreviewFulfillmentMethodEnum>
    _$projectSelectionPreviewFulfillmentMethodEnumValues = BuiltSet<
        ProjectSelectionPreviewFulfillmentMethodEnum>(const <ProjectSelectionPreviewFulfillmentMethodEnum>[
  _$projectSelectionPreviewFulfillmentMethodEnum_PICKUP,
  _$projectSelectionPreviewFulfillmentMethodEnum_DELIVERY,
]);

Serializer<ProjectSelectionPreviewFulfillmentMethodEnum>
    _$projectSelectionPreviewFulfillmentMethodEnumSerializer =
    _$ProjectSelectionPreviewFulfillmentMethodEnumSerializer();

class _$ProjectSelectionPreviewFulfillmentMethodEnumSerializer
    implements
        PrimitiveSerializer<ProjectSelectionPreviewFulfillmentMethodEnum> {
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
    ProjectSelectionPreviewFulfillmentMethodEnum
  ];
  @override
  final String wireName = 'ProjectSelectionPreviewFulfillmentMethodEnum';

  @override
  Object serialize(Serializers serializers,
          ProjectSelectionPreviewFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectSelectionPreviewFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectSelectionPreviewFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectSelectionPreview extends ProjectSelectionPreview {
  @override
  final BuiltList<ProjectSpecificationSelection>? selections;
  @override
  final ProjectSelectionPreviewFulfillmentMethodEnum? fulfillmentMethod;

  factory _$ProjectSelectionPreview(
          [void Function(ProjectSelectionPreviewBuilder)? updates]) =>
      (ProjectSelectionPreviewBuilder()..update(updates))._build();

  _$ProjectSelectionPreview._({this.selections, this.fulfillmentMethod})
      : super._();
  @override
  ProjectSelectionPreview rebuild(
          void Function(ProjectSelectionPreviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectSelectionPreviewBuilder toBuilder() =>
      ProjectSelectionPreviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectSelectionPreview &&
        selections == other.selections &&
        fulfillmentMethod == other.fulfillmentMethod;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, selections.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectSelectionPreview')
          ..add('selections', selections)
          ..add('fulfillmentMethod', fulfillmentMethod))
        .toString();
  }
}

class ProjectSelectionPreviewBuilder
    implements
        Builder<ProjectSelectionPreview, ProjectSelectionPreviewBuilder> {
  _$ProjectSelectionPreview? _$v;

  ListBuilder<ProjectSpecificationSelection>? _selections;
  ListBuilder<ProjectSpecificationSelection> get selections =>
      _$this._selections ??= ListBuilder<ProjectSpecificationSelection>();
  set selections(ListBuilder<ProjectSpecificationSelection>? selections) =>
      _$this._selections = selections;

  ProjectSelectionPreviewFulfillmentMethodEnum? _fulfillmentMethod;
  ProjectSelectionPreviewFulfillmentMethodEnum? get fulfillmentMethod =>
      _$this._fulfillmentMethod;
  set fulfillmentMethod(
          ProjectSelectionPreviewFulfillmentMethodEnum? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  ProjectSelectionPreviewBuilder() {
    ProjectSelectionPreview._defaults(this);
  }

  ProjectSelectionPreviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _selections = $v.selections?.toBuilder();
      _fulfillmentMethod = $v.fulfillmentMethod;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectSelectionPreview other) {
    _$v = other as _$ProjectSelectionPreview;
  }

  @override
  void update(void Function(ProjectSelectionPreviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectSelectionPreview build() => _build();

  _$ProjectSelectionPreview _build() {
    _$ProjectSelectionPreview _$result;
    try {
      _$result = _$v ??
          _$ProjectSelectionPreview._(
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
            r'ProjectSelectionPreview', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
