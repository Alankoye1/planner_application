import 'package:flutter/material.dart';

class TableCalory extends StatelessWidget {
  const TableCalory({
    super.key,
    required this.caloryTable,
    required this.result,
  });

  final Map<String, double>? caloryTable;
  final double result;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[50],
      ),
      padding: const EdgeInsets.all(12),
      child: Table(
        columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(2)},
        border: TableBorder.symmetric(inside: BorderSide(color: Colors.grey)),
        children: [
          if (caloryTable!.isNotEmpty)
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    ' To lose 1 kg in 1 week',
                    style: const TextStyle(color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    (result - 1000).toStringAsFixed(0),
                    style: const TextStyle(color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  ' To lose 0.5 kg in 1 week',
                  style: const TextStyle(color: Colors.green),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  (result - 500).toStringAsFixed(0),
                  style: const TextStyle(color: Colors.green),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'To maintain weight',
                  style: const TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  (result).toStringAsFixed(0),
                  style: const TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'To Gain 0.5 kg in 1 week',
                  style: const TextStyle(color: Colors.orange),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  (result + 500).toStringAsFixed(0),
                  style: const TextStyle(color: Colors.orange),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'To Gain 1 kg in 1 week',
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  (result + 1000).toStringAsFixed(0),
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
