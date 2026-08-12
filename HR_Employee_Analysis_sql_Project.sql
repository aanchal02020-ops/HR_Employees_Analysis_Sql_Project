-- =========================================================
--  HR EMPLOYEE DATA ANAYLSIS PROJECT
-- =========================================================

-- =========================================================
-- SECTION 1: DATABASE SETUP
-- =========================================================

drop table if exists employee_data;

-- 1.1 Creating Employee_performance Table 

create table employee_performance
(
    Serial_No serial primary key,
	employee_id bigint unique,
    name varchar(100),
    department varchar(100),
    job_role varchar(100),
    performance_score integer,
    kpi_score numeric(5,2),
    attendance numeric(5,2),
    peer_rating numeric(3,1),
    task_completion numeric(5,2),
    work_hours_logged numeric(5,2),
    manager_feedback numeric(5,1),
    training_hours integer,
    promotion_eligibility varchar(20)
);

-- 1.2 Importing data into employee_performance table 
-- Update the file path below to point to your local CSV file before running

-- 1.3 Reviewing the table 
select * from employee_performance;

alter table employee_performance
alter column work_hours_logged type int;

-- =========================================================
-- SECTION 2: DATA CLEANING 
-- =========================================================

-- 2.1 Data Cleaning checking duplicate ids
select employee_id, count(*) from employee_performance
group by employee_id
having count(*)>1;

-- 2.2 Checking for NULL values across key columns
select *
from employee_performance
where employee_id is null
   or name is null
   or department is null
   or job_role is null
   or performance_score is null
   or kpi_score is null
   or attendance is null
   or peer_rating is null
   or task_completion is null
   or promotion_eligibility is null;

-- 2.3 Checking for out-of-range values
select * from employee_performance
where performance_score not between 0 and 100
   or kpi_score not between 0 and 100
   or attendance not between 0 and 100
   or task_completion not between 0 and 100
   or peer_rating not between 0 and 5;

-- 2.4 Checking for stray/unexpected values in promotion_eligibility
select distinct promotion_eligibility from employee_performance;

-- 2.5 Checking for leading/trailing whitespace in text columns
select * from employee_performance
where name <> trim(name)
   or department <> trim(department)
   or job_role <> trim(job_role);


-- =========================================================
-- SECTION 3: BUSINESS INSIGHTS
-- =========================================================

-- 3.1 With the help of CTE and Window Function, finding Top 3 employees from each department based on multiple aspects
-- Insight: This analysis identifies the top 3 high-performing employees from each department based on multiple
-- performance metrics. These employees can be considered strong candidates for future promotion or recognition.
with employee_score as
(
select name, department,
round((performance_score + kpi_score + attendance + task_completion +peer_rating * 20)/ 5.0) as overall_score
from employee_performance
),
ranked_employees as
(
select name , department, overall_score, 
row_number() over (partition by department order by overall_score desc)
as Ranks
from employee_score
)
select * from ranked_employees
where ranks <=3;


-- 3.2 Finding employees whose KPI score is high but performance_score is low
-- Insight: This helps in identifying employees who are achieving high KPI scores but have relatively
-- low overall performance scores, which may indicate a mismatch between individual metrics and overall evaluation.
select name,kpi_score,performance_score,department from employee_performance
where kpi_Score>=90 and performance_score<=70
limit  10;


-- 3.3 Using a CTE to calculate average performance score for each department whose average is below the overall company average
-- Insight: These departments are underperforming relative to the company-wide average performance score
-- and may need targeted training, better resource allocation, or management attention.
with department_avg as
(
select department,round(avg(performance_Score),2) as avg_performance from employee_performance
group by department
)
select * from department_avg
where avg_performance<(select(avg(performance_Score))
from employee_performance
);


-- 3.4 Using a CTE and the ROW_NUMBER() window function to find the highest-performing employee from each department
-- Insight: This highlights the single best performer in each department based on performance score,
-- useful for recognition programs or identifying internal mentors.
with employee_rank as
(
select name,department,performance_Score,
row_number() over(partition by department order by performance_score desc)
as rank_person
from employee_performance
)
select * from employee_rank
where rank_person = 1;


