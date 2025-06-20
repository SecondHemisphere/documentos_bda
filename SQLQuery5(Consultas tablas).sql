-- Usar la base de datos
USE stockmate;

-- ========================================
-- CONSULTAS SIMPLES
-- ========================================

-- Listar productos con categoría y proveedor
SELECT 
  p.id, 
  p.nombre, 
  p.descripcion, 
  p.precio_venta, 
  p.stock_actual,
  c.nombre AS categoria, 
  pr.nombre AS proveedor
FROM productos p
LEFT JOIN categorias c ON p.categoria_id = c.id
LEFT JOIN proveedores pr ON p.proveedor_id = pr.id
WHERE p.estado = 'ACTIVO';

-- Ver productos por debajo del stock mínimo
SELECT nombre, stock_actual, stock_minimo
FROM productos
WHERE stock_actual < stock_minimo AND estado = 'ACTIVO';

-- Ver productos inactivos
SELECT * FROM productos WHERE estado = 'INACTIVO';

-- Listar categorías activas
SELECT * FROM categorias WHERE estado = 'ACTIVO';

-- Contar productos por categoría
SELECT c.nombre, COUNT(p.id) AS total_productos
FROM categorias c
LEFT JOIN productos p ON p.categoria_id = c.id
GROUP BY c.id;

-- Listar proveedores activos
SELECT * FROM proveedores WHERE estado = 'ACTIVO';

-- Ver productos por proveedor (proveedor activo)
SELECT pr.nombre AS proveedor, p.nombre AS producto
FROM productos p
JOIN proveedores pr ON p.proveedor_id = pr.id
WHERE pr.estado = 'ACTIVO';

-- Listar clientes activos
SELECT id, nombre, correo FROM clientes WHERE estado = 'ACTIVO';

-- Buscar cliente por nombre o correo
SELECT * FROM clientes
WHERE nombre LIKE '%perez%' OR correo LIKE '%gmail.com%';

-- Ver todos los usuarios activos
SELECT id, nombre, correo FROM usuarios WHERE estado = 'ACTIVO';

-- Ver roles de un usuario
SELECT r.nombre AS rol
FROM usuario_rol ur
JOIN roles r ON ur.rol_id = r.id
WHERE ur.usuario_id = 1;

-- Consultar permisos de un usuario
SELECT u.nombre AS usuario, r.nombre AS rol, pe.nombre AS permiso
FROM usuarios u
JOIN usuario_rol ur ON u.id = ur.usuario_id
JOIN roles r ON ur.rol_id = r.id
JOIN rol_permiso rp ON r.id = rp.rol_id
JOIN permisos pe ON rp.permiso_id = pe.id
WHERE u.id = 1;

-- Ventas del día actual
SELECT v.id, v.numero_factura, v.monto_total, v.fecha, c.nombre AS cliente
FROM ventas v
JOIN clientes c ON v.cliente_id = c.id
WHERE DATE(v.fecha) = CURDATE();

-- Ventas entre fechas
SELECT v.numero_factura, v.fecha, c.nombre AS cliente, v.total_con_iva
FROM ventas v
JOIN clientes c ON v.cliente_id = c.id
WHERE v.fecha BETWEEN '2025-06-01' AND '2025-06-30';

-- Detalles de una venta
SELECT dv.cantidad, dv.precio_unitario, dv.precio_total, p.nombre AS producto
FROM detalles_venta dv
JOIN productos p ON dv.producto_id = p.id
WHERE dv.venta_id = 1;

-- Productos más vendidos
SELECT p.nombre, SUM(dv.cantidad) AS total_vendidos
FROM detalles_venta dv
JOIN productos p ON dv.producto_id = p.id
GROUP BY p.id
ORDER BY total_vendidos DESC
LIMIT 10;

-- Pagos de una venta (datos ahora en la tabla ventas)
SELECT
    v.id,
    v.numero_factura,
    v.fecha,
    v.metodo_pago,
    v.monto_total,
    v.monto_descuento,
    v.total_con_iva,
    v.observaciones
FROM ventas v
WHERE v.id = 1;

-- Todas las compras realizadas
SELECT c.id, p.nombre AS producto, c.cantidad, c.monto_total, c.fecha_transaccion
FROM compras c
JOIN productos p ON c.producto_id = p.id
ORDER BY c.fecha_transaccion DESC;

