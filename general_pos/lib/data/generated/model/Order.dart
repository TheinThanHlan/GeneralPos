import '../../all.dart';
class Order implements IMVCModel{ 
	int? id=0;
	late Voucher voucher;
	late OrderStatus orderStatus;
	Address? deliveryAddress;
	DateTime? orderDateTime;
	late Inventory item;
	late int qty;
	double? buyPrice;
	Order({ this.id,required this.voucher,required this.orderStatus, this.deliveryAddress, this.orderDateTime,required this.item,required this.qty, this.buyPrice});
	Map<String, dynamic> toJson() => {"id":id,"voucher":voucher,"orderStatus":orderStatus,"deliveryAddress":deliveryAddress,"orderDateTime":orderDateTime,"item":item,"qty":qty,"buyPrice":buyPrice};
	Map<String, dynamic> toJsonWithoutDbAuto() => {"qty":qty,"buyPrice":buyPrice};
	Order.fromJson(Map<String,dynamic> data): id=data["id"],voucher=data["voucher"],orderStatus=data["orderStatus"],deliveryAddress=data["deliveryAddress"],orderDateTime=DateTime.parse(data["orderDateTime"]),item=data["item"],qty=data["qty"],buyPrice=data["buyPrice"];

	Order clone(){return Order.fromJson(this.toJson());}
}
