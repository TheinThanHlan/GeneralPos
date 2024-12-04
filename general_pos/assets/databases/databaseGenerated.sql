CREATE TABLE 'Order'(
'id' INTEGER not null primary key      ,
'voucher' INTEGER not null REFERENCES 'Voucher'('id')     ,
'deliveryAddress' INTEGER  REFERENCES 'Address'('id')     ,
'orderDateTime' Text not null  Default   (datetime('now','localtime'))  ,
'item' INTEGER not null REFERENCES 'Inventory'('id')     ,
'qty' INTEGER not null  Default   0  ,
'totalBuyPrice' REAL       
);
--#-#
CREATE TABLE 'ProductPropertyName'(
'id' INTEGER not null primary key      ,
'name' Text not null unique  Default   ""  
);
--#-#
CREATE TABLE 'Employee'(
'id' INTEGER not null primary key      ,
'user' INTEGER not null REFERENCES 'User'('id')     ,
UNIQUE( 'user' )
);
--#-#
CREATE TABLE 'ProductTemplate'(
'id' INTEGER not null primary key      ,
'name' Text not null unique  Default   ""  ,
'description' Text       ,
'Customer_mappedBy_savedProducts' INTEGER  REFERENCES 'Customer'('id')     
);
--#-#
CREATE TABLE 'VoucherStatus'(
'id' INTEGER not null primary key      ,
'name' Text not null unique  Default   ""  
);
--#-#
CREATE TABLE 'Color'(
'id' INTEGER not null primary key      ,
'name' Text not null unique  Default   ""  ,
'code' Text not null unique  Default   ""  
);
--#-#
CREATE TABLE 'Shop'(
'id' INTEGER not null primary key      ,
'createdDateTime' Text not null  Default   (datetime('now','localtime'))  ,
'name' Text not null  Default   ""  ,
'user' INTEGER not null REFERENCES 'User'('id')     ,
'type' INTEGER not null REFERENCES 'ShopType'('id')     
);
--#-#
CREATE TABLE 'ProductProvider'(
'id' INTEGER not null primary key      ,
'provider' INTEGER not null REFERENCES 'User'('id')     ,
'ratings' REAL       ,
UNIQUE( 'provider' )
);
--#-#
CREATE TABLE 'ProductCategory'(
'id' INTEGER not null primary key      ,
'name' Text not null unique  Default   ""  ,
'parentProductCategory' INTEGER  REFERENCES 'ProductCategory'('id')     
);
--#-#
CREATE TABLE 'PhoneNumber'(
'id' INTEGER not null primary key      ,
'number' Text not null unique  Default   ""  ,
'User_mappedBy_phones' INTEGER  REFERENCES 'User'('id')     
);
--#-#
CREATE TABLE 'Salary'(
'id' INTEGER not null primary key      ,
'salary' INTEGER not null  Default   0  ,
'dateTime' Text not null  Default   (datetime('now','localtime'))  ,
'employee' INTEGER not null REFERENCES 'Employee'('id')     
);
--#-#
CREATE TABLE 'Address'(
'id' INTEGER not null primary key      ,
'address' Text not null  Default   ""  ,
'latitude' REAL       ,
'longitude' REAL       ,
'User_mappedBy_addresses' INTEGER  REFERENCES 'User'('id')     
);
--#-#
CREATE TABLE 'Template'(
'id' INTEGER not null primary key      ,
'createdDateTime' Text not null  Default   (datetime('now','localtime'))  
);
--#-#
CREATE TABLE 'VoucherType'(
'id' INTEGER not null primary key      ,
'name' Text not null unique  Default   ""  
);
--#-#
CREATE TABLE 'Voucher'(
'id' INTEGER not null primary key      ,
'name' Text       ,
'table' INTEGER  REFERENCES 'ServingTable'('id')     ,
'customer' INTEGER  REFERENCES 'Customer'('id')     ,
'totalPrice' REAL not null  Default   0.0  ,
'discount' REAL not null  Default   0.0  ,
'deliveryAddress' INTEGER  REFERENCES 'Address'('id')     ,
'openedTime' Text not null  Default   (datetime('now','localtime'))  ,
'closedTime' Text       ,
'status' INTEGER not null REFERENCES 'VoucherStatus'('id')     ,
'type' INTEGER not null REFERENCES 'VoucherType'('id')     ,
Constraint name_or_table_can_null Check('name' is not null or 'table' is not null)
);
--#-#
CREATE TABLE 'Inventory'(
'id' INTEGER not null primary key      ,
'productTemplate' INTEGER not null REFERENCES 'ProductTemplate'('id')     ,
'qty' INTEGER not null  Default   0  ,
'SKU' Text unique      ,
'UPC' Text unique      ,
'currentPrice' INTEGER  REFERENCES 'ProductPrice'('id')     ,
UNIQUE( 'currentPrice' )
);
--#-#
CREATE TABLE 'DeliveryMethod'(
'id' INTEGER not null primary key      ,
'name' REAL not null unique  Default   0.0  
);
--#-#
CREATE TABLE 'ProductProperty'(
'id' INTEGER not null primary key      ,
'productPropertyName' INTEGER not null REFERENCES 'ProductPropertyName'('id')     ,
'value' Text not null  Default   ""  ,
UNIQUE( 'productPropertyName','value' )
);
--#-#
CREATE TABLE 'ProductPrice'(
'id' INTEGER not null primary key      ,
'createdDateTime' Text not null  Default   (datetime('now','localtime'))  ,
'price' INTEGER not null  Default   0  ,
'Inventory_mappedBy_prices' INTEGER  REFERENCES 'Inventory'('id')     
);
--#-#
CREATE TABLE 'User'(
'id' INTEGER not null primary key      ,
'name' Text not null  Default   ""  ,
'socialSecurityNumber' Text unique      ,
'driverLicense' Text unique      ,
'email' Text not null unique  Default   ""  
);
--#-#
CREATE TABLE 'Delivery'(
'id' INTEGER not null primary key      ,
'rating' REAL       ,
'deliveryMethod' INTEGER not null REFERENCES 'DeliveryMethod'('id')     
);
--#-#
CREATE TABLE 'OrderStatus'(
'id' INTEGER not null primary key      ,
'name' Text not null unique  Default   ""  
);
--#-#
CREATE TABLE 'ShopType'(
'id' INTEGER not null primary key      ,
'type' Text not null unique  Default   ""  
);
--#-#
CREATE TABLE 'ServingTable'(
'id' INTEGER not null primary key      ,
'name' Text not null unique  Default   ""  
);
--#-#
CREATE TABLE 'Customer'(
'id' INTEGER not null primary key      ,
'user' INTEGER not null unique REFERENCES 'User'('id')     ,
UNIQUE( 'user' )
);
--#-#
CREATE TABLE '#_#_#Order_OrderStatus'(
'orderId' INTEGER not null REFERENCES 'Order'('id')     ,
'orderStatusId' INTEGER not null REFERENCES 'OrderStatus'('id')     ,
UNIQUE( 'orderId','orderStatusId' )
);
--#-#
CREATE TABLE '#_#_#ProductTemplate_ProductCategory'(
'productTemplateId' INTEGER not null REFERENCES 'ProductTemplate'('id')     ,
'productCategoryId' INTEGER not null REFERENCES 'ProductCategory'('id')     ,
UNIQUE( 'productTemplateId','productCategoryId' )
);
--#-#
CREATE TABLE '#_#_#ProductProvider_ProductTemplate'(
'productProviderId' INTEGER not null REFERENCES 'ProductProvider'('id')     ,
'productTemplateId' INTEGER not null REFERENCES 'ProductTemplate'('id')     ,
UNIQUE( 'productProviderId','productTemplateId' )
);
--#-#
CREATE TABLE '#_#_#Inventory_ProductProperty'(
'inventoryId' INTEGER not null REFERENCES 'Inventory'('id')     ,
'productPropertyId' INTEGER not null REFERENCES 'ProductProperty'('id')     ,
UNIQUE( 'inventoryId','productPropertyId' )
);