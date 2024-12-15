import 'package:sqflite/sqflite.dart';
import '../all.dart';

class ProductPropertyDao extends ProductPropertyGeneratedDao {
  Future<List<ProductProperty>> readFromInventoryId(int id) async {
    String sql = """
      select p.id     as pId,
             p.value  as pValue,
             pn.id    as pnId,
             pn.name  as pnName
             from '#_#_#Inventory_ProductProperty' as i
             inner join ProductProperty as p on i.'productPropertyId'=p.id
             inner join ProductPropertyName as pn on p.productPropertyName=pn.id
             where i.inventoryId=$id order by pnName desc
    """;
    List tmp = await db.rawQuery(sql);
    List<ProductProperty> output = tmp.map((a) {
      return ProductProperty(
          id: a['pId'],
          value: a['pValue'],
          productPropertyName:
              ProductPropertyName(id: a['pnId'], name: a['pnName']));
    }).toList();
    return output;
  }

  Future<List<ProductProperty>> readFromPropertyName_value_like(
      ProductPropertyName name, String value) async {
    String sql = """
      select p.id     as pId,
             p.value  as pValue
             from 'ProductProperty' as p
             where p.productPropertyName=${name.id}
    """;
    List tmp = await db.rawQuery(sql);
    List<ProductProperty> output = tmp.map((a) {
      return ProductProperty(
          id: a['pId'], value: a['pValue'], productPropertyName: name);
    }).toList();
    return output;
  }

  Future<int> insert(ProductProperty data) {
    return this.db.insert("ProductProperty", {
      'value': data.value,
      'productPropertyName': data.productPropertyName.id
    });
  }

  Future<List<ProductProperty>> readFromProductPropertyName(
      ProductPropertyName name) async {
    List tmp = await db.query("ProductProperty",
        where: " productPropertyName=${name.id}");
    return tmp.map((a) {
      return ProductProperty(
          id: a['id'], productPropertyName: name, value: a["value"]);
    }).toList();
  }

  Future<List<ProductProperty>> readFromProductTemplateId(int id) async {
    String sql = """
    select p.id     as pId,
           p.value  as pValue,
           pn.id    as pnId,
           pn.name  as pnName
           from '#_#_#Inventory_ProductProperty' as ip
           inner join ProductProperty as p on ip.'productPropertyId'=p.id
           inner join ProductPropertyName as pn on p.productPropertyName=pn.id
           inner join Inventory as i on i.id=ip.id
    """;
    List tmp = await db.rawQuery(sql);
    List<ProductProperty> output = tmp.map((a) {
      return ProductProperty(
          id: a['pId'], value: a['pValue'], productPropertyName: a['pnName']);
    }).toList();
    return output;
  }
}
