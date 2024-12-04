import '../../all.dart';
class Voucher implements IMVCModel{ 
	int? id=0;
	String? name;
	ServingTable? table;
	Customer? customer;
	double totalPrice=0.0;
	double discount=0.0;
	Address? deliveryAddress;
	DateTime? openedTime;
	DateTime? closedTime;
	late VoucherStatus status;
	late VoucherType type;
	List<Order>? ListOfOrder_mappedBy_voucher;
	Voucher({ this.id, this.name, this.table, this.customer,required this.totalPrice,required this.discount, this.deliveryAddress, this.openedTime, this.closedTime,required this.status,required this.type, this.ListOfOrder_mappedBy_voucher});
	Map<String, dynamic> toJson() => {"id":id,"name":name,"table":table,"customer":customer,"totalPrice":totalPrice,"discount":discount,"deliveryAddress":deliveryAddress,"openedTime":openedTime,"closedTime":closedTime,"status":status,"type":type,"ListOfOrder_mappedBy_voucher":ListOfOrder_mappedBy_voucher};
	Map<String, dynamic> toJsonWithoutDbAuto() => {"closedTime":closedTime};
	Voucher.fromJson(Map<String,dynamic> data): id=data["id"],name=data["name"],table=data["table"],customer=data["customer"],totalPrice=data["totalPrice"],discount=data["discount"],deliveryAddress=data["deliveryAddress"],openedTime=DateTime.parse(data["openedTime"]),closedTime=DateTime.parse(data["closedTime"]),status=data["status"],type=data["type"],ListOfOrder_mappedBy_voucher=data["ListOfOrder_mappedBy_voucher"];

	Voucher clone(){return Voucher.fromJson(this.toJson());}
}
