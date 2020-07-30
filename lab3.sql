--- Лабораторная работа 5 ---
--- Задание 1 (проекция) ---
SELECT DISTINCT type, ser
from docs;
--- Задание 2 (селекция) ---
SELECT *
from docs
WHERE date_and_provider like '%Москвы%';
--- Задание 3 (декартово произведение) ---
SELECT * from owners, docs;
--- Задание 4 (объединение) ---
SELECT * from docs
UNION SELECT * from old_docs
order by owner;
--- Для задания 5 выведем старые документы людей, у которых не зарегестрированы новые ---
--- Задание 5 (разность с помощью NOT IN) ---
SELECT owner, type, ser, date_and_provider
FROM old_docs as oldDocs
WHERE owner NOT in (select docs.owner
    from docs where oldDocs.owner = docs.owner);
--- Задание 6 (пересечение) (старые документы тех, у кого есть старые и новые документы) ---
SELECT owner, type, ser, date_and_provider
FROM old_docs as o_Docs
WHERE owner IN (select docs.owner
    from docs where docs.owner = o_Docs.owner);
--- Задание 7 (соединение) ---
SELECT *
from docs, owners o
where docs.owner = o.id
order by sex;
