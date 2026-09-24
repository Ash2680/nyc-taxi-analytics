with zones as (
    select * from {{ ref('taxi_zone_lookup') }}
),

final as (
    select
        LocationID as location_id,
        Borough as borough,
        Zone as zone,
        service_zone
    from zones
)

select * from final