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

-- Vista 3: Lista las ventas con detalles de cliente, usuario que registró, montos y método de pago
CREATE OR REPLACE VIEW vw_ventas_por_fecha AS
SELECT
    v.id,
    v.numero_factura,
    c.nombre AS cliente,
    u.nombre AS usuario,
    v.monto_total,
    v.monto_descuento,
    v.total_con_iva,
    v.fecha,
    v.metodo_pago,
    v.observaciones
FROM ventas v
LEFT JOIN clientes c ON v.cliente_id = c.id
LEFT JOIN usuarios u ON v.usuario_id = u.id;

-- Vista 4: Lista las compras realizadas con detalles del producto, cantidad y fecha de transacción
CREATE OR REPLACE VIEW vw_compras_por_fecha AS
SELECT
    c.id,
    p.nombre AS producto,
    c.cantidad,
    c.monto_total,
    c.fecha_transaccion
FROM compras c
LEFT JOIN productos p ON c.producto_id = p.id;

-- Vista 5: Muestra qué usuario hizo qué acción en qué tabla y cuándo
CREATE OR REPLACE VIEW vw_auditoria_sistema AS
SELECT
    a.id,
    u.nombre AS usuario,
    a.tabla_afectada,
    a.id_registro_afectado,
    a.accion,
    a.descripcion,
    a.fecha
FROM auditoria a
LEFT JOIN usuarios u ON a.usuario_id = u.id
ORDER BY a.fecha DESC;

-- Vista 6: Muestra el stock actual de todos los productos activos con detalles de categoría y proveedor
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

-- Vista 7: Muestra el historial de movimientos (ventas y compras) de productos, con cantidades y fechas
CREATE OR REPLACE VIEW vw_historial_producto AS
SELECT
    p.id AS producto_id,
    p.nombre AS producto_nombre,
    'VENTA' AS tipo_movimiento,
    dv.cantidad,
    dv.precio_unitario,
    dv.precio_total,
    v.fecha AS fecha_movimiento,
    v.numero_factura AS referencia
FROM detalles_venta dv
JOIN ventas v ON dv.venta_id = v.id
JOIN productos p ON dv.producto_id = p.id

UNION ALL

SELECT
    p.id AS producto_id,
    p.nombre AS producto_nombre,
    'COMPRA' AS tipo_movimiento,
    c.cantidad,
    NULL AS precio_unitario,
    c.monto_total AS precio_total,
    c.fecha_transaccion AS fecha_movimiento,
    NULL AS referencia
FROM compras c
JOIN productos p ON c.producto_id = p.id
ORDER BY producto_id, fecha_movimiento DESC;

-- Vista 8: Lista los movimientos de inventario separando entradas (compras) y salidas (ventas), con usuario responsable
CREATE OR REPLACE VIEW vw_movimientos_inventario AS
SELECT
    p.id AS producto_id,
    p.nombre AS producto_nombre,
    'SALIDA' AS tipo_movimiento,
    dv.cantidad,
    dv.precio_unitario,
    dv.precio_total,
    v.fecha AS fecha_movimiento,
    u.nombre AS usuario,
    v.numero_factura AS referencia
FROM detalles_venta dv
JOIN ventas v ON dv.venta_id = v.id
JOIN usuarios u ON v.usuario_id = u.id
JOIN productos p ON dv.producto_id = p.id

UNION ALL

SELECT
    p.id AS producto_id,
    p.nombre AS producto_nombre,
    'ENTRADA' AS tipo_movimiento,
    c.cantidad,
    NULL AS precio_unitario,
    c.monto_total AS precio_total,
    c.fecha_transaccion AS fecha_movimiento,
    NULL AS usuario,
    NULL AS referencia
FROM compras c
JOIN productos p ON c.producto_id = p.id
ORDER BY fecha_movimiento DESC;

-- Vista 9: Muestra los clientes frecuentes, con número de compras y monto total gastado
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

-- Vista 10: Lista todos los proveedores que están activos en el sistema
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

