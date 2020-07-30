create or replace function children_owners(
date1 date,
date2 date default current_date) -- если не задана вторая дата, то п.у. текущая
returns char(18) as $$
declare
    return_statement char(18); -- переменная для выводимого сообщения
    tmp date; -- временная переменная
BEGIN
    if(date1 > date2) then  -- проверка, какая дата больше для корректного результата
        tmp = date1;
        date1 = date2;
        date2 = date1;
    end if;

    if(age(date2, date1) <= interval '18 years 0 months 0 day')
    then
        return_statement = 'несовершеннолетний';
    else
        return_statement = to_char(DATE(date1 + interval '18 years 0 months 1 day'),'DD/MM/YYYY' );
    end if;
    return return_statement;
END;$$
language plpgsql;


create or replace function owners_by_func(n_numBuilding numeric(8), regiment numeric(1))
returns void as $$
    DECLARE
        row record;
        flag boolean  = false;
BEGIN
    -- Очищение таблицы, если необходимо пользователю --
    if(regiment = 0) then
        truncate owners_from_func;
    end if;
    for row in
        select a.idbuiding as building,
                        o.startown as Started,
                        ow.fio as FIO,
                        o.part as PART,
                        o.flat as FLAT,
                        ow.born as BORN
        from adress a join ownership o on a.idbuiding = o.idbuilding
             join owners ow on o.owner = ow.id
        where
              -- подзапрос на количество владельцев --
        ((select distinct count(flat)
            from ownership p where
                a.idbuiding = p.idbuilding
                and o.flat = p.flat
                and p.idbuilding = n_numBuilding
                and p.endown is null)>=10 or
            -- подзапрос на владельцев, которые несовершеннолетние --
        (select distinct children_owners(born)
            from owners ow where
                ow.id = o.owner
                and a.idbuiding = n_numBuilding
                and o.idbuilding = n_numBuilding
                and o.endown is null
                ) = 'несовершеннолетний')
        group by a.idbuiding, o.startown, ow.fio, o.part, o.flat, ow.born
    LOOP
        if(children_owners(row.BORN) != 'несовершеннолетний') then
        -- insert операция в таблицу owners_from_func --
            insert into owners_from_func values (row.building,
                                             row.Started,
                                             row.FIO,
                                             row.PART,
                                             row.FLAT, true);
            flag = true;
        else
             insert into owners_from_func values (row.building,
                                             row.Started,
                                             row.FIO,
                                             row.PART,

                                             row.FLAT, false);
             flag = true;
        end if;
    END LOOP;
    if (flag is false) then -- Проверка, были ли найдены записи
         raise info 'Не найдено';
    end if;
END;$$
LANGUAGE plpgsql;
drop function owners_by_func(n_numBuilding numeric, regiment numeric);