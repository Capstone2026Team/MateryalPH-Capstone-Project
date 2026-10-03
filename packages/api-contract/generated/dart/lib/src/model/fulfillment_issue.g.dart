// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fulfillment_issue.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FulfillmentIssueCategoryEnum _$fulfillmentIssueCategoryEnum_NOT_RECEIVED =
    const FulfillmentIssueCategoryEnum._('NOT_RECEIVED');
const FulfillmentIssueCategoryEnum _$fulfillmentIssueCategoryEnum_INCOMPLETE =
    const FulfillmentIssueCategoryEnum._('INCOMPLETE');
const FulfillmentIssueCategoryEnum _$fulfillmentIssueCategoryEnum_DAMAGED =
    const FulfillmentIssueCategoryEnum._('DAMAGED');
const FulfillmentIssueCategoryEnum _$fulfillmentIssueCategoryEnum_WRONG_ITEM =
    const FulfillmentIssueCategoryEnum._('WRONG_ITEM');
const FulfillmentIssueCategoryEnum _$fulfillmentIssueCategoryEnum_LATE =
    const FulfillmentIssueCategoryEnum._('LATE');
const FulfillmentIssueCategoryEnum
    _$fulfillmentIssueCategoryEnum_ACCESS_PROBLEM =
    const FulfillmentIssueCategoryEnum._('ACCESS_PROBLEM');
const FulfillmentIssueCategoryEnum _$fulfillmentIssueCategoryEnum_OTHER =
    const FulfillmentIssueCategoryEnum._('OTHER');

FulfillmentIssueCategoryEnum _$fulfillmentIssueCategoryEnumValueOf(
    String name) {
  switch (name) {
    case 'NOT_RECEIVED':
      return _$fulfillmentIssueCategoryEnum_NOT_RECEIVED;
    case 'INCOMPLETE':
      return _$fulfillmentIssueCategoryEnum_INCOMPLETE;
    case 'DAMAGED':
      return _$fulfillmentIssueCategoryEnum_DAMAGED;
    case 'WRONG_ITEM':
      return _$fulfillmentIssueCategoryEnum_WRONG_ITEM;
    case 'LATE':
      return _$fulfillmentIssueCategoryEnum_LATE;
    case 'ACCESS_PROBLEM':
      return _$fulfillmentIssueCategoryEnum_ACCESS_PROBLEM;
    case 'OTHER':
      return _$fulfillmentIssueCategoryEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FulfillmentIssueCategoryEnum>
    _$fulfillmentIssueCategoryEnumValues =
    BuiltSet<FulfillmentIssueCategoryEnum>(const <FulfillmentIssueCategoryEnum>[
  _$fulfillmentIssueCategoryEnum_NOT_RECEIVED,
  _$fulfillmentIssueCategoryEnum_INCOMPLETE,
  _$fulfillmentIssueCategoryEnum_DAMAGED,
  _$fulfillmentIssueCategoryEnum_WRONG_ITEM,
  _$fulfillmentIssueCategoryEnum_LATE,
  _$fulfillmentIssueCategoryEnum_ACCESS_PROBLEM,
  _$fulfillmentIssueCategoryEnum_OTHER,
]);

const FulfillmentIssueStateEnum _$fulfillmentIssueStateEnum_OPEN =
    const FulfillmentIssueStateEnum._('OPEN');
const FulfillmentIssueStateEnum _$fulfillmentIssueStateEnum_RESOLVED =
    const FulfillmentIssueStateEnum._('RESOLVED');

FulfillmentIssueStateEnum _$fulfillmentIssueStateEnumValueOf(String name) {
  switch (name) {
    case 'OPEN':
      return _$fulfillmentIssueStateEnum_OPEN;
    case 'RESOLVED':
      return _$fulfillmentIssueStateEnum_RESOLVED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FulfillmentIssueStateEnum> _$fulfillmentIssueStateEnumValues =
    BuiltSet<FulfillmentIssueStateEnum>(const <FulfillmentIssueStateEnum>[
  _$fulfillmentIssueStateEnum_OPEN,
  _$fulfillmentIssueStateEnum_RESOLVED,
]);

const FulfillmentIssueResolutionEnum
    _$fulfillmentIssueResolutionEnum_BUYER_RESOLVED =
    const FulfillmentIssueResolutionEnum._('BUYER_RESOLVED');
const FulfillmentIssueResolutionEnum
    _$fulfillmentIssueResolutionEnum_RECEIPT_CONFIRMED =
    const FulfillmentIssueResolutionEnum._('RECEIPT_CONFIRMED');
const FulfillmentIssueResolutionEnum
    _$fulfillmentIssueResolutionEnum_ORDER_CANCELLED =
    const FulfillmentIssueResolutionEnum._('ORDER_CANCELLED');

FulfillmentIssueResolutionEnum _$fulfillmentIssueResolutionEnumValueOf(
    String name) {
  switch (name) {
    case 'BUYER_RESOLVED':
      return _$fulfillmentIssueResolutionEnum_BUYER_RESOLVED;
    case 'RECEIPT_CONFIRMED':
      return _$fulfillmentIssueResolutionEnum_RECEIPT_CONFIRMED;
    case 'ORDER_CANCELLED':
      return _$fulfillmentIssueResolutionEnum_ORDER_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FulfillmentIssueResolutionEnum>
    _$fulfillmentIssueResolutionEnumValues = BuiltSet<
        FulfillmentIssueResolutionEnum>(const <FulfillmentIssueResolutionEnum>[
  _$fulfillmentIssueResolutionEnum_BUYER_RESOLVED,
  _$fulfillmentIssueResolutionEnum_RECEIPT_CONFIRMED,
  _$fulfillmentIssueResolutionEnum_ORDER_CANCELLED,
]);

Serializer<FulfillmentIssueCategoryEnum>
    _$fulfillmentIssueCategoryEnumSerializer =
    _$FulfillmentIssueCategoryEnumSerializer();
Serializer<FulfillmentIssueStateEnum> _$fulfillmentIssueStateEnumSerializer =
    _$FulfillmentIssueStateEnumSerializer();
Serializer<FulfillmentIssueResolutionEnum>
    _$fulfillmentIssueResolutionEnumSerializer =
    _$FulfillmentIssueResolutionEnumSerializer();

class _$FulfillmentIssueCategoryEnumSerializer
    implements PrimitiveSerializer<FulfillmentIssueCategoryEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NOT_RECEIVED': 'NOT_RECEIVED',
    'INCOMPLETE': 'INCOMPLETE',
    'DAMAGED': 'DAMAGED',
    'WRONG_ITEM': 'WRONG_ITEM',
    'LATE': 'LATE',
    'ACCESS_PROBLEM': 'ACCESS_PROBLEM',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NOT_RECEIVED': 'NOT_RECEIVED',
    'INCOMPLETE': 'INCOMPLETE',
    'DAMAGED': 'DAMAGED',
    'WRONG_ITEM': 'WRONG_ITEM',
    'LATE': 'LATE',
    'ACCESS_PROBLEM': 'ACCESS_PROBLEM',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[FulfillmentIssueCategoryEnum];
  @override
  final String wireName = 'FulfillmentIssueCategoryEnum';

  @override
  Object serialize(Serializers serializers, FulfillmentIssueCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FulfillmentIssueCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FulfillmentIssueCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FulfillmentIssueStateEnumSerializer
    implements PrimitiveSerializer<FulfillmentIssueStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OPEN': 'OPEN',
    'RESOLVED': 'RESOLVED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OPEN': 'OPEN',
    'RESOLVED': 'RESOLVED',
  };

  @override
  final Iterable<Type> types = const <Type>[FulfillmentIssueStateEnum];
  @override
  final String wireName = 'FulfillmentIssueStateEnum';

  @override
  Object serialize(Serializers serializers, FulfillmentIssueStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FulfillmentIssueStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FulfillmentIssueStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FulfillmentIssueResolutionEnumSerializer
    implements PrimitiveSerializer<FulfillmentIssueResolutionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER_RESOLVED': 'BUYER_RESOLVED',
    'RECEIPT_CONFIRMED': 'RECEIPT_CONFIRMED',
    'ORDER_CANCELLED': 'ORDER_CANCELLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER_RESOLVED': 'BUYER_RESOLVED',
    'RECEIPT_CONFIRMED': 'RECEIPT_CONFIRMED',
    'ORDER_CANCELLED': 'ORDER_CANCELLED',
  };

  @override
  final Iterable<Type> types = const <Type>[FulfillmentIssueResolutionEnum];
  @override
  final String wireName = 'FulfillmentIssueResolutionEnum';

  @override
  Object serialize(
          Serializers serializers, FulfillmentIssueResolutionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FulfillmentIssueResolutionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FulfillmentIssueResolutionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FulfillmentIssue extends FulfillmentIssue {
  @override
  final String id;
  @override
  final FulfillmentIssueCategoryEnum category;
  @override
  final String description;
  @override
  final FulfillmentIssueStateEnum state;
  @override
  final DateTime? reportedAt;
  @override
  final String? vendorResponse;
  @override
  final DateTime? vendorRespondedAt;
  @override
  final FulfillmentIssueResolutionEnum? resolution;
  @override
  final DateTime? resolvedAt;
  @override
  final BuiltList<String> photoPaths;

  factory _$FulfillmentIssue(
          [void Function(FulfillmentIssueBuilder)? updates]) =>
      (FulfillmentIssueBuilder()..update(updates))._build();

  _$FulfillmentIssue._(
      {required this.id,
      required this.category,
      required this.description,
      required this.state,
      this.reportedAt,
      this.vendorResponse,
      this.vendorRespondedAt,
      this.resolution,
      this.resolvedAt,
      required this.photoPaths})
      : super._();
  @override
  FulfillmentIssue rebuild(void Function(FulfillmentIssueBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FulfillmentIssueBuilder toBuilder() =>
      FulfillmentIssueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FulfillmentIssue &&
        id == other.id &&
        category == other.category &&
        description == other.description &&
        state == other.state &&
        reportedAt == other.reportedAt &&
        vendorResponse == other.vendorResponse &&
        vendorRespondedAt == other.vendorRespondedAt &&
        resolution == other.resolution &&
        resolvedAt == other.resolvedAt &&
        photoPaths == other.photoPaths;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, reportedAt.hashCode);
    _$hash = $jc(_$hash, vendorResponse.hashCode);
    _$hash = $jc(_$hash, vendorRespondedAt.hashCode);
    _$hash = $jc(_$hash, resolution.hashCode);
    _$hash = $jc(_$hash, resolvedAt.hashCode);
    _$hash = $jc(_$hash, photoPaths.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FulfillmentIssue')
          ..add('id', id)
          ..add('category', category)
          ..add('description', description)
          ..add('state', state)
          ..add('reportedAt', reportedAt)
          ..add('vendorResponse', vendorResponse)
          ..add('vendorRespondedAt', vendorRespondedAt)
          ..add('resolution', resolution)
          ..add('resolvedAt', resolvedAt)
          ..add('photoPaths', photoPaths))
        .toString();
  }
}

class FulfillmentIssueBuilder
    implements Builder<FulfillmentIssue, FulfillmentIssueBuilder> {
  _$FulfillmentIssue? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  FulfillmentIssueCategoryEnum? _category;
  FulfillmentIssueCategoryEnum? get category => _$this._category;
  set category(FulfillmentIssueCategoryEnum? category) =>
      _$this._category = category;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  FulfillmentIssueStateEnum? _state;
  FulfillmentIssueStateEnum? get state => _$this._state;
  set state(FulfillmentIssueStateEnum? state) => _$this._state = state;

  DateTime? _reportedAt;
  DateTime? get reportedAt => _$this._reportedAt;
  set reportedAt(DateTime? reportedAt) => _$this._reportedAt = reportedAt;

  String? _vendorResponse;
  String? get vendorResponse => _$this._vendorResponse;
  set vendorResponse(String? vendorResponse) =>
      _$this._vendorResponse = vendorResponse;

  DateTime? _vendorRespondedAt;
  DateTime? get vendorRespondedAt => _$this._vendorRespondedAt;
  set vendorRespondedAt(DateTime? vendorRespondedAt) =>
      _$this._vendorRespondedAt = vendorRespondedAt;

  FulfillmentIssueResolutionEnum? _resolution;
  FulfillmentIssueResolutionEnum? get resolution => _$this._resolution;
  set resolution(FulfillmentIssueResolutionEnum? resolution) =>
      _$this._resolution = resolution;

  DateTime? _resolvedAt;
  DateTime? get resolvedAt => _$this._resolvedAt;
  set resolvedAt(DateTime? resolvedAt) => _$this._resolvedAt = resolvedAt;

  ListBuilder<String>? _photoPaths;
  ListBuilder<String> get photoPaths =>
      _$this._photoPaths ??= ListBuilder<String>();
  set photoPaths(ListBuilder<String>? photoPaths) =>
      _$this._photoPaths = photoPaths;

  FulfillmentIssueBuilder() {
    FulfillmentIssue._defaults(this);
  }

  FulfillmentIssueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _category = $v.category;
      _description = $v.description;
      _state = $v.state;
      _reportedAt = $v.reportedAt;
      _vendorResponse = $v.vendorResponse;
      _vendorRespondedAt = $v.vendorRespondedAt;
      _resolution = $v.resolution;
      _resolvedAt = $v.resolvedAt;
      _photoPaths = $v.photoPaths.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FulfillmentIssue other) {
    _$v = other as _$FulfillmentIssue;
  }

  @override
  void update(void Function(FulfillmentIssueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FulfillmentIssue build() => _build();

  _$FulfillmentIssue _build() {
    _$FulfillmentIssue _$result;
    try {
      _$result = _$v ??
          _$FulfillmentIssue._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'FulfillmentIssue', 'id'),
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'FulfillmentIssue', 'category'),
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'FulfillmentIssue', 'description'),
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'FulfillmentIssue', 'state'),
            reportedAt: reportedAt,
            vendorResponse: vendorResponse,
            vendorRespondedAt: vendorRespondedAt,
            resolution: resolution,
            resolvedAt: resolvedAt,
            photoPaths: photoPaths.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'photoPaths';
        photoPaths.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FulfillmentIssue', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
