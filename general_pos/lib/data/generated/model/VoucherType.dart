import '../../all.dart';
class VoucherType implements IMVCModel{ 
	int? id=0;
	late String name;
	List<Voucher>? ListOfVoucher_mappedBy_type;
	VoucherType({ this.id,required this.name, this.ListOfVoucher_mappedBy_type});
	Map<String, dynamic> toJson() => {"id":id,"name":name,"ListOfVoucher_mappedBy_type":ListOfVoucher_mappedBy_type};
	Map<String, dynamic> toJsonWithoutDbAuto() => {"name":name};
	VoucherType.fromJson(Map<String,dynamic> data): id=data["id"],name=data["name"],ListOfVoucher_mappedBy_type=data["ListOfVoucher_mappedBy_type"];

	VoucherType clone(){return VoucherType.fromJson(this.toJson());}
}
