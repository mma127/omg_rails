SELECT c.id as company_id,
       COALESCE(SUM(s.vet), 0) as total_exp
FROM companies c
         LEFT OUTER JOIN squads s on c.id = s.company_id
GROUP BY c.id