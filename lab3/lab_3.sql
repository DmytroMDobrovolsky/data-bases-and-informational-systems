-- Лабораторна робота №3
-- З дисципліни: Бази даних та інформаційні системи
-- Студент групи МІТ-31 Добровольський Дмитро
-- Тема: База даних лікарні

-- Пацієнти
INSERT INTO patients (full_name, birth_date, gender, phone) VALUES
('Іван Іваненко', '1990-01-10', 'чоловік', '+380501112233'),
('Олена Петрівна', '1985-05-20', 'жінка', '+380631234567'),
('Петро Сидоренко', '1975-12-05', 'чоловік', '+380971234567');

-- Лікарі
INSERT INTO doctors (full_name, specialty, experience_years, room_number) VALUES
('д-р Наталія Кохомієць', 'Кардіолог', 15, '101'),
('д-р Андрій Коваль', 'Терапевт', 10, '102'),
('д-р Оксана Бондаренко', 'Невролог', 12, '103');

-- Прийоми
INSERT INTO appointments (appointment_date, patient_id, doctor_id, diagnosis, notes) VALUES
('2025-04-10', 1, 1, 'Гіпертонія', 'Призначено аналіз крові'),
('2025-04-11', 2, 2, 'Застуда', 'Рекомендовано постільний режим'),
('2025-04-12', 3, 3, 'Мігрень', 'Призначено обстеження');

-- Медичні послуги
INSERT INTO medical_services (name, price) VALUES
('Аналіз крові', 300.00),
('МРТ головного мозку', 1500.00),
('ЕКГ', 400.00);

-- Призначені послуги
INSERT INTO patient_services (patient_id, service_id, assigned_date) VALUES
(1, 1, '2025-04-10'),
(3, 2, '2025-04-12'),
(2, 3, '2025-04-11');

-- Призначення ліків
INSERT INTO prescribed_medications (patient_id, medication_name, dosage, start_date, end_date) VALUES
(1, 'Еналаприл', '1 таблетка 2 рази на день', '2025-04-10', '2025-04-20'),
(2, 'Парацетамол', '500мг 3 рази на день', '2025-04-11', '2025-04-15');


-- Для запиту 14 (пацієнти з однаковим днем народження)
INSERT INTO patients (full_name, birth_date, gender, phone) VALUES
('Марія Дубенко', '1985-05-20', 'жінка', '+380671112233');

--Для запиту 16 та 28  (пацієнт з двома послугами)
INSERT INTO patient_services (patient_id, service_id, assigned_date) VALUES
(2, 1, '2025-04-13'); -- той самий пацієнт, ще одна послуга

--Для запиту 18 (однакові прізвища в пацієнтах і лікарях)
INSERT INTO patients (full_name, birth_date, gender, phone) VALUES
('д-р Оксана Бондаренко', '1992-08-08', 'жінка', '+380671234888');

--Для запиту 19 (пацієнт без жодного прийому)
INSERT INTO patients (full_name, birth_date, gender, phone) VALUES
('Андрій Безприйомний', '2000-07-15', 'чоловік', '+380991234321');

--Для запиту 29 (лікар з кількома пацієнтами)
-- д-р Наталія Кохомієць приймає ще одного пацієнта
INSERT INTO appointments (appointment_date, patient_id, doctor_id, diagnosis, notes) VALUES
('2025-04-14', 2, 1, 'ГРВІ', 'Призначено симптоматичне лікування');

--Для запиту 31 (лікар без прийомів)
INSERT INTO doctors (full_name, specialty, experience_years, room_number) VALUES
('д-р Сергій Безпацієнтов', 'Дерматолог', 8, '104');

-- Для запиту 32 (послуга, що не призначалась)
INSERT INTO medical_services (name, price) VALUES
('УЗД щитовидної залози', 500.00);

--Для запиту 33 (ліки з майбутнім end_date)
INSERT INTO prescribed_medications (patient_id, medication_name, dosage, start_date, end_date) VALUES
(3, 'Ібупрофен', '1 табл після їжі', '2025-04-22', '2025-05-05');

--Для запиту 34 (прийом на сьогодні)
INSERT INTO appointments (appointment_date, patient_id, doctor_id, diagnosis, notes) VALUES
(CURRENT_DATE, 1, 2, 'Головний біль', 'Рекомендовано обстеження');

-- Запит 1. Вивести всі записи з таблиці пацієнтів
SELECT * FROM patients;

-- Запит 2. Вивести всіх лікарів зі спеціалізацією 'Кардіолог'
SELECT * FROM doctors
WHERE specialty = 'Кардіолог';

-- Запит 3. Порахувати кількість прийомів у кожного лікаря
SELECT d.full_name, COUNT(a.id) AS total_appointments
FROM doctors d
LEFT JOIN appointments a ON d.id = a.doctor_id
GROUP BY d.full_name;

-- Запит 4. Знайти середню вартість медичних послуг
SELECT AVG(price) AS avg_price FROM medical_services;

-- Запит 5. Підрахувати кількість чоловіків і жінок серед пацієнтів
SELECT gender, COUNT(*) AS total FROM patients
GROUP BY gender;

-- Запит 6. З’єднання: список пацієнтів із призначеними послугами
SELECT p.full_name, ms.name AS service_name, ps.assigned_date
FROM patient_services ps
JOIN patients p ON ps.patient_id = p.id
JOIN medical_services ms ON ps.service_id = ms.id;

-- Запит 7. LEFT JOIN: усі пацієнти з інформацією про призначені послуги (навіть якщо послуг немає)
SELECT p.full_name, ms.name AS service_name
FROM patients p
LEFT JOIN patient_services ps ON p.id = ps.patient_id
LEFT JOIN medical_services ms ON ps.service_id = ms.id;

-- Запит 8. Підзапит у WHERE: знайти пацієнтів, які проходили 'МРТ головного мозку'
SELECT full_name FROM patients
WHERE id IN (
    SELECT patient_id FROM patient_services
    WHERE service_id = (
        SELECT id FROM medical_services WHERE name = 'МРТ головного мозку'
    )
);

-- Запит 9. Вивести найдорожчу медичну послугу
SELECT * FROM medical_services
ORDER BY price DESC LIMIT 1;

-- Запит 10. Скільки ліків було призначено кожному пацієнту (використання агрегатної функції)
SELECT p.full_name, COUNT(pm.id) AS medication_count
FROM patients p
LEFT JOIN prescribed_medications pm ON p.id = pm.patient_id
GROUP BY p.full_name;

-- Запит 11. RIGHT JOIN: всі медичні послуги з пацієнтами, яким їх призначили
SELECT ms.name, p.full_name
FROM medical_services ms
RIGHT JOIN patient_services ps ON ms.id = ps.service_id
RIGHT JOIN patients p ON p.id = ps.patient_id;

-- Запит 12. FULL OUTER JOIN: всі пацієнти і всі призначені послуги (враховуючи відсутність призначень)
SELECT p.full_name, ms.name AS service_name
FROM patients p
FULL OUTER JOIN patient_services ps ON p.id = ps.patient_id
FULL OUTER JOIN medical_services ms ON ps.service_id = ms.id;

-- Запит 13. CROSS JOIN: кожен пацієнт і кожна медична послуга (усі можливі комбінації)
SELECT p.full_name, ms.name
FROM patients p
CROSS JOIN medical_services ms;

-- Запит 14. SELF JOIN: пацієнти, які народились в один день
SELECT p1.full_name AS patient1, p2.full_name AS patient2, p1.birth_date
FROM patients p1
JOIN patients p2 ON p1.birth_date = p2.birth_date AND p1.id <> p2.id;

-- Запит 15. Пацієнти, які не мають призначених ліків (NOT EXISTS)
SELECT full_name FROM patients p
WHERE NOT EXISTS (
    SELECT 1 FROM prescribed_medications pm WHERE pm.patient_id = p.id
);

-- Запит 16. Пацієнти, які мають більше одного призначення послуг (HAVING + COUNT)
SELECT p.full_name, COUNT(ps.id) AS service_count
FROM patients p
JOIN patient_services ps ON p.id = ps.patient_id
GROUP BY p.full_name
HAVING COUNT(ps.id) > 1;

-- Запит 17. UNION: всі імена пацієнтів і лікарів (одна колонка)
SELECT full_name FROM patients
UNION
SELECT full_name FROM doctors;

-- Запит 18. INTERSECT: пацієнти, які є одночасно лікарями (теоретично)
SELECT full_name FROM patients
INTERSECT
SELECT full_name FROM doctors;

-- Запит 19. EXCEPT: пацієнти, які не мають жодного прийому
SELECT full_name FROM patients
EXCEPT
SELECT DISTINCT p.full_name
FROM patients p
JOIN appointments a ON p.id = a.patient_id;

-- Запит 20. Підзапит у SELECT: вивести пацієнтів з кількістю призначень
SELECT full_name,
    (SELECT COUNT(*) FROM patient_services ps WHERE ps.patient_id = p.id) AS service_count
FROM patients p;

-- Запит 21. CTE: найзавантаженіші лікарі за кількістю прийомів
WITH doctor_appointments AS (
    SELECT doctor_id, COUNT(*) AS total
    FROM appointments
    GROUP BY doctor_id
)
SELECT d.full_name, da.total
FROM doctor_appointments da
JOIN doctors d ON da.doctor_id = d.id
ORDER BY da.total DESC;

-- Запит 22. CTE з підзапитом: лікарі, які мають прийоми з діагнозом "Гіпертонія"
WITH hypertensive_appointments AS (
    SELECT doctor_id
    FROM appointments
    WHERE diagnosis = 'Гіпертонія'
)
SELECT DISTINCT d.full_name
FROM doctors d
JOIN hypertensive_appointments ha ON d.id = ha.doctor_id;

-- Запит 23. Віконна функція: номер кожного пацієнта за алфавітом
SELECT full_name, ROW_NUMBER() OVER (ORDER BY full_name) AS row_num
FROM patients;

-- Запит 24. Віконна функція: кількість призначень для кожного пацієнта (без GROUP BY)
SELECT full_name,
       COUNT(*) OVER (PARTITION BY p.id) AS total_services
FROM patients p
JOIN patient_services ps ON p.id = ps.patient_id;

-- Запит 25. Віконна функція: ранжування лікарів за кількістю років досвіду
SELECT full_name, specialty, experience_years,
       RANK() OVER (ORDER BY experience_years DESC) AS rank_by_experience
FROM doctors;

-- Запит 26. Знайти наймолодшого пацієнта
SELECT * FROM patients
ORDER BY birth_date DESC
LIMIT 1;

-- Запит 27. Порахувати середню кількість прийомів на одного лікаря
SELECT AVG(appointment_count) AS avg_appointments
FROM (
    SELECT doctor_id, COUNT(*) AS appointment_count
    FROM appointments
    GROUP BY doctor_id
) sub;

-- Запит 28. Пацієнти, які проходили більше однієї послуги
SELECT p.full_name, COUNT(*) AS service_count
FROM patient_services ps
JOIN patients p ON p.id = ps.patient_id
GROUP BY p.full_name
HAVING COUNT(*) > 1;

-- Запит 29. Лікарі, у яких більше одного пацієнта
SELECT d.full_name, COUNT(DISTINCT a.patient_id) AS unique_patients
FROM doctors d
JOIN appointments a ON d.id = a.doctor_id
GROUP BY d.full_name
HAVING COUNT(DISTINCT a.patient_id) > 1;

-- Запит 30. Пацієнти з принаймні однією призначеною послугою або ліками
SELECT DISTINCT p.full_name
FROM patients p
LEFT JOIN patient_services ps ON p.id = ps.patient_id
LEFT JOIN prescribed_medications pm ON p.id = pm.patient_id
WHERE ps.id IS NOT NULL OR pm.id IS NOT NULL;

-- Запит 31. Лікарі без прийомів
SELECT full_name FROM doctors
WHERE id NOT IN (SELECT DISTINCT doctor_id FROM appointments);

-- Запит 32. Послуги, які не були нікому призначені
SELECT name FROM medical_services
WHERE id NOT IN (SELECT DISTINCT service_id FROM patient_services);

-- Запит 33. Ліки, які ще не завершилися (активні)
SELECT * FROM prescribed_medications
WHERE end_date > CURRENT_DATE;

-- Запит 34. Пацієнти, у яких сьогодні прийом
SELECT p.full_name FROM appointments a
JOIN patients p ON a.patient_id = p.id
WHERE appointment_date = CURRENT_DATE;

-- Запит 35. Вивести всі діагнози без повторів
SELECT DISTINCT diagnosis FROM appointments;

-- Запит 36. Найстарший пацієнт
SELECT * FROM patients
ORDER BY birth_date ASC
LIMIT 1;

-- Запит 37. Список лікарів з кількістю років досвіду більше середнього
SELECT * FROM doctors
WHERE experience_years > (SELECT AVG(experience_years) FROM doctors);

-- Запит 38. Вивести пацієнтів, у яких були і прийоми, і призначені ліки
SELECT DISTINCT p.full_name
FROM patients p
JOIN appointments a ON p.id = a.patient_id
JOIN prescribed_medications pm ON p.id = pm.patient_id;

-- Запит 39. Вивести кількість пацієнтів на кожну послугу
SELECT ms.name, COUNT(ps.patient_id) AS total_patients
FROM medical_services ms
LEFT JOIN patient_services ps ON ms.id = ps.service_id
GROUP BY ms.name;

-- Запит 40. Останній прийом кожного пацієнта (віконна функція)
SELECT full_name, appointment_date
FROM (
    SELECT p.full_name, a.appointment_date,
           ROW_NUMBER() OVER (PARTITION BY p.id ORDER BY a.appointment_date DESC) AS rn
    FROM patients p
    JOIN appointments a ON p.id = a.patient_id
) sub
WHERE rn = 1;

