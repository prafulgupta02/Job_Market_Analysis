/*
Question: What are the top skills based on salary for Data Analysts?

- Identify the skills associated with the highest average salaries.
- Calculate the average salary for jobs requiring each skill.
- Rank skills based on their average salary.
- Why? Determine which skills are associated with higher-paying Data Analyst positions and may increase earning potential.
*/


SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary
LIMIT 25