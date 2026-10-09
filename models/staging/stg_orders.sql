{#
  Staging: order headers.
  Grain: one row per order.
 #}
select
    cast(order_id as integer) as order_id,
    cast(customer_id as integer) as customer_id,
    cast(order_date as date) as order_date,
    lower(status) as status,
    cast(order_total as decimal(12, 2)) as order_total
from {{ source('ecommerce', 'raw_orders') }}
