class OcrExcelEntity {
  int log_id;
  int ret_code;
  String result_data;

  OcrExcelEntity({this.log_id, this.ret_code, this.result_data});

  OcrExcelEntity.fromJson(Map<String, dynamic> json) {
    log_id = json['log_id'];
    ret_code = json['result']['ret_code'];
    result_data = json['result']['result_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['log_id'] = this.log_id;
    data['ret_code'] = this.ret_code;
    data['result_data'] = this.result_data;
    return data;
  }
}