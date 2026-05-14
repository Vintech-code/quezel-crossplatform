class OrderStatus {
  static const pending = "pending";
  static const accepted = "accepted";
  static const preparing = "preparing";
  static const outForDelivery = "out_for_delivery";
  static const delivered = "delivered";
  static const cancelled = "cancelled";
  static const refundRequested = "refund_requested";
  static const refundApproved = "refund_approved";
  static const refundRejected = "refund_rejected";

  static const activeStatuses = [pending, accepted, preparing, outForDelivery];
  static const refundStatuses = [
    refundRequested,
    refundApproved,
    refundRejected,
  ];

  static String label(String status) {
    switch (normalize(status)) {
      case pending:
        return "Pending";
      case accepted:
        return "Accepted";
      case preparing:
        return "Preparing";
      case outForDelivery:
        return "Out for Delivery";
      case delivered:
        return "Delivered";
      case cancelled:
        return "Cancelled";
      case refundRequested:
        return "Refund Requested";
      case refundApproved:
        return "Refund Approved";
      case refundRejected:
        return "Refund Rejected";
      default:
        return status;
    }
  }

  static String normalize(String status) {
    switch (status) {
      case "Pending":
        return pending;
      case "Accepted":
        return accepted;
      case "Preparing":
        return preparing;
      case "Completed":
      case "Delivered":
        return delivered;
      case "Out for delivery":
      case "Out For Delivery":
      case "Out for Delivery":
        return outForDelivery;
      case "Cancelled":
        return cancelled;
      case "Refund":
      case "Refund Requested":
        return refundRequested;
      case "Refund Approved":
        return refundApproved;
      case "Refund Rejected":
        return refundRejected;
      default:
        return status;
    }
  }
}
