SELECT *
FROM   docs
WHERE  ser ~ 'X|V|I|M|C'
AND    ser LIKE 'k{2}'
AND    ser ~ 'А|Б|В|Г|Д|Е|Ё|Ж|З|И|Й|К|Л|М|Н|О|П|Р|С|Т|У|Ф|Х|Ц|Ч|Ш|Щ|Ъ|Ы|Ь|Э|Ю|Я';SELECT *
FROM   docs
WHERE  (
              ser similar TO '(X|V|I|M|C){1,6}-([А-Я]){2}'
       AND    numb similar TO '([0-9]){6}'
       AND    type LIKE 'Свидетельство о%')
OR     (
              ser NOT similar TO '([0-9]){4}'
       AND    numb similar TO '([0-9]){6}'
       AND    type = 'Паспорт');

--ЗАДАНИЕ 1--
-- Триггерная процедура --CREATE
OR
replace FUNCTION check_docs()
returns TRIGGER AS $$
BEGIN
  -- Проверка серии и номера по маске для свидетельства рождения или смерти --IF (new.type = 'Паспорт') then
  IF (new.ser NOT similar TO '([0-9]){4}'
  AND
  new.numb similar TO '([0-9]){6}'
  AND
  new.type = 'Паспорт') THEN
  raise
  exception
  'Ошибка серии паспорта ';ELSEIF (new.ser similar TO '([0-9]){4}'
  AND
  new.numb NOT similar TO '([0-9]){6}'
  AND
  new.type = 'Паспорт') THEN
  raise
  exception
  'Ошибка номера паспорта ';ELSEIF (new.ser NOT similar TO '([0-9]){4}'
  AND
  new.numb NOT similar TO '([0-9]){6}'
  AND
  new.type = 'Паспорт') THEN
  raise
  exception
  'Ошибка серии и номера паспорта ';ELSERETURN new;ENDIF;ELSEIF (new.type similar TO 'Свидетельство о%') THENIF (new.ser NOT similar TO '(X|V|I|M|C){1,6}-([А-Я]){2}'
  AND
  new.type LIKE 'Свидетельство о%'
  AND
  new.numb similar TO '([0-9]){6}') THEN
  raise
  exception
  'Ошибка формата серии (%)', new.type;ELSEIF (new.numb NOT similar TO '([0-9]){6}'
  AND
  new.ser similar TO '(X|V|I|M|C){1,6}-([А-Я]){2}'
  AND
  new.type LIKE 'Свидетельство о%') THEN
  raise
  exception
  'Ошибка формата номера (%)', new.type;ELSEIF (new.ser NOT similar TO '(X|V|I|M|C){1,6}-([А-Я]){2}'
  AND
  new.numb NOT similar TO '([0-9]){6}'
  AND
  new.type LIKE 'Свидетельство о%') THEN
  raise
  exception
  'Ошибка серии и номера (%)', new.type;ELSERETURN new;ENDIF;
ELSE raise
exception
'Ошибка типа!';ENDIF;END;$$ language plpgsql;
-- Триггер для таблицы документов --CREATE TRIGGER tr_check_docs before
INSERT
OR
UPDATE
ON docs FOR each row
EXECUTE PROCEDURE
  check_docs();
-- Задание 2 --
-- Триггерная процедура --
create
OR
replace FUNCTION check_ownership()
returns TRIGGER AS $$
BEGIN
  -- Проверка даты начала владения --
  IF (new.startown > CURRENT_DATE) THEN
  raise
  exception
  'Ошибка даты начала владения';
  -- Проверка даты окончания владения --
elseif (new.endown > CURRENT_DATE
  OR
  new.endown < new.startown) THEN
  raise
  exception
  'Ошибка даты окончания владения';
  -- Проверка квартиры по пормату ЧИСЛОЧИСЛОЧИСЛОБУКВА или
  -- ЧИСЛОЧИСЛОЧИСЛО (предполагая только трехзначные квартиры)
elseif (new.flat NOT similar TO '([0-9]){3}([А-Я]){1}'
  OR
  new.flat NOT similar TO '([0-9]){3}') THEN
  raise
  exception
  'Ошибка ввода квартиры';
  else
  -- Проверка на null значение начала владения --
  IF (new.startown IS NULL) THEN
  new.startown = CURRENT_DATE;
  return new;
  else
  RETURN new;
end
IF;
end
IF;
end;
$$ language plpgsql;
-- Триггер для таблицы владения --CREATE TRIGGER tr_check_ownership before
INSERT
OR
UPDATE
ON ownership FOR each row
EXECUTE PROCEDURE
  check_ownership();
