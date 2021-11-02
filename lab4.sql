CREATE
OR
replace FUNCTION children_owners( date1 date, date2 date DEFAULT CURRENT_DATE) -- если не задана вторая дата, то п.у. текущая
returns                  char(18) AS $$DECLARE return_statement CHAR(18); -- переменная для выводимого сообщенияtmp                      date;     -- временная переменнаяBEGIN
  IF(date1 > date2) then -- проверка, какая дата больше для корректного результата
  tmp = date1;
  date1 = date2;
  date2 = date1;
ENDIF;IF(Age(date2, date1) <= interval '18 years 0 months 0 day') THEN
return_statement = 'несовершеннолетний';
else return_statement = to_char(date(date1 + interval '18 years 0 months 1 day'),'DD/MM/YYYY' );ENDIF;RETURN return_statement;END;$$ language plpgsql;

CREATE
OR
replace FUNCTION owners_by_func(n_numbuilding numeric(8), regiment numeric(1))
returns void AS $$DECLARE row RECORD;flag boolean = false;BEGIN
  -- Очищение таблицы, если необходимо пользователю --
  IF(regiment = 0) then
  TRUNCATE owners_from_func;
ENDIF;FOR row INSELECT   a.idbuiding AS building,
         o.startown  AS started,
         ow.fio      AS fio,
         o.part      AS part,
         o.flat      AS flat,
         ow.born     AS born
FROM     adress a
JOIN     ownership o
ON       a.idbuiding = o.idbuilding
JOIN     owners ow
ON       o.owner = ow.id
WHERE
         -- подзапрос на количество владельцев --
         ((
                                  SELECT DISTINCT Count(flat)
                                  FROM            ownership p
                                  WHERE           a.idbuiding = p.idbuilding
                                  AND             o.flat = p.flat
                                  AND             p.idbuilding = n_numbuilding
                                  AND             p.endown IS NULL)>=10
         OR
                  -- подзапрос на владельцев, которые несовершеннолетние --
                  (
                                  SELECT DISTINCT Children_owners(born)
                                  FROM            owners ow
                                  WHERE           ow.id = o.owner
                                  AND             a.idbuiding = n_numbuilding
                                  AND             o.idbuilding = n_numbuilding
                                  AND             o.endown IS NULL ) = 'несовершеннолетний')
GROUP BY a.idbuiding,
         o.startown,
         ow.fio,
         o.part,
         o.flat,
         ow.born
loopIF(Children_owners(row.born) != 'несовершеннолетний') then
-- insert операция в таблицу owners_from_func --
INSERT INTO owners_from_func VALUES
            (
                        row.building,
                        row.started,
                        row.fio,
                        row.part,
                        row.flat,
                        true
            );flag = true;ELSEINSERT INTO owners_from_func VALUES
            (
                        row.building,
                        row.started,
                        row.fio,
                        row.part,
                        row.flat,
                        false
            );flag = true;ENDIF;END
loop;IF (flag IS false) THEN -- Проверка, были ли найдены записи
raise info 'Не найдено';ENDIF;END;$$ language plpgsql;DROP FUNCTION owners_by_func(n_numbuilding numeric, regiment numeric);
