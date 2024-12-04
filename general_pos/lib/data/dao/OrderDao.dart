import 'package:sqflite/sqflite.dart';
import '../all.dart';

class OrderDao extends OrderGeneratedDao {
  Future<int> insert(Order data) {
    return this.db.insert("Order", {
      'voucher': data.voucher.id,
      //'orderStatus': 1,
      'item': data.item.id,
      'qty': data.qty
    });
  }

  Future<Map<int, Order>> readOrdersWith_voucher_searchWith_productTemplateName(
      Voucher voucher, String productTemplateName) async {
    String sql = """
      Select * from
      (Select
        o.id oId,
        o.orderDateTime oDt,
        SUM(o.qty) oQty,
        i.id iId,
        pp.price ppPrice,
        pt.name ptName,
        'os'.name osName,
       'os'.id osId

        from 'Order' o
        inner join 'Inventory' i on o.item=i.id
        inner join 'ProductPrice' pp on pp.id=i.currentPrice
        inner join 'ProductTemplate' pt on i.productTemplate=pt.id
        left join '#_#_#Order_OrderStatus' oos on oos.orderId=o.id
        left join 'OrderStatus' 'os' on os.id=oos.orderStatusId
        where o.voucher=${voucher.id}
        GROUP BY i.id) where oQty>0
        """;
    List tmp = await db.rawQuery(sql);
    Map<int, Order> output = {};
    for (var a in tmp) {
      output[a["oId"]] = Order(
        id: a["oId"],
        orderDateTime: DateTime.parse(a['oDt']),
        orderStatus: OrderStatus(id: a['osId'], name: a['osName'] ?? ""),
        //orderStatus: OrderStatus(id: 0, name: 'osName'),
        qty: a["oQty"],
        voucher: voucher,
        item: Inventory(
          id: a["iId"],
          currentPrice: ProductPrice(price: a["ppPrice"]),
          qty: 0,
          productTemplate: ProductTemplate(name: a["ptName"]),
          productProperties:
              await getIt<ProductPropertyDao>().readFromInventoryId(a['iId']),
        ),
      );
    }
    return output;
  }
}
