INSERT INTO zaly (nazva, povershnya, tematyka) VALUES
('Стародавній Єгипет', 1, 'Археологія'),
('Ренесанс', 2, 'Живопис'),
('Сучасне мистецтво', 3, 'Авангард'),
('Природнича колекція', 1, 'Біологія'),
('Історія України', 2, 'Історія');


INSERT INTO eksponaty (nazva, rik_stvorennya, avtor, typ, zal_id) VALUES
('Статуя Рамзеса', -1250, 'Невідомий', 'Скульптура', 2),
('Мона Ліза', 1503, 'Леонардо да Вінчі', 'Картина', 3),
('Чорний квадрат', 1915, 'Казимир Малевич', 'Живопис', 4),
('Скелет динозавра', -70000000, 'Природа', 'Мінералогія', 5),
('Кобзар Тараса Шевченка', 1840, 'Тарас Шевченко', 'Книга', 6);


INSERT INTO vidviduvachi (imya, prizvyshche, kontakt_email, data_vidviduvannya) VALUES
('Іван', 'Петренко', 'ivan.petrenko@example.com', '2025-04-20'),
('Олена', 'Ковальчук', 'olena.kov@example.com', '2025-04-20'),
('Максим', 'Дорошенко', 'maks.dor@example.com', '2025-04-21'),
('Наталія', 'Гриценко', 'nat.hry@example.com', '2025-04-21'),
('Сергій', 'Левицький', 'serg.lev@example.com', '2025-04-22');




select * from zaly;
select * from eksponaty;
select * from vidviduvachi;

UPDATE eksponaty 
SET typ = 'Артефакт' 
WHERE id = 10;


DELETE FROM vidviduvachi
WHERE id = 5;
