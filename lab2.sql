/* task 1 */
CREATE OR replace VIEW children_owners(ФИО, Улица, Дом, Квартира, Лет, id)
AS SELECT c.fio, e.street, e.numbuilding, o.flat, (extract(years FROM age(current_date, c.born))), o.id
FROM adress e, owners c, ownership o
WHERE e.idbuiding = o.idbuilding AND o.owner = c.id AND extract(years FROM age(current_date, c.born))< 18;

/* task 2*/
CREATE view owners_by_building(Номер_здания, Улица, Дом, Количество_Собственников)
AS SELECT o.idbuilding, a.street, a.numbuilding, COUNT(o.idbuilding)
FROM adress a, ownership o
WHERE a.idbuiding = o.idbuilding AND o.endown IS NULL
GROUP BY o.idbuilding, a.street, a.numbuilding;

/* task 3 */
CREATE view current_owners(Номер_Здания, Квартира, Количество_Собственников)
AS SELECT idbuilding, flat, COUNT(flat) filter (WHERE endown IS NULL AND startown IS NOT NULL )
FROM ownership
GROUP BY idbuilding, flat;
