{#
  Staging: product catalog.
  Grain: one row per product.
 #}
select
    cast(product_id as integer) as product_id,
    product_name,
    category,
    cast(unit_price as decimal(12, 2)) as unit_price,
    cast(unit_cost as decimal(12, 2)) as unit_cost
from {{ source('ecommerce', 'raw_products') }}
