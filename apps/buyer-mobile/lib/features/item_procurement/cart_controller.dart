import 'package:flutter/foundation.dart';

import '../map_discovery/discovery_models.dart';
import 'procurement_models.dart';
import 'procurement_repository.dart';

/// Cart state. Every change sends the cart lock_version; a 409 reloads the latest cart and keeps
/// the Buyer's message visible instead of overwriting another device's edit. Nothing here reserves
/// stock or submits an order.
class CartController extends ChangeNotifier {
  CartController({required ProcurementRepository repository})
    : _repository = repository;

  final ProcurementRepository _repository;

  CartView? cart;
  LoadPhase phase = LoadPhase.loading;
  DiscoveryFailure? failure;

  /// A non-blocking message about the last action (for example a version conflict).
  String? notice;
  String? busyLineId;
  bool busy = false;

  CheckoutPreviewView? preview;
  DiscoveryFailure? previewFailure;
  bool previewLoading = false;
  int _previewSequence = 0;
  bool _disposed = false;
  bool _loadingCart = false;
  int _cartSequence = 0;

  int get lineCount => cart?.lineCount ?? 0;

  Future<void> load() async {
    if (_loadingCart || busy) return;
    _loadingCart = true;
    final sequence = ++_cartSequence;
    phase = cart == null ? LoadPhase.loading : phase;
    failure = null;
    _notify();
    try {
      final loaded = await _repository.cart();
      if (_disposed || sequence != _cartSequence) return;
      cart = loaded;
      phase = LoadPhase.ready;
    } on DiscoveryFailure catch (error) {
      if (_disposed || sequence != _cartSequence) return;
      failure = error;
      phase = cart == null ? LoadPhase.failed : LoadPhase.ready;
    } finally {
      _loadingCart = false;
    }
    _notify();
  }

  void replace(CartView next) {
    _cartSequence++;
    preview = null;
    _previewSequence++;
    previewLoading = false;
    cart = next;
    phase = LoadPhase.ready;
    _notify();
  }

  Future<void> changeQuantity(CartLineView line, String quantity) => _mutate(
    line.id,
    (version) => _repository.updateLine(
      line,
      cartLockVersion: version,
      quantity: quantity,
    ),
  );

  Future<void> acceptCurrentPrice(CartLineView line) => _mutate(
    line.id,
    (version) => _repository.updateLine(
      line,
      cartLockVersion: version,
      acceptCurrentPrice: true,
    ),
  );

  Future<void> saveForLater(CartLineView line, {required bool saved}) =>
      _mutate(
        line.id,
        (version) => _repository.updateLine(
          line,
          cartLockVersion: version,
          savedForLater: saved,
        ),
      );

  Future<void> remove(CartLineView line) => _mutate(
    line.id,
    (version) => _repository.removeLine(line, cartLockVersion: version),
  );

  /// Removes every selected (active) line, one versioned request at a time. The first failure
  /// stops the run and keeps the cart the server last returned; saved-for-later lines stay.
  Future<void> removeSelected() async {
    if (busy || cart == null) return;
    busy = true;
    _cartSequence++;
    notice = null;
    preview = null;
    _previewSequence++;
    previewLoading = false;
    _notify();
    try {
      for (final line in [...cart!.groups.expand((group) => group.lines)]) {
        cart = await _repository.removeLine(
          line,
          cartLockVersion: cart!.lockVersion,
        );
      }
    } on DiscoveryFailure catch (error) {
      await _handle(error);
    } finally {
      busy = false;
      _notify();
    }
  }

  /// Selection reuses the persisted active/saved-for-later partition consumed by
  /// checkout preview. Unselected lines remain in the cart, with separate variants.
  Future<bool> selectOnlyVariant(String variantId) =>
      _selectLines((line) => line.variantId == variantId);

  Future<bool> selectAll(bool selected) => _selectLines(
    (line) =>
        selected &&
        line.available &&
        !line.issues.any((issue) => issue.blocking),
  );

  Future<bool> _selectLines(bool Function(CartLineView) selected) async {
    if (busy || cart == null) return false;
    busy = true;
    _cartSequence++;
    notice = null;
    preview = null;
    _previewSequence++;
    previewLoading = false;
    _notify();
    try {
      final lines = [
        ...cart!.groups.expand((group) => group.lines),
        ...cart!.savedForLater,
      ];
      for (final line in lines) {
        final saved = !selected(line);
        if (line.savedForLater == saved) continue;
        cart = await _repository.updateLine(
          line,
          cartLockVersion: cart!.lockVersion,
          savedForLater: saved,
        );
      }
      return true;
    } on DiscoveryFailure catch (error) {
      await _handle(error);
      return false;
    } finally {
      busy = false;
      _notify();
    }
  }

  Future<void> setFulfillment(String vendorId, String method) => _mutate(
    null,
    (version) =>
        _repository.setFulfillment(vendorId, method, cartLockVersion: version),
  );

  /// Returns field errors from a 422 so the destination form can show them next to each field.
  Future<Map<String, Object?>?> setDestination({
    required String? intendedLocationId,
    required String heavyVehicleRestriction,
    String? alternateDropOffLocationId,
    String? accessInstructions,
  }) async {
    final current = cart;
    if (current == null || busy) {
      return {'form': 'Wait for the current cart update.'};
    }
    busy = true;
    notice = null;
    _cartSequence++;
    _previewSequence++;
    previewLoading = false;
    _notify();
    try {
      cart = await _repository.setDestination(
        cartLockVersion: current.lockVersion,
        intendedLocationId: intendedLocationId,
        heavyVehicleRestriction: heavyVehicleRestriction,
        alternateDropOffLocationId: alternateDropOffLocationId,
        accessInstructions: accessInstructions,
      );
      return null;
    } on DiscoveryFailure catch (error) {
      if (error.kind == DiscoveryFailureKind.validation) {
        notice = error.message;
        return error.details.isEmpty ? {'form': error.message} : error.details;
      }
      await _handle(error);
      return {'form': error.message};
    } finally {
      busy = false;
      _notify();
    }
  }

  /// A preview is valid only for the request that produced it; older replies are discarded.
  Future<void> loadPreview() async {
    final sequence = ++_previewSequence;
    previewLoading = true;
    previewFailure = null;
    _notify();
    try {
      final result = await _repository.checkoutPreview(
        requestVersion: 'preview-$sequence',
      );
      if (_disposed ||
          sequence != _previewSequence ||
          result.requestVersion != 'preview-$sequence') {
        return;
      }
      preview = result;
    } on DiscoveryFailure catch (error) {
      if (_disposed || sequence != _previewSequence) return;
      previewFailure = error;
    } finally {
      if (!_disposed && sequence == _previewSequence) {
        previewLoading = false;
        _notify();
      }
    }
  }

  Future<void> _mutate(
    String? lineId,
    Future<CartView> Function(int version) operation,
  ) async {
    final current = cart;
    if (current == null || busy) return;
    _cartSequence++;
    preview = null;
    _previewSequence++;
    previewLoading = false;
    busy = true;
    busyLineId = lineId;
    notice = null;
    _notify();
    try {
      cart = await operation(current.lockVersion);
    } on DiscoveryFailure catch (error) {
      await _handle(error);
    } finally {
      busy = false;
      busyLineId = null;
      _notify();
    }
  }

  Future<void> _handle(DiscoveryFailure error) async {
    notice = error.message;
    if (error.kind == DiscoveryFailureKind.conflict ||
        error.kind == DiscoveryFailureKind.notFound) {
      try {
        cart = await _repository.cart();
      } on DiscoveryFailure catch (reload) {
        failure = reload;
      }
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
