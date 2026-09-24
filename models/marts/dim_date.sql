with date_spine as (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2020-01-01' as date)",
        end_date="cast('2020-12-31' as date)"
    ) }}

),

final as (

    select
        cast(date_day as date) as date_day,
        extract(year from date_day) as year,
        extract(month from date_day) as month,
        extract(day from date_day) as day,
        extract(dayofweek from date_day) as day_of_week,
        format_date('%A', date_day) as day_name,
        format_date('%B', date_day) as month_name,
        extract(quarter from date_day) as quarter,
        case when extract(dayofweek from date_day) in (1, 7) then true else false end as is_weekend

    from date_spine

)

select * from final