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

## 09
## Clubs that have obtained the maximum number of wins with the minimum goal difference
SELECT c.Name AS Club, COUNT(c.Name) as Counter
FROM games AS g, clubs AS c
WHERE ((g.home_club_goals - g.away_club_goals) = 1 AND c.id = g.home_club_id) OR
	  ((g.away_club_goals - g.home_club_goals) = 1 AND c.id = g.away_club_id)
GROUP BY c.id
ORDER BY Counter DESC;
## This result makes us understand that there are some clubs which adopt a defensive style of play.

## 12
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

## 13
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