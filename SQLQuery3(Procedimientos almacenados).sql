-- ============================================
-- PROCEDIMIENTOS ALMACENADOS DEL SISTEMA "STOCKMATE"
-- ============================================

USE stockmate;

DROP PROCEDURE IF EXISTS sp_insertar_producto;
DROP PROCEDURE IF EXISTS sp_registrar_venta;
DROP PROCEDURE IF EXISTS sp_insertar_detalle_venta;
DROP PROCEDURE IF EXISTS sp_registrar_compra;
DROP PROCEDURE IF EXISTS sp_crear_usuario;
DROP PROCEDURE IF EXISTS sp_insertar_pago;
DROP PROCEDURE IF EXISTS sp_filtrar_categorias;
DROP PROCEDURE IF EXISTS sp_filtrar_clientes;
DROP PROCEDURE IF EXISTS sp_filtrar_proveedores;
DROP PROCEDURE IF EXISTS sp_filtrar_productos;
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
-- 1. Insertar un nuevo producto
-- ============================================
CREATE PROCEDURE sp_insertar_producto (
  IN p_categoria_id BIGINT,
  IN p_proveedor_id BIGINT,
  IN p_nombre VARCHAR(100),
  IN p_descripcion TEXT,
  IN p_precio_compra DECIMAL(10,2),
  IN p_precio_venta DECIMAL(10,2),
  IN p_stock_inicial INT,
  IN p_stock_minimo INT,
  IN p_ruta_imagen VARCHAR(255)
)
BEGIN
  INSERT INTO productos (
    categoria_id, proveedor_id, nombre, descripcion,
    precio_compra, precio_venta, stock_actual, stock_minimo, ruta_imagen
  ) VALUES (
    p_categoria_id, p_proveedor_id, p_nombre, p_descripcion,
    p_precio_compra, p_precio_venta, p_stock_inicial, p_stock_minimo, p_ruta_imagen
  );
END$$

-- ============================================
-- 2. Registrar una nueva venta
-- ============================================
CREATE PROCEDURE sp_registrar_venta (
  IN p_cliente_id BIGINT,
  IN p_usuario_id BIGINT,
  IN p_numero_factura VARCHAR(255),
  IN p_monto_total DECIMAL(10,2),
  IN p_descuento DECIMAL(10,2),
  IN p_total_con_iva DECIMAL(10,2),
  IN p_fecha DATETIME
)
BEGIN
  INSERT INTO ventas (
    cliente_id, usuario_id, numero_factura,
    monto_total, monto_descuento, total_con_iva, fecha
  ) VALUES (
    p_cliente_id, p_usuario_id, p_numero_factura,
    p_monto_total, p_descuento, p_total_con_iva, p_fecha
  );
END$$

-- ============================================
-- 3. Insertar detalle de una venta
-- ============================================
-- El trigger asociado disminuirá automáticamente el stock del producto
CREATE PROCEDURE sp_insertar_detalle_venta (
  IN p_venta_id BIGINT,
  IN p_producto_id BIGINT,
  IN p_cantidad INT,
  IN p_precio_unitario DECIMAL(10,2)
)
BEGIN
  DECLARE total DECIMAL(10,2);
  SET total = p_cantidad * p_precio_unitario;

  INSERT INTO detalles_venta (
    venta_id, producto_id, cantidad, precio_unitario, precio_total
  ) VALUES (
    p_venta_id, p_producto_id, p_cantidad, p_precio_unitario, total
  );
END$$

-- ============================================
-- 4. Registrar una compra
-- ============================================
-- El trigger asociado aumentará automáticamente el stock del producto
CREATE PROCEDURE sp_registrar_compra (
  IN p_producto_id BIGINT,
  IN p_monto_total DECIMAL(10,2),
  IN p_cantidad INT,
  IN p_fecha DATETIME
)
BEGIN
  INSERT INTO compras (
    producto_id, monto_total, cantidad, fecha_transaccion
  ) VALUES (
    p_producto_id, p_monto_total, p_cantidad, p_fecha
  );
END$$

-- ============================================
-- 5. Crear nuevo usuario del sistema
-- ============================================
CREATE PROCEDURE sp_crear_usuario (
  IN p_nombre VARCHAR(255),
  IN p_correo VARCHAR(255),
  IN p_contrasena VARCHAR(255)
)
BEGIN
  INSERT INTO usuarios (
    nombre, correo, contrasena
  ) VALUES (
    p_nombre, p_correo, p_contrasena
  );
END$$

-- ============================================
-- 6. Registrar un pago asociado a una venta
-- ============================================
CREATE PROCEDURE sp_insertar_pago (
  IN p_venta_id BIGINT,
  IN p_fecha DATE,
  IN p_metodo_pago ENUM('EFECTIVO', 'TARJETA_CREDITO', 'TARJETA_DEBITO', 'TRANSFERENCIA', 'OTRO'),
  IN p_monto DECIMAL(10,2),
  IN p_observaciones TEXT
)
BEGIN
  INSERT INTO pagos (
    venta_id, fecha, metodo_pago, monto, observaciones
  ) VALUES (
    p_venta_id, p_fecha, p_metodo_pago, p_monto, p_observaciones
  );
END$$

