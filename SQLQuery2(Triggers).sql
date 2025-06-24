USE stockmate;

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
-- TRIGGER ANTES DE INSERTAR EN detalles_venta PARA CALCULAR PRECIOS
CREATE TRIGGER trg_calcular_precios_detalle_venta_before_insert
BEFORE INSERT ON detalles_venta
FOR EACH ROW
BEGIN
  DECLARE precio DECIMAL(10,2);

  SELECT precio_venta INTO precio FROM productos WHERE id = NEW.producto_id;

  SET NEW.precio_unitario = precio;
  SET NEW.precio_total = precio * NEW.cantidad;
END$$

-- ========================================
-- TRIGGER ANTES DE ACTUALIZAR EN detalles_venta PARA CALCULAR PRECIOS
CREATE TRIGGER trg_calcular_precios_detalle_venta_before_update
BEFORE UPDATE ON detalles_venta
FOR EACH ROW
BEGIN
  DECLARE precio DECIMAL(10,2);

  SELECT precio_venta INTO precio FROM productos WHERE id = NEW.producto_id;

  SET NEW.precio_unitario = precio;
  SET NEW.precio_total = precio * NEW.cantidad;
END$$

-- 1. Disminuir stock al registrar una venta (detalle)
CREATE TRIGGER trg_reducir_stock_venta
AFTER INSERT ON detalles_venta
FOR EACH ROW
BEGIN
  UPDATE productos
  SET stock_actual = stock_actual - NEW.cantidad
  WHERE id = NEW.producto_id;
END$$

-- 2. Restaurar stock al eliminar un detalle de venta
CREATE TRIGGER trg_restaurar_stock_venta
AFTER DELETE ON detalles_venta
FOR EACH ROW
BEGIN
  UPDATE productos
  SET stock_actual = stock_actual + OLD.cantidad
  WHERE id = OLD.producto_id;
END$$

-- 3. Ajustar stock al actualizar un detalle de venta
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

-- 4. Prevenir stock negativo en ventas
CREATE TRIGGER trg_prevenir_stock_negativo
BEFORE INSERT ON detalles_venta
FOR EACH ROW
BEGIN
  DECLARE stock_disponible INT;

  SELECT stock_actual INTO stock_disponible
  FROM productos
  WHERE id = NEW.producto_id;

  IF stock_disponible < NEW.cantidad THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No hay suficiente stock disponible para realizar la venta.';
  END IF;
END$$

-- 5. Actualizar totales de venta al insertar detalle
CREATE TRIGGER trg_actualizar_totales_venta_after_insert
AFTER INSERT ON detalles_venta
FOR EACH ROW
BEGIN
  DECLARE total DECIMAL(10,2);
  DECLARE descuento DECIMAL(10,2) DEFAULT 0;
  DECLARE iva_rate DECIMAL(5,2) DEFAULT 0.12;

  SELECT COALESCE(SUM(precio_total), 0)
  INTO total
  FROM detalles_venta
  WHERE venta_id = NEW.venta_id;

  UPDATE ventas
  SET monto_total = total,
      monto_descuento = descuento,
      total_con_iva = (total - descuento) * (1 + iva_rate)
  WHERE id = NEW.venta_id;
END$$

-- 6. Actualizar totales de venta al eliminar detalle
CREATE TRIGGER trg_actualizar_totales_venta_after_delete
AFTER DELETE ON detalles_venta
FOR EACH ROW
BEGIN
  DECLARE total DECIMAL(10,2);
  DECLARE descuento DECIMAL(10,2) DEFAULT 0;
  DECLARE iva_rate DECIMAL(5,2) DEFAULT 0.12;

  SELECT COALESCE(SUM(precio_total), 0)
  INTO total
  FROM detalles_venta
  WHERE venta_id = OLD.venta_id;

  UPDATE ventas
  SET monto_total = total,
      monto_descuento = descuento,
      total_con_iva = (total - descuento) * (1 + iva_rate)
  WHERE id = OLD.venta_id;
END$$

-- 7. Actualizar totales de venta al actualizar detalle
CREATE TRIGGER trg_actualizar_totales_venta_after_update
AFTER UPDATE ON detalles_venta
FOR EACH ROW
BEGIN
  DECLARE total DECIMAL(10,2);
  DECLARE descuento DECIMAL(10,2) DEFAULT 0;
  DECLARE iva_rate DECIMAL(5,2) DEFAULT 0.12;

  SELECT COALESCE(SUM(precio_total), 0)
  INTO total
  FROM detalles_venta
  WHERE venta_id = NEW.venta_id;

  UPDATE ventas
  SET monto_total = total,
      monto_descuento = descuento,
      total_con_iva = (total - descuento) * (1 + iva_rate)
  WHERE id = NEW.venta_id;
END$$

-- ========================================
-- TRIGGERS PARA COMPRAS (tabla compras)
-- ========================================

-- 8. Aumentar stock al registrar una compra
CREATE TRIGGER trg_aumentar_stock_compra
AFTER INSERT ON compras
FOR EACH ROW
BEGIN
  UPDATE productos
  SET stock_actual = stock_actual + NEW.cantidad
  WHERE id = NEW.producto_id;
END$$

-- 9. Disminuir stock al eliminar una compra
CREATE TRIGGER trg_disminuir_stock_eliminar_compra
AFTER DELETE ON compras
FOR EACH ROW
BEGIN
  UPDATE productos
  SET stock_actual = stock_actual - OLD.cantidad
  WHERE id = OLD.producto_id;
END$$

-- 10. Ajustar stock al actualizar una compra
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
