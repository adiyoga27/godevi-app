class VillageModel {
  String? villageName;
  String? villageAddress;
  String? contactPerson;
  String? desc;
  String? lat;
  String? lng;
  String? thumbnail;
  String? defaultImg;
  String? bankName;
  String? bankAccName;
  String? bankAccNo;

  VillageModel({
    this.villageName,
    this.villageAddress,
    this.contactPerson,
    this.desc,
    this.lat,
    this.lng,
    this.thumbnail,
    this.defaultImg,
    this.bankName,
    this.bankAccName,
    this.bankAccNo,
  });

  VillageModel.fromJson(Map<String, dynamic> json) {
    villageName = json['village_name'];
    villageAddress = json['village_address'];
    contactPerson = json['contact_person'];
    desc = json['desc'];
    lat = json['lat'];
    lng = json['lng'];
    thumbnail = json['thumbnail'];
    // Handle key with space "defaultImg "
    defaultImg = json['defaultImg '] ?? json['defaultImg'];
    bankName = json['bank_name'];
    bankAccName = json['bank_acc_name'];
    bankAccNo = json['bank_acc_no'];
  }
}

class VillageResponse {
  List<VillageModel>? data;
  Pagination? pagination;
  bool? status;
  String? messages;

  VillageResponse({this.data, this.pagination, this.status, this.messages});

  VillageResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <VillageModel>[];
      json['data'].forEach((v) {
        data!.add(VillageModel.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    status = json['status'];
    messages = json['messages'];
  }
}

class Pagination {
  String? path;
  String? firstPageUrl;
  String? prevPageUrl;
  String? nextPageUrl;
  String? lastPageUrl;
  int? total;
  int? count;
  int? perPage;
  int? currentPage;
  int? totalPages;

  Pagination({
    this.path,
    this.firstPageUrl,
    this.prevPageUrl,
    this.nextPageUrl,
    this.lastPageUrl,
    this.total,
    this.count,
    this.perPage,
    this.currentPage,
    this.totalPages,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    firstPageUrl = json['first_page_url'];
    prevPageUrl = json['prev_page_url'];
    nextPageUrl = json['next_page_url'];
    lastPageUrl = json['last_page_url'];
    total = json['total'];
    count = json['count'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
  }
}
