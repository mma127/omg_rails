SELECT cs.company_id,
       c.name                                                                                    as company_name,
       p.name                                                                                    as player_name,
       p.id                                                                                      as player_id,
       f.name                                                                                    as faction_name,
       f.display_name                                                                            as faction_display_name,
       d.name                                                                                    as doctrine_name,
       d.display_name                                                                            as doctrine_display_name,
       ce.total_exp,

       cs.infantry_kills_1v1,
       cs.infantry_kills_2v2,
       cs.infantry_kills_3v3,
       cs.infantry_kills_4v4,
       cs.infantry_kills_1v1 + cs.infantry_kills_2v2 + cs.infantry_kills_3v3 +
       cs.infantry_kills_4v4                                                                     as total_infantry_kills,

       cs.vehicle_kills_1v1,
       cs.vehicle_kills_2v2,
       cs.vehicle_kills_3v3,
       cs.vehicle_kills_4v4,
       cs.vehicle_kills_1v1 + cs.vehicle_kills_2v2 + cs.vehicle_kills_3v3 + cs.vehicle_kills_4v4 as total_vehicle_kills,

       cs.infantry_losses_1v1,
       cs.infantry_losses_2v2,
       cs.infantry_losses_3v3,
       cs.infantry_losses_4v4,
       cs.infantry_losses_1v1 + cs.infantry_losses_2v2 + cs.infantry_losses_3v3 +
       cs.infantry_losses_4v4                                                                    as total_infantry_losses,

       cs.vehicle_losses_1v1,
       cs.vehicle_losses_2v2,
       cs.vehicle_losses_3v3,
       cs.vehicle_losses_4v4,
       cs.vehicle_losses_1v1 + cs.vehicle_losses_2v2 + cs.vehicle_losses_3v3 +
       cs.vehicle_losses_4v4                                                                     as total_vehicle_losses,

       cs.infantry_kills_1v1 + cs.vehicle_kills_1v1                                              as unit_kills_1v1,
       cs.infantry_kills_2v2 + cs.vehicle_kills_2v2                                              as unit_kills_2v2,
       cs.infantry_kills_3v3 + cs.vehicle_kills_3v3                                              as unit_kills_3v3,
       cs.infantry_kills_4v4 + cs.vehicle_kills_4v4                                              as unit_kills_4v4,
       cs.infantry_kills_1v1 + cs.infantry_kills_2v2 + cs.infantry_kills_3v3 +
       cs.infantry_kills_4v4 + cs.vehicle_kills_1v1 + cs.vehicle_kills_2v2 + cs.vehicle_kills_3v3 +
       cs.vehicle_kills_4v4                                                                      as total_unit_kills,

       cs.infantry_losses_1v1 + cs.vehicle_losses_1v1                                            as unit_losses_1v1,
       cs.infantry_losses_2v2 + cs.vehicle_losses_2v2                                            as unit_losses_2v2,
       cs.infantry_losses_3v3 + cs.vehicle_losses_3v3                                            as unit_losses_3v3,
       cs.infantry_losses_4v4 + cs.vehicle_losses_4v4                                            as unit_losses_4v4,
       cs.infantry_losses_1v1 + cs.infantry_losses_2v2 + cs.infantry_losses_3v3 +
       cs.infantry_losses_4v4 + cs.vehicle_losses_1v1 + cs.vehicle_losses_2v2 + cs.vehicle_losses_3v3 +
       cs.vehicle_losses_4v4                                                                     as total_unit_losses,

       CASE
           WHEN (cs.wins_1v1 + cs.losses_1v1) = 0
               THEN 0
           ELSE
               CAST((cs.infantry_kills_1v1 + cs.vehicle_kills_1v1) AS FLOAT) /
               (cs.wins_1v1 + cs.losses_1v1) END                                                 as avg_kills_1v1,
       CASE
           WHEN (cs.wins_2v2 + cs.losses_2v2) = 0
               THEN 0
           ELSE
               CAST((cs.infantry_kills_2v2 + cs.vehicle_kills_2v2) AS FLOAT) /
               (cs.wins_2v2 + cs.losses_2v2) END                                                 as avg_kills_2v2,
       CASE
           WHEN (cs.wins_3v3 + cs.losses_3v3) = 0
               THEN 0
           ELSE
               CAST((cs.infantry_kills_3v3 + cs.vehicle_kills_3v3) AS FLOAT) /
               (cs.wins_3v3 + cs.losses_3v3) END                                                 as avg_kills_3v3,
       CASE
           WHEN (cs.wins_4v4 + cs.losses_4v4) = 0
               THEN 0
           ELSE
               CAST((cs.infantry_kills_4v4 + cs.vehicle_kills_4v4) AS FLOAT) /
               (cs.wins_4v4 + cs.losses_4v4) END                                                 as avg_kills_4v4,
       CASE
           WHEN (cs.wins_1v1 + cs.wins_2v2 + cs.wins_3v3 + cs.wins_4v4 + cs.losses_1v1 + cs.losses_2v2 + cs.losses_3v3 +
                 cs.losses_4v4) = 0
               THEN 0
           ELSE
               CAST((cs.infantry_kills_1v1 + cs.infantry_kills_2v2 + cs.infantry_kills_3v3 + cs.infantry_kills_4v4 +
                     cs.vehicle_kills_1v1 + cs.vehicle_kills_2v2 + cs.vehicle_kills_3v3 +
                     cs.vehicle_kills_4v4) AS FLOAT) /
               (cs.wins_1v1 + cs.wins_2v2 + cs.wins_3v3 + cs.wins_4v4 + cs.losses_1v1 + cs.losses_2v2 + cs.losses_3v3 +
                cs.losses_4v4) END                                                               as combined_avg_kills,


       CASE
           WHEN (cs.wins_1v1 + cs.losses_1v1) = 0
               THEN 0
           ELSE
               CAST((cs.infantry_losses_1v1 + cs.vehicle_losses_1v1) AS FLOAT) /
               (cs.wins_1v1 + cs.losses_1v1) END                                                 as avg_losses_1v1,
       CASE
           WHEN (cs.wins_2v2 + cs.losses_2v2) = 0
               THEN 0
           ELSE
               CAST((cs.infantry_losses_2v2 + cs.vehicle_losses_2v2) AS FLOAT) /
               (cs.wins_2v2 + cs.losses_2v2) END                                                 as avg_losses_2v2,
       CASE
           WHEN (cs.wins_3v3 + cs.losses_3v3) = 0
               THEN 0
           ELSE
               CAST((cs.infantry_losses_3v3 + cs.vehicle_losses_3v3) AS FLOAT) /
               (cs.wins_3v3 + cs.losses_3v3) END                                                 as avg_losses_3v3,
       CASE
           WHEN (cs.wins_4v4 + cs.losses_4v4) = 0
               THEN 0
           ELSE
               CAST((cs.infantry_losses_4v4 + cs.vehicle_losses_4v4) AS FLOAT) /
               (cs.wins_4v4 + cs.losses_4v4) END                                                 as avg_losses_4v4,
       CASE
           WHEN (cs.wins_1v1 + cs.wins_2v2 + cs.wins_3v3 + cs.wins_4v4 + cs.losses_1v1 + cs.losses_2v2 + cs.losses_3v3 +
                 cs.losses_4v4) = 0
               THEN 0
           ELSE
               CAST((cs.infantry_losses_1v1 + cs.infantry_losses_2v2 + cs.infantry_losses_3v3 + cs.infantry_losses_4v4 +
                     cs.vehicle_losses_1v1 + cs.vehicle_losses_2v2 + cs.vehicle_losses_3v3 +
                     cs.vehicle_losses_4v4) AS FLOAT) /
               (cs.wins_1v1 + cs.wins_2v2 + cs.wins_3v3 + cs.wins_4v4 + cs.losses_1v1 + cs.losses_2v2 + cs.losses_3v3 +
                cs.losses_4v4) END                                                               as combined_avg_losses,

       cs.wins_1v1,
       cs.wins_2v2,
       cs.wins_3v3,
       cs.wins_4v4,
       cs.wins_1v1 + cs.wins_2v2 + cs.wins_3v3 + cs.wins_4v4                                     as total_wins,

       cs.losses_1v1,
       cs.losses_2v2,
       cs.losses_3v3,
       cs.losses_4v4,
       cs.losses_1v1 + cs.losses_2v2 + cs.losses_3v3 + cs.losses_4v4                             as total_losses,
       cs.streak_1v1,
       cs.streak_2v2,

       cs.streak_3v3,
       cs.streak_4v4,
       cs.streak_1v1 + cs.streak_2v2 + cs.streak_3v3 + cs.streak_4v4                             as total_streak
FROM company_stats cs
         JOIN companies c on cs.company_id = c.id
         JOIN company_exps ce on ce.company_id = cs.company_id
         JOIN players p on c.player_id = p.id
         JOIN factions f on f.id = c.faction_id
         JOIN doctrines d on d.id = c.doctrine_id