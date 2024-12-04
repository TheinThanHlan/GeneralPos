--Serving table
insert into
    ServingTable (name)
values
    ("က"),
    ("ခ"),
    ("ဂ"),
    ("င"),
    ("စ"),
    ("ဆ"),
    ("ဇ"),
    ("ဈ"),
    ("ည"),
    ("1"),
    ("2"),
    ("3"),
    ("4"),
    ("5"),
    ("6");

--#-#
-- prepare for productPropertyName
insert into
    ProductPropertyName (id, name)
values
    (1, "size"),
    (2, "ပါဝင်ပစ္စည်း");

--#-#
-- insert Voucher Status
insert into
    OrderStatus (id, name)
values
    (1, "မှာထားသည်"),
    (2, "ချက်နေသည်"),
    (3, "ချက်ပြီး"),
    (4, "မှာရန်"),
    (5, "ပို့ပြီး"),
    (6, "ငွေရှင်းပြီး");

--#-#
-- insert Voucher Status
insert into
    VoucherStatus (id, name)
values
    (1, "Open"),
    (2, "Waiting"),
    (3, "Closed");

--#-#
-- insert Voucher Type
insert into
    VoucherType (id, name)
values
    (1, "ရောင်း"),
    (2, "ဝယ်");

--#-#
-- add trigger into voucher
create Trigger autoAddVoucherCloseDate After
UPDATE OF status on Voucher FOR EACH ROW WHEN NEW.status = 3 BEGIN
update 'Voucher'
SET
    closedTime = (datetime ('now', 'localtime'))
where
    id = NEW.id;

update 'Voucher'
SET
    totalPrice = IfNull (
        (
            select
                SUM(o.qty * pp.price)
            from
                'Order' o
                inner join 'Inventory' i on o.item = i.id
                inner join 'ProductPrice' pp on pp.id = i.currentPrice
            where
                o.voucher = New.id
            Group By
                o.voucher
        ),
        0
    )
where
    id = NEW.id;

END;

--#-#
-- Prepare datafor ProductCategory
insert into
    'ProductCategory' ('id', 'name')
values
    (1, "အိမ်ဆောက်ပစ္စည်း"),
    (2, "ရေပိုက်"),
    (3, "လျှပ်စစ်ပစ္စည်း");

--#-#
