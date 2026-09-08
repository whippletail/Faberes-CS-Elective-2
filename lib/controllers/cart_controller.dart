import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartController extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  List<CartItem> get items => List.unmodifiable(_items.values);
  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);
  int get total => _items.values.fold(0, (sum, item) => sum + item.subtotal);
  bool get isEmpty => _items.isEmpty;
  void add(Product product, {int quantity = 1}) { final current = _items[product.id]; _items[product.id] = CartItem(product: product, quantity: (current?.quantity ?? 0) + quantity); notifyListeners(); }
  void increment(String id) { final item = _items[id]; if (item == null) return; _items[id] = item.copyWith(quantity: item.quantity + 1); notifyListeners(); }
  void decrement(String id) { final item = _items[id]; if (item == null) return; item.quantity == 1 ? _items.remove(id) : _items[id] = item.copyWith(quantity: item.quantity - 1); notifyListeners(); }
  void remove(String id) { _items.remove(id); notifyListeners(); }
  void clear() { _items.clear(); notifyListeners(); }
}
