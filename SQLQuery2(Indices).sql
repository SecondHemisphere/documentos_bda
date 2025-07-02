USE stockmate;

-- ========================================
-- PROCEDIMIENTO PARA ELIMINAR ÍNDICES SI EXISTEN
-- ========================================

DELIMITER $$

CREATE PROCEDURE DropIndexIfExists(
    IN tbl VARCHAR(64),  -- Nombre de la tabla
    IN idx VARCHAR(64)   -- Nombre del índice
)
BEGIN
    DECLARE idx_count INT DEFAULT 0;  -- Variable para contar índices existentes

    -- Verificar si el índice existe en la tabla y base de datos actual
    SELECT COUNT(*)
    INTO idx_count
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()  -- Base de datos actual
      AND table_name = tbl           -- Tabla específica
      AND index_name = idx;          -- Índice específico

    -- Si existe al menos un índice con ese nombre, proceder a eliminarlo
    IF idx_count > 0 THEN
        -- Construir la consulta ALTER TABLE para eliminar el índice
        SET @s = CONCAT('ALTER TABLE ', tbl, ' DROP INDEX ', idx);
        
        -- Preparar y ejecutar la consulta dinámica
        PREPARE stmt FROM @s;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END$$

DELIMITER ;

-- ========================================
-- EJECUCIÓN DEL PROCEDIMIENTO PARA ELIMINAR ÍNDICES SI EXISTEN
-- ========================================

CALL DropIndexIfExists('productos', 'idx_productos_categoria');
CALL DropIndexIfExists('productos', 'idx_productos_proveedor');

CALL DropIndexIfExists('ventas', 'idx_ventas_cliente');
CALL DropIndexIfExists('ventas', 'idx_ventas_usuario');

CALL DropIndexIfExists('compras', 'idx_compras_producto');
CALL DropIndexIfExists('compras', 'idx_compras_usuario');

CALL DropIndexIfExists('detalles_venta', 'idx_detalles_venta_venta');
CALL DropIndexIfExists('detalles_venta', 'idx_detalles_venta_producto');

-- ========================================
-- CREACIÓN DE LOS ÍNDICES NUEVOS
-- ========================================

-- Índice para acelerar búsquedas en productos por categoría
CREATE INDEX idx_productos_categoria ON productos(categoria_id);

-- Índice para acelerar búsquedas en productos por proveedor
CREATE INDEX idx_productos_proveedor ON productos(proveedor_id);

-- Índice para acelerar búsquedas en ventas por cliente
CREATE INDEX idx_ventas_cliente ON ventas(cliente_id);

-- Índice para acelerar búsquedas en ventas por usuario (vendedor)
CREATE INDEX idx_ventas_usuario ON ventas(usuario_id);

-- Índice para acelerar búsquedas en compras por producto
CREATE INDEX idx_compras_producto ON compras(producto_id);

-- Índice para acelerar búsquedas en compras por usuario (quien registró)
CREATE INDEX idx_compras_usuario ON compras(usuario_id);

-- Índice para acelerar búsquedas en detalles de venta por venta
CREATE INDEX idx_detalles_venta_venta ON detalles_venta(venta_id);

-- Índice para acelerar búsquedas en detalles de venta por producto
CREATE INDEX idx_detalles_venta_producto ON detalles_venta(producto_id);