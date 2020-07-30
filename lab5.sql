select *
from docs
where ser ~ 'X|V|I|M|C'
  and ser like 'k{2}'
  and ser ~ 'А|Б|В|Г|Д|Е|Ё|Ж|З|И|Й|К|Л|М|Н|О|П|Р|С|Т|У|Ф|Х|Ц|Ч|Ш|Щ|Ъ|Ы|Ь|Э|Ю|Я';
select *
from docs
where (ser similar to '(X|V|I|M|C){1,6}-([А-Я]){2}'
    and numb similar to '([0-9]){6}'
    and type like 'Свидетельство о%')
   or (ser not similar to '([0-9]){4}'
    and numb similar to '([0-9]){6}'
    and type = 'Паспорт');

--ЗАДАНИЕ 1--
-- Триггерная процедура --
create or replace function check_docs()
    returns trigger as
$$

BEGIN
    -- Проверка серии и номера по маске для свидетельства рождения или смерти --
    if (new.type = 'Паспорт')
    then
        if (new.ser not similar to '([0-9]){4}' and new.numb similar to '([0-9]){6}'
            and new.type = 'Паспорт') then
            raise exception 'Ошибка серии паспорта ';
        elseif (new.ser similar to '([0-9]){4}' and new.numb not similar to '([0-9]){6}'
            and new.type = 'Паспорт') then
            raise exception 'Ошибка номера паспорта ';
        elseif (new.ser not similar to '([0-9]){4}' and new.numb not similar to '([0-9]){6}'
            and new.type = 'Паспорт') then
            raise exception 'Ошибка серии и номера паспорта ';
        else
            return new;
        end if;
    elseif (new.type similar to 'Свидетельство о%') then
        if (new.ser not similar to '(X|V|I|M|C){1,6}-([А-Я]){2}'
            and new.type like 'Свидетельство о%'
            and new.numb similar to '([0-9]){6}')
        then
           raise exception 'Ошибка формата серии (%)', new.type;
        elseif (new.numb not similar to '([0-9]){6}'
            and new.ser similar to '(X|V|I|M|C){1,6}-([А-Я]){2}'
            and new.type like 'Свидетельство о%') then
            raise exception 'Ошибка формата номера (%)', new.type;
        elseif (new.ser not similar to '(X|V|I|M|C){1,6}-([А-Я]){2}'
            and new.numb not similar to '([0-9]){6}'
            and new.type like 'Свидетельство о%') then
            raise exception 'Ошибка серии и номера (%)', new.type;
        else
            return new;
        end if;
    else
        raise exception 'Ошибка типа!';
    end if;
END;
$$
    LANGUAGE plpgsql;
-- Триггер для таблицы документов --
create trigger tr_check_docs
    before insert or update
    on docs
    for each row
execute procedure check_docs();

-- Задание 2 --
-- Триггерная процедура --
create or replace function check_ownership()
    returns trigger as
$$
BEGIN
    -- Проверка даты начала владения --
    if (new.startown > current_date) then
        raise exception 'Ошибка даты начала владения';
        -- Проверка даты окончания владения --
    elseif (new.endown > current_date or new.endown < new.startown) then
        raise exception 'Ошибка даты окончания владения';
        -- Проверка квартиры по пормату ЧИСЛОЧИСЛОЧИСЛОБУКВА или
        -- ЧИСЛОЧИСЛОЧИСЛО (предполагая только трехзначные квартиры)
    elseif (new.flat not similar to '([0-9]){3}([А-Я]){1}' or
            new.flat not similar to '([0-9]){3}') then
        raise exception 'Ошибка ввода квартиры';
    else
        -- Проверка на null значение начала владения --
        if (new.startown is null) then
            new.startown = current_date;
            return NEW;
        else
            return NEW;
        end if;
    end if;
END;
$$
    LANGUAGE plpgsql;
-- Триггер для таблицы владения --
create trigger tr_check_ownership
    before insert or update
    on ownership
    for each row
execute procedure check_ownership();
