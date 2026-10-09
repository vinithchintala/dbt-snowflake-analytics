{#
  Singular test: every product must have a non-negative list price and cost.
  Fails if any violating rows are returned.
 #}
select
    product_id,
    product_name,
    unit_price,
    unit_cost
from {{ ref('stg_products') }}
where unit_price < 0 or unit_cost < 0
