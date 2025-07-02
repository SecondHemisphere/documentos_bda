USE stockmate;

-- ========================================
-- CONSULTAS SIMPLES
-- ========================================

-- Listar productos activos con su categoría y proveedor
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

-- Mostrar productos cuyo stock actual es menor al stock mínimo (productos que necesitan reabastecimiento)
SELECT nombre, stock_actual, stock_minimo
FROM productos
WHERE stock_actual < stock_minimo AND estado = 'ACTIVO';

-- Mostrar productos que están inactivos
SELECT * FROM productos WHERE estado = 'INACTIVO';

-- Listar todas las categorías que están activas
SELECT * FROM categorias WHERE estado = 'ACTIVO';

-- Contar cuántos productos hay en cada categoría (incluye categorías sin productos)
SELECT c.nombre, COUNT(p.id) AS total_productos
FROM categorias c
LEFT JOIN productos p ON p.categoria_id = c.id
GROUP BY c.id;

-- Listar proveedores que están activos
SELECT * FROM proveedores WHERE estado = 'ACTIVO';

-- Mostrar productos asociados a proveedores activos
SELECT pr.nombre AS proveedor, p.nombre AS producto
FROM productos p
JOIN proveedores pr ON p.proveedor_id = pr.id
WHERE pr.estado = 'ACTIVO';

-- Listar clientes activos con campos básicos
SELECT id, nombre, correo FROM clientes WHERE estado = 'ACTIVO';

-- Buscar clientes cuyo nombre contiene "perez" o correo contiene "gmail.com"
SELECT * FROM clientes
WHERE nombre LIKE '%perez%' OR correo LIKE '%gmail.com%';

-- Listar usuarios activos con información básica
SELECT id, nombre, correo FROM usuarios WHERE estado = 'ACTIVO';

-- Mostrar el rol asignado a un usuario específico (id = 1)
SELECT u.nombre AS usuario, r.nombre AS rol
FROM usuarios u
JOIN roles r ON u.rol_id = r.id
WHERE u.id = 1;

-- Consultar los permisos asociados al rol de un usuario específico (id = 1)
SELECT 
  u.nombre AS usuario, 
  r.nombre AS rol, 
  p.nombre AS permiso
FROM usuarios u
JOIN roles r ON u.rol_id = r.id
JOIN rol_permiso rp ON r.id = rp.rol_id
JOIN permisos p ON rp.permiso_id = p.id
WHERE u.id = 1;

-- Listar las ventas realizadas en la fecha actual
SELECT v.id, v.numero_factura, v.monto_total, v.fecha, c.nombre AS cliente
FROM ventas v
JOIN clientes c ON v.cliente_id = c.id
WHERE DATE(v.fecha) = CURDATE();

-- Listar ventas realizadas en un rango de fechas específico
SELECT v.numero_factura, v.fecha, c.nombre AS cliente, v.total_con_iva
FROM ventas v
JOIN clientes c ON v.cliente_id = c.id
WHERE v.fecha BETWEEN '2025-06-01' AND '2025-06-30';

-- Detalles (productos, cantidades y precios) de una venta específica (venta_id = 1)
SELECT dv.cantidad, dv.precio_unitario, dv.precio_total, p.nombre AS producto
FROM detalles_venta dv
JOIN productos p ON dv.producto_id = p.id
WHERE dv.venta_id = 1;

-- Top 10 productos más vendidos, ordenados por cantidad total vendida
SELECT p.nombre, SUM(dv.cantidad) AS total_vendidos
FROM detalles_venta dv
JOIN productos p ON dv.producto_id = p.id
GROUP BY p.id
ORDER BY total_vendidos DESC
LIMIT 10;

-- Información de pagos y detalles de una venta específica (id = 1)
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

-- Listar todas las compras realizadas, con detalle de producto y ordenadas por fecha descendente
SELECT c.id, p.nombre AS producto, c.cantidad, c.monto_total, c.fecha_transaccion
FROM compras c
JOIN productos p ON c.producto_id = p.id
ORDER BY c.fecha_transaccion DESC;

-- ========================================
-- CONSULTAS AVANZADAS
-- ========================================

-- 1. Productos con mejor rotación: relación entre ventas y stock actual
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

-- 2. Proveedores más confiables: número de compras y costo unitario promedio
SELECT 
  pr.nombre AS proveedor,
  COUNT(c.id) AS compras,
  ROUND(AVG(c.monto_total / c.cantidad), 2) AS costo_unitario_prom
FROM compras c
JOIN productos p ON p.id = c.producto_id
JOIN proveedores pr ON pr.id = p.proveedor_id
GROUP BY pr.id
ORDER BY compras DESC, costo_unitario_prom ASC;

-- 3. Clientes que sólo han realizado una compra
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

-- 4. Porcentaje de ventas por categoría sobre el total de ventas
SELECT 
  c.nombre AS categoria,
  ROUND(SUM(dv.precio_total) / (SELECT SUM(precio_total) FROM detalles_venta) * 100, 2) AS porcentaje_ventas
FROM detalles_venta dv
JOIN productos p ON dv.producto_id = p.id
JOIN categorias c ON p.categoria_id = c.id
GROUP BY c.id
ORDER BY porcentaje_ventas DESC;

-- 5. Tiempo promedio entre compras sucesivas por producto (días promedio de reabastecimiento)
SELECT 
  p.nombre,
  ROUND(AVG(DATEDIFF(c2.fecha_transaccion, c1.fecha_transaccion)), 2) AS dias_promedio_reabastecimiento
FROM productos p
JOIN compras c1 ON c1.producto_id = p.id
JOIN compras c2 ON c2.producto_id = p.id AND c2.fecha_transaccion > c1.fecha_transaccion
GROUP BY p.id;

-- 6. Relación entre ventas y compras por producto (proporción de ventas sobre compras)
SELECT 
  p.nombre,
  COALESCE(SUM(dv.cantidad), 0) AS vendidos,
  COALESCE(SUM(c.cantidad), 0) AS comprados,
  ROUND(COALESCE(SUM(dv.cantidad), 0) / GREATEST(COALESCE(SUM(c.cantidad), 0), 1), 2) AS proporcion_venta_compra
FROM productos p
LEFT JOIN detalles_venta dv ON dv.producto_id = p.id
LEFT JOIN compras c ON c.producto_id = p.id
GROUP BY p.id
ORDER BY proporcion_venta_compra DESC;

-- 7. Clientes inactivos: sin compras en los últimos 60 días o sin compras registradas
SELECT 
  c.id,
  c.nombre,
  MAX(v.fecha) AS ultima_compra
FROM clientes c
LEFT JOIN ventas v ON v.cliente_id = c.id
GROUP BY c.id
HAVING ultima_compra IS NULL OR ultima_compra < CURDATE() - INTERVAL 60 DAY
ORDER BY ultima_compra ASC;

-- 8. Ingresos totales generados por categoría
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
