{#
  Staging: order line items.
  line_total is the source-of-truth extended amount for the line
  (quantity x unit_price, net of discount).
  Grain: one row per order line item.
 #}
select
    cast(order_item_id as integer) as order_item_id,
    cast(order_id as integer) as order_id,
    cast(product_id as integer) as product_id,
    cast(quantity as integer) as quantity,
    cast(unit_price as decimal(12, 2)) as unit_price,
    cast(discount_pct as integer) as discount_pct,
    cast(line_total as decimal(12, 2)) as line_total
from {{ source('ecommerce', 'raw_order_items') }}
