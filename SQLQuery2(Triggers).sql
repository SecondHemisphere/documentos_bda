-- ================================================
-- TRIGGERS DEL SISTEMA STOCKMATE
-- ================================================

-- Establecer delimitador personalizado
DELIMITER $$

-- ==========================================================
-- SECCIÓN 1: TRIGGERS DE AUDITORÍA PARA TABLA PRODUCTOS
-- ==========================================================

-- Auditoría: INSERT en productos
CREATE TRIGGER trg_audit_insert_producto
AFTER INSERT ON productos
FOR EACH ROW
BEGIN
  INSERT INTO auditoria (usuario_id, tabla_afectada, id_registro_afectado, accion, descripcion)
  VALUES (NULL, 'productos', NEW.id, 'INSERT', CONCAT('Producto creado: ', NEW.nombre));
END$$

-- Auditoría: UPDATE en productos
CREATE TRIGGER trg_audit_update_producto
AFTER UPDATE ON productos
FOR EACH ROW
BEGIN
  IF OLD.nombre != NEW.nombre OR OLD.stock_actual != NEW.stock_actual THEN
    INSERT INTO auditoria (usuario_id, tabla_afectada, id_registro_afectado, accion, descripcion)
    VALUES (NULL, 'productos', NEW.id, 'UPDATE',
      CONCAT('Producto actualizado: ',
             IF(OLD.nombre != NEW.nombre, CONCAT('nombre de "', OLD.nombre, '" a "', NEW.nombre, '"'), ''),
             IF(OLD.stock_actual != NEW.stock_actual, CONCAT(' | stock_actual de ', OLD.stock_actual, ' a ', NEW.stock_actual), '')
      )
    );
  END IF;
END$$

-- Auditoría: DELETE en productos
CREATE TRIGGER trg_audit_delete_producto
AFTER DELETE ON productos
FOR EACH ROW
BEGIN
  INSERT INTO auditoria (usuario_id, tabla_afectada, id_registro_afectado, accion, descripcion)
  VALUES (NULL, 'productos', OLD.id, 'DELETE', CONCAT('Producto eliminado: ', OLD.nombre));
END$$

-- ========================================================
-- SECCIÓN 2: TRIGGERS PARA AJUSTE AUTOMÁTICO DE STOCK
-- ========================================================

-- Disminuir stock al realizar una venta
CREATE TRIGGER trg_reducir_stock_venta
AFTER INSERT ON detalles_venta
FOR EACH ROW
BEGIN
  UPDATE productos
  SET stock_actual = stock_actual - NEW.cantidad
  WHERE id = NEW.producto_id;
END$$

-- Restaurar stock al eliminar una venta (detalle)
CREATE TRIGGER trg_restaurar_stock_venta
AFTER DELETE ON detalles_venta
FOR EACH ROW
BEGIN
  UPDATE productos
  SET stock_actual = stock_actual + OLD.cantidad
  WHERE id = OLD.producto_id;
END$$

-- Aumentar stock al registrar una compra
CREATE TRIGGER trg_aumentar_stock_compra
AFTER INSERT ON compras
FOR EACH ROW
BEGIN
  UPDATE productos
  SET stock_actual = stock_actual + NEW.cantidad
  WHERE id = NEW.producto_id;
END$$

-- =====================================================
-- SECCIÓN 3: AUDITORÍA PARA VENTAS Y COMPRAS
-- =====================================================

-- Registrar auditoría al insertar una venta
CREATE TRIGGER trg_audit_insert_venta
AFTER INSERT ON ventas
FOR EACH ROW
BEGIN
  INSERT INTO auditoria (usuario_id, tabla_afectada, id_registro_afectado, accion, descripcion)
  VALUES (NEW.usuario_id, 'ventas', NEW.id, 'INSERT',
          CONCAT('Nueva venta registrada con factura ', NEW.numero_factura));
END$$

-- Registrar auditoría al insertar una compra
CREATE TRIGGER trg_audit_insert_compra
AFTER INSERT ON compras
FOR EACH ROW
BEGIN
  INSERT INTO auditoria (usuario_id, tabla_afectada, id_registro_afectado, accion, descripcion)
  VALUES (NULL, 'compras', NEW.id, 'INSERT',
          CONCAT('Compra registrada del producto ID ', NEW.producto_id, ', cantidad: ', NEW.cantidad));
END$$

-- =====================================================
-- SECCIÓN 4: AUDITORÍA PARA USUARIOS
-- =====================================================

-- Registrar auditoría al crear nuevo usuario
CREATE TRIGGER trg_audit_insert_usuario
AFTER INSERT ON usuarios
FOR EACH ROW
BEGIN
  INSERT INTO auditoria (usuario_id, tabla_afectada, id_registro_afectado, accion, descripcion)
  VALUES (NULL, 'usuarios', NEW.id, 'INSERT', CONCAT('Nuevo usuario creado: ', NEW.nombre));
END$$

-- Restaurar delimitador por defecto
DELIMITER ;
