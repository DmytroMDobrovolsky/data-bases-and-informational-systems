
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


--  (пацієнти з однаковим днем народження)
INSERT INTO patients (full_name, birth_date, gender, phone) VALUES
('Марія Дубенко', '1985-05-20', 'жінка', '+380671112233');

-- (пацієнт з двома послугами)
INSERT INTO patient_services (patient_id, service_id, assigned_date) VALUES
(2, 1, '2025-04-13'); -- той самий пацієнт, ще одна послуга

--(однакові прізвища в пацієнтах і лікарях)
INSERT INTO patients (full_name, birth_date, gender, phone) VALUES
('д-р Оксана Бондаренко', '1992-08-08', 'жінка', '+380671234888');

-- (пацієнт без жодного прийому)
INSERT INTO patients (full_name, birth_date, gender, phone) VALUES
('Андрій Безприйомний', '2000-07-15', 'чоловік', '+380991234321');

-- (лікар з кількома пацієнтами)
-- д-р Наталія Кохомієць приймає ще одного пацієнта
INSERT INTO appointments (appointment_date, patient_id, doctor_id, diagnosis, notes) VALUES
('2025-04-14', 2, 1, 'ГРВІ', 'Призначено симптоматичне лікування');

--(лікар без прийомів)
INSERT INTO doctors (full_name, specialty, experience_years, room_number) VALUES
('д-р Сергій Безпацієнтов', 'Дерматолог', 8, '104');

--  (послуга, що не призначалась)
INSERT INTO medical_services (name, price) VALUES
('УЗД щитовидної залози', 500.00);

--(ліки з майбутнім end_date)
INSERT INTO prescribed_medications (patient_id, medication_name, dosage, start_date, end_date) VALUES
(3, 'Ібупрофен', '1 табл після їжі', '2025-04-22', '2025-05-05');

--(прийом на сьогодні)
INSERT INTO appointments (appointment_date, patient_id, doctor_id, diagnosis, notes) VALUES
(CURRENT_DATE, 1, 2, 'Головний біль', 'Рекомендовано обстеження');

-- Створення ENUM типу для статусу пацієнта
CREATE TYPE patient_status AS ENUM ('активний', 'виписаний', 'переведений');

-- Додавання колонки до таблиці пацієнтів
ALTER TABLE patients ADD COLUMN status patient_status DEFAULT 'активний';

-- функція для обчислення середньої кількості прийомів на лікаря.
CREATE OR REPLACE FUNCTION avg_appointments_per_doctor() RETURNS NUMERIC AS $$
DECLARE
    result NUMERIC;
BEGIN
    SELECT COUNT(*) * 1.0 / COUNT(DISTINCT doctor_id) INTO result FROM appointments;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Тестовий запит:
SELECT avg_appointments_per_doctor();

-- Таблиця для логів
CREATE TABLE appointment_logs (
    log_id SERIAL PRIMARY KEY,
    appointment_id INT,
    operation_type TEXT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Функція логування
CREATE OR REPLACE FUNCTION log_appointment_changes() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO appointment_logs (appointment_id, operation_type)
    VALUES (
        COALESCE(NEW.id, OLD.id),
        TG_OP
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Тригер
CREATE TRIGGER trg_log_appointment
AFTER INSERT OR UPDATE OR DELETE ON appointments
FOR EACH ROW
EXECUTE FUNCTION log_appointment_changes();

-- Тест 1: Змінимо статус пацієнта
UPDATE patients 
SET status = 'виписаний' WHERE id = 1;

select * from patients;

-- Тест 2: Додамо новий прийом
INSERT INTO appointments (appointment_date, patient_id, doctor_id, diagnosis, notes)
VALUES (CURRENT_DATE, 1, 1, 'Новий діагноз', 'Примітка до прийому');

select * from appointments;

-- Тест 3: Перевіримо лог
SELECT * FROM appointment_logs ORDER BY changed_at DESC;

-- Тест 4: Виклик користувацької функції
SELECT avg_appointments_per_doctor();

