USE stockmate;

-- ============================
-- VISTAS PARA CONSULTAS FRECUENTES
-- ============================

-- Vista 1: Productos con categoría y proveedor
CREATE OR REPLACE VIEW vista_productos_detalle AS
SELECT 
    p.id AS producto_id,
    p.nombre AS nombre_producto,
    p.descripcion,
    p.precio_compra,
    p.precio_venta,
    p.stock_actual,
    p.stock_minimo,
    c.nombre AS categoria,
    pr.nombre AS proveedor,
    p.estado
FROM productos p
LEFT JOIN categorias c ON p.categoria_id = c.id
LEFT JOIN proveedores pr ON p.proveedor_id = pr.id;

-- Vista 2: Ventas con cliente y usuario
CREATE OR REPLACE VIEW vista_ventas_completas AS
SELECT 
    v.id AS venta_id,
    v.numero_factura,
    v.fecha,
    v.monto_total,
    v.monto_descuento,
    v.total_con_iva,
    v.estado_pago,
    c.nombre AS cliente,
    u.nombre AS usuario
FROM ventas v
JOIN clientes c ON v.cliente_id = c.id
JOIN usuarios u ON v.usuario_id = u.id;

-- Vista 3: Detalles de venta extendidos
CREATE OR REPLACE VIEW vista_detalles_venta_extendida AS
SELECT 
    dv.id AS detalle_id,
    v.numero_factura,
    p.nombre AS producto,
    dv.cantidad,
    dv.precio_unitario,
    dv.precio_total
FROM detalles_venta dv
JOIN ventas v ON dv.venta_id = v.id
JOIN productos p ON dv.producto_id = p.id;

-- Vista 4: Compras con detalle de producto
CREATE OR REPLACE VIEW vista_compras_productos AS
SELECT 
    c.id AS compra_id,
    p.nombre AS producto,
    c.cantidad,
    c.monto_total,
    c.fecha_transaccion
FROM compras c
JOIN productos p ON c.producto_id = p.id;

-- Vista 5: Pagos con número de factura y método
CREATE OR REPLACE VIEW vista_pagos_ventas AS
SELECT 
    pa.id AS pago_id,
    v.numero_factura,
    pa.fecha,
    pa.metodo_pago,
    pa.monto,
    pa.observaciones
FROM pagos pa
JOIN ventas v ON pa.venta_id = v.id;

-- Vista 6: Auditoría detallada
CREATE OR REPLACE VIEW vista_auditoria_detallada AS
SELECT 
    a.id,
    u.nombre AS usuario,
    a.tabla_afectada,
    a.id_registro_afectado,
    a.accion,
    a.descripcion,
    a.fecha
FROM auditoria a
LEFT JOIN usuarios u ON a.usuario_id = u.id;
