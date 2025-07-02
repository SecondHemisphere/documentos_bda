USE stockmate;

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