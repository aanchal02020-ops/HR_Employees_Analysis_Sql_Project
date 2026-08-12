# HR_Employees_Analysis_Sql_Project
Real World Employee Performance Analysis using SQL

# Project Overview
This project focuses on analyzing employee performance data using SQL to understand employee productivity, performance, attendance, KPI scores, peer ratings, task completion, and promotion eligibility.
The main purpose of this project is to use employee performance data to identify important patterns and situations that can help management make better decisions regarding employee recognition, incentives, promotions, and performance improvement.
The project also focuses on identifying cases where an employee's actual performance does not match their promotion eligibility.

# Project Objectives
The main objectives of this project are:
- Analyze the overall performance of employees.
- Compare individual employee performance with the overall company average.
- Analyze employee attendance and task completion.
- Analyze KPI scores and peer ratings.
- Identify high-performing employees who are performing better than the company average.
- Identify high-performing employees who are still marked as promotion eligible = No.
- Identify low-performing employees who are marked as promotion eligible = Yes.
- Rank employees based on their performance and KPI scores.
- Find useful patterns and insights from employee performance data.
- Provide business recommendations based on the analysis.
 
# Dataset Description
The dataset contains employee performance, productivity, feedback, training, and promotion-related information.

Columns
Description
serial_no ====================  Unique serial number for each record

employee_id =================== Unique ID assigned to each employee

name ========================== Name of the employee

department ==================== Department in which the employee works

job_role ====================== Job role of the employee

performance_score ============= Overall performance score of the employee

kpi_score ===================== KPI score of the employee

attendance ==================== Employee attendance percentage.

peer_rating =================== Rating given by peers

task_completion =============== Percentage of tasks completed

work_hours_logged ============= Total work hours logged by the employee

manager_feedback ============== Manager's feedback score

training_hours ================ Number of training hours completed

promotion_eligibility ========= Indicates whether the employee is eligible for promotion

promotion_eligibility ========= Indicates whether the employee is eligible for promotion

# Tools & Technologies
SQL
PostgreSQL
SQL Environment

# SQL Concepts Used
This project covers different SQL concepts used for data analysis, including:
- SELECT
- WHERE
- ORDER BY
- GROUP BY
- HAVING
- Aggregate Functions
- CASE WHEN
- Calculated Columns
- Subqueries
- Common Table Expressions (CTEs)
- Window Functions
- RANK()
- ROW_NUMBER()
- PERCENT_RANK()
- PARTITION BY

# Key Analysis Performed
1. Overall Employee Performance
Calculated an overall performance score using different employee performance metrics such as performance score, KPI score, attendance, task completion, and peer rating.
This helps in getting a broader view of an employee's performance instead of analyzing only one metric.
2. High-Performing Employees
Identified employees whose overall performance is better than the overall company average.
These employees can be considered strong performers who may contribute significantly to the organization.
3. High Performers Not Eligible for Promotion
Identified employees who have good attendance, performance score, peer rating, task completion, and KPI score but are still marked as:
promotion_eligibility = 'No'
This helps identify employees whose performance and promotion eligibility may not be aligned.
4. Low Performers Marked as Promotion Eligible
Identified employees whose overall performance is low but whose promotion eligibility is marked as:
promotion_eligibility = 'Yes'
These employees can be reviewed by management to check whether the promotion criteria are being applied correctly.
5. Employee Ranking
Used window functions to rank employees based on their KPI scores and performance within their respective groups.
This helps compare employees without removing individual employee-level records.
6. Performance Comparison
Compared different performance metrics such as attendance, KPI score, peer rating, task completion, and performance score to identify employees with strong or weak performance across multiple areas.

# Business Insights
The analysis can help identify several important business situations:
- Employees performing better than the company average can be recognized and rewarded.
- High-performing employees who are not promotion eligible may require a review of promotion criteria.
- Low-performing employees who are promotion eligible may require management review.
- Employees consistently performing well can be considered for leadership opportunities.
- Employees with consistently low performance can be given an opportunity to improve their performance.
- Comparing performance with promotion eligibility can help identify possible mismatches in the promotion process.


Employees consistently performing well can be considered for leadership opportunities.
Employees with consistently low performance can be given an opportunity to improve their performance.
Comparing performance with promotion eligibility can help identify possible mismatches in the promotion process.
