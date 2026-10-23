import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/service_booking_model.dart';
import '../models/user_model.dart';
import '../core/constants.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const StatusBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  factory StatusBadge.forOrder(OrderStatus status) {
    Color bg;
    Color text;
    String textLabel = status.name.toUpperCase();

    switch (status) {
      case OrderStatus.placed:
        bg = Colors.blue.shade50;
        text = Colors.blue.shade700;
        break;
      case OrderStatus.confirmed:
        bg = Colors.teal.shade50;
        text = Colors.teal.shade700;
        break;
      case OrderStatus.processing:
        bg = Colors.amber.shade50;
        text = Colors.amber.shade800;
        break;
      case OrderStatus.shipped:
        bg = Colors.indigo.shade50;
        text = Colors.indigo.shade700;
        break;
      case OrderStatus.delivered:
        bg = Colors.green.shade50;
        text = Colors.green.shade700;
        break;
      case OrderStatus.cancelled:
        bg = Colors.red.shade50;
        text = Colors.red.shade700;
        break;
    }

    return StatusBadge(
      label: textLabel,
      backgroundColor: bg,
      textColor: text,
    );
  }

  factory StatusBadge.forService(ServiceStatus status) {
    Color bg;
    Color text;
    String textLabel = status.name.replaceAll('_', ' ').toUpperCase();

    switch (status) {
      case ServiceStatus.submitted:
        bg = Colors.blue.shade50;
        text = Colors.blue.shade700;
        break;
      case ServiceStatus.scheduled:
        bg = Colors.purple.shade50;
        text = Colors.purple.shade700;
        break;
      case ServiceStatus.technician_assigned:
        bg = Colors.orange.shade50;
        text = Colors.orange.shade800;
        break;
      case ServiceStatus.in_progress:
        bg = Colors.amber.shade50;
        text = Colors.amber.shade800;
        break;
      case ServiceStatus.completed:
        bg = Colors.green.shade50;
        text = Colors.green.shade700;
        break;
      case ServiceStatus.cancelled:
        bg = Colors.red.shade50;
        text = Colors.red.shade700;
        break;
    }

    return StatusBadge(
      label: textLabel,
      backgroundColor: bg,
      textColor: text,
    );
  }

  factory StatusBadge.forDealer(DealerStatus status) {
    Color bg;
    Color text;
    String textLabel = status.name.toUpperCase();

    switch (status) {
      case DealerStatus.approved:
        bg = Colors.green.shade50;
        text = Colors.green.shade700;
        break;
      case DealerStatus.pending:
        bg = Colors.amber.shade50;
        text = Colors.amber.shade800;
        textLabel = 'PENDING APPROVAL';
        break;
      case DealerStatus.rejected:
        bg = Colors.red.shade50;
        text = Colors.red.shade700;
        break;
      case DealerStatus.none:
      default:
        bg = Colors.grey.shade100;
        text = Colors.grey.shade700;
        break;
    }

    return StatusBadge(
      label: textLabel,
      backgroundColor: bg,
      textColor: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withOpacity(0.2), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
