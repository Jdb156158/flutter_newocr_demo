class OcrExcelEntity {
  int log_id;
  int ret_code;
  String result_data;
  String error_msg;

  OcrExcelEntity({this.log_id, this.ret_code, this.result_data, this.error_msg});

  OcrExcelEntity.fromJson(Map<String, dynamic> json) {
    log_id = json['log_id'];
    error_msg = json['error_msg'];
    ret_code = json['result']['ret_code'];
    result_data = json['result']['result_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['log_id'] = this.log_id;
    data['ret_code'] = this.ret_code;
    data['result_data'] = this.result_data;
    data['error_msg'] = this.error_msg;
    return data;
  }
}