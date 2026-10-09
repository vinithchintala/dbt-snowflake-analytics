{#
  Intermediate: one row per order, enriched with customer attributes and
  line-item aggregates. This is the shared "silver" building block that all
  marts read from, so business logic (e.g. what counts as a fulfilled order)
  lives in the marts, not here.
  Grain: one row per order.
 #}
with orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

line_item_aggs as (
    select
        order_id,
        count(*) as line_item_count,
        sum(quantity) as total_units,
        sum(line_total) as items_total
    from {{ ref('stg_order_items') }}
    group by 1
)

select
    o.order_id,
    o.order_date,
    date_trunc('month', o.order_date) as order_month,
    extract(year from o.order_date) as order_year,
    o.status,
    o.customer_id,
    c.full_name as customer_name,
    c.email as customer_email,
    c.country as customer_country,
    c.signup_date as customer_signup_date,
    coalesce(l.line_item_count, 0) as line_item_count,
    coalesce(l.total_units, 0) as total_units,
    o.order_total
from orders as o
left join customers as c
    on o.customer_id = c.customer_id
left join line_item_aggs as l
    on o.order_id = l.order_id