-- 3.5 Using PERCENT_RANK() window function to find employees in the top 10% in the company
-- Insight: This identifies the top decile of performers company-wide, useful for company-level
-- recognition, bonuses, or leadership development programs.
with employee_score as
(
select name, department,
round((performance_score + kpi_score + attendance + task_completion +peer_rating * 20)/ 5.0) as overall_score
from employee_performance
),
ranked_employees as
(
select name , department, overall_score,
percent_rank() over (order by overall_score desc)
as Ranks
from employee_score
)
select name,department,overall_score,round(percent_rank,) from ranked_employees
where ranks <= 0.10;


-- 3.6 Using NTILE(4) window function to divide employees into four performance groups based on performance score
-- Insight: This segments employees within each department into quartiles, helping identify
-- top-quartile and bottom-quartile performers for targeted action.
select name,department,performance_score,
ntile(4) over(partition by department order by performance_score) as department_wise
from employee_performance;


-- 3.7 Finding total number of employees in each department
-- Insight: This gives a headcount distribution across departments, useful for workforce planning.
select department ,count(*) from employee_performance
group by department;


-- 3.8 Using a subquery to find employees whose KPI score is above the company average
-- Insight: These employees are outperforming the company average on KPI score and could be
-- considered for additional responsibilities or rewards.
select name,kpi_score
from employee_performance
where kpi_score>
(
select avg(kpi_score)
from employee_performance
)
order by kpi_score desc;


-- 3.9 Using a CASE WHEN statement to categorize employees into 'High', 'Medium', 'Low' performance based on performance score
-- Insight: This creates a simple performance tier for each employee, useful for quick
-- reporting and dashboards without exposing raw scores.
select 
    case 
        when performance_score between 80 and 100 then 'high'
		when performance_score between 50 and 79 then 'medium'
		when performance_score between 0 and 49 then 'low'
		else 'undefine'
		end as categories_performance,name,department from employee_performance
		group by department ;


-- 3.10 Using HAVING to identify departments with fewer than 10 employees
-- Insight: Smaller departments identified here may need headcount planning or closer monitoring
-- since performance trends can be more volatile with fewer employees.
group by department
having count(*)<10;


-- 3.11 Using a window function to calculate each employee's rank within their department by KPI score
-- Insight: This ranks employees within their own department by KPI score, useful for
-- department-level performance reviews and comparisons.
select name,kpi_score,department,
rank() over ( partition by department order by kpi_score desc)
as rank_employees
from employee_performance;


-- 3.12 Employees with strong overall performance, attendance, peer rating and KPI score but whose promotion eligibility is marked 'No'
-- Insight: These are high-performing employees who are currently not marked eligible for promotion.
-- This is a strong candidate list to review for potential promotion, retention risk, or policy re-evaluation.
with employee_score as
(
select name,performance_score, kpi_score, attendance, task_completion, peer_rating,promotion_eligibility,
round((performance_score + kpi_score + attendance + task_completion +peer_rating * 20)/ 5.0) as overall_score
from employee_performance
)
select * from employee_score
where overall_score >= 90
and attendance >= 90
and peer_rating >= 4.5
and kpi_score >= 90
and promotion_eligibility = 'No'
order by overall_score desc;


-- 3.13 Employees with low overall performance, attendance, peer rating and KPI score but whose promotion eligibility is marked 'Yes'
-- Insight: These are low-performing employees who are currently marked eligible for promotion.
-- This is a those candidate list to review for high risk of termination or policy re-evaluation.
with employee_score as
(
    select 
        name,
        performance_score,
        kpi_score,
        attendance,
        task_completion,
        peer_rating,
		department,
        promotion_eligibility,
        round(
            (performance_score + kpi_score + attendance + task_completion + (peer_rating * 20)) / 5.0
        ) as overall_score
    from employee_performance
)

select *
from employee_score
where overall_score <= 75
  and promotion_eligibility = 'Yes'
order by overall_score;

--============================================================================
--============================================================================