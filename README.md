# Introduction 🚀
Finding the right job can be challenging, especially when it comes to knowing which skills are in demand , what salaries to expect , and which opportunities are worth pursuing 🎯.

This project uses SQL 🛠️ to analyze job posting data and uncover insights that can help job seekers make data-driven career decisions 📊. The analysis focuses on job demand, salaries, remote opportunities , and the most valuable skills for Data Analyst roles 📈.

Check out the SQL Querries here: [project_sql folder](/porject_sql/)
# Background
The job market is constantly changing, and understanding which skills employers are looking for and what they are willing to pay 💰 can give job seekers a significant advantage.

This project analyzes real-world job posting data to identify trends in Data Analyst roles 📊 and provide practical insights that can help job seekers focus their learning and job search efforts 🎯.

## Questions We Aim to Answer ❓
-  What are the most in-demand skills for Data Analyst jobs?
-  Which skills are associated with the highest average salaries?
-  What are the most in-demand skills for remote Data Analyst jobs?
-  Which skills offer the best combination of demand and salary?
-  What skills should a Data Analyst learn to maximize their job opportunities and earning potential?
# Tools Used 🛠️
1. **SQL 🗄️:** Used to query, filter, and analyze the job posting data to uncover meaningful insights.
2. **PostgreSQL 🐘 :** Used as the database management system to store and work with the dataset.
3. **VS Code 💻 :** Used as the code editor for writing and managing SQL queries and project files.
4. **Git & Github🔧 :** Used for version control to track changes and manage the project efficiently.
# Analysis
Analysis 📊

In this section, I analyzed the job posting dataset using SQL to identify in-demand skills, salary trends, and remote work opportunities for Data Analyst roles. 🔍

The analysis is divided into several questions, with each query designed to uncover a specific insight that can help job seekers make better, data-driven career decisions. 🎯

**1. Most In-Demand Skills 💻**

Identified the skills that appear most frequently in Data Analyst job postings, helping job seekers understand which technical skills are most commonly requested by employers.

```sql
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
```

**2. Highest-Paying Skills 💰**

Analyzed the average salaries associated with different skills to determine which skills have the highest earning potential in Data Analyst roles.

``` sql
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
```
![Top paying Data Analyst Skills](assests\top_5_data_analyst_skills_dark.png)
*Bar grpah visualizing the top 5 salaries for data analyst; ChatGPT gnerated this graph from my SQL query results*

**3. Most In-Demand Skills for Remote Jobs 🏠**

Focused specifically on remote Data Analyst positions to identify the skills most frequently requested for work-from-home opportunities.

```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5
```
| Rank | Skill | Demand Count |
|------|-------|-------------:|
|  1 | SQL | 92,628 |
|  2 | Excel | 67,031 |
|  3 | Python | 57,326 |
| 4 | Tableau | 46,554 |
| 5 | Power BI | 39,468 |


**4. Best Skills Based on Demand & Salary 📈**

Compared skill demand with average salary to find skills that provide a strong combination of job opportunities and earning potential.

``` sql
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
```

| Rank | Skill | Average Salary |
|------|-------|---------------:|
|  1 | Fortran | $82,500 |
|  2 | Selenium | $82,500 |
|  3 | Ruby | $80,960 |
| 4 | Outlook | $80,680 |
| 5 | Monday.com | $79,000 |

**5. Skills to Learn for Career Growth 🎯**

Combined the insights from the analysis to identify which skills could be most valuable for aspiring Data Analysts, considering both employer demand and salary potential.

```sql
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id,
        skills_dim.skills
),

avrg_salary AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY
        skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM skills_demand
INNER JOIN avrg_salary
    ON skills_demand.skill_id = avrg_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
    
LIMIT 25
```
| Rank | Skill | Demand Count | Average Salary |
|------|-------|-------------:|---------------:|
|  1 | Go | 27 | $115,320 |
|  2 | Confluence | 11 | $114,210 |
|  3 | Hadoop | 22 | $113,193 |
| 4 | Snowflake | 37 | $112,948 |
| 5 | Azure | 34 | $111,225 |

# What I Learned

1. **SQL & PostgreSQL 🗄️** — Learned how to create and connect to databases, write SQL queries, and analyze data using PostgreSQL in VS Code.

2. **Git & GitHub 🔧** — Learned how to use Git for version control, push and pull changes, and organize a GitHub repository into a clear, readable format for users.

3. **Data Analysis 📊** — Learned how to approach a real-world problem using data, analyze job posting data, and generate meaningful insights to support data-driven decisions.

4. **Problem-Solving 🧠** — Improved my ability to break down real-world questions into smaller problems and solve them using SQL and data analysis techniques.

# Conclusions

This project analyzed real-world job posting data to uncover insights about the **Data Analyst job market**. Using SQL and PostgreSQL, I explored skill demand, salary trends, and remote job opportunities to identify which skills are most valuable for aspiring Data Analysts. 

Working on this project helped me strengthen my **SQL, PostgreSQL, Git, GitHub, and problem-solving skills** while giving me hands-on experience with a real-world data analysis problem. It also helped me understand how to turn raw data into **meaningful, actionable insights** and improved my overall approach to data-driven decision-making.