-- ============================================
-- 7. Filtrar categorías por nombre
-- ============================================
CREATE PROCEDURE sp_filtrar_categorias (
  IN p_busqueda VARCHAR(100)
)
BEGIN
  SELECT * FROM categorias
  WHERE nombre LIKE CONCAT('%', p_busqueda, '%');
END$$

-- ============================================
-- 8. Filtrar clientes por nombre o documento
-- ============================================
CREATE PROCEDURE sp_filtrar_clientes (
  IN p_busqueda VARCHAR(100)
)
BEGIN
  SELECT * FROM clientes
  WHERE nombre LIKE CONCAT('%', p_busqueda, '%')
     OR documento LIKE CONCAT('%', p_busqueda, '%');
END$$

-- ============================================
-- 9. Filtrar proveedores por nombre o RUC
-- ============================================
CREATE PROCEDURE sp_filtrar_proveedores (
  IN p_busqueda VARCHAR(100)
)
BEGIN
  SELECT * FROM proveedores
  WHERE nombre LIKE CONCAT('%', p_busqueda, '%')
     OR ruc LIKE CONCAT('%', p_busqueda, '%');
END$$

-- ============================================
-- 10. Filtrar productos por nombre o código
-- ============================================
CREATE PROCEDURE sp_filtrar_productos (
  IN p_busqueda VARCHAR(100)
)
BEGIN
  SELECT * FROM productos
  WHERE nombre LIKE CONCAT('%', p_busqueda, '%');
END$$

-- ============================================
-- 11. Obtener total de unidades vendidas
-- ============================================
CREATE PROCEDURE sp_total_unidades_vendidas ()
BEGIN
  SELECT SUM(cantidad) AS total_unidades
  FROM detalles_venta;
END$$

-- ============================================
-- 12. Obtener total de categorías
-- ============================================
CREATE PROCEDURE sp_total_categorias ()
BEGIN
  SELECT COUNT(*) AS total_categorias
  FROM categorias;
END$$

-- ============================================
-- 13. Obtener total de productos
-- ============================================
CREATE PROCEDURE sp_total_productos ()
BEGIN
  SELECT COUNT(*) AS total_productos
  FROM productos;
END$$

-- ============================================
-- 14. Obtener total de proveedores
-- ============================================
CREATE PROCEDURE sp_total_proveedores ()
BEGIN
  SELECT COUNT(*) AS total_proveedores
  FROM proveedores;
END$$

-- ============================================
-- 15. Obtener total de clientes
-- ============================================
CREATE PROCEDURE sp_total_clientes ()
BEGIN
  SELECT COUNT(*) AS total_clientes
  FROM clientes;
END$$

-- ============================================
-- 16. Obtener total de usuarios
-- ============================================
CREATE PROCEDURE sp_total_usuarios ()
BEGIN
  SELECT COUNT(*) AS total_usuarios
  FROM usuarios;
END$$

-- ============================================
-- 17. Obtener total de productos con stock crítico
-- ============================================
CREATE PROCEDURE sp_total_stock_critico ()
BEGIN
  SELECT COUNT(*) AS total_criticos
  FROM productos
  WHERE stock_actual <= stock_minimo;
END$$

-- ============================================
-- 18. Obtener lista de productos con stock crítico
-- ============================================
CREATE PROCEDURE sp_productos_stock_critico ()
BEGIN
  SELECT * FROM productos
  WHERE stock_actual <= stock_minimo;
END$$

-- ============================================
-- 19. Obtener total de facturas (ventas registradas)
-- ============================================
CREATE PROCEDURE sp_total_facturas ()
BEGIN
  SELECT COUNT(*) AS total_facturas
  FROM ventas;
END$$

-- ============================================
-- 20. Obtener el total de ganancias (ventas - compras)
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
-- 21. Ganancia del día especificado
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
-- 22. Ganancia del mes actual
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
-- 23. Top 5 productos más vendidos
-- ============================================
CREATE PROCEDURE sp_top_productos_vendidos ()
BEGIN
  SELECT p.nombre, SUM(dv.cantidad) AS total_vendido
  FROM detalles_venta dv
  INNER JOIN productos p ON p.id = dv.producto_id
  GROUP BY dv.producto_id
  ORDER BY total_vendido DESC
  LIMIT 5;
END$$

-- ============================================
-- 24. Total de ventas realizadas hoy
-- ============================================
CREATE PROCEDURE sp_total_ventas_hoy ()
BEGIN
  SELECT COUNT(*) AS total_ventas_hoy
  FROM ventas
  WHERE DATE(fecha) = CURDATE();
END$$

-- ============================================
-- 25. Monto total de ventas realizadas hoy
-- ============================================
CREATE PROCEDURE sp_monto_total_ventas_hoy ()
BEGIN
  SELECT IFNULL(SUM(total_con_iva), 0) AS monto_ventas_hoy
  FROM ventas
  WHERE DATE(fecha) = CURDATE();
END$$

-- ============================================
-- 26. Stock total actual (sumatoria de stock de todos los productos)
-- ============================================
CREATE PROCEDURE sp_stock_total ()
BEGIN
  SELECT SUM(stock_actual) AS total_stock
  FROM productos;
END$$

DELIMITER ;
