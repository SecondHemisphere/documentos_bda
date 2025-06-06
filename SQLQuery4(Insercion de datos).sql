-- ============================================
-- DATOS DE EJEMPLO REALISTAS PARA STOCKMATE
-- Activan triggers de auditoría y stock
-- ============================================

-- 1. Roles
INSERT INTO roles (nombre) VALUES 
('Administrador'),
('Vendedor'),
('Almacenero');

-- 2. Permisos
INSERT INTO permisos (nombre) VALUES 
('crear_producto'),
('editar_producto'),
('eliminar_producto'),
('ver_ventas'),
('registrar_compra'),
('ver_stock'),
('generar_reporte');

-- 3. Usuarios
INSERT INTO usuarios (nombre, correo, contrasena, estado) VALUES
('Admin Principal', 'admin@stockmate.com', SHA2('admin123', 256), 'ACTIVO'),
('Juan Pérez', 'juan@stockmate.com', SHA2('ventas123', 256), 'ACTIVO'),
('Ana Torres', 'ana@stockmate.com', SHA2('almacen123', 256), 'ACTIVO'),
('Carlos Ruiz', 'carlos@stockmate.com', SHA2('admin456', 256), 'ACTIVO'),
('Laura Gómez', 'laura@stockmate.com', SHA2('ventas456', 256), 'ACTIVO');

-- 4. usuario_rol
INSERT INTO usuario_rol (usuario_id, rol_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 1), (5, 2);

-- 5. rol_permiso
INSERT INTO rol_permiso (rol_id, permiso_id) VALUES
-- Admin
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7),
-- Vendedor
(2, 4), (2, 7),
-- Almacenero
(3, 1), (3, 2), (3, 5), (3, 6);

-- 6. Categorías
INSERT INTO categorias (nombre) VALUES 
('Papelería'),
('Tecnología'),
('Útiles Escolares'),
('Oficina'),
('Arte');

-- 7. Proveedores
INSERT INTO proveedores (nombre, correo, telefono, direccion) VALUES
('Distribuidora Nacional', 'contacto@dn.com', '0991002001', 'Av. Central 123'),
('Importadora Office', 'ventas@office.com', '0987654321', 'Calle Comercio 45'),
('Súper Papelería', 'papeleria@super.com', '0977543210', 'Av. Amazonas 202'),
('Mayorista Escolar', 'mayorista@escolar.com', '0912345678', 'Calle Los Andes 789'),
('Tech Supplies', 'tech@supplies.com', '0923456789', 'Zona Industrial Norte');

-- 8. Clientes
INSERT INTO clientes (nombre, correo, telefono, direccion) VALUES
('María López', 'maria.lopez@gmail.com', '0987651234', 'Quito Norte'),
('Luis Castillo', 'luis.castillo@yahoo.com', '0911122233', 'Guayaquil Centro'),
('Empresa XYZ', 'contacto@xyz.com', '0998877665', 'Av. Empresarial 777'),
('Colegio Santa Fe', 'info@santafe.edu.ec', '0955566778', 'Machala'),
('Patricia Jara', 'paty.jara@hotmail.com', '0933344556', 'Cuenca Sur');

-- 9. Productos (5)
INSERT INTO productos (categoria_id, proveedor_id, nombre, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ruta_imagen) VALUES
(1, 1, 'Cuaderno A4', 'Cuaderno grande rayado 100 hojas', 1.20, 2.00, 100, 20, 'img/cuaderno_a4.jpg'),
(3, 3, 'Lápiz de carbón', 'Lápiz escolar HB', 0.10, 0.20, 500, 100, 'img/lapiz_hb.jpg'),
(2, 5, 'Mouse inalámbrico', 'Mouse óptico USB 2.4GHz', 6.00, 9.00, 50, 10, 'img/mouse_wireless.jpg'),
(4, 2, 'Resma de papel', 'Papel tamaño carta 500 hojas', 3.50, 5.00, 80, 15, 'img/resma_papel.jpg'),
(5, 4, 'Marcadores color', 'Set de 6 marcadores punta fina', 1.80, 3.50, 60, 10, 'img/marcadores_color.jpg');

-- 10. Compras (5)
INSERT INTO compras (producto_id, monto_total, cantidad, fecha_transaccion) VALUES
(1, 120.00, 100, NOW()),
(2, 50.00, 500, NOW()),
(3, 300.00, 50, NOW()),
(4, 280.00, 80, NOW()),
(5, 108.00, 60, NOW());

-- 11. Ventas (5)
INSERT INTO ventas (cliente_id, usuario_id, numero_factura, monto_total, fecha, monto_descuento, total_con_iva, estado_pago) VALUES
(1, 2, 'FAC-1001', 20.00, NOW(), 0, 22.40, 'PAGADO'),
(2, 2, 'FAC-1002', 45.00, NOW(), 5.00, 44.80, 'PAGADO'),
(3, 5, 'FAC-1003', 60.00, NOW(), 0, 67.20, 'PAGADO'),
(4, 2, 'FAC-1004', 15.00, NOW(), 0, 16.80, 'PENDIENTE'),
(5, 5, 'FAC-1005', 32.00, NOW(), 2.00, 33.60, 'PAGADO');

-- 12. Detalles de venta (10 en total, 2 por venta)
INSERT INTO detalles_venta (venta_id, producto_id, cantidad, precio_unitario, precio_total) VALUES
(1, 1, 5, 2.00, 10.00),
(1, 2, 50, 0.20, 10.00),

(2, 3, 5, 9.00, 45.00),

(3, 4, 10, 5.00, 50.00),
(3, 5, 4, 3.50, 14.00),

(4, 2, 30, 0.20, 6.00),
(4, 1, 5, 2.00, 10.00),

(5, 5, 5, 3.50, 17.50),
(5, 2, 30, 0.20, 6.00);

-- 13. Pagos (5)
INSERT INTO pagos (venta_id, fecha, metodo_pago, monto, observaciones) VALUES
  (1, CURDATE(), 'EFECTIVO', 22.40, 'Pago exacto'),
  (2, CURDATE(), 'TRANSFERENCIA', 44.80, 'Transferencia desde Banco Pichincha'),
  (3, CURDATE(), 'TARJETA_CREDITO', 67.20, 'Pagó con tarjeta Visa'),
  (4, CURDATE(), 'EFECTIVO', 10.00, 'Abono inicial'),
  (5, CURDATE(), 'EFECTIVO', 33.60, 'Pago completo');


