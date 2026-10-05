import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/controllers/order_controller.dart';
import 'package:kitchenary/core/constants/grocery_stores.dart';
import 'package:kitchenary/models/shopping_item.dart';

void main() {
  const items = [
    ShoppingItem(id: '1', name: 'Onion'),
    ShoppingItem(id: '2', name: 'Rice'),
    ShoppingItem(id: '3', name: 'Salt'),
  ];

  test('starts with no store and no current item', () {
    final order = OrderController(items);
    expect(order.hasItems, isTrue);
    expect(order.hasStore, isFalse);
    expect(order.current, isNull);
    expect(order.isDone, isFalse);
  });

  test('empty list has nothing to order', () {
    expect(OrderController(const []).hasItems, isFalse);
  });

  test('choosing a store starts at the first item', () {
    final order = OrderController(items)..chooseStore(GroceryStores.blinkit);
    expect(order.store, GroceryStores.blinkit);
    expect(order.current!.name, 'Onion');
    expect(order.position, 1);
    expect(order.progress, 0);
  });

  test('next walks through the items and then finishes', () {
    final order = OrderController(items)..chooseStore(GroceryStores.zepto);
    order.next();
    expect(order.current!.name, 'Rice');
    expect(order.progress, closeTo(1 / 3, 0.001));
    order
      ..next()
      ..next();
    expect(order.isDone, isTrue);
    expect(order.current, isNull);
    expect(order.progress, 1);

    order.next();
    expect(order.index, 3, reason: 'cannot go past the end');
  });

  test('previous goes back but not before the first item', () {
    final order = OrderController(items)..chooseStore(GroceryStores.zepto);
    order.previous();
    expect(order.index, 0);
    order
      ..next()
      ..previous();
    expect(order.current!.name, 'Onion');
  });

  test('changing the store starts over', () {
    final order = OrderController(items)..chooseStore(GroceryStores.zepto);
    order.next();
    order.changeStore();
    expect(order.hasStore, isFalse);
    order.chooseStore(GroceryStores.bigBasket);
    expect(order.index, 0);
  });

  test('next and previous do nothing before a store is chosen', () {
    final order = OrderController(items);
    order
      ..next()
      ..previous();
    expect(order.index, 0);
  });
}
