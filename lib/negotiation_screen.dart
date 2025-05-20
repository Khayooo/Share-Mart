import 'package:flutter/material.dart';

class NegotiationScreen extends StatefulWidget {
  final double originalPrice;
  final String itemId;
  final String sellerId;

  const NegotiationScreen({
    super.key,
    required this.originalPrice,
    required this.itemId,
    required this.sellerId,
  });

  @override
  State<NegotiationScreen> createState() => _NegotiationScreenState();
}

class _NegotiationScreenState extends State<NegotiationScreen> {
  final TextEditingController _priceController = TextEditingController();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Price Negotiation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Original Price'),
              trailing: Text('Rs.${widget.originalPrice}'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Your Offer (Rs.)',
                prefixIcon: Icon(Icons.currency_rupee),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitOffer,
              child: Text(_isSubmitting ? 'Submitting...' : 'Submit Offer'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitOffer() async {
    final offer = double.tryParse(_priceController.text);
    if (offer == null || offer >= widget.originalPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid lower offer')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    Navigator.pop(context, offer);
  }
}