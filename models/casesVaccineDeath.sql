{% set currentISO = var('currentISO', None) %}
{% set currentYear = var('currentYear', None) %}

with final_view as (
select location, curYear, max(curMonth) as current_month, 
	max(max_total_cases) as total_cases,
    max(max_total_deaths) as total_deaths,
    max(max_total_tests) as total_tests,
    max(max_vaccinations) as total_vaccines
    from
    
    (
select location,
date_part('year',date) as curYear,
date_part('month', date) as curMonth,
max(total_cases) as max_total_cases, 
max(total_deaths) as max_total_deaths,
max(total_tests) as max_total_tests,
max(total_vaccinations) as max_vaccinations
	from covid_data
where 
(
    {% if currentISO is not none %} iso_code = '{{currentISO}}' {%else%} 1=1 {%endif%}
) and 
(
    {% if currentYear is not none %} date_part('year',date) = {{currentYear}} {%else%} 1=1 {%endif%}
)
	group by 
	location,
date_part('year',date) ,
date_part('month', date)
	) subquery
	group by 
	location, curYear
)

select location, 
curYear,
total_cases,
total_deaths,
total_vaccines
from final_view
order by curYear, location