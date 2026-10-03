// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_review_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FinanceReviewItemStateEnum _$financeReviewItemStateEnum_OPEN =
    const FinanceReviewItemStateEnum._('OPEN');
const FinanceReviewItemStateEnum _$financeReviewItemStateEnum_RESOLVED =
    const FinanceReviewItemStateEnum._('RESOLVED');

FinanceReviewItemStateEnum _$financeReviewItemStateEnumValueOf(String name) {
  switch (name) {
    case 'OPEN':
      return _$financeReviewItemStateEnum_OPEN;
    case 'RESOLVED':
      return _$financeReviewItemStateEnum_RESOLVED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FinanceReviewItemStateEnum> _$financeReviewItemStateEnumValues =
    BuiltSet<FinanceReviewItemStateEnum>(const <FinanceReviewItemStateEnum>[
  _$financeReviewItemStateEnum_OPEN,
  _$financeReviewItemStateEnum_RESOLVED,
]);

Serializer<FinanceReviewItemStateEnum> _$financeReviewItemStateEnumSerializer =
    _$FinanceReviewItemStateEnumSerializer();

class _$FinanceReviewItemStateEnumSerializer
    implements PrimitiveSerializer<FinanceReviewItemStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OPEN': 'OPEN',
    'RESOLVED': 'RESOLVED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OPEN': 'OPEN',
    'RESOLVED': 'RESOLVED',
  };

  @override
  final Iterable<Type> types = const <Type>[FinanceReviewItemStateEnum];
  @override
  final String wireName = 'FinanceReviewItemStateEnum';

  @override
  Object serialize(Serializers serializers, FinanceReviewItemStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FinanceReviewItemStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FinanceReviewItemStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FinanceReviewItem extends FinanceReviewItem {
  @override
  final String id;
  @override
  final String kind;
  @override
  final FinanceReviewItemStateEnum state;
  @override
  final String reasonCode;
  @override
  final String summary;
  @override
  final BuiltMap<String, JsonObject?>? vendor;
  @override
  final String sourceType;
  @override
  final String sourceId;
  @override
  final BuiltMap<String, JsonObject?> expected;
  @override
  final BuiltMap<String, JsonObject?> reported;
  @override
  final String? resolution;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? resolvedAt;

  factory _$FinanceReviewItem(
          [void Function(FinanceReviewItemBuilder)? updates]) =>
      (FinanceReviewItemBuilder()..update(updates))._build();

  _$FinanceReviewItem._(
      {required this.id,
      required this.kind,
      required this.state,
      required this.reasonCode,
      required this.summary,
      this.vendor,
      required this.sourceType,
      required this.sourceId,
      required this.expected,
      required this.reported,
      this.resolution,
      this.createdAt,
      this.resolvedAt})
      : super._();
  @override
  FinanceReviewItem rebuild(void Function(FinanceReviewItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FinanceReviewItemBuilder toBuilder() =>
      FinanceReviewItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FinanceReviewItem &&
        id == other.id &&
        kind == other.kind &&
        state == other.state &&
        reasonCode == other.reasonCode &&
        summary == other.summary &&
        vendor == other.vendor &&
        sourceType == other.sourceType &&
        sourceId == other.sourceId &&
        expected == other.expected &&
        reported == other.reported &&
        resolution == other.resolution &&
        createdAt == other.createdAt &&
        resolvedAt == other.resolvedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, reasonCode.hashCode);
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jc(_$hash, vendor.hashCode);
    _$hash = $jc(_$hash, sourceType.hashCode);
    _$hash = $jc(_$hash, sourceId.hashCode);
    _$hash = $jc(_$hash, expected.hashCode);
    _$hash = $jc(_$hash, reported.hashCode);
    _$hash = $jc(_$hash, resolution.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, resolvedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FinanceReviewItem')
          ..add('id', id)
          ..add('kind', kind)
          ..add('state', state)
          ..add('reasonCode', reasonCode)
          ..add('summary', summary)
          ..add('vendor', vendor)
          ..add('sourceType', sourceType)
          ..add('sourceId', sourceId)
          ..add('expected', expected)
          ..add('reported', reported)
          ..add('resolution', resolution)
          ..add('createdAt', createdAt)
          ..add('resolvedAt', resolvedAt))
        .toString();
  }
}

class FinanceReviewItemBuilder
    implements Builder<FinanceReviewItem, FinanceReviewItemBuilder> {
  _$FinanceReviewItem? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _kind;
  String? get kind => _$this._kind;
  set kind(String? kind) => _$this._kind = kind;

  FinanceReviewItemStateEnum? _state;
  FinanceReviewItemStateEnum? get state => _$this._state;
  set state(FinanceReviewItemStateEnum? state) => _$this._state = state;

  String? _reasonCode;
  String? get reasonCode => _$this._reasonCode;
  set reasonCode(String? reasonCode) => _$this._reasonCode = reasonCode;

  String? _summary;
  String? get summary => _$this._summary;
  set summary(String? summary) => _$this._summary = summary;

  MapBuilder<String, JsonObject?>? _vendor;
  MapBuilder<String, JsonObject?> get vendor =>
      _$this._vendor ??= MapBuilder<String, JsonObject?>();
  set vendor(MapBuilder<String, JsonObject?>? vendor) =>
      _$this._vendor = vendor;

  String? _sourceType;
  String? get sourceType => _$this._sourceType;
  set sourceType(String? sourceType) => _$this._sourceType = sourceType;

  String? _sourceId;
  String? get sourceId => _$this._sourceId;
  set sourceId(String? sourceId) => _$this._sourceId = sourceId;

  MapBuilder<String, JsonObject?>? _expected;
  MapBuilder<String, JsonObject?> get expected =>
      _$this._expected ??= MapBuilder<String, JsonObject?>();
  set expected(MapBuilder<String, JsonObject?>? expected) =>
      _$this._expected = expected;

  MapBuilder<String, JsonObject?>? _reported;
  MapBuilder<String, JsonObject?> get reported =>
      _$this._reported ??= MapBuilder<String, JsonObject?>();
  set reported(MapBuilder<String, JsonObject?>? reported) =>
      _$this._reported = reported;

  String? _resolution;
  String? get resolution => _$this._resolution;
  set resolution(String? resolution) => _$this._resolution = resolution;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _resolvedAt;
  DateTime? get resolvedAt => _$this._resolvedAt;
  set resolvedAt(DateTime? resolvedAt) => _$this._resolvedAt = resolvedAt;

  FinanceReviewItemBuilder() {
    FinanceReviewItem._defaults(this);
  }

  FinanceReviewItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _kind = $v.kind;
      _state = $v.state;
      _reasonCode = $v.reasonCode;
      _summary = $v.summary;
      _vendor = $v.vendor?.toBuilder();
      _sourceType = $v.sourceType;
      _sourceId = $v.sourceId;
      _expected = $v.expected.toBuilder();
      _reported = $v.reported.toBuilder();
      _resolution = $v.resolution;
      _createdAt = $v.createdAt;
      _resolvedAt = $v.resolvedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FinanceReviewItem other) {
    _$v = other as _$FinanceReviewItem;
  }

  @override
  void update(void Function(FinanceReviewItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FinanceReviewItem build() => _build();

  _$FinanceReviewItem _build() {
    _$FinanceReviewItem _$result;
    try {
      _$result = _$v ??
          _$FinanceReviewItem._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'FinanceReviewItem', 'id'),
            kind: BuiltValueNullFieldError.checkNotNull(
                kind, r'FinanceReviewItem', 'kind'),
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'FinanceReviewItem', 'state'),
            reasonCode: BuiltValueNullFieldError.checkNotNull(
                reasonCode, r'FinanceReviewItem', 'reasonCode'),
            summary: BuiltValueNullFieldError.checkNotNull(
                summary, r'FinanceReviewItem', 'summary'),
            vendor: _vendor?.build(),
            sourceType: BuiltValueNullFieldError.checkNotNull(
                sourceType, r'FinanceReviewItem', 'sourceType'),
            sourceId: BuiltValueNullFieldError.checkNotNull(
                sourceId, r'FinanceReviewItem', 'sourceId'),
            expected: expected.build(),
            reported: reported.build(),
            resolution: resolution,
            createdAt: createdAt,
            resolvedAt: resolvedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vendor';
        _vendor?.build();

        _$failedField = 'expected';
        expected.build();
        _$failedField = 'reported';
        reported.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FinanceReviewItem', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
