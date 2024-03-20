Create database E_commerce;
Use E_commerce;

-- INSERTING TABLES
select * from olist_customers_dataset;
select * from olist_order_items_dataset;
select * from olist_order_payments_dataset;
select * from olist_order_reviews_dataset;
select * from olist_orders_dataset;
select * from olist_products_dataset;


-- 1). WEEKDAY VS WEEKEND PAYMENT STATISTICS:

SELECT `Day type`, ROUND(SUM(Payment_value), 0) AS Total_Payment
FROM olist_orders_dataset
INNER JOIN olist_order_payments_dataset ON olist_orders_dataset.order_id = olist_order_payments_dataset.order_id
GROUP BY `Day type`;

-- Here we calculate Payment_Percentage
SELECT 
    `Day type`, 
    concat(round(SUM(Payment_value) / (SELECT SUM(Payment_value) FROM olist_order_payments_dataset) * 100, 0),"%") AS Payment_percentage
FROM 
    olist_orders_dataset
INNER JOIN 
    olist_order_payments_dataset ON olist_orders_dataset.order_id = olist_order_payments_dataset.order_id
GROUP BY 
    `Day type`;
    
  
-- 2).Number of Orders with review score 5 and payment type as credit card

SELECT 
    COUNT(olist_order_payments_dataset.order_id) AS Order_Count
FROM 
    olist_order_payments_dataset 
INNER JOIN 
    olist_order_reviews_dataset ON olist_order_payments_dataset.order_id = olist_order_reviews_dataset.order_id
WHERE 
    olist_order_reviews_dataset.Review_score = 5
    AND olist_order_payments_dataset.Payment_type = 'credit_card';


-- 3) Average number of days taken for order_delivered_customer_date for pet_shop

Select Round(avg(`no.of days`),0) as Average_days from olist_orders_dataset
Inner join 
        olist_order_items_dataset ON olist_orders_dataset.order_id = olist_order_items_dataset.order_id
Inner Join 
		olist_Products_dataset ON  olist_order_items_dataset.product_id = olist_Products_dataset.product_id
Where product_category_name="pet_shop" ;
        

-- 4) Average price and payment values from customers of sao paulo city

SELECT 
    ROUND(AVG(order_items.price), 0) AS Average_Price,
    ROUND(AVG(order_payments.payment_value), 0) AS Average_Payment_Value
FROM 
    olist_orders_dataset AS orders
JOIN 
    olist_order_items_dataset AS order_items ON orders.order_id = order_items.order_id
JOIN 
    olist_order_payments_dataset AS order_payments ON orders.order_id = order_payments.order_id
JOIN 
    olist_customers_dataset AS customers ON orders.customer_id = customers.customer_id
WHERE 
    customers.customer_city = 'São Paulo';


-- 5) Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

SELECT `No.of days`,review_score
FROM 
    olist_order_reviews_dataset 
Inner Join 
    Olist_orders_dataset ON olist_order_reviews_dataset.order_id =  Olist_orders_dataset.order_id ;


SELECT * FROM e_commerce.olist_order_payments_dataset;
SELECT * FROM e_commerce.olist_orders_dataset;


-- 6) year wise payment values
select round(sum(payment_value),0)  as payment_value, year(order_purchase_timestamp ), `Day type` from Olist_orders_dataset
inner join Olist_order_payments_dataset ON Olist_order_payments_dataset.order_id =  Olist_orders_dataset.order_id 
group by `day type`,
year(order_purchase_timestamp) 
order by payment_value asc;


-- 7) Top 5 state orders 
select seller_state , count(seller_id) as Total_seller from olist_sellers_dataset
group by seller_state
order by total_seller desc
limit 5 ;

-- 8) Bottom 5 state orders
select seller_state , count(seller_id) as Total_seller from olist_sellers_dataset
group by seller_state
order by total_seller asc
limit 5 ;

