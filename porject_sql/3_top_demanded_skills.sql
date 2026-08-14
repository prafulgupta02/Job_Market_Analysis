/*
Question:Most in-demand skills?

- Identify the top 5 in-demand skills.
- Count how often each skill is requested by employers.
- Why? Understand which skills employers are looking for most frequently and prioritize skills that are widely required in the job market.
*/

SELECT *
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
LIMIT 5