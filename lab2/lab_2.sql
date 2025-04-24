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


-- 1. Усі пацієнти
SELECT * FROM patients;

-- 2. Прийоми з діагнозом "Гіпертонія"
SELECT * FROM appointments WHERE diagnosis = 'Гіпертонія';

-- 3. Сортування лікарів за досвідом
SELECT * FROM doctors ORDER BY experience_years DESC;

-- 4. Кількість пацієнтів за статтю
SELECT gender, COUNT(*) FROM patients GROUP BY gender;

-- 5. Пацієнти з призначеними послугами
SELECT p.full_name, ms.name AS service_name, ps.assigned_date
FROM patient_services ps
JOIN patients p ON ps.patient_id = p.id
JOIN medical_services ms ON ps.service_id = ms.id;

-- 6. Кількість прийомів у кожного лікаря
SELECT d.full_name, COUNT(a.id) AS total_appointments
FROM appointments a
JOIN doctors d ON a.doctor_id = d.id
GROUP BY d.full_name;

-- 7. Середня ціна медичних послуг
SELECT AVG(price) AS avg_service_price FROM medical_services;

-- 8. Найдорожча послуга
SELECT * FROM medical_services ORDER BY price DESC LIMIT 1;

-- 9. Ліки, призначені пацієнтам
SELECT p.full_name, m.medication_name, m.dosage
FROM prescribed_medications m
JOIN patients p ON m.patient_id = p.id;

-- 10. Скільки пацієнтів має призначення ліків
SELECT COUNT(DISTINCT patient_id) FROM prescribed_medications;


