create Database healthcare
use healthcare

 --KPI 1) Find Total number of appointment
 
 select count(*) as total_appointment from healthcare_project

 --KPI 2) What's our overall no_show rate

 select no_show,count(*) as total_appointments,
 round(count() * 100/(select count() from healthcare_project),2) as percent_of_total
 from healthcare_project group by No_show


 --KPI 3) does the day of the week matter
 -- week day wise distribution of no_show rate 

 select datename(weekday,appointment_day) as appointment_day,
 count(*) as total_appointment,
 sum(case when no_show='Yes' then 1 else 0 end) as no_shows,
 round(sum(case when no_show='Yes' then 1 else 0 end) 100/count(),2) as rate_of_no_show
 from healthcare_project group by datename(weekday,appointment_day)
 order by datename(weekday,appointment_day) desc

 -- KPI 4) Does Lead time matter
 select * from healthcare_project where lead_time_days 
 --Same day
 --1-3 Days
 -- within week (4-7 days)
 -- long lead (8+ day)


 with cte as(
 select *, (case
 when lead_time_days =0 then 'Same day'
 when abs(lead_time_days) between 1 and 3 then 'Short (1-3 days)'
 when abs(lead_time_days) between 4 and 7 then 'within week (4-7 days)'
  when abs(lead_time_days) >= 8 then 'long lead (8+ day)'
 end) as lead_time_bucket from healthcare_project
),
cte2 as( select lead_time_bucket,
 count(*) as total_appointment,
  round(sum(case when no_show='Yes' then 1 else 0 end) 100/count(),2) as rate_of_no_show
 from cte group by lead_time_bucket
 )
 select * from cte2

 --KPI 5) add columns

 alter table healthcare_project
add  appointment_day date

--KPI 6) add columns

alter table healthcare_project
add  scheduled_day date

--KPI 7) update data

update healthcare_project 
set scheduled_day = replace(replace(ScheduledDay,'T',' '),'Z',' ');

-- 8)  update data

update healthcare_project 
set appointment_day = replace(replace(AppointmentDay,'T',' '),'Z',' ');





