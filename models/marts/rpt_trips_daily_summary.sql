with trips as (
    select * from {{ ref('fct_trips') }}
),

locations as (
    select * from {{ ref('dim_location') }}
),

final as (
    select
        trips.pickup_date,
        locations.borough as pickup_borough,
        trips.payment_type_desc,

        count(*) as trip_count,
        sum(trips.total_amount) as total_revenue,
        avg(trips.fare_amount) as avg_fare,
        avg(trips.trip_duration_minutes) as avg_duration_minutes,
        avg(trips.trip_distance) as avg_distance
    from trips
    left join locations
        on trips.pickup_location_id = locations.location_id
    group by trips.pickup_date, locations.borough, trips.payment_type_desc
)

select * from final