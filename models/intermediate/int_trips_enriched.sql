with trips as (
    select * from {{ ref('stg_taxi_yellow_trips') }}
),

zones as (
    select * from {{ ref('taxi_zone_lookup') }}
),

payment_types as (
    select * from {{ ref('payment_type_lookup') }}
),

enriched as (
    select
        trips.vendor_id,
        trips.pickup_datetime,
        trips.dropoff_datetime,
        trips.passenger_count,
        trips.trip_distance,
        trips.rate_code,
        trips.store_and_fwd_flag,
        trips.pickup_location_id,
        trips.dropoff_location_id,
        trips.payment_type,
        payment_types.payment_type_desc,
        pickup_zone.Borough as pickup_borough,
        pickup_zone.Zone as pickup_zone,
        dropoff_zone.Borough as dropoff_borough,
        dropoff_zone.Zone as dropoff_zone,
        trips.fare_amount,
        trips.extra,
        trips.mta_tax,
        trips.tip_amount,
        trips.tolls_amount,
        trips.improvement_surcharge,
        trips.airport_fee,
        trips.total_amount,
        timestamp_diff(trips.dropoff_datetime, trips.pickup_datetime, minute) as trip_duration_minutes,
        extract(hour from trips.pickup_datetime) as pickup_hour,
        extract(dayofweek from trips.pickup_datetime) as pickup_day_of_week
    from trips
    left join zones as pickup_zone
        on trips.pickup_location_id = pickup_zone.LocationID
    left join zones as dropoff_zone
        on trips.dropoff_location_id = dropoff_zone.LocationID
    left join payment_types
        on cast(trips.payment_type as int64) = payment_types.payment_type_id
    where trips.pickup_datetime >= '2020-01-01'
      and trips.pickup_datetime < '2020-04-01'
)

select * from enriched