## 01
## Napoli's top scorer (top 10) 
SELECT p.Name AS Player, SUM(a.goals) AS Goals
FROM players AS p, appearances AS a
WHERE p.id = a.players_id AND a.clubs_id = (SELECT id FROM clubs WHERE Name = 'Ssc Neapel')
GROUP BY p.id
ORDER BY goals DESC
LIMIT 10;
-- 2.485 (0.531)

## 02
## Player with the highest market value
SELECT c.Name AS Club, p.Name AS Player, MAX(highest_market_value_in_gbp) AS Max_Value, country_of_citizenship AS Country, date_of_birth AS Date, position AS Position
FROM players AS p, clubs AS c
WHERE highest_market_value_in_gbp = (SELECT MAX(highest_market_value_in_gbp) FROM players)
      AND c.Name = (SELECT Name FROM clubs WHERE id =
      (SELECT clubs_id FROM players WHERE highest_market_value_in_gbp = (SELECT MAX(highest_market_value_in_gbp) FROM players)));
## This result can be expected especially after the victory of the world championship with the French national team.
-- 0.172 (0.141)

## 03
## Return italian clubs whose players have an average market value greater than 10 million
SELECT c.Name AS Club, ROUND(AVG(p.market_value_in_gbp), 2) AS Average_Market_Value
FROM clubs AS c JOIN players AS p ON c.id = p.clubs_id
WHERE c.leagues_id = 'IT1' AND p.last_season = '2021'
GROUP BY Club
HAVING AVG(p.market_value_in_gbp) > 10000000
ORDER BY AVG(p.market_value_in_gbp) DESC;
-- 0.047 (0.031)

## 04 (Low)
## Return the name of every player such that the total amount of red cards taken is greater than 4
SELECT p.Name AS Player, SUM(a.red_cards) AS Red_Cards
FROM players p JOIN appearances AS a ON p.id = a.players_id
GROUP BY p.id
HAVING SUM(a.red_cards) > 4
ORDER BY Red_Cards DESC;
-- 3.875 (6.140) !!!!!

## 05
## Players with the most appearances in Serie A (Top 10)
SELECT Name AS Player, COUNT(Name) AS Appearances
FROM players AS p, appearances AS a
WHERE p.id = a.players_id 
	 AND a.games_id IN (SELECT id
					   FROM games
					   WHERE competitions_id = 'IT1')
GROUP BY p.id
ORDER BY Appearances DESC
LIMIT 10;
## Samir Handanovic is the captain of the FC Inter and he was played also with Udinese in the previous experience in Serie A.
## At the second position we find Andrea Consigli, who is a goalkeeper for Sassuolo.
## Both are goal keepers and maybe this helped them to collect this number of appearances.
-- 3.687 (1.218)

## 06
## Name of the Italian player with the most appearances in champions
SELECT p.Name AS Player, COUNT(p.Name) AS Appearances
FROM players AS p, appearances AS a
WHERE p.id = a.players_id AND p.country_of_citizenship = 'Italy' AND a.competitions_id = 'CL'
GROUP BY p.id
ORDER BY Appearances DESC;
## We have that the players with greater number of appearances in UCL belong to Juventus FC. This result is coherent with the fact that it is the italian club that has
## played most in that competition.
-- 1.281 (0.562)

## 07
## Italian player with the most Champions League victories
SELECT p.Name, COUNT(p.Name) AS Wins
FROM players AS p, appearances AS a, (SELECT g.id AS game, c.id AS club, c.Name
									  FROM games AS g, clubs AS c
									  WHERE g.competitions_id = 'CL' AND
											((g.home_club_goals > g.away_club_goals) AND c.id = g.home_club_id OR
											(g.away_club_goals > g.home_club_goals) AND c.id = g.away_club_id)) AS cl
WHERE p.id = a.players_id AND a.games_id = cl.game AND a.clubs_id = cl.club
	  AND p.country_of_citizenship = 'Italy'
GROUP BY p.id
ORDER BY Wins DESC;
## We have that the players with greater number of wins in UCL belong to Juventus FC. This result is coherent with the fact that it is the italian club that has
## played most in that competition.
-- 9.437 (0.359)

## 08
## Players who have scored in the Roma Lazio derby since 2014
SELECT p.Name AS Player, SUM(a.goals) AS Goals
FROM players AS p, appearances AS a
WHERE p.id = a.players_id AND a.goals > 0 AND a.games_id IN (SELECT id
															 FROM games
															 WHERE (home_club_id = (SELECT id FROM clubs WHERE Name = 'As Rom') AND
																    away_club_id = (SELECT id FROM clubs WHERE Name = 'Lazio Rom')
                                                                    or
																   (home_club_id = (SELECT id FROM clubs WHERE Name = 'Lazio Rom') AND
																    away_club_id = (SELECT id FROM clubs WHERE Name = 'As Rom'))))
					
