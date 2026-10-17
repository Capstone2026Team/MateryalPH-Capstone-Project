// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_quotation_discount_assessment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ChatQuotationDiscountAssessmentScopeEnum
    _$chatQuotationDiscountAssessmentScopeEnum_MATERIALS =
    const ChatQuotationDiscountAssessmentScopeEnum._('MATERIALS');
const ChatQuotationDiscountAssessmentScopeEnum
    _$chatQuotationDiscountAssessmentScopeEnum_DELIVERY =
    const ChatQuotationDiscountAssessmentScopeEnum._('DELIVERY');

ChatQuotationDiscountAssessmentScopeEnum
    _$chatQuotationDiscountAssessmentScopeEnumValueOf(String name) {
  switch (name) {
    case 'MATERIALS':
      return _$chatQuotationDiscountAssessmentScopeEnum_MATERIALS;
    case 'DELIVERY':
      return _$chatQuotationDiscountAssessmentScopeEnum_DELIVERY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ChatQuotationDiscountAssessmentScopeEnum>
    _$chatQuotationDiscountAssessmentScopeEnumValues = BuiltSet<
        ChatQuotationDiscountAssessmentScopeEnum>(const <ChatQuotationDiscountAssessmentScopeEnum>[
  _$chatQuotationDiscountAssessmentScopeEnum_MATERIALS,
  _$chatQuotationDiscountAssessmentScopeEnum_DELIVERY,
]);

Serializer<ChatQuotationDiscountAssessmentScopeEnum>
    _$chatQuotationDiscountAssessmentScopeEnumSerializer =
    _$ChatQuotationDiscountAssessmentScopeEnumSerializer();

class _$ChatQuotationDiscountAssessmentScopeEnumSerializer
    implements PrimitiveSerializer<ChatQuotationDiscountAssessmentScopeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MATERIALS': 'MATERIALS',
    'DELIVERY': 'DELIVERY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MATERIALS': 'MATERIALS',
    'DELIVERY': 'DELIVERY',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ChatQuotationDiscountAssessmentScopeEnum
  ];
  @override
  final String wireName = 'ChatQuotationDiscountAssessmentScopeEnum';

  @override
  Object serialize(Serializers serializers,
          ChatQuotationDiscountAssessmentScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ChatQuotationDiscountAssessmentScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ChatQuotationDiscountAssessmentScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ChatQuotationDiscountAssessment
    extends ChatQuotationDiscountAssessment {
  @override
  final ChatQuotationDiscountAssessmentScopeEnum scope;
  @override
  final String percent;
  @override
  final int basisCentavos;
  @override
  final int deductionCentavos;

  factory _$ChatQuotationDiscountAssessment(
          [void Function(ChatQuotationDiscountAssessmentBuilder)? updates]) =>
      (ChatQuotationDiscountAssessmentBuilder()..update(updates))._build();

  _$ChatQuotationDiscountAssessment._(
      {required this.scope,
      required this.percent,
      required this.basisCentavos,
      required this.deductionCentavos})
      : super._();
  @override
  ChatQuotationDiscountAssessment rebuild(
          void Function(ChatQuotationDiscountAssessmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatQuotationDiscountAssessmentBuilder toBuilder() =>
      ChatQuotationDiscountAssessmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatQuotationDiscountAssessment &&
        scope == other.scope &&
        percent == other.percent &&
        basisCentavos == other.basisCentavos &&
        deductionCentavos == other.deductionCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, percent.hashCode);
    _$hash = $jc(_$hash, basisCentavos.hashCode);
    _$hash = $jc(_$hash, deductionCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatQuotationDiscountAssessment')
          ..add('scope', scope)
          ..add('percent', percent)
          ..add('basisCentavos', basisCentavos)
          ..add('deductionCentavos', deductionCentavos))
        .toString();
  }
}

class ChatQuotationDiscountAssessmentBuilder
    implements
        Builder<ChatQuotationDiscountAssessment,
            ChatQuotationDiscountAssessmentBuilder> {
  _$ChatQuotationDiscountAssessment? _$v;

  ChatQuotationDiscountAssessmentScopeEnum? _scope;
  ChatQuotationDiscountAssessmentScopeEnum? get scope => _$this._scope;
  set scope(ChatQuotationDiscountAssessmentScopeEnum? scope) =>
      _$this._scope = scope;

  String? _percent;
  String? get percent => _$this._percent;
  set percent(String? percent) => _$this._percent = percent;

  int? _basisCentavos;
  int? get basisCentavos => _$this._basisCentavos;
  set basisCentavos(int? basisCentavos) =>
      _$this._basisCentavos = basisCentavos;

  int? _deductionCentavos;
  int? get deductionCentavos => _$this._deductionCentavos;
  set deductionCentavos(int? deductionCentavos) =>
      _$this._deductionCentavos = deductionCentavos;

  ChatQuotationDiscountAssessmentBuilder() {
    ChatQuotationDiscountAssessment._defaults(this);
  }

  ChatQuotationDiscountAssessmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _scope = $v.scope;
      _percent = $v.percent;
      _basisCentavos = $v.basisCentavos;
      _deductionCentavos = $v.deductionCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatQuotationDiscountAssessment other) {
    _$v = other as _$ChatQuotationDiscountAssessment;
  }

  @override
  void update(void Function(ChatQuotationDiscountAssessmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatQuotationDiscountAssessment build() => _build();

  _$ChatQuotationDiscountAssessment _build() {
    final _$result = _$v ??
        _$ChatQuotationDiscountAssessment._(
          scope: BuiltValueNullFieldError.checkNotNull(
              scope, r'ChatQuotationDiscountAssessment', 'scope'),
          percent: BuiltValueNullFieldError.checkNotNull(
              percent, r'ChatQuotationDiscountAssessment', 'percent'),
          basisCentavos: BuiltValueNullFieldError.checkNotNull(basisCentavos,
              r'ChatQuotationDiscountAssessment', 'basisCentavos'),
          deductionCentavos: BuiltValueNullFieldError.checkNotNull(
              deductionCentavos,
              r'ChatQuotationDiscountAssessment',
              'deductionCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
