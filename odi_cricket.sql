create database retail_db;
use retail_db;
create table odi_cricket_data( player_name varchar(100), role varchar(50),total_runs INT,strike_rate varchar(50),
                               total_balls_faced int,total_wickets_taken int, total_runs_conceded int, total_overs_bowled int,
                               total_matches_played int, matches_played_as_batter int, matches_played_as_bowler int, matches_won int,
                               matches_lost int, player_of_match_awards int, team varchar(100),average varchar(50),percentage varchar(255));

select*from odi_cricket_data;
desc table odi_cricket_data;

show variables like'local_infile';

set global local_infile=1;

load data infile"C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\ODI_data.csv"
into table odi_cricket_data
fields terminated by','
lines terminated by'\n'
ignore 1 rows;					
select*from odi_cricket_data	;
-- categorizing players by role
Select player_name,role,
case
when role='batter' then'batsman'
when role='bowler'then'bowler'
else'all-rounder'
end as player_category
from odi_cricket_data;

-- classifying players based on runs scored
select player_name,total_runs,
case
when total_runs>=10000 then'legend'
when total_runs between 5000 and 9999 then 'great player'
when total_runs between 1000 and 4999 then 'average player'
else'newcomer'
end as player_class
from odi_cricket_data;

-- evaluating bowling performance(wickets taken)
select player_name,total_wickets_taken,
case
when total_wickets_taken>=300 then 'elite bowler'
when total_wickets_taken between 100 and 299 then 'experienced bowler'
when total_wickets_taken between 50 and 99 then 'developing bowler'
else'part-time-bowler'
end as bowling_category
from odi_cricket_data;

-- classifying players by matches won
select player_name, matches_won,
case
when matches_won >=300 then 'match winner'
when matches_won between 200 and 299 then ' consistent performer'
when matches_won between 100 and 199 then 'contributor'
else 'less impactful'
end as match_impact
from odi_cricket_data;

-- categorizing player of the match award
select player_name, player_of_match_awards,
case
when player_of_match_awards>=30 then'superstar'
when player_of_match_awards between 15 and 29 then 'key players'
when player_of_match_awards between 5 and 14 then'Ocassional star'
else 'rare winner'
end as award_category
from odi_cricket_data;

update odi_cricket_data
set strike_rate = substring_index (strike_rate,".",2);

update odi_cricket_data
set average=substring_index (average,".",2);

-- get top 10 batsmen by runs
select player_name,team,total_runs,strike_rate from odi_cricket_data where role='batter'
order by total_runs desc limit 10;

-- get top 10 bowlers by wickets
select player_name,team,total_wickets_taken,total_runs_conceded,total_overs_bowled from
       odi_cricket_data where total_wickets_taken > 0 order by total_wickets_taken desc limit 10;

-- insert a new player record
insert into odi_cricket_data (player_name,role,total_runs,strike_rate,total_balls_faced,
                              total_wickets_taken, total_runs_conceded,total_overs_bowled,total_matches_played,
                              matches_played_as_batter, matches_played_as_bowler,matches_won,matches_lost,
                              player_of_match_awards,team, average, percentage)
							  values
						      ('new player','batter',5000,85.50,6000,0,0,0,200,200,0,120,80,25,'india',45.5,50.75);
       
-- update strike rate for a specific player
update odi_cricket_data set strike_rate=90.25 where player_name='V Kolhi';

-- delete records of retired players
delete from odi_cricket_data where total_matches_played<50;

-- increase the total runs of a player after arecent match
update odi_cricket_data set total_runs= total_runs+75, total_balls_faced= total_balls_faced+80
where player_name ='RG SHARMA';

-- set role as'all rounders' for players with both runs and wickets
update odi_cricket_data set role='all rounders' where total_runs>1000 and total_wickets_taken>50;

-- reset strike rate and average rate for players with inncorrect values update odi_cricket_data set strike_rate=null,average=null where strike_rate<0 or average<0;

-- remove players who have never won a match
delete from odi_cricket_data where matches_won=0;

-- set the average to 0 for players with zero matches played
update odi_cricket_data set average=0 where total_matches_played=0;

-- increase total wickets taken by 5 for bowlers from a specific team
update odi_cricket_data set total_wickets_taken=total_wickets_taken + 5 where role = 'bowler' and team='australia';       