-- ========================================
-- CONSULTAS AVANZADAS
-- ========================================

-- 1. Productos con mejor rotación (más vendidos en relación a su stock actual)
SELECT 
  p.nombre,
  SUM(dv.cantidad) AS vendidos,
  p.stock_actual,
  ROUND(SUM(dv.cantidad) / GREATEST(p.stock_actual, 1), 2) AS rotacion
FROM productos p
JOIN detalles_venta dv ON dv.producto_id = p.id
GROUP BY p.id
ORDER BY rotacion DESC
LIMIT 10;

-- 2. Proveedores más confiables (mayor número de compras con menor total unitario promedio)
SELECT 
  pr.nombre AS proveedor,
  COUNT(c.id) AS compras,
  ROUND(AVG(c.monto_total / c.cantidad), 2) AS costo_unitario_prom
FROM compras c
JOIN productos p ON p.id = c.producto_id
JOIN proveedores pr ON pr.id = p.proveedor_id
GROUP BY pr.id
ORDER BY compras DESC, costo_unitario_prom ASC;

-- 3. Clientes con una sola compra registrada
SELECT 
  c.id,
  c.nombre,
  COUNT(v.id) AS total_compras,
  MAX(v.fecha) AS ultima_compra
FROM clientes c
JOIN ventas v ON v.cliente_id = c.id
GROUP BY c.id
HAVING total_compras = 1
ORDER BY ultima_compra DESC;

-- 4. Porcentaje de ventas por categoría
SELECT 
  c.nombre AS categoria,
  ROUND(SUM(dv.precio_total) / (SELECT SUM(precio_total) FROM detalles_venta) * 100, 2) AS porcentaje_ventas
FROM detalles_venta dv
JOIN productos p ON dv.producto_id = p.id
JOIN categorias c ON p.categoria_id = c.id
GROUP BY c.id
ORDER BY porcentaje_ventas DESC;

-- 5. Tiempo promedio entre compras por producto
SELECT 
  p.nombre,
  ROUND(AVG(DATEDIFF(c2.fecha_transaccion, c1.fecha_transaccion)), 2) AS dias_promedio_reabastecimiento
FROM productos p
JOIN compras c1 ON c1.producto_id = p.id
JOIN compras c2 ON c2.producto_id = p.id AND c2.fecha_transaccion > c1.fecha_transaccion
GROUP BY p.id;

-- 6. Relación ventas vs compras por producto
SELECT 
  p.nombre,
  COALESCE(SUM(dv.cantidad),0) AS vendidos,
  COALESCE(SUM(c.cantidad),0) AS comprados,
  ROUND(COALESCE(SUM(dv.cantidad),0) / GREATEST(COALESCE(SUM(c.cantidad),0), 1), 2) AS proporcion_venta_compra
FROM productos p
LEFT JOIN detalles_venta dv ON dv.producto_id = p.id
LEFT JOIN compras c ON c.producto_id = p.id
GROUP BY p.id
ORDER BY proporcion_venta_compra DESC;

-- 7. Clientes inactivos (sin compras recientes)
SELECT 
  c.id,
  c.nombre,
  MAX(v.fecha) AS ultima_compra
FROM clientes c
LEFT JOIN ventas v ON v.cliente_id = c.id
GROUP BY c.id
HAVING ultima_compra IS NULL OR ultima_compra < CURDATE() - INTERVAL 60 DAY
ORDER BY ultima_compra ASC;

-- 8. Ingresos generados por cada categoría de productos
SELECT 
  cat.nombre AS categoria,
  ROUND(SUM(dv.precio_total), 2) AS ingresos_totales
FROM detalles_venta dv
JOIN productos p ON p.id = dv.producto_id
JOIN categorias cat ON cat.id = p.categoria_id
GROUP BY cat.id
ORDER BY ingresos_totales DESC;

-- 9. Clientes que han comprado productos de más de 3 categorías distintas
SELECT 
  c.nombre,
  COUNT(DISTINCT cat.id) AS categorias_distintas
FROM ventas v
JOIN detalles_venta dv ON dv.venta_id = v.id
JOIN productos p ON p.id = dv.producto_id
JOIN categorias cat ON cat.id = p.categoria_id
JOIN clientes c ON c.id = v.cliente_id
GROUP BY c.id
HAVING categorias_distintas > 3;
