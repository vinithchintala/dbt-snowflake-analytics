{#
  Mart: product performance with gross margin.
  Only line items from fulfilled orders (completed / shipped) are counted.
  Grain: one row per product.
 #}
with fulfilled_items as (
    select i.*
    from {{ ref('stg_order_items') }} as i
    inner join {{ ref('stg_orders') }} as o
        on i.order_id = o.order_id
    where o.status in ('completed', 'shipped')
)

select
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price as current_list_price,
    count(distinct f.order_id) as distinct_orders,
    sum(f.quantity) as units_sold,
    round(sum(f.line_total), 2) as gross_revenue,
    round(sum(f.quantity * p.unit_cost), 2) as total_cost,
    round(sum(f.line_total) - sum(f.quantity * p.unit_cost), 2) as gross_margin,
    round(
        (sum(f.line_total) - sum(f.quantity * p.unit_cost))
        / nullif(sum(f.line_total), 0), 4
    ) as gross_margin_pct
from {{ ref('stg_products') }} as p
left join fulfilled_items as f
    on p.product_id = f.product_id
group by 1, 2, 3, 4
