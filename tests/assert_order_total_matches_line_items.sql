{#
  Singular test: the recorded order_total on every order header must equal
  the sum of its line-item amounts (tolerance: 1 cent for rounding).
  Fails if any violating rows are returned.
 #}
with line_item_totals as (
    select
        order_id,
        sum(line_total) as calculated_total
    from {{ ref('stg_order_items') }}
    group by 1
)

select
    o.order_id,
    o.order_total as recorded_total,
    l.calculated_total
from {{ ref('stg_orders') }} as o
inner join line_item_totals as l
    on o.order_id = l.order_id
where abs(o.order_total - l.calculated_total) > 0.01
