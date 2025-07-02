USE stockmate;

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