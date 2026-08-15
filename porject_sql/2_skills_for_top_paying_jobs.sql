/*
Question: What skills are required for the top-paying Data Analyst roles?

- Identify the skills associated with the highest-paying Data Analyst jobs.
- Focus on the top-paying roles identified in the previous analysis.
- Determine which skills are most commonly required for these positions.
- Why? Understand which skills are valuable for accessing higher-paying Data Analyst opportunities.
*/

WITH top_paying_jobs AS (
SELECT
    job_id,
    job_title,
    salary_year_avg,
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
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
