USE stockmate;

-- ============================
-- VISTAS PARA CONSULTAS FRECUENTES
-- ============================

-- Vista 1: Muestra productos cuyo stock actual está por debajo o igual al stock mínimo establecido
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

-- Vista 2: Muestra los productos más vendidos con la suma total de unidades vendidas
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

-- Vista 3: Lista las ventas realizadas con detalles de cliente, usuario que registró, montos, fecha y método de pago
-- Permite controlar las ventas según cliente, usuario y rango de fechas
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

-- Vista 4: Lista las compras realizadas con detalles del producto, cantidad, monto, fecha de transacción y proveedor
-- Permite controlar las compras según proveedor y rango de fechas
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

-- Vista 5: Muestra el stock actual de todos los productos activos con detalles de categoría y proveedor
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

-- Vista 6: Muestra compras y ventas de todos los productos con detalle de movimientos, fechas, cantidades y participantes.
CREATE OR REPLACE VIEW vw_historial_producto AS

SELECT
    p.id AS producto_id,
    p.nombre AS producto_nombre,
    'COMPRA' AS tipo_movimiento,
    c.fecha_transaccion AS fecha,
    c.cantidad,
    ROUND(c.monto_total / c.cantidad, 2) AS precio_unitario,
    ROUND(c.monto_total, 2) AS precio_total,
    pr.nombre AS relacionado, -- proveedor
    NULL AS usuario_nombre

FROM compras c
JOIN productos p ON p.id = c.producto_id
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
    cl.nombre AS relacionado, -- cliente
    u.nombre AS usuario_nombre

FROM detalles_venta dv
JOIN productos p ON p.id = dv.producto_id
JOIN ventas v ON v.id = dv.venta_id
JOIN clientes cl ON v.cliente_id = cl.id
JOIN usuarios u ON v.usuario_id = u.id;

-- Vista 7: Lista los movimientos de inventario separando entradas (compras) y salidas (ventas), con usuario responsable
CREATE OR REPLACE VIEW vw_movimientos_inventario AS
SELECT
    p.id AS producto_id,
    p.nombre AS producto_nombre,
    'ENTRADA' AS tipo_movimiento,
    c.fecha_transaccion AS fecha,
    c.cantidad,
    (c.monto_total / c.cantidad) AS precio_unitario,
    c.monto_total AS precio_total,
    pr.nombre AS proveedor_cliente,
    NULL AS usuario_id,
    NULL AS usuario_nombre
FROM compras c
JOIN productos p ON p.id = c.producto_id
LEFT JOIN proveedores pr ON p.proveedor_id = pr.id

UNION ALL

SELECT
    p.id AS producto_id,
    p.nombre AS producto_nombre,
    'SALIDA' AS tipo_movimiento,
    v.fecha AS fecha,
    dv.cantidad,
    dv.precio_unitario,
    dv.precio_total,
    cl.nombre AS proveedor_cliente,
    v.usuario_id,
    u.nombre AS usuario_nombre
FROM detalles_venta dv
JOIN productos p ON p.id = dv.producto_id
JOIN ventas v ON v.id = dv.venta_id
JOIN clientes cl ON v.cliente_id = cl.id
JOIN usuarios u ON v.usuario_id = u.id;

-- Vista 8: Muestra los clientes frecuentes, con número de compras y monto total gastado
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

-- Vista 9: Lista todos los proveedores que están activos en el sistema
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

