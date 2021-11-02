/*
 * 1) Департаменты - DONE
 * 2) Сотрудники - DONE
 * 3) Телефоны сотрудников - DONE
 * 4) Должность-оклад - DONE
 * 5) Рейсы - DONE
 * 6) Типы рейсов - DONE
 * 7) Обслуживание - DONE
 * 8) Самолеты - DONE
 * 9) Модели - DONE
 * 10) Аэропорты - DONE
 * 11) Страны - DONE
 * 12) Города - DONE
 * 13) Авиакомпании - DONE
 */
/*
 * Таблица "Страны"
 */
CREATE TABLE countries
  (
     c_name VARCHAR(50) PRIMARY KEY
  );

/*
 * Таблица "Города"
 */
CREATE TABLE cities
  (
     g_city    VARCHAR(50),
     g_country VARCHAR(50),
     PRIMARY KEY(g_city, g_country),
     FOREIGN KEY(g_country) REFERENCES countries
  );

/*
 * Таблица "Аэропорты"
 */
CREATE TABLE airports
  (
     ap_code    CHAR(3) PRIMARY KEY,
     ap_name    VARCHAR(50) NOT NULL,
     ap_city    VARCHAR(50) NOT NULL,
     ap_country VARCHAR(50) NOT NULL,
     FOREIGN KEY(ap_city, ap_country) REFERENCES cities(g_city, g_country)
  );

/*
 * Таблица "Департаменты"
*/
CREATE TABLE departments
  (
     d_id     NUMERIC(4) PRIMARY KEY,
     d_name   VARCHAR(100) NOT NULL,
     d_type   VARCHAR(10) CHECK (d_type IN ('внутренний',
     'внешний')),
     d_income NUMERIC(9, 2) NOT NULL
  );

/*
 * Таблица "Авиакомпании"
 */
CREATE TABLE airlines
  (
     al_id   VARCHAR(20) PRIMARY KEY,
     al_name VARCHAR(50) NOT NULL UNIQUE
  );

/*
 * Таблица "Должность-оклад"
 */
CREATE TABLE postsalary
  (
     ps_post   VARCHAR(50) PRIMARY KEY,
     ps_salary NUMERIC(8, 2) NOT NULL CHECK (ps_salary >= 15000)
  );

/*
 * Таблица "Модели"
 */
CREATE TABLE models
  (
     m_name VARCHAR(50) PRIMARY KEY
  );

/*
 * Табилца "Типы рейсов"
 */
CREATE TABLE flighttypes
  (
     ft_name VARCHAR(30) PRIMARY KEY
  );

/*
 * Таблица "Самолеты"
 */
CREATE TABLE airplanes
  (
     s_av        VARCHAR(20),
     s_num       VARCHAR(20),
     s_model     VARCHAR(50) REFERENCES models(m_name),
     s_date      DATE NOT NULL,
     s_lastcheck DATE NOT NULL,
     PRIMARY KEY(s_av, s_num),
     FOREIGN KEY(s_av) REFERENCES airlines(al_id)
  );

/*
 * Таблица "Сотрудники
 */
CREATE TABLE employees
  (
     e_dep    NUMERIC(4) REFERENCES departments(d_id),
     e_id     NUMERIC(8) PRIMARY KEY,
     e_fam    VARCHAR(20) NOT NULL,
     e_name   VARCHAR(20) NOT NULL,
     e_patr   VARCHAR(20) NOT NULL,
     e_gender CHAR(1) CHECK (e_gender IN ('м', 'ж')),
     e_dob    DATE NOT NULL,
     e_pass   CHAR(10) NOT NULL UNIQUE,
     e_given  CHAR(12) NOT NULL,
     e_date   DATE NOT NULL,
     e_inn    CHAR(12) NOT NULL UNIQUE,
     e_post   VARCHAR(50) REFERENCES postsalary(ps_post)
  );

/*
 * Таблица "Телефоны сотрудников"
 */
CREATE TABLE phones
  (
     t_emp NUMERIC(8) REFERENCES employees(e_id),
     t_num VARCHAR(20) PRIMARY KEY
  );

/*
 * Таблица "Рейсы"
 */
CREATE TABLE flights
  (
     f_id       INTEGER PRIMARY KEY,
     f_numb     NUMERIC(10) NOT NULL,
     f_ser      VARCHAR(20) NOT NULL,
     f_plane    VARCHAR(20) NOT NULL,
     f_airport  CHAR(3) NOT NULL,
     f_start    TIMESTAMP NOT NULL,
     f_end      TIMESTAMP NOT NULL,
     f_type     VARCHAR(30) NOT NULL,
     f_incoming BOOLEAN NOT NULL,
     FOREIGN KEY(f_ser, f_plane) REFERENCES airplanes(s_num, s_av),
     FOREIGN KEY (f_type) REFERENCES flighttypes(ft_name),
     FOREIGN KEY (f_airport) REFERENCES airports(ap_code)
  );

/*
 * Таблица "Обслуживание"
 */
CREATE TABLE service
  (
     serv_emp    NUMERIC(8),
     serv_flight INTEGER,
     PRIMARY KEY(serv_emp, serv_flight),
     FOREIGN KEY(serv_emp) REFERENCES employees(e_id),
     FOREIGN KEY (serv_flight) REFERENCES flights(f_id)
  ); 
