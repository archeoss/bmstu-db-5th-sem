CREATE TABLE context (
    data jsonb
);
drop table context;
INSERT INTO context (data) VALUES
    ('{"name": "Simeon", "age":20, "weapon": {"name": "AA12", "quality": "Good", "ammo": 8}}'),
    ('{"name": "Constantin", "age": 50, "weapon": {"name": "M4A1", "quality": "Good", "ammo": 30}}'),
    ('{"name": "Ivan", "age": 30, "weapon": {"name": "AK-47", "quality": "Bad", "ammo": 30}}');

-- Извлечь XML/JSON фрагмент из XML/JSON документа
select data->'weapon' weapon from context;

-- Извлечь значения конкретных узлов или атрибутов XML/JSON документа
select data->'weapon'->'name' weapon from context;

-- Выполнить проверку существования узла или атрибута.
CREATE FUNCTION key_exists(json_to_check jsonb, key text)
    RETURNS BOOLEAN
AS $$
BEGIN
    RETURN (json_to_check->key) IS NOT NULL;
END;
$$ LANGUAGE PLPGSQL;
SELECT key_exists( (SELECT * from context limit 1), 'age');
SELECT key_exists((SELECT * from context limit 1), 'last_name');

-- Изменить JSON документ.
UPDATE context SET data = data || '{"age": 21}'::jsonb WHERE (data->'age')::INT = 20;
select * from context;

-- Разделить XML/JSON документ на несколько строк по узлам
SELECT * FROM jsonb_array_elements('[
{"name": "Simeon", "age":20, "weapon": {"name": "AA12", "quality": "Good", "ammo": 8}},
{"name": "Constantin", "age": 50, "weapon": {"name": "M4A1", "quality": "Good", "ammo": 30}},
{"name": "Ivan", "age": 30, "weapon": {"name": "AK-47", "quality": "Bad", "ammo": 30}}]'::jsonb);

SELECT * FROM context;

-- Защита

SELECT row_to_json(r) FROM (SELECT name, count(*) as count, AVG(capacity) as avg FROM military_base.vehicles GROUP BY name) r;
