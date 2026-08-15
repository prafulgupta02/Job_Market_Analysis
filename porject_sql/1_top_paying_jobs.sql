/*
Question: What are the top-paying Data Analyst jobs?

- Identify the top 10 highest-paying Data Analyst roles.
- Focus on job postings with a specified salary.
- Remove records with missing salary data.
- Why? Highlight the highest-paying opportunities for Data Analysts and understand which roles offer the best earning potential.
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND 
    job_location = 'India' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10