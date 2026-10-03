// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_draft_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatDraftLine extends ChatDraftLine {
  @override
  final String? description;
  @override
  final BuiltMap<String, String>? specifications;
  @override
  final String variantId;
  @override
  final String quantity;
  @override
  final int unitPriceCentavos;

  factory _$ChatDraftLine([void Function(ChatDraftLineBuilder)? updates]) =>
      (ChatDraftLineBuilder()..update(updates))._build();

  _$ChatDraftLine._(
      {this.description,
      this.specifications,
      required this.variantId,
      required this.quantity,
      required this.unitPriceCentavos})
      : super._();
  @override
  ChatDraftLine rebuild(void Function(ChatDraftLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatDraftLineBuilder toBuilder() => ChatDraftLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatDraftLine &&
        description == other.description &&
        specifications == other.specifications &&
        variantId == other.variantId &&
        quantity == other.quantity &&
        unitPriceCentavos == other.unitPriceCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, specifications.hashCode);
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, unitPriceCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatDraftLine')
          ..add('description', description)
          ..add('specifications', specifications)
          ..add('variantId', variantId)
          ..add('quantity', quantity)
          ..add('unitPriceCentavos', unitPriceCentavos))
        .toString();
  }
}

class ChatDraftLineBuilder
    implements Builder<ChatDraftLine, ChatDraftLineBuilder> {
  _$ChatDraftLine? _$v;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  MapBuilder<String, String>? _specifications;
  MapBuilder<String, String> get specifications =>
      _$this._specifications ??= MapBuilder<String, String>();
  set specifications(MapBuilder<String, String>? specifications) =>
      _$this._specifications = specifications;

  String? _variantId;
  String? get variantId => _$this._variantId;
  set variantId(String? variantId) => _$this._variantId = variantId;

  String? _quantity;
  String? get quantity => _$this._quantity;
  set quantity(String? quantity) => _$this._quantity = quantity;

  int? _unitPriceCentavos;
  int? get unitPriceCentavos => _$this._unitPriceCentavos;
  set unitPriceCentavos(int? unitPriceCentavos) =>
      _$this._unitPriceCentavos = unitPriceCentavos;

  ChatDraftLineBuilder() {
    ChatDraftLine._defaults(this);
  }

  ChatDraftLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _description = $v.description;
      _specifications = $v.specifications?.toBuilder();
      _variantId = $v.variantId;
      _quantity = $v.quantity;
      _unitPriceCentavos = $v.unitPriceCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatDraftLine other) {
    _$v = other as _$ChatDraftLine;
  }

  @override
  void update(void Function(ChatDraftLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatDraftLine build() => _build();

  _$ChatDraftLine _build() {
    _$ChatDraftLine _$result;
    try {
      _$result = _$v ??
          _$ChatDraftLine._(
            description: description,
            specifications: _specifications?.build(),
            variantId: BuiltValueNullFieldError.checkNotNull(
                variantId, r'ChatDraftLine', 'variantId'),
            quantity: BuiltValueNullFieldError.checkNotNull(
                quantity, r'ChatDraftLine', 'quantity'),
            unitPriceCentavos: BuiltValueNullFieldError.checkNotNull(
                unitPriceCentavos, r'ChatDraftLine', 'unitPriceCentavos'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'specifications';
        _specifications?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChatDraftLine', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
