CREATE TEMPORARY TABLE TempProducts (
    Id UUID,
    Name VARCHAR(30) NOT NULL,
    Price NUMERIC(10,2) NOT NULL,
    Quantity INTEGER NOT NULL
);

INSERT INTO TempProducts VALUES
    (gen_random_uuid(), 'Book',         50.20, 0),
    (gen_random_uuid(), 'Computer',   2050.10, 0),
    (gen_random_uuid(), 'Table',       400.00, 0),
    (gen_random_uuid(), 'Monitor',     250.70, 0),
    (gen_random_uuid(), 'Charger',      30.00, 0),
    (gen_random_uuid(), 'Printer',    1540.50, 0),
    (gen_random_uuid(), 'Headphones',  350.00, 0);

CREATE TABLE IF NOT EXISTS public.Products (
    Id UUID,
    Name VARCHAR(30) NOT NULL,
    Price NUMERIC(10,2) NOT NULL,
    Quantity INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT PK_PRODUCTS_ID PRIMARY KEY (Id)
);

INSERT INTO public.Products
SELECT * FROM TempProducts
WHERE NOT EXISTS (SELECT * FROM public.Products);

DROP TABLE TempProducts;
