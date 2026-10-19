// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_buyer_profile_ratings_written.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DirectoryBuyerProfileRatingsWritten
    extends DirectoryBuyerProfileRatingsWritten {
  @override
  final int count;

  factory _$DirectoryBuyerProfileRatingsWritten(
          [void Function(DirectoryBuyerProfileRatingsWrittenBuilder)?
              updates]) =>
      (DirectoryBuyerProfileRatingsWrittenBuilder()..update(updates))._build();

  _$DirectoryBuyerProfileRatingsWritten._({required this.count}) : super._();
  @override
  DirectoryBuyerProfileRatingsWritten rebuild(
          void Function(DirectoryBuyerProfileRatingsWrittenBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryBuyerProfileRatingsWrittenBuilder toBuilder() =>
      DirectoryBuyerProfileRatingsWrittenBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryBuyerProfileRatingsWritten && count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectoryBuyerProfileRatingsWritten')
          ..add('count', count))
        .toString();
  }
}

class DirectoryBuyerProfileRatingsWrittenBuilder
    implements
        Builder<DirectoryBuyerProfileRatingsWritten,
            DirectoryBuyerProfileRatingsWrittenBuilder> {
  _$DirectoryBuyerProfileRatingsWritten? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  DirectoryBuyerProfileRatingsWrittenBuilder() {
    DirectoryBuyerProfileRatingsWritten._defaults(this);
  }

  DirectoryBuyerProfileRatingsWrittenBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectoryBuyerProfileRatingsWritten other) {
    _$v = other as _$DirectoryBuyerProfileRatingsWritten;
  }

  @override
  void update(
      void Function(DirectoryBuyerProfileRatingsWrittenBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryBuyerProfileRatingsWritten build() => _build();

  _$DirectoryBuyerProfileRatingsWritten _build() {
    final _$result = _$v ??
        _$DirectoryBuyerProfileRatingsWritten._(
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'DirectoryBuyerProfileRatingsWritten', 'count'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
