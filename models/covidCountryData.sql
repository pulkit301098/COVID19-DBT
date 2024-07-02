{% set yearSelect = var('yearSelect', None) %}
{% set selectISO = var('selectISO', None) %}

select location, 
date_part('year',date) as year,
CASE 
        WHEN EXTRACT(MONTH FROM date) = 1 THEN 'Jan'
        WHEN EXTRACT(MONTH FROM date) = 2 THEN 'Feb'
        WHEN EXTRACT(MONTH FROM date) = 3 THEN 'Mar'
        WHEN EXTRACT(MONTH FROM date) = 4 THEN 'Apr'
        WHEN EXTRACT(MONTH FROM date) = 5 THEN 'May'
        WHEN EXTRACT(MONTH FROM date) = 6 THEN 'Jun'
        WHEN EXTRACT(MONTH FROM date) = 7 THEN 'Jul'
        WHEN EXTRACT(MONTH FROM date) = 8 THEN 'Aug'
        WHEN EXTRACT(MONTH FROM date) = 9 THEN 'Sep'
        WHEN EXTRACT(MONTH FROM date) = 10 THEN 'Oct'
        WHEN EXTRACT(MONTH FROM date) = 11 THEN 'Nov'
        WHEN EXTRACT(MONTH FROM date) = 12 THEN 'Dec'
        ELSE 'Unknown' end as month_name,
sum(total_cases) as total_cases,
sum(total_deaths) as total_deaths, 
(sum(total_deaths)/sum(total_cases)*100) as total_death_percentage
from covid_data
where 
(
    ({% if yearSelect is not none%} date_part('year', date) = {{yearSelect}} {%else%} 1=1 {%endif%})
) AND
(
    ({% if selectISO is not none %} lower(iso_code) = lower('{{selectISO}}') {%else%} 1=1 {%endif%})
)
group by 
location, 
date_part('year',date), EXTRACT(MONTH FROM date)