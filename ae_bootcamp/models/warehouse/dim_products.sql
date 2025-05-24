with source as(
    select
    p.id as product_id,
    p.product_code,
    p.product_name,
    p.description,
    s.company as supplier_company,
    p.standard_cost,
    p.list_price,
    p.reorder_level,
    p.target_level,
    p.quantity_per_unit,
    p.discontinued,
    s.minimum_reorder_quantity,
    s.category,
    s.attachments,
    current_timestamp() as insertion_timestamp
    from {{ ref('stg_products') }} p
    left join {{ ref('stg_suppliers') }} s
    on s.id = p.supplier_id
),
unique_source as(
    select
    *,
    row_number() over (partition by product_id) as rn
    from source
)
select
*
except (rn),
from unique_source
where rn = 1
order by 1