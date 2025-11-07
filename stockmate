-- ========================================
-- ELIMINACIÓN Y CREACIÓN DE BASE DE DATOS
-- ========================================
DROP DATABASE IF EXISTS stockmate;
CREATE DATABASE stockmate CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE stockmate;

-- ========================================
-- ELIMINACIÓN Y CREACIÓN DE TABLESPACES PERSONALIZADOS
-- ========================================

-- Tablespace: ts_productos
DROP TABLESPACE ts_productos;

CREATE TABLESPACE ts_productos
  ADD DATAFILE 'ts_productos.ibd'
  ENGINE = InnoDB;

-- Tablespace: ts_ventas
DROP TABLESPACE ts_ventas;

CREATE TABLESPACE ts_ventas
  ADD DATAFILE 'ts_ventas.ibd'
  ENGINE = InnoDB;

-- ========================================
-- TABLAS DE SEGURIDAD Y ROLES
-- ========================================

-- Tabla: roles
-- Descripción: Define los roles del sistema (Admin, Almacenero, Cajero, etc.)
CREATE TABLE IF NOT EXISTS roles (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla: permisos
-- Descripción: Permisos o acciones específicas asignables a roles
CREATE TABLE IF NOT EXISTS permisos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla: rol_permiso
-- Descripción: Relación N:M entre roles y permisos
CREATE TABLE IF NOT EXISTS rol_permiso (
    rol_id BIGINT UNSIGNED NOT NULL,
    permiso_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (rol_id, permiso_id),
    FOREIGN KEY (rol_id) REFERENCES roles(id) ON DELETE CASCADE,
    FOREIGN KEY (permiso_id) REFERENCES permisos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla: usuarios
-- Descripción: Usuarios del sistema (con su rol correspondiente)
CREATE TABLE IF NOT EXISTS usuarios (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    correo VARCHAR(255) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    rol_id BIGINT UNSIGNED NOT NULL,
    estado ENUM('ACTIVO', 'INACTIVO') DEFAULT 'ACTIVO',
    FOREIGN KEY (rol_id) REFERENCES roles(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================
-- TABLAS GENERALES
-- ========================================

-- Tabla: categorias
-- Descripción: Categorías de productos
CREATE TABLE IF NOT EXISTS categorias (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    estado ENUM('ACTIVO', 'INACTIVO') DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla: proveedores
-- Descripción: Proveedores de productos
CREATE TABLE IF NOT EXISTS proveedores (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    correo VARCHAR(255) UNIQUE,
    telefono VARCHAR(20),
    direccion TEXT,
    estado ENUM('ACTIVO', 'INACTIVO') DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla: clientes
-- Descripción: Clientes de las ventas realizadas
CREATE TABLE IF NOT EXISTS clientes (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    correo VARCHAR(255) UNIQUE,
    telefono VARCHAR(20),
    direccion TEXT,
    estado ENUM('ACTIVO', 'INACTIVO') DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================
-- TABLAS CON VOLUMEN USANDO TABLESPACES
-- ========================================

-- Tabla: productos
-- Descripción: Productos de inventario
-- Tablespace: ts_productos
CREATE TABLE IF NOT EXISTS productos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    categoria_id BIGINT UNSIGNED,
    proveedor_id BIGINT UNSIGNED,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT NOT NULL,
    precio_compra DECIMAL(10,2) NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,
    stock_actual INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 10,
    ruta_imagen VARCHAR(255),
    estado ENUM('ACTIVO', 'INACTIVO') DEFAULT 'ACTIVO',
    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE SET NULL,
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(id) ON DELETE SET NULL
) TABLESPACE ts_productos
  ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla: compras
-- Descripción: Registro de compras de productos realizadas por usuarios
-- Tablespace: ts_productos
CREATE TABLE IF NOT EXISTS compras (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    producto_id BIGINT UNSIGNED NOT NULL,
    usuario_id BIGINT UNSIGNED NOT NULL,
    monto_total DECIMAL(10,2) NOT NULL,
    cantidad INT UNSIGNED NOT NULL,
    fecha_transaccion DATETIME NOT NULL,
    FOREIGN KEY (producto_id) REFERENCES productos(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
) TABLESPACE ts_productos
  ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla: ventas
-- Descripción: Ventas realizadas a clientes
-- Tablespace: ts_ventas
CREATE TABLE IF NOT EXISTS ventas (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    cliente_id BIGINT UNSIGNED NOT NULL,
    usuario_id BIGINT UNSIGNED NOT NULL,
    numero_factura VARCHAR(255) NOT NULL UNIQUE,
    monto_total DECIMAL(10,2) NOT NULL DEFAULT 0,
    porcentaje_descuento TINYINT NOT NULL DEFAULT 0,
    monto_descuento DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_con_iva DECIMAL(10,2) NOT NULL DEFAULT 0,
    fecha DATETIME NOT NULL,
    metodo_pago ENUM('EFECTIVO', 'TARJETA_CREDITO', 'TARJETA_DEBITO', 'TRANSFERENCIA', 'OTRO') NOT NULL DEFAULT 'EFECTIVO',
    observaciones TEXT,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
) TABLESPACE ts_ventas
  ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla: detalles_venta
-- Descripción: Detalle de productos vendidos en cada venta
-- Tablespace: ts_ventas (hereda tablespace de ventas si se requiere)
CREATE TABLE IF NOT EXISTS detalles_venta (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    venta_id BIGINT UNSIGNED NOT NULL,
    producto_id BIGINT UNSIGNED NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    precio_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (venta_id) REFERENCES ventas(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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


-- ========================================
-- ELIMINACIÓN DE TRIGGERS EXISTENTES
-- ========================================
DROP TRIGGER IF EXISTS trg_reducir_stock_venta;
DROP TRIGGER IF EXISTS trg_restaurar_stock_venta;
DROP TRIGGER IF EXISTS trg_actualizar_stock_venta;
DROP TRIGGER IF EXISTS trg_prevenir_stock_negativo;
DROP TRIGGER IF EXISTS trg_calcular_precios_detalle_venta_before_insert;
DROP TRIGGER IF EXISTS trg_calcular_precios_detalle_venta_before_update;
DROP TRIGGER IF EXISTS trg_actualizar_totales_venta_after_insert;
DROP TRIGGER IF EXISTS trg_actualizar_totales_venta_after_delete;
DROP TRIGGER IF EXISTS trg_actualizar_totales_venta_after_update;
DROP TRIGGER IF EXISTS trg_aumentar_stock_compra;
DROP TRIGGER IF EXISTS trg_disminuir_stock_eliminar_compra;
DROP TRIGGER IF EXISTS trg_actualizar_stock_compra;

DELIMITER $$

-- ========================================
-- TRIGGERS PARA DETALLES DE VENTA
-- ========================================

-- Trigger: trg_calcular_precios_detalle_venta_before_insert
-- Descripción: Antes de insertar en detalles_venta, calcula precio_unitario y precio_total
CREATE TRIGGER trg_calcular_precios_detalle_venta_before_insert
BEFORE INSERT ON detalles_venta
FOR EACH ROW
BEGIN
  DECLARE precio DECIMAL(10,2);
  SELECT precio_venta INTO precio FROM productos WHERE id = NEW.producto_id;
  SET NEW.precio_unitario = precio;
  SET NEW.precio_total = precio * NEW.cantidad;
END$$

-- Trigger: trg_calcular_precios_detalle_venta_before_update
-- Descripción: Antes de actualizar detalles_venta, recalcula precio_unitario y precio_total
CREATE TRIGGER trg_calcular_precios_detalle_venta_before_update
BEFORE UPDATE ON detalles_venta
FOR EACH ROW
BEGIN
  DECLARE precio DECIMAL(10,2);
  SELECT precio_venta INTO precio FROM productos WHERE id = NEW.producto_id;
  SET NEW.precio_unitario = precio;
  SET NEW.precio_total = precio * NEW.cantidad;
END$$

-- Trigger: trg_reducir_stock_venta
-- Descripción: Después de insertar detalle de venta, reduce stock del producto vendido
CREATE TRIGGER trg_reducir_stock_venta
AFTER INSERT ON detalles_venta
FOR EACH ROW
BEGIN
  UPDATE productos
  SET stock_actual = stock_actual - NEW.cantidad
  WHERE id = NEW.producto_id;
END$$

-- Trigger: trg_restaurar_stock_venta
-- Descripción: Después de eliminar detalle de venta, restaura stock del producto
CREATE TRIGGER trg_restaurar_stock_venta
AFTER DELETE ON detalles_venta
FOR EACH ROW
BEGIN
  UPDATE productos
  SET stock_actual = stock_actual + OLD.cantidad
  WHERE id = OLD.producto_id;
END$$

-- Trigger: trg_actualizar_stock_venta
-- Descripción: Después de actualizar detalle de venta, ajusta stock considerando cambios de cantidad
CREATE TRIGGER trg_actualizar_stock_venta
AFTER UPDATE ON detalles_venta
FOR EACH ROW
BEGIN
  -- Sumar la cantidad anterior
  UPDATE productos
  SET stock_actual = stock_actual + OLD.cantidad
  WHERE id = OLD.producto_id;

  -- Restar la nueva cantidad
  UPDATE productos
  SET stock_actual = stock_actual - NEW.cantidad
  WHERE id = NEW.producto_id;
END$$

-- Trigger: trg_prevenir_stock_negativo
-- Descripción: Antes de insertar detalle de venta, previene stock negativo validando existencia
CREATE TRIGGER trg_prevenir_stock_negativo
BEFORE INSERT ON detalles_venta
FOR EACH ROW
BEGIN
  DECLARE stock_disponible INT;
  SELECT stock_actual INTO stock_disponible FROM productos WHERE id = NEW.producto_id;
  IF stock_disponible < NEW.cantidad THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No hay suficiente stock disponible para realizar la venta.';
  END IF;
END$$

-- Trigger: trg_actualizar_totales_venta_after_insert
-- Descripción: Después de insertar detalle de venta, actualiza montos y total con IVA en ventas
CREATE TRIGGER trg_actualizar_totales_venta_after_insert
AFTER INSERT ON detalles_venta
FOR EACH ROW
BEGIN
    DECLARE v_subtotal_sin_descuento DECIMAL(10,2);
    DECLARE v_porcentaje_desc_venta TINYINT;
    DECLARE v_monto_desc_calculado DECIMAL(10,2);
    DECLARE v_tasa_iva DECIMAL(5,2) DEFAULT 0.15;

    SELECT COALESCE(SUM(precio_total), 0)
    INTO v_subtotal_sin_descuento
    FROM detalles_venta
    WHERE venta_id = NEW.venta_id;

    SELECT porcentaje_descuento
    INTO v_porcentaje_desc_venta
    FROM ventas
    WHERE id = NEW.venta_id;

    SET v_monto_desc_calculado = v_subtotal_sin_descuento * (v_porcentaje_desc_venta / 100);

    UPDATE ventas
    SET
        monto_total = v_subtotal_sin_descuento,
        monto_descuento = v_monto_desc_calculado,
        total_con_iva = (v_subtotal_sin_descuento - v_monto_desc_calculado) * (1 + v_tasa_iva)
    WHERE id = NEW.venta_id;
END$$

-- Trigger: trg_actualizar_totales_venta_after_delete
-- Descripción: Después de eliminar detalle de venta, actualiza montos y total con IVA en ventas
CREATE TRIGGER trg_actualizar_totales_venta_after_delete
AFTER DELETE ON detalles_venta
FOR EACH ROW
BEGIN
    DECLARE v_subtotal_sin_descuento DECIMAL(10,2);
    DECLARE v_porcentaje_desc_venta TINYINT;
    DECLARE v_monto_desc_calculado DECIMAL(10,2);
    DECLARE v_tasa_iva DECIMAL(5,2) DEFAULT 0.15;

    SELECT COALESCE(SUM(precio_total), 0)
    INTO v_subtotal_sin_descuento
    FROM detalles_venta
    WHERE venta_id = OLD.venta_id;

    SELECT porcentaje_descuento
    INTO v_porcentaje_desc_venta
    FROM ventas
    WHERE id = OLD.venta_id;

    SET v_monto_desc_calculado = v_subtotal_sin_descuento * (v_porcentaje_desc_venta / 100);

    UPDATE ventas
    SET
        monto_total = v_subtotal_sin_descuento,
        monto_descuento = v_monto_desc_calculado,
        total_con_iva = (v_subtotal_sin_descuento - v_monto_desc_calculado) * (1 + v_tasa_iva)
    WHERE id = OLD.venta_id;
END$$

-- Trigger: trg_actualizar_totales_venta_after_update
-- Descripción: Después de actualizar detalle de venta, actualiza montos y total con IVA en ventas (maneja cambio de venta_id)
CREATE TRIGGER trg_actualizar_totales_venta_after_update
AFTER UPDATE ON detalles_venta
FOR EACH ROW
BEGIN
    DECLARE v_subtotal_sin_descuento DECIMAL(10,2);
    DECLARE v_porcentaje_desc_venta TINYINT;
    DECLARE v_monto_desc_calculado DECIMAL(10,2);
    DECLARE v_tasa_iva DECIMAL(5,2) DEFAULT 0.15;

    -- Actualizar venta destino
    SELECT COALESCE(SUM(precio_total), 0)
    INTO v_subtotal_sin_descuento
    FROM detalles_venta
    WHERE venta_id = NEW.venta_id;

    SELECT porcentaje_descuento
    INTO v_porcentaje_desc_venta
    FROM ventas
    WHERE id = NEW.venta_id;

    SET v_monto_desc_calculado = v_subtotal_sin_descuento * (v_porcentaje_desc_venta / 100);

    UPDATE ventas
    SET
        monto_total = v_subtotal_sin_descuento,
        monto_descuento = v_monto_desc_calculado,
        total_con_iva = (v_subtotal_sin_descuento - v_monto_desc_calculado) * (1 + v_tasa_iva)
    WHERE id = NEW.venta_id;

    -- Actualizar venta origen si cambió
    IF OLD.venta_id <> NEW.venta_id THEN
        SELECT COALESCE(SUM(precio_total), 0)
        INTO v_subtotal_sin_descuento
        FROM detalles_venta
        WHERE venta_id = OLD.venta_id;

        SELECT porcentaje_descuento
        INTO v_porcentaje_desc_venta
        FROM ventas
        WHERE id = OLD.venta_id;

        SET v_monto_desc_calculado = v_subtotal_sin_descuento * (v_porcentaje_desc_venta / 100);

        UPDATE ventas
        SET
            monto_total = v_subtotal_sin_descuento,
            monto_descuento = v_monto_desc_calculado,
            total_con_iva = (v_subtotal_sin_descuento - v_monto_desc_calculado) * (1 + v_tasa_iva)
        WHERE id = OLD.venta_id;
    END IF;
END$$

-- ========================================
-- TRIGGERS PARA COMPRAS
-- ========================================

-- Trigger: trg_aumentar_stock_compra
-- Descripción: Después de insertar compra, aumenta stock del producto comprado
CREATE TRIGGER trg_aumentar_stock_compra
AFTER INSERT ON compras
FOR EACH ROW
BEGIN
  UPDATE productos
  SET stock_actual = stock_actual + NEW.cantidad
  WHERE id = NEW.producto_id;
END$$

-- Trigger: trg_disminuir_stock_eliminar_compra
-- Descripción: Después de eliminar compra, disminuye stock del producto comprado
CREATE TRIGGER trg_disminuir_stock_eliminar_compra
AFTER DELETE ON compras
FOR EACH ROW
BEGIN
  UPDATE productos
  SET stock_actual = stock_actual - OLD.cantidad
  WHERE id = OLD.producto_id;
END$$

-- Trigger: trg_actualizar_stock_compra
-- Descripción: Después de actualizar compra, ajusta stock considerando cambios de cantidad
CREATE TRIGGER trg_actualizar_stock_compra
AFTER UPDATE ON compras
FOR EACH ROW
BEGIN
  -- Restar la cantidad anterior
  UPDATE productos
  SET stock_actual = stock_actual - OLD.cantidad
  WHERE id = OLD.producto_id;

  -- Sumar la nueva cantidad
  UPDATE productos
  SET stock_actual = stock_actual + NEW.cantidad
  WHERE id = NEW.producto_id;
END$$

DELIMITER ;

-- ============================================
-- ELIMINACIÓN DE PROCEDIMIENTOS ALMACENADOS EXISTENTES
-- ============================================
DROP PROCEDURE IF EXISTS sp_filtrar_roles;
DROP PROCEDURE IF EXISTS sp_filtrar_categorias;
DROP PROCEDURE IF EXISTS sp_filtrar_usuarios;
DROP PROCEDURE IF EXISTS sp_filtrar_proveedores;
DROP PROCEDURE IF EXISTS sp_filtrar_clientes;
DROP PROCEDURE IF EXISTS sp_filtrar_productos;
DROP PROCEDURE IF EXISTS sp_filtrar_compras;
DROP PROCEDURE IF EXISTS sp_filtrar_ventas;
DROP PROCEDURE IF EXISTS sp_total_unidades_vendidas;
DROP PROCEDURE IF EXISTS sp_total_categorias;
DROP PROCEDURE IF EXISTS sp_total_productos;
DROP PROCEDURE IF EXISTS sp_total_proveedores;
DROP PROCEDURE IF EXISTS sp_total_clientes;
DROP PROCEDURE IF EXISTS sp_total_usuarios;
DROP PROCEDURE IF EXISTS sp_total_stock_critico;
DROP PROCEDURE IF EXISTS sp_productos_stock_critico;
DROP PROCEDURE IF EXISTS sp_total_facturas;
DROP PROCEDURE IF EXISTS sp_total_ganancias;
DROP PROCEDURE IF EXISTS sp_ganancia_dia;
DROP PROCEDURE IF EXISTS sp_ganancia_mes_actual;
DROP PROCEDURE IF EXISTS sp_top_productos_vendidos;
DROP PROCEDURE IF EXISTS sp_total_ventas_hoy;
DROP PROCEDURE IF EXISTS sp_monto_total_ventas_hoy;
DROP PROCEDURE IF EXISTS sp_stock_total;

DELIMITER $$

-- ============================================
-- 1. sp_filtrar_roles
-- Descripción: Filtra roles por nombre
-- ============================================
CREATE PROCEDURE sp_filtrar_roles (
  IN p_busqueda VARCHAR(100)
)
BEGIN
  SELECT * FROM roles
  WHERE nombre LIKE CONCAT('%', p_busqueda, '%');
END$$

-- ============================================
-- 2. sp_filtrar_categorias
-- Descripción: Filtra categorías por nombre
-- ============================================
CREATE PROCEDURE sp_filtrar_categorias (
  IN p_busqueda VARCHAR(100)
)
BEGIN
  SELECT * FROM categorias
  WHERE nombre LIKE CONCAT('%', p_busqueda, '%');
END$$

-- ============================================
-- 3. sp_filtrar_usuarios
-- Descripción: Filtra usuarios por nombre o correo
-- ============================================
CREATE PROCEDURE sp_filtrar_usuarios (
  IN p_busqueda VARCHAR(100)
)
BEGIN
  SELECT * FROM usuarios
  WHERE nombre LIKE CONCAT('%', p_busqueda, '%')
     OR correo LIKE CONCAT('%', p_busqueda, '%');
END$$

-- ============================================
-- 4. sp_filtrar_proveedores
-- Descripción: Filtra proveedores por nombre
-- ============================================
CREATE PROCEDURE sp_filtrar_proveedores (
  IN p_busqueda VARCHAR(100)
)
BEGIN
  SELECT * FROM proveedores
  WHERE nombre LIKE CONCAT('%', p_busqueda, '%');
END$$

-- ============================================
-- 5. sp_filtrar_clientes
-- Descripción: Filtra clientes por nombre
-- ============================================
CREATE PROCEDURE sp_filtrar_clientes (
  IN p_busqueda VARCHAR(100)
)
BEGIN
  SELECT * FROM clientes
  WHERE nombre LIKE CONCAT('%', p_busqueda, '%');
END$$

-- ============================================
-- 6. sp_filtrar_productos
-- Descripción: Filtra productos por nombre
-- ============================================
CREATE PROCEDURE sp_filtrar_productos (
  IN p_busqueda VARCHAR(100)
)
BEGIN
  SELECT * FROM productos
  WHERE nombre LIKE CONCAT('%', p_busqueda, '%');
END$$

-- ============================================
-- 7. sp_filtrar_compras
-- Descripción: Filtra compras por nombre de producto, nombre de usuario o fecha_transaccion
-- ============================================
CREATE PROCEDURE sp_filtrar_compras (
  IN p_busqueda VARCHAR(100)
)
BEGIN
  SELECT c.id,
         p.nombre AS nombre_producto,
         u.nombre AS nombre_usuario,
         c.monto_total,
         c.cantidad,
         c.fecha_transaccion
  FROM compras c
  INNER JOIN productos p ON c.producto_id = p.id
  INNER JOIN usuarios u ON c.usuario_id = u.id
  WHERE p.nombre LIKE CONCAT('%', p_busqueda, '%')
     OR u.nombre LIKE CONCAT('%', p_busqueda, '%')
     OR c.fecha_transaccion LIKE CONCAT('%', p_busqueda, '%');
END$$

-- ============================================
-- 8. sp_filtrar_ventas
-- Descripción: Filtra ventas por número de factura, nombre de cliente, nombre de usuario o fecha
-- ============================================
CREATE PROCEDURE sp_filtrar_ventas (
  IN p_busqueda VARCHAR(255)
)
BEGIN
  SELECT v.id,
         v.numero_factura,
         c.nombre AS nombre_cliente,
         u.nombre AS nombre_usuario,
         v.monto_total,
         v.total_con_iva,
         v.fecha,
         v.metodo_pago
  FROM ventas v
  INNER JOIN clientes c ON v.cliente_id = c.id
  INNER JOIN usuarios u ON v.usuario_id = u.id
  WHERE v.numero_factura LIKE CONCAT('%', p_busqueda, '%')
     OR c.nombre LIKE CONCAT('%', p_busqueda, '%')
     OR u.nombre LIKE CONCAT('%', p_busqueda, '%')
     OR v.fecha LIKE CONCAT('%', p_busqueda, '%');
END$$

-- ============================================
-- 9. sp_total_unidades_vendidas
-- Descripción: Obtiene el total de unidades vendidas
-- ============================================
CREATE PROCEDURE sp_total_unidades_vendidas ()
BEGIN
  SELECT SUM(cantidad) AS total_unidades
  FROM detalles_venta;
END$$

-- ============================================
-- 10. sp_total_categorias
-- Descripción: Obtiene el total de categorías registradas
-- ============================================
CREATE PROCEDURE sp_total_categorias ()
BEGIN
  SELECT COUNT(*) AS total_categorias
  FROM categorias;
END$$

-- ============================================
-- 11. sp_total_productos
-- Descripción: Obtiene el total de productos registrados
-- ============================================
CREATE PROCEDURE sp_total_productos ()
BEGIN
  SELECT COUNT(*) AS total_productos
  FROM productos;
END$$

-- ============================================
-- 12. sp_total_proveedores
-- Descripción: Obtiene el total de proveedores registrados
-- ============================================
CREATE PROCEDURE sp_total_proveedores ()
BEGIN
  SELECT COUNT(*) AS total_proveedores
  FROM proveedores;
END$$

-- ============================================
-- 13. sp_total_clientes
-- Descripción: Obtiene el total de clientes registrados
-- ============================================
CREATE PROCEDURE sp_total_clientes ()
BEGIN
  SELECT COUNT(*) AS total_clientes
  FROM clientes;
END$$

-- ============================================
-- 14. sp_total_usuarios
-- Descripción: Obtiene el total de usuarios registrados
-- ============================================
CREATE PROCEDURE sp_total_usuarios ()
BEGIN
  SELECT COUNT(*) AS total_usuarios
  FROM usuarios;
END$$

-- ============================================
-- 15. sp_total_stock_critico
-- Descripción: Obtiene el total de productos con stock crítico
-- ============================================
CREATE PROCEDURE sp_total_stock_critico ()
BEGIN
  SELECT COUNT(*) AS total_criticos
  FROM productos
  WHERE stock_actual <= stock_minimo;
END$$

-- ============================================
-- 16. sp_productos_stock_critico
-- Descripción: Obtiene lista de productos con stock crítico
-- ============================================
CREATE PROCEDURE sp_productos_stock_critico ()
BEGIN
  SELECT * FROM productos
  WHERE stock_actual <= stock_minimo;
END$$

-- ============================================
-- 17. sp_total_facturas
-- Descripción: Obtiene el total de facturas (ventas registradas)
-- ============================================
CREATE PROCEDURE sp_total_facturas ()
BEGIN
  SELECT COUNT(*) AS total_facturas
  FROM ventas;
END$$

-- ============================================
-- 18. sp_total_ganancias
-- Descripción: Calcula las ganancias totales (ventas - compras)
-- ============================================
CREATE PROCEDURE sp_total_ganancias ()
BEGIN
  DECLARE total_ventas DECIMAL(10,2);
  DECLARE total_compras DECIMAL(10,2);

  SELECT IFNULL(SUM(total_con_iva), 0) INTO total_ventas FROM ventas;
  SELECT IFNULL(SUM(monto_total), 0) INTO total_compras FROM compras;

  SELECT (total_ventas - total_compras) AS ganancia_total;
END$$

-- ============================================
-- 19. sp_ganancia_dia
-- Descripción: Calcula la ganancia de un día específico
-- ============================================
CREATE PROCEDURE sp_ganancia_dia (IN p_fecha DATE)
BEGIN
  DECLARE ventas DECIMAL(10,2);
  DECLARE compras DECIMAL(10,2);

  SELECT IFNULL(SUM(total_con_iva), 0) INTO ventas
  FROM ventas
  WHERE DATE(fecha) = p_fecha;

  SELECT IFNULL(SUM(monto_total), 0) INTO compras
  FROM compras
  WHERE DATE(fecha_transaccion) = p_fecha;

  SELECT (ventas - compras) AS ganancia_dia;
END$$

-- ============================================
-- 20. sp_ganancia_mes_actual
-- Descripción: Calcula la ganancia del mes actual
-- ============================================
CREATE PROCEDURE sp_ganancia_mes_actual ()
BEGIN
  DECLARE v_ventas DECIMAL(10,2);
  DECLARE v_compras DECIMAL(10,2);

  SELECT IFNULL(SUM(total_con_iva), 0) INTO v_ventas
  FROM ventas
  WHERE MONTH(fecha) = MONTH(CURDATE()) AND YEAR(fecha) = YEAR(CURDATE());

  SELECT IFNULL(SUM(monto_total), 0) INTO v_compras
  FROM compras
  WHERE MONTH(fecha_transaccion) = MONTH(CURDATE()) AND YEAR(fecha_transaccion) = YEAR(CURDATE());

  SELECT (v_ventas - v_compras) AS ganancia_mes;
END$$

-- ============================================
-- 21. sp_top_productos_vendidos
-- Descripción: Obtiene el top 10 de productos más vendidos
-- ============================================
CREATE PROCEDURE sp_top_productos_vendidos ()
BEGIN
  SELECT p.nombre, SUM(dv.cantidad) AS total_vendido
  FROM detalles_venta dv
  INNER JOIN productos p ON p.id = dv.producto_id
  GROUP BY dv.producto_id
  ORDER BY total_vendido DESC
  LIMIT 10;
END$$

-- ============================================
-- 22. sp_total_ventas_hoy
-- Descripción: Obtiene el total de ventas realizadas hoy
-- ============================================
CREATE PROCEDURE sp_total_ventas_hoy ()
BEGIN
  SELECT COUNT(*) AS total_ventas_hoy
  FROM ventas
  WHERE DATE(fecha) = CURDATE();
END$$

-- ============================================
-- 23. sp_monto_total_ventas_hoy
-- Descripción: Obtiene el monto total de ventas realizadas hoy
-- ============================================
CREATE PROCEDURE sp_monto_total_ventas_hoy ()
BEGIN
  SELECT IFNULL(SUM(total_con_iva), 0) AS monto_ventas_hoy
  FROM ventas
  WHERE DATE(fecha) = CURDATE();
END$$

-- ============================================
-- 24. sp_stock_total
-- Descripción: Obtiene el stock total actual de todos los productos
-- ============================================
CREATE PROCEDURE sp_stock_total ()
BEGIN
  SELECT SUM(stock_actual) AS total_stock
  FROM productos;
END$$

DELIMITER ;

-- =====================================
-- VISTAS PARA CONSULTAS FRECUENTES EN EL SISTEMA
-- Agrupadas por su propósito funcional
-- =====================================

-- ============================
-- GRUPO 1: INVENTARIO Y STOCK
-- ============================

-- Vista: Productos con stock crítico (menor o igual al mínimo)
CREATE OR REPLACE VIEW vw_productos_stock_minimo AS
SELECT
    p.id,
    p.nombre,
    p.descripcion,
    p.stock_actual,
    p.stock_minimo,
    c.nombre AS categoria,
    pr.nombre AS proveedor
FROM productos p
LEFT JOIN categorias c ON p.categoria_id = c.id
LEFT JOIN proveedores pr ON p.proveedor_id = pr.id
WHERE p.estado = 'ACTIVO' AND p.stock_actual <= p.stock_minimo;

-- Vista: Stock actual de productos activos con detalles completos
CREATE OR REPLACE VIEW vw_stock_actual_productos AS
SELECT
    p.id,
    p.nombre,
    p.descripcion,
    p.stock_actual,
    p.stock_minimo,
    p.precio_compra,
    p.precio_venta,
    c.nombre AS categoria,
    pr.nombre AS proveedor,
    p.estado
FROM productos p
LEFT JOIN categorias c ON p.categoria_id = c.id
LEFT JOIN proveedores pr ON p.proveedor_id = pr.id
WHERE p.estado = 'ACTIVO';

-- Vista: Historial completo de movimientos de productos (compras y ventas)
CREATE OR REPLACE VIEW vw_historial_producto AS
SELECT
    p.id AS producto_id,
    p.nombre AS producto_nombre,
    'COMPRA' AS tipo_movimiento,
    c.fecha_transaccion AS fecha,
    c.cantidad,
    ROUND(c.monto_total / c.cantidad, 2) AS precio_unitario,
    ROUND(c.monto_total, 2) AS precio_total,
    pr.nombre AS relacionado,
    u.nombre AS usuario_nombre
FROM compras c
JOIN productos p ON p.id = c.producto_id
JOIN usuarios u ON c.usuario_id = u.id
LEFT JOIN proveedores pr ON p.proveedor_id = pr.id

UNION ALL

SELECT
    p.id AS producto_id,
    p.nombre AS producto_nombre,
    'VENTA' AS tipo_movimiento,
    v.fecha AS fecha,
    dv.cantidad,
    ROUND(dv.precio_unitario, 2) AS precio_unitario,
    ROUND(dv.precio_total, 2) AS precio_total,
    cl.nombre AS relacionado,
    u.nombre AS usuario_nombre
FROM detalles_venta dv
JOIN productos p ON p.id = dv.producto_id
JOIN ventas v ON v.id = dv.venta_id
JOIN clientes cl ON v.cliente_id = cl.id
JOIN usuarios u ON v.usuario_id = u.id;

-- Vista: Movimientos de inventario detallados (entradas y salidas) con responsables
CREATE OR REPLACE VIEW vw_movimientos_inventario AS
SELECT
    p.id AS producto_id,
    p.nombre AS producto_nombre,
    'ENTRADA' AS tipo_movimiento,
    c.fecha_transaccion AS fecha,
    c.cantidad,
    ROUND(c.monto_total / c.cantidad, 2) AS precio_unitario,
    ROUND(c.monto_total, 2) AS precio_total,
    pr.nombre AS relacionado,
    c.usuario_id,
    u.nombre AS usuario_nombre
FROM compras c
JOIN productos p ON p.id = c.producto_id
JOIN usuarios u ON c.usuario_id = u.id
LEFT JOIN proveedores pr ON p.proveedor_id = pr.id

UNION ALL

SELECT
    p.id AS producto_id,
    p.nombre AS producto_nombre,
    'SALIDA' AS tipo_movimiento,
    v.fecha AS fecha,
    dv.cantidad,
    ROUND(dv.precio_unitario, 2) AS precio_unitario,
    ROUND(dv.precio_total, 2) AS precio_total,
    cl.nombre AS relacionado,
    v.usuario_id,
    u.nombre AS usuario_nombre
FROM detalles_venta dv
JOIN productos p ON p.id = dv.producto_id
JOIN ventas v ON v.id = dv.venta_id
JOIN clientes cl ON v.cliente_id = cl.id
JOIN usuarios u ON v.usuario_id = u.id;

-- =====================================
-- GRUPO 2: VENTAS Y PRODUCTOS MÁS VENDIDOS
-- =====================================

-- Vista: Productos más vendidos (total unidades vendidas)
CREATE OR REPLACE VIEW vw_productos_mas_vendidos AS
SELECT
    p.id,
    p.nombre,
    SUM(dv.cantidad) AS total_vendido
FROM productos p
JOIN detalles_venta dv ON p.id = dv.producto_id
JOIN ventas v ON dv.venta_id = v.id
WHERE p.estado = 'ACTIVO' AND v.fecha <= NOW()
GROUP BY p.id, p.nombre
ORDER BY total_vendido DESC;

-- Vista: Registro detallado de ventas con cliente y usuario
CREATE OR REPLACE VIEW vw_ventas_por_fecha AS
SELECT
    v.id AS venta_id,
    v.numero_factura,
    v.fecha,
    v.cliente_id,
    c.nombre AS cliente_nombre,
    v.usuario_id,
    u.nombre AS usuario_nombre,
    v.monto_total,
    v.monto_descuento,
    v.total_con_iva,
    v.metodo_pago,
    v.observaciones
FROM ventas v
LEFT JOIN clientes c ON v.cliente_id = c.id
LEFT JOIN usuarios u ON v.usuario_id = u.id
ORDER BY v.fecha DESC;

-- =====================================
-- GRUPO 3: COMPRAS Y PROVEEDORES
-- =====================================

-- Vista: Registro detallado de compras con producto y proveedor
CREATE OR REPLACE VIEW vw_compras_por_fecha AS
SELECT
    c.fecha_transaccion,
    pr.id AS proveedor_id,
    pr.nombre AS proveedor_nombre,
    p.id AS producto_id,
    p.nombre AS producto,
    c.cantidad,
    c.monto_total,
    c.id AS compra_id
FROM compras c
LEFT JOIN productos p ON c.producto_id = p.id
LEFT JOIN proveedores pr ON p.proveedor_id = pr.id
ORDER BY c.fecha_transaccion DESC;

-- Vista: Proveedores activos en el sistema
CREATE OR REPLACE VIEW vw_proveedores_activos AS
SELECT
    id,
    nombre,
    correo,
    telefono,
    direccion,
    estado
FROM proveedores
WHERE estado = 'ACTIVO';

-- =====================================
-- GRUPO 4: CLIENTES FRECUENTES
-- =====================================

-- Vista: Clientes frecuentes con número de compras y total gastado
CREATE OR REPLACE VIEW vw_clientes_frecuentes AS
SELECT
    c.id,
    c.nombre,
    COUNT(v.id) AS numero_compras,
    SUM(v.monto_total) AS total_compras
FROM clientes c
JOIN ventas v ON c.id = v.cliente_id
GROUP BY c.id, c.nombre
ORDER BY numero_compras DESC, total_compras DESC;

-- ***********************************************
-- SCRIPT DE CARGA INICIAL DE DATOS DE EJEMPLO
-- CON TRANSACCIÓN PARA INTEGRIDAD COMPLETA
-- ***********************************************

USE stockmate;

START TRANSACTION;

-- ===============================
-- 1. Inserción de Roles
-- ===============================
INSERT INTO roles (nombre) VALUES 
('Administrador'),
('Vendedor'),
('Almacenero');

-- ===============================
-- 2. Inserción de Permisos
-- ===============================
INSERT INTO permisos (nombre) VALUES
-- Permisos de usuarios
('usuarios.ver'),
('usuarios.crear'),
('usuarios.editar'),
('usuarios.eliminar'),
-- Permisos de roles
('roles.ver'),
('roles.crear'),
('roles.editar'),
('roles.eliminar'),
-- Permisos de categorías
('categorias.ver'),
('categorias.crear'),
('categorias.editar'),
('categorias.eliminar'),
-- Permisos de productos
('productos.ver'),
('productos.crear'),
('productos.editar'),
('productos.eliminar'),
-- Permisos de proveedores
('proveedores.ver'),
('proveedores.crear'),
('proveedores.editar'),
('proveedores.eliminar'),
-- Permisos de clientes
('clientes.ver'),
('clientes.crear'),
('clientes.editar'),
('clientes.eliminar'),
-- Permisos de compras
('compras.ver'),
('compras.crear'),
('compras.editar'),
('compras.eliminar'),
-- Permisos de ventas
('ventas.ver'),
('ventas.crear'),
('ventas.editar'),
('ventas.eliminar'),
-- Permiso de reportes
('reportes.ver');

-- ===============================
-- 3. Asignación de permisos por rol
-- ===============================

-- 3.1. Todos los permisos al Administrador (rol_id = 1)
INSERT INTO rol_permiso (rol_id, permiso_id)
SELECT 1, id FROM permisos;

-- 3.2. Permisos para Vendedor (rol_id = 2)
INSERT INTO rol_permiso (rol_id, permiso_id) VALUES
-- Clientes
(2, (SELECT id FROM permisos WHERE nombre = 'clientes.ver')),
(2, (SELECT id FROM permisos WHERE nombre = 'clientes.crear')),
(2, (SELECT id FROM permisos WHERE nombre = 'clientes.editar')),
(2, (SELECT id FROM permisos WHERE nombre = 'clientes.eliminar')),
-- Ventas
(2, (SELECT id FROM permisos WHERE nombre = 'ventas.ver')),
(2, (SELECT id FROM permisos WHERE nombre = 'ventas.crear')),
(2, (SELECT id FROM permisos WHERE nombre = 'ventas.editar')),
(2, (SELECT id FROM permisos WHERE nombre = 'ventas.eliminar')),
-- Reportes
(2, (SELECT id FROM permisos WHERE nombre = 'reportes.ver'));

-- 3.3. Permisos para Almacenero (rol_id = 3)
INSERT INTO rol_permiso (rol_id, permiso_id) VALUES
-- Categorías
(3, (SELECT id FROM permisos WHERE nombre = 'categorias.ver')),
(3, (SELECT id FROM permisos WHERE nombre = 'categorias.crear')),
(3, (SELECT id FROM permisos WHERE nombre = 'categorias.editar')),
(3, (SELECT id FROM permisos WHERE nombre = 'categorias.eliminar')),
-- Productos
(3, (SELECT id FROM permisos WHERE nombre = 'productos.ver')),
(3, (SELECT id FROM permisos WHERE nombre = 'productos.crear')),
(3, (SELECT id FROM permisos WHERE nombre = 'productos.editar')),
(3, (SELECT id FROM permisos WHERE nombre = 'productos.eliminar')),
-- Proveedores
(3, (SELECT id FROM permisos WHERE nombre = 'proveedores.ver')),
(3, (SELECT id FROM permisos WHERE nombre = 'proveedores.crear')),
(3, (SELECT id FROM permisos WHERE nombre = 'proveedores.editar')),
(3, (SELECT id FROM permisos WHERE nombre = 'proveedores.eliminar')),
-- Compras
(3, (SELECT id FROM permisos WHERE nombre = 'compras.ver')),
(3, (SELECT id FROM permisos WHERE nombre = 'compras.crear')),
(3, (SELECT id FROM permisos WHERE nombre = 'compras.editar')),
(3, (SELECT id FROM permisos WHERE nombre = 'compras.eliminar')),
-- Reportes
(3, (SELECT id FROM permisos WHERE nombre = 'reportes.ver'));

-- ===============================
-- 4. Inserción de Usuarios con roles asignados
-- ===============================
INSERT INTO usuarios (nombre, correo, contrasena, rol_id, estado) VALUES
('Admin Principal', 'admin@stockmate.com', SHA2('admin123', 256), 1, 'ACTIVO'),
('Derek Cagua', 'derek@stockmate.com', SHA2('derek123', 256), 2, 'ACTIVO'),
('Omar Mite', 'omar@stockmate.com', SHA2('omar123', 256), 2, 'ACTIVO'),
('Clarissa Centeno', 'clarissa@stockmate.com', SHA2('clarissa123', 256), 3, 'ACTIVO'),
('Alexander Cruz', 'alexander@stockmate.com', SHA2('alexander123', 256), 3, 'ACTIVO'),
('Jefferson Guashpa', 'jefferson@stockmate.com', SHA2('jefferson123', 256), 3, 'ACTIVO');

-- ===============================
-- 5. Inserción de Categorías
-- ===============================
INSERT INTO categorias (nombre) VALUES 
('Papelería General'),
('Útiles Escolares'),
('Material de Oficina'),
('Arte y Manualidades'),
('Tecnología y Accesorios'),
('Limpieza y Mantenimiento'),
('Mobiliario y Ergonomía');

-- ===============================
-- 6. Inserción de Proveedores
-- ===============================
INSERT INTO proveedores (nombre, correo, telefono, direccion) VALUES
('Distribuidora Nacional', 'contacto@dn.com', '0991002001', 'Av. Central 123'),
('Importadora Office', 'ventas@office.com', '0987654321', 'Calle Comercio 45'),
('Súper Papelería', 'papeleria@super.com', '0977543210', 'Av. Amazonas 202'),
('Mayorista Escolar', 'mayorista@escolar.com', '0912345678', 'Calle Los Andes 789'),
('Tech Supplies', 'tech@supplies.com', '0923456789', 'Zona Industrial Norte'),
('OfficeMax', 'info@officemax.com', '0911223344', 'Plaza Norte'),
('MegaDistribuidor', 'ventas@megadist.com', '0909876543', 'Av. Libertad 101'),
('PromoEquipos', 'contacto@promoequipos.com', '0912346789', 'Calle 12 Octubre'),
('Librería Central', 'info@libreriacentral.com', '0987456321', 'La Floresta'),
('Punto Escolar', 'ventas@puntoescolar.com', '0971234567', 'Sur Ciudad'),
('Todo Arte', 'arte@todoarte.com', '0934567890', 'Centro Histórico'),
('Eco Proveedores', 'eco@proveedores.com', '0945678901', 'EcoParque Industrial'),
('Suminca', 'contacto@suminca.com', '0901122334', 'Av. República'),
('OfiExpress', 'contacto@ofiexpress.com', '0911556677', 'Zona Empresarial'),
('Distribuciones Sur', 'ventas@distsur.com', '0933221100', 'Av. Suramérica'),
('Mundo Oficina', 'ventas@mundooficina.com', '0911888999', 'Centro Norte'),
('Equipos Total', 'ventas@equipostotal.com', '0977001122', 'Zona Norte'),
('School Depot', 'ventas@schooldepot.com', '0922887766', 'Zona Escolar'),
('Accesorios TI', 'ventas@accesoristi.com', '0988888877', 'Tech Park'),
('Colores y Más', 'ventas@coloresymas.com', '0966666655', 'Av. Las Artes'),
('Papelería Escolar', 'ventas@papeleriaescolar.com', '0954321876', 'Av. La Prensa 111'),
('Distribuidora Andes', 'contacto@andesdist.com', '0933445566', 'Av. América 45'),
('Global Suministros', 'info@globalsuministros.com', '0966778899', 'Sector Industrial Sur'),
('OfiTotal', 'ventas@ofitotal.com', '0922113344', 'Parque Empresarial Quito'),
('Comercial Norte', 'contacto@comercialnorte.com', '0911554433', 'Av. Occidental 300');

-- ===============================
-- 7. Inserción de Clientes
-- ===============================
INSERT INTO clientes (nombre, correo, telefono, direccion) VALUES
('María López', 'maria.lopez@gmail.com', '0987651234', 'Quito Norte'),
('Luis Castillo', 'luis.castillo@yahoo.com', '0911122233', 'Guayaquil Centro'),
('Empresa XYZ', 'contacto@xyz.com', '0998877665', 'Av. Empresarial 777'),
('Colegio Santa Fe', 'info@santafe.edu.ec', '0955566778', 'Machala'),
('Patricia Jara', 'paty.jara@hotmail.com', '0933344556', 'Cuenca Sur'),
('Quique Saldaña Borrego', 'rmartorell@aguilera.es', '7902245254', 'Badajoz'),
('Rosendo Puente Carrera', 'huguetandres-felipe@chaves.net', '2975349128', 'Melilla'),
('Jorge Merino', 'jorge.merino@gmail.com', '0933001122', 'Ambato'),
('Escuela Los Andes', 'escuela@losandes.edu', '0977771234', 'Riobamba'),
('Comercial Andina', 'contacto@andina.com', '0922345678', 'Loja'),
('Fundación Educativa', 'contacto@fundacion.edu', '0981122334', 'Quito Centro'),
('Librería La Estrella', 'ventas@laestrella.com', '0944556677', 'Guayaquil Norte'),
('Centro de Capacitación', 'info@capacitacion.com', '0911223344', 'Cuenca Centro'),
('Escuela Nueva Vida', 'contacto@nuevavida.edu', '0977888999', 'Machala Sur'),
('Distribuciones ABC', 'ventas@distribucionesabc.com', '0933112233', 'Quito Sur'),
('Comercial Lopez', 'comercial.lopez@gmail.com', '0999444555', 'Guayaquil Este'),
('Instituto Nacional', 'info@institutonacional.edu', '0911999888', 'Ambato Centro'),
('Corporación Educar', 'contacto@corporacioneducar.com', '0922003344', 'Loja Norte'),
('Escuela San José', 'info@sanjose.edu', '0955667788', 'Riobamba Oeste'),
('Papelería El Rincón', 'ventas@elrincon.com', '0988776655', 'Cuenca Norte'),
('Unidad Educativa San Marcos', 'info@sanmarcos.edu', '0987653322', 'Tena'),
('Distribuciones Eléctricas', 'ventas@distribuciones-electricas.com', '0911887766', 'Portoviejo'),
('Instituto Técnico Loja', 'contacto@institutoloja.edu', '0933445566', 'Loja Sur'),
('Papelería Express', 'info@papeleriaexpress.com', '0966554433', 'Ibarra'),
('Centro Educativo Amanecer', 'amanecer@educativo.com', '0955667788', 'Santo Domingo');

-- ===============================
-- 8. Inserción de Productos
-- ===============================
INSERT INTO productos (categoria_id, proveedor_id, nombre, descripcion, precio_compra, precio_venta, stock_minimo) VALUES
(1, 1, 'Cuaderno A4', 'Cuaderno grande rayado 100 hojas', 1.20, 2.00, 20),
(2, 3, 'Lápiz de carbón', 'Lápiz escolar HB', 0.10, 0.20, 100),
(2, 5, 'Bolígrafo azul', 'Bolígrafo tinta azul punta media', 0.25, 0.50, 50),
(1, 2, 'Resma de papel bond', 'Papel tamaño carta 500 hojas', 3.50, 5.00, 15),
(4, 4, 'Marcadores permanentes', 'Set de 6 colores punta fina', 1.80, 3.50, 10),
(2, 6, 'Tijeras escolares', 'Tijeras punta roma para niños', 0.90, 1.50, 20),
(1, 7, 'Corrector líquido', 'Botella de corrector blanco 20ml', 0.60, 1.00, 15),
(2, 8, 'Cartulina blanca', 'Cartulina tamaño A4 180g', 0.20, 0.40, 100),
(4, 10, 'Pintura témpera', 'Frasco de 250ml color rojo', 1.10, 2.00, 10),
(2, 9, 'Sacapuntas doble', 'Sacapuntas con depósito', 0.30, 0.60, 25),
(1, 11, 'Block de notas adhesivas', 'Pack de 3 colores surtidos', 0.90, 1.50, 20),
(3, 12, 'Engrapadora metálica', 'Capacidad de 20 hojas', 2.80, 4.50, 8),
(3, 13, 'Perforadora 2 huecos', 'Perforadora para oficina', 3.00, 5.00, 6),
(2, 14, 'Goma de borrar', 'Goma blanca no tóxica', 0.15, 0.30, 50),
(4, 15, 'Pinceles escolares', 'Set de 3 pinceles básicos', 0.90, 1.80, 15),
(1, 16, 'Carpeta manila', 'Carpeta tamaño carta con pestaña', 0.25, 0.50, 40),
(3, 17, 'Separadores plásticos', 'Juego de 5 separadores A4', 0.60, 1.20, 20),
(2, 18, 'Regla plástica 30cm', 'Regla transparente flexible', 0.35, 0.70, 30),
(4, 19, 'Colores de madera', 'Caja de 12 colores escolares', 1.50, 2.80, 10),
(1, 20, 'Agenda académica', 'Agenda escolar con calendario', 2.00, 3.50, 10),
(2, 1, 'Lápiz de color', 'Caja de 12 lápices de color', 1.20, 2.00, 15),
(3, 2, 'Archivador tamaño A-Z', 'Archivador de cartón forrado', 1.80, 3.00, 10),
(4, 3, 'Papel crepé', 'Rollo de papel crepé colores variados', 0.50, 1.00, 30),
(5, 4, 'Mouse inalámbrico', 'Mouse óptico inalámbrico USB', 4.00, 6.50, 5),
(6, 5, 'Toallas desechables', 'Paquete de toallas multiuso', 1.30, 2.50, 20),
(7, 6, 'Silla ergonómica', 'Silla giratoria con soporte lumbar', 35.00, 60.00, 2),
(2, 7, 'Cuaderno espiral', 'Cuaderno con tapa dura 100 hojas', 1.50, 2.30, 25),
(1, 8, 'Papel kraft', 'Resma tamaño carta 500 hojas', 3.80, 6.00, 12),
(3, 9, 'Cinta adhesiva', 'Cinta transparente 24mm x 50m', 0.50, 1.00, 30),
(4, 10, 'Temperas escolares', 'Set de 12 colores 15ml', 2.00, 3.80, 10),
(5, 11, 'Teclado USB', 'Teclado alámbrico estándar', 5.00, 8.00, 6),
(6, 12, 'Limpiador multiusos', 'Botella de 1L con atomizador', 2.20, 3.50, 10),
(7, 13, 'Escritorio pequeño', 'Escritorio MDF color blanco', 40.00, 65.00, 2),
(2, 14, 'Marcador fluorescente', 'Set de 4 colores neón', 1.00, 1.80, 15),
(1, 15, 'Plumones para pizarra', 'Set de 5 colores con borrador', 1.50, 2.50, 20),
(3, 16, 'Carpetas colgantes', 'Paquete de 10 carpetas verdes', 2.50, 4.00, 10),
(4, 17, 'Pinceles gruesos', 'Set de 4 pinceles grandes', 1.20, 2.00, 8),
(5, 18, 'Memoria USB 16GB', 'Unidad flash USB 2.0', 5.50, 9.00, 10),
(6, 19, 'Jabón líquido', 'Galón de 3.8L antibacterial', 3.50, 6.00, 12),
(7, 20, 'Silla plástica apilable', 'Color negro con respaldo', 12.00, 18.00, 5),
(2, 21, 'Tiza blanca', 'Caja de 100 unidades', 1.00, 1.80, 30),
(1, 22, 'Cartapacios escolares', 'Cartapacios tamaño oficio', 0.80, 1.50, 25),
(3, 23, 'Clips metálicos', 'Caja de 100 clips grandes', 0.60, 1.00, 30),
(4, 24, 'Acuarelas escolares', 'Set de 12 colores', 1.20, 2.00, 10),
(5, 25, 'Cable HDMI', 'Cable de 1.5m alta velocidad', 2.50, 4.00, 8),
(6, 1, 'Guantes de látex', 'Caja de 100 unidades talla M', 4.00, 6.50, 10),
(7, 2, 'Escritorio infantil', 'Para niños de 6 a 10 años', 25.00, 40.00, 3),
(2, 3, 'Libreta de apuntes', 'Libreta pequeña rayada', 0.90, 1.60, 30),
(1, 4, 'Folder plástico con broche', 'Tamaño carta colores surtidos', 0.70, 1.20, 40),
(3, 5, 'Grapas metálicas', 'Caja de 5000 grapas 26/6', 0.80, 1.30, 50);

-- ===============================
-- 9. Inserción de Compras (usuarios con rol almacenero: ids 4, 5, 6)
-- Distribuidas en los últimos 98 días, agrupadas por días simulados
-- ===============================
-- Día 1 (hace 98 días)
INSERT INTO compras (producto_id, usuario_id, monto_total, cantidad, fecha_transaccion) VALUES
(1, 4, 120.00, 100, NOW() - INTERVAL 98 DAY),
(2, 5, 12.50, 125, NOW() - INTERVAL 98 DAY),
(3, 6, 25.00, 100, NOW() - INTERVAL 98 DAY),

-- Día 2 (hace 91 días)
(4, 4, 210.00, 60, NOW() - INTERVAL 91 DAY),
(5, 5, 54.00, 30, NOW() - INTERVAL 91 DAY),
(6, 6, 45.00, 50, NOW() - INTERVAL 91 DAY),

-- Día 3 (hace 84 días)
(7, 4, 36.00, 60, NOW() - INTERVAL 84 DAY),
(8, 5, 40.00, 200, NOW() - INTERVAL 84 DAY),
(9, 6, 33.00, 30, NOW() - INTERVAL 84 DAY),
(21, 4, 18.00, 15, NOW() - INTERVAL 84 DAY),
(22, 5, 20.00, 20, NOW() - INTERVAL 84 DAY),
(23, 6, 10.00, 10, NOW() - INTERVAL 84 DAY),

-- Día 4 (hace 77 días)
(10, 4, 22.00, 20, NOW() - INTERVAL 77 DAY),
(11, 6, 27.00, 30, NOW() - INTERVAL 77 DAY),
(12, 4, 50.40, 18, NOW() - INTERVAL 77 DAY),
(24, 5, 13.20, 16, NOW() - INTERVAL 77 DAY),
(25, 6, 18.20, 14, NOW() - INTERVAL 77 DAY),
(26, 4, 27.00, 10, NOW() - INTERVAL 77 DAY),

-- Día 5 (hace 70 días)
(13, 5, 180.00, 60, NOW() - INTERVAL 70 DAY),
(14, 4, 5.25, 35, NOW() - INTERVAL 70 DAY),
(15, 5, 18.00, 20, NOW() - INTERVAL 70 DAY),
(27, 6, 27.00, 18, NOW() - INTERVAL 70 DAY),
(28, 4, 45.60, 20, NOW() - INTERVAL 70 DAY),
(29, 5, 15.00, 15, NOW() - INTERVAL 70 DAY),

-- Día 6 (hace 63 días)
(16, 4, 10.00, 40, NOW() - INTERVAL 63 DAY),
(17, 5, 24.00, 40, NOW() - INTERVAL 63 DAY),
(18, 6, 17.50, 50, NOW() - INTERVAL 63 DAY),
(30, 4, 30.00, 17, NOW() - INTERVAL 63 DAY),
(31, 5, 36.75, 21, NOW() - INTERVAL 63 DAY),
(32, 6, 12.00, 20, NOW() - INTERVAL 63 DAY),

-- Día 7 (hace 56 días)
(19, 6, 30.00, 20, NOW() - INTERVAL 56 DAY),
(20, 5, 20.00, 25, NOW() - INTERVAL 56 DAY),
(1, 4, 144.00, 120, NOW() - INTERVAL 56 DAY),
(33, 6, 16.80, 14, NOW() - INTERVAL 56 DAY),
(34, 5, 21.00, 20, NOW() - INTERVAL 56 DAY),
(35, 4, 9.60, 12, NOW() - INTERVAL 56 DAY),

-- Día 8 (hace 49 días)
(2, 5, 15.00, 150, NOW() - INTERVAL 49 DAY),
(3, 6, 27.50, 110, NOW() - INTERVAL 49 DAY),
(4, 4, 227.50, 65, NOW() - INTERVAL 49 DAY),
(36, 5, 11.20, 21, NOW() - INTERVAL 49 DAY),
(37, 6, 18.00, 27, NOW() - INTERVAL 49 DAY),
(38, 4, 13.30, 19, NOW() - INTERVAL 49 DAY),

-- Día 9 (hace 42 días)
(5, 5, 59.40, 33, NOW() - INTERVAL 42 DAY),
(6, 6, 49.50, 55, NOW() - INTERVAL 42 DAY),
(7, 4, 39.60, 66, NOW() - INTERVAL 42 DAY),
(39, 5, 20.00, 20, NOW() - INTERVAL 42 DAY),
(40, 6, 21.60, 18, NOW() - INTERVAL 42 DAY),
(41, 4, 26.40, 22, NOW() - INTERVAL 42 DAY),

-- Día 10 (hace 35 días)
(8, 5, 43.00, 215, NOW() - INTERVAL 35 DAY),
(9, 6, 38.50, 35, NOW() - INTERVAL 35 DAY),
(10, 4, 18.70, 22, NOW() - INTERVAL 35 DAY),
(42, 5, 11.20, 19, NOW() - INTERVAL 35 DAY),
(43, 6, 12.00, 10, NOW() - INTERVAL 35 DAY),
(44, 4, 10.50, 15, NOW() - INTERVAL 35 DAY),

-- Día 11 (hace 28 días)
(11, 6, 27.90, 31, NOW() - INTERVAL 28 DAY),
(12, 4, 53.20, 19, NOW() - INTERVAL 28 DAY),
(13, 5, 205.00, 25, NOW() - INTERVAL 28 DAY),
(45, 6, 9.60, 19, NOW() - INTERVAL 28 DAY),
(46, 4, 11.90, 25, NOW() - INTERVAL 28 DAY),
(47, 5, 18.00, 20, NOW() - INTERVAL 28 DAY),

-- Día 12 (hace 21 días)
(14, 4, 5.40, 36, NOW() - INTERVAL 21 DAY),
(15, 5, 19.80, 22, NOW() - INTERVAL 21 DAY),
(16, 6, 11.00, 11, NOW() - INTERVAL 21 DAY),
(48, 4, 9.10, 45, NOW() - INTERVAL 21 DAY),
(49, 5, 12.00, 34, NOW() - INTERVAL 21 DAY),
(50, 6, 14.25, 23, NOW() - INTERVAL 21 DAY),

-- Día 13 (hace 14 días)
(17, 5, 15.60, 43, NOW() - INTERVAL 14 DAY),
(18, 6, 18.90, 23, NOW() - INTERVAL 14 DAY),
(19, 4, 31.50, 21, NOW() - INTERVAL 14 DAY),

-- Día 14 (hace 7 días)
(20, 5, 24.30, 45, NOW() - INTERVAL 7 DAY),
(1, 6, 120.00, 30, NOW() - INTERVAL 7 DAY),
(2, 4, 12.50, 125, NOW() - INTERVAL 7 DAY);

-- ===============================
-- 10. Inserción de Ventas (usuarios vendedores: ids 2 y 3)
-- ===============================
INSERT INTO ventas 
(cliente_id, usuario_id, numero_factura, porcentaje_descuento, fecha, metodo_pago, observaciones)
VALUES
(3, 2, 'FAC-1001', 0.00, NOW() - INTERVAL 150 DAY, 'EFECTIVO', 'Pago exacto'),
(15, 3, 'FAC-1002', 5.00, NOW() - INTERVAL 145 DAY, 'TRANSFERENCIA', 'Transferencia realizada'),
(8, 2, 'FAC-1003', 0.00, NOW() - INTERVAL 140 DAY, 'TARJETA_CREDITO', 'Pagó con tarjeta Visa'),
(22, 3, 'FAC-1004', 6.00, NOW() - INTERVAL 135 DAY, 'EFECTIVO', ''),
(12, 2, 'FAC-1005', 0.00, NOW() - INTERVAL 130 DAY, 'EFECTIVO', 'Pago completo'),
(4, 3, 'FAC-1006', 0.00, NOW() - INTERVAL 125 DAY, 'EFECTIVO', ''),
(19, 2, 'FAC-1007', 3.00, NOW() - INTERVAL 120 DAY, 'EFECTIVO', ''),
(7, 3, 'FAC-1008', 0.00, NOW() - INTERVAL 115 DAY, 'TRANSFERENCIA', ''),
(25, 2, 'FAC-1009', 5.00, NOW() - INTERVAL 110 DAY, 'TARJETA_CREDITO', ''),
(10, 3, 'FAC-1010', 5.00, NOW() - INTERVAL 105 DAY, 'EFECTIVO', ''),
(1, 2, 'FAC-1011', 0.00, NOW() - INTERVAL 100 DAY, 'TRANSFERENCIA', ''),
(13, 3, 'FAC-1012', 0.00, NOW() - INTERVAL 95 DAY, 'TARJETA_CREDITO', ''),
(6, 2, 'FAC-1013', 6.00, NOW() - INTERVAL 90 DAY, 'EFECTIVO', ''),
(21, 3, 'FAC-1014', 4.00, NOW() - INTERVAL 85 DAY, 'EFECTIVO', ''),
(17, 2, 'FAC-1015', 0.00, NOW() - INTERVAL 80 DAY, 'TRANSFERENCIA', 'Pago anticipado'),
(5, 3, 'FAC-1016', 0.00, NOW() - INTERVAL 75 DAY, 'EFECTIVO', 'Venta reciente'),
(2, 2, 'FAC-1017', 3.00, NOW() - INTERVAL 70 DAY, 'TARJETA_CREDITO', ''),
(18, 3, 'FAC-1018', 0.00, NOW() - INTERVAL 65 DAY, 'TRANSFERENCIA', 'Pago con descuento'),
(11, 2, 'FAC-1019', 0.00, NOW() - INTERVAL 60 DAY, 'EFECTIVO', 'Venta final del día'),
(20, 3, 'FAC-1020', 3.00, NOW() - INTERVAL 55 DAY, 'EFECTIVO', ''),
(9, 2, 'FAC-1021', 0.00, NOW() - INTERVAL 50 DAY, 'TRANSFERENCIA', ''),
(14, 3, 'FAC-1022', 6.00, NOW() - INTERVAL 45 DAY, 'EFECTIVO', ''),
(16, 2, 'FAC-1023', 0.00, NOW() - INTERVAL 40 DAY, 'TARJETA_CREDITO', ''),
(24, 3, 'FAC-1024', 0.00, NOW() - INTERVAL 35 DAY, 'TRANSFERENCIA', ''),
(23, 2, 'FAC-1025', 0.00, NOW() - INTERVAL 30 DAY, 'EFECTIVO', ''),
(22, 3, 'FAC-1026', 6.00, NOW() - INTERVAL 25 DAY, 'EFECTIVO', ''),
(21, 2, 'FAC-1027', 0.00, NOW() - INTERVAL 20 DAY, 'TRANSFERENCIA', ''),
(19, 3, 'FAC-1028', 0.00, NOW() - INTERVAL 15 DAY, 'TARJETA_CREDITO', ''),
(8, 2, 'FAC-1029', 3.00, NOW() - INTERVAL 10 DAY, 'EFECTIVO', ''),
(7, 3, 'FAC-1030', 0.00, NOW() - INTERVAL 9 DAY, 'TRANSFERENCIA', ''),
(6, 2, 'FAC-1031', 8.00, NOW() - INTERVAL 8 DAY, 'EFECTIVO', ''),
(5, 3, 'FAC-1032', 0.00, NOW() - INTERVAL 7 DAY, 'TARJETA_CREDITO', ''),
(4, 2, 'FAC-1033', 5.00, NOW() - INTERVAL 6 DAY, 'EFECTIVO', ''),
(3, 3, 'FAC-1034', 0.00, NOW() - INTERVAL 5 DAY, 'TRANSFERENCIA', ''),
(2, 2, 'FAC-1035', 0.00, NOW() - INTERVAL 4 DAY, 'EFECTIVO', ''),
(1, 3, 'FAC-1036', 5.00, NOW() - INTERVAL 3 DAY, 'TARJETA_CREDITO', ''),
(12, 2, 'FAC-1037', 0.00, NOW() - INTERVAL 2 DAY, 'EFECTIVO', ''),
(15, 3, 'FAC-1038', 2.00, NOW() - INTERVAL 1 DAY, 'TRANSFERENCIA', ''),
(20, 2, 'FAC-1039', 0.00, NOW(), 'EFECTIVO', 'Venta final del día'),
(14, 3, 'FAC-1040', 0.00, NOW(), 'TARJETA_CREDITO', 'Pago completado');

-- ===============================
-- 11. Inserción de Detalles de Ventas
-- ===============================
INSERT INTO detalles_venta (venta_id, producto_id, cantidad) VALUES
(1, 12, 3), (1, 25, 2), (1, 7, 1),
(2, 3, 4), (2, 11, 2), (2, 49, 1),
(3, 50, 2), (3, 8, 4), (3, 21, 1),
(4, 45, 4), (4, 26, 2), (4, 19, 3),
(5, 31, 3), (5, 22, 2), (5, 39, 1),
(6, 13, 2), (6, 47, 3), (6, 41, 10),
(7, 15, 3), (7, 23, 2), (7, 1, 3),
(8, 24, 3), (8, 37, 1), (8, 20, 2),
(9, 9, 4), (9, 12, 2), (9, 50, 3),
(10, 11, 3), (10, 6, 2), (10, 7, 3),
(11, 30, 3), (11, 31, 3), (11, 33, 2),
(12, 14, 2), (12, 3, 3), (12, 28, 1),
(13, 25, 2), (13, 44, 3), (13, 42, 4),
(14, 38, 3), (14, 40, 2), (14, 4, 1),
(15, 1, 3), (15, 5, 2), (15, 6, 3),
(16, 36, 4), (16, 41, 1), (16, 47, 2),
(17, 43, 2), (17, 44, 3), (17, 50, 2),
(18, 13, 3), (18, 14, 2), (18, 15, 3),
(19, 30, 3), (19, 33, 4), (19, 35, 2),
(20, 45, 3), (20, 46, 2), (20, 48, 1),
(21, 7, 10), (21, 10, 3), (21, 11, 1),
(22, 22, 2), (22, 25, 3), (22, 26, 2),
(23, 32, 3), (23, 34, 2), (23, 35, 3),
(24, 43, 2), (24, 44, 1), (24, 45, 3),
(25, 1, 2), (25, 3, 1), (25, 6, 3),
(26, 13, 3), (26, 15, 2), (26, 18, 3),
(27, 27, 3), (27, 29, 2), (27, 31, 1),
(28, 39, 1), (28, 41, 2), (28, 43, 3),
(29, 50, 2), (29, 2, 1), (29, 4, 3),
(30, 10, 2), (30, 12, 1), (30, 14, 3),
(31, 22, 2), (31, 24, 1), (31, 26, 1),
(32, 34, 2), (32, 36, 3), (32, 38, 1),
(33, 46, 2), (33, 48, 1), (33, 50, 3),
(34, 7, 2), (34, 9, 1), (34, 11, 3),
(35, 19, 3), (35, 21, 1), (35, 23, 2),
(36, 31, 1), (36, 33, 1), (36, 35, 1),
(37, 43, 1), (37, 45, 1), (37, 47, 1),
(38, 4, 1), (38, 6, 2), (38, 8, 3),
(39, 16, 2), (39, 18, 1), (39, 20, 3),
(40, 28, 3), (40, 30, 1), (40, 32, 1);

COMMIT;
