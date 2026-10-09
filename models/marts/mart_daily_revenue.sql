{#
  Mart: daily revenue summary for trend reporting.
  Only fulfilled orders (completed / shipped) are counted.
  Grain: one row per calendar date.
 #}
select
    order_date,
    count(*) as total_orders,
    sum(total_units) as units_sold,
    count(distinct customer_id) as unique_customers,
    round(sum(order_total), 2) as gross_revenue,
    round(sum(order_total) / nullif(count(*), 0), 2) as avg_order_value
from {{ ref('int_order_enriched') }}
where status in ('completed', 'shipped')
group by 1
order by 1
