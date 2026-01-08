class TransactionModel {
  int? id;
  String? uuid;
  String? name; // Title (Event/Package Name)
  String? category; // e.g. "Virtual Tour", "Homestay"
  String? type; // raw type: tour, event, homestay
  String? location;
  int? price;
  int? pax;
  int? total;
  String? status;
  String? image;
  double? rating;
  String? date;

  String? code; // INV Code
  String? customerName;
  String? customerEmail;
  String? customerPhone;
  String? customerAddress;
  String? paymentType;
  String? paymentDate; // keeping as String based on JSON
  String? specialNote;
  String? checkinDate;
  String? snapToken;
  String? linkPayment;

  TransactionModel({
    this.id,
    this.uuid,
    this.code,
    this.name,
    this.category,
    this.type,
    this.location,
    this.price,
    this.pax,
    this.total,
    this.status,
    this.image,
    this.rating,
    this.date,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.customerAddress,
    this.paymentType,
    this.paymentDate,
    this.specialNote,
    this.checkinDate,
    this.snapToken,
    this.linkPayment,
  });

  TransactionModel.fromJson(Map<String, dynamic> json, {String? type}) {
    this.type = type;
    // ID isn't consistently available as integer 'id' in the new JSON, usually 'code' or 'uuid'
    if (json['id'] != null) {
      id = json['id'] is String ? int.tryParse(json['id']) : json['id'];
    }

    uuid = json['uuid'];
    code = json['code'];
    status = json['payment_status'] ?? json['status'];
    date = json['created_at'];

    // Customer Info
    customerName = json['customer_name'];
    customerEmail = json['customer_email'];
    customerPhone = json['customer_phone'];
    customerAddress = json['customer_address'];

    // Payment & Extras
    paymentType = json['payment_type'];
    paymentType = json['payment_type'];
    paymentDate = json['payment_date'];
    specialNote = json['special_note'];
    checkinDate = json['checkin_date'];
    checkinDate = json['checkin_date'];
    snapToken = json['snap_token'];
    linkPayment = json['link_payment'];

    // Handle Price
    dynamic priceVal;

    // Handle Total
    dynamic totalVal = json['total_payment'] ?? json['total'];
    if (totalVal != null) {
      if (totalVal is String) {
        // handle "2000" or "2000.00"
        total = double.tryParse(totalVal)?.toInt();
      } else if (totalVal is num) {
        total = totalVal.toInt();
      }
    }

    if (json['rating'] != null) {
      rating = double.tryParse(json['rating'].toString());
    }

    // Type specific parsing
    if (type == 'tour') {
      name = json['package_name'] ?? json['name'];
      category = "Tour Package";
      location = json['village_name'] ?? json['location'];
      image = json['thumbnail'];
      priceVal = json['package_price'];

      // Fallback for category name if present
      if (json['category_name'] != null) category = json['category_name'];
    } else if (type == 'event') {
      name = json['event_name'] ?? json['name'];
      category = "Event";
      location =
          json['village_name'] ??
          json['location']; // Event JSON has village_id, but maybe not name directly? JSON shows 'village_name' in tours, not explicitly in event JSON provided?
      // Wait, Event JSON in prompt DOES NOT show 'village_name'. It shows 'customer_address' and 'village_id'.
      // But it has `thumbnail`.
      // Let's use generic location if not found.
      image = json['thumbnail'];
      priceVal = json['event_price'];
    } else if (type == 'homestay') {
      name = json['homestay_name'] ?? json['name'];
      category = "Homestay";
      location = json['village_name'] ?? json['location'];
      image = json['thumbnail'];
      priceVal = json['homestay_price'];
    } else {
      // Generic / Fallback
      name = json['name'] ?? json['title'];
      category = type ?? 'Transaction';
      location = json['location'];
      image = json['image'] ?? json['default_img'] ?? json['thumbnail'];
      priceVal = json['price'];
    }

    // Process Price
    if (priceVal != null) {
      if (priceVal is String) {
        price = double.tryParse(priceVal)?.toInt();
      } else if (priceVal is num) {
        price = priceVal.toInt();
      }
    }

    // Clean up location if null
    if (location == null) {
      // Try parsing from special_note if desperate? No, leave null.
      // Or user customer_address?
      // JSON has 'customer_address'.
      // location = json['customer_address'];
    }
  }
}