GROUP BY p.Name                                                                 
ORDER BY Goals desc
LIMIT 10;
-- 1.610 (0.078)

## 09
## Clubs that have obtained the maximum number of wins with the minimum goal difference
SELECT c.Name AS Club, COUNT(c.Name) as Counter
FROM games AS g, clubs AS c
WHERE ((g.home_club_goals - g.away_club_goals) = 1 AND c.id = g.home_club_id) OR
	  ((g.away_club_goals - g.home_club_goals) = 1 AND c.id = g.away_club_id)
GROUP BY c.id
ORDER BY Counter DESC;
## This result makes us understand that there are some clubs which adopt a defensive style of play.
-- 4.047 (0.578)

# in casa
SELECT c.Name AS Club, COUNT(c.Name) AS Counter 
FROM games AS g, clubs AS c
WHERE (g.home_club_goals - g.away_club_goals) = 1 AND c.id = g.home_club_id
GROUP BY c.id
ORDER BY Counter DESC;
-- 0.078

# in trasferta
SELECT c.Name AS Club, COUNT(c.Name) AS Counter 
FROM games AS g, clubs AS c
WHERE (g.away_club_goals - g.home_club_goals) = 1 AND c.id = g.away_club_id
GROUP BY c.id
ORDER BY Counter DESC;
-- 0.078

## 10
## Match with the maximum number of goals
SELECT c_home.name AS Home_Team, c_away.name AS Away_Team,
				home_club_goals AS Home_Goals, away_club_goals AS Away_Goals, MAX(home_club_goals + away_club_goals) AS Num_Max_Goal,
                round AS Round, c.Name AS Competition, date AS Date, stadium AS Stadium, attendance AS Attendance
from clubs AS c_home, clubs AS c_away, games AS g, competitions AS c
WHERE c_home.id = (SELECT home_club_id
				  FROM games
				  WHERE (home_club_goals + away_club_goals) = (SELECT MAX(home_club_goals + away_club_goals) FROM games))
	AND c_away.id = (SELECT away_club_id
				  FROM games
				  WHERE (home_club_goals + away_club_goals) = (SELECT MAX(home_club_goals + away_club_goals) FROM games))
	AND home_club_goals = (SELECT home_club_goals
				  FROM games
				  WHERE (home_club_goals+ away_club_goals) = (SELECT MAX(home_club_goals + away_club_goals) FROM games))
	AND away_club_goals = (SELECT away_club_goals
				  FROM games
				  WHERE (home_club_goals+ away_club_goals) = (SELECT MAX(home_club_goals + away_club_goals) FROM games))
	AND c.id = g.competitions_id;
## This EFL-CUP match ended after penalties shootout. This justifies the high score. 
-- 0.422 (0.329)

## 11
## Match with the largest number of spectators
## Define the variables
SET @Match_Id := (SELECT id FROM games where attendance = (SELECT max(attendance) FROM games));
SET @p.Name := (SELECT Name FROM players where id in (SELECT players_id FROM appearances where games_id = @Match_Id and goals > 0) limit 1);
SET @p2.Name := (SELECT Name FROM players where id in (SELECT players_id FROM appearances where games_id = @Match_Id and goals > 0) limit 1,1);
SET @p3.Name := (SELECT Name FROM players where id in (SELECT players_id FROM appearances where games_id = @Match_Id and goals > 0) limit 2,2);
-- ~6 sec (0.150)
## Query
SELECT c_home.Name AS Home_team, c_away.Name AS Away_Team, competitions_id AS Competition, round AS Round, stadium AS Stadium,
		date AS Date, home_club_goals AS Home_Goals, away_club_goals AS Away_Goals, MAX(attendance) AS Attendance,
        p.Name AS Soccer_Player1, p2.Name AS Soccer_Player2, p3.Name AS Soccer_Player3
FROM games AS g, clubs AS c_home, clubs AS c_away, players AS p, players AS p2, players AS p3
WHERE attendance = (SELECT max(attendance) FROM games) AND
	  c_home.Name = (SELECT Name FROM clubs WHERE id = (SELECT home_club_id FROM games WHERE attendance = (SELECT MAX(attendance) FROM games))) AND
      c_away.Name = (SELECT Name FROM clubs WHERE id = (SELECT away_club_id FROM games WHERE attendance = (SELECT MAX(attendance) FROM games))) AND
      p.Name = @p.Name AND
      p2.Name = @p2.Name AND
      p3.Name = @p3.Name;
## This match was the final of the Copa del Rey 2015. It was won by Barcelona with two goals of Lionel Messi and one of Neymar.
-- 0.422 (0.282)

## 12 (Slow)
## Player who scored the most goals in the Champions League final
SELECT p.Name AS Player, goals as Goals, c.Name AS Club, a.minutes_played AS Minutes_Played
FROM players AS p JOIN appearances AS a ON p.id = a.players_id, games AS g, clubs AS c
WHERE a.competitions_id = (SELECT id FROM competitions WHERE Name = 'uefa-champions-league') AND
	  a.games_id IN (SELECT id
					 FROM games
					 WHERE competitions_id = 'CL' AND round = 'Final') AND
	  a.goals IN (SELECT goals FROM appearances WHERE a.games_id IN (SELECT id
																	 FROM games
																	 WHERE competitions_id = 'CL' AND round = 'Final') AND a.goals > 0) AND
	  c.id = a.clubs_id
GROUP BY p.id
ORDER BY Goals DESC;
-- 36.95

## 12 (Fast)
## Create View
DROP VIEW `transfermarkt`.`final`;
CREATE VIEW final AS
SELECT id
FROM games
WHERE competitions_id = 'CL' AND round = 'Final';

SELECT p.Name AS Player, goals AS Goals, c.Name AS Club, a.minutes_played AS Minutes_Played
FROM players AS p JOIN appearances AS a ON p.id = a.players_id, games AS g, clubs AS c, competitions AS co, final AS f
WHERE a.competitions_id = co.id AND co.Name = 'uefa-champions-league' AND
	  a.games_id = f.id AND
	  a.goals > 0  AND
	  c.id = a.clubs_id
GROUP BY p.id
ORDER BY Goals DESC;
-- 15.657

## 13 (Slow)
## Player that scored the most goals in a match
SELECT p.Name AS Player, c.Name AS Club, MAX(goals) AS Num_Max_Goals, games_id AS Games_id, g.home_club_goals AS Home_Goals, g.away_club_goals AS Away_Goals,
	   g.competitions_id AS Competition, g.date AS Date, g.round AS Round
FROM appearances AS a, players AS p, clubs AS c, games AS g
WHERE p.Name = (SELECT Name
					FROM players
                    WHERE id = (SELECT players_id FROM appearances WHERE goals = (SELECT MAX(goals) FROM appearances)))
	  AND c.Name = (SELECT Name
					FROM clubs
                    WHERE id = (SELECT clubs_id
								FROM appearances
                                WHERE goals = (SELECT MAX(goals) FROM appearances)))
	  AND games_id = (SELECT games_id FROM appearances WHERE goals = (SELECT MAX(goals) FROM appearances))
      AND home_club_goals = (SELECT home_club_goals FROM games WHERE id = (SELECT games_id FROM appearances WHERE goals = (SELECT max(goals) FROM appearances)))
      AND away_club_goals = (SELECT away_club_goals FROM games WHERE id = (SELECT games_id FROM appearances WHERE goals = (SELECT max(goals) FROM appearances)))
      AND g.competitions_id = (SELECT competitions_id FROM games WHERE id = (SELECT games_id FROM appearances WHERE goals = (SELECT max(goals) FROM appearances)))
      AND g.date = (SELECT date FROM games WHERE id = (SELECT games_id FROM appearances WHERE goals = (SELECT max(goals) FROM appearances)))
      AND g.round = (SELECT round FROM games WHERE id = (SELECT games_id FROM appearances WHERE goals = (SELECT max(goals) FROM appearances)));
## Milik scores six goals in one match in the Dutch national cup.
-- 22.110 (16.890)

## 13 (Fast)
# Create View
DROP VIEW `transfermarkt`.`match_id_max_goal`;
CREATE VIEW match_id_max_goal AS
SELECT games_id
FROM appearances
WHERE goals = (SELECT MAX(goals) FROM appearances);

# Query
SELECT p.Name AS Player, c.Name AS Club, MAX(goals) AS Num_Max_Goals, a.games_id AS Games_id, g.home_club_goals AS Home_Goals, g.away_club_goals AS Away_Goals,
	   g.competitions_id AS Competition, g.date AS Date, g.round AS Round
FROM appearances AS a, players AS p, clubs AS c, games AS g, match_id_max_goal as mmg
WHERE p.Name = (SELECT Name
					FROM players
                    WHERE id = (SELECT players_id FROM appearances WHERE goals = (SELECT MAX(goals) FROM appearances)))
	  AND c.Name = (SELECT Name
					FROM clubs
                    WHERE id = (SELECT clubs_id
								FROM appearances
                                WHERE goals = (SELECT MAX(goals) FROM appearances)))
	  AND a.games_id = mmg.games_id
      AND home_club_goals = (SELECT home_club_goals FROM games WHERE id = mmg.games_id)
      AND away_club_goals = (SELECT away_club_goals FROM games WHERE id = mmg.games_id)
      AND g.competitions_id = (SELECT competitions_id FROM games WHERE id = mmg.games_id)
      AND g.date = (SELECT date FROM games WHERE id = mmg.games_id)
      AND g.round = (SELECT round FROM games WHERE id = mmg.games_id);
-- 6.563