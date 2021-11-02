--- Лабораторная работа 5 ---
--- Задание 1 (проекция) ---
SELECT DISTINCT type,
                ser
FROM   docs;

--- Задание 2 (селекция) ---
SELECT *
FROM   docs
WHERE  date_and_provider LIKE '%Москвы%';

--- Задание 3 (декартово произведение) ---
SELECT *
FROM   owners,
       docs;

--- Задание 4 (объединение) ---
SELECT *
FROM   docs
UNION
SELECT *
FROM   old_docs
ORDER  BY owner;

--- Для задания 5 выведем старые документы людей, у которых не зарегестрированы новые ---
--- Задание 5 (разность с помощью NOT IN) ---
SELECT owner,
       type,
       ser,
       date_and_provider
FROM   old_docs AS oldDocs
WHERE  owner NOT IN (SELECT docs.owner
                     FROM   docs
                     WHERE  oldDocs.owner = docs.owner);

--- Задание 6 (пересечение) (старые документы тех, у кого есть старые и новые документы) ---
SELECT owner,
       type,
       ser,
       date_and_provider
FROM   old_docs AS o_Docs
WHERE  owner IN (SELECT docs.owner
                 FROM   docs
                 WHERE  docs.owner = o_Docs.owner);

--- Задание 7 (соединение) ---
SELECT *
FROM   docs,
       owners o
WHERE  docs.owner = o.id
ORDER  BY sex; 
