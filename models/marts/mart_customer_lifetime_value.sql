{#
  Mart: customer lifetime value.
  Only fulfilled orders (completed / shipped) contribute to revenue metrics.
  Grain: one row per customer.
 #}
with fulfilled_orders as (
    select * from {{ ref('int_order_enriched') }}
    where status in ('completed', 'shipped')
)

select
    customer_id,
    max(customer_name) as customer_name,
    max(customer_email) as customer_email,
    max(customer_country) as customer_country,
    min(order_date) as first_order_date,
    max(order_date) as last_order_date,
    count(*) as total_orders,
    sum(total_units) as total_units_purchased,
    round(sum(order_total), 2) as total_revenue,
    round(sum(order_total) / nullif(count(*), 0), 2) as avg_order_value,
    date_diff('day', max(order_date), current_date) as days_since_last_order
from fulfilled_orders
group by 1
