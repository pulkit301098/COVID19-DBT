{% set high_threshold = var('high_threshold',1000000) %}
{% set selectYear = var('selectYear', None) %}

with highDeaths as (select location, 
date_part('year',date) as current_year,
sum(total_deaths) as yearly_deaths
from covid_data
where
(
    {% if selectYear is not none %} date_part('year',date) = {{selectYear}} {% else %} 1=1 {%endif%} 
)
group by 
date_part('year',date),
location
having sum(total_deaths) >= {{high_threshold}}
)

select * from highDeaths
where location is not null
order by yearly_deaths