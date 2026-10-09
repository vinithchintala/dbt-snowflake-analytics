{% docs int_order_enriched %}
One row per order, enriched with customer attributes and line-item aggregates.

This is the project's "silver" layer: every mart reads from here instead of
re-joining raw staging tables, so join logic and column definitions stay
consistent across all downstream models. Business rules about *which* orders
count (e.g. fulfilled vs. cancelled) are deliberately left to the marts.
{% enddocs %}

{% docs mart_customer_lifetime_value %}
Customer 360 / lifetime-value summary. Grain: **one row per customer**.

Includes only fulfilled orders (`completed`, `shipped`) — pending, cancelled
and returned orders never contribute to revenue metrics. `days_since_last_order`
is computed against `current_date`, so it is always relative to "today".
{% enddocs %}

{% docs mart_daily_revenue %}
Daily revenue trend table for dashboards. Grain: **one row per calendar date**.

Counts fulfilled orders only (`completed`, `shipped`). Dates with no fulfilled
orders do not appear as rows — join to a date spine if you need zero-filled
series in BI.
{% enddocs %}

{% docs mart_product_performance %}
Product-level sales and margin summary. Grain: **one row per product**.

`gross_margin` uses the product's `unit_cost` from the catalog, so it reflects
merchandising margin before shipping, taxes and overhead. Products with no
fulfilled sales still appear (left join) with NULL metrics — filter or coalesce
downstream as needed.
{% enddocs %}
