import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingView extends StatelessWidget {
  const BookingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking'), centerTitle: true),
      body: const Center(
        child: Text(
          'Booking Form Placeholder\n\n(This requires Auth)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
