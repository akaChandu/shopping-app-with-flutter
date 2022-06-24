import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  const OrderItem(this.order, {Key? key}) : super(key: key);

  final ord.OrderItem order;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300,),
      height: _expanded ? min(widget.order.products.length * 20.0 + 110, 200) : 95,
      child: Card(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat.yMd().add_jm().format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            // if (_expanded)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _expanded ? min(widget.order.products.length * 20.0 + 10, 100) : 0,
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
                child: ListView(
                  children: widget.order.products
                      .map(
                        (e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.title,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${e.quantity}x\$${e.price}',
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
