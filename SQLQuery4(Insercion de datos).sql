-- ============================================
-- DATOS DE EJEMPLO REALISTAS PARA STOCKMATE
-- Activan triggers de auditoría y stock
-- ============================================

use stockmate;

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
('Derek Cagua', 'derek@stockmate.com', SHA2('derek123', 256), 'ACTIVO'),
('Omar Mite', 'omar@stockmate.com', SHA2('omar123', 256), 'ACTIVO'),
('Clarissa Centeno', 'clarissa@stockmate.com', SHA2('clarissa123', 256), 'ACTIVO'),
('Alexander Cruz', 'alexander@stockmate.com', SHA2('alexander123', 256), 'ACTIVO'),
('Jefferson Guashpa', 'jefferson@stockmate.com', SHA2('jefferson123', 256), 'ACTIVO');

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
('Patricia Jara', 'paty.jara@hotmail.com', '0933344556', 'Cuenca Sur'),
('Quique Saldaña Borrego', 'rmartorell@aguilera.es', '7902245254', 'Badajoz'),
('Rosendo Puente Carrera', 'huguetandres-felipe@chaves.net', '2975349128', 'Melilla');

-- 9. Productos (5)
INSERT INTO productos (categoria_id, proveedor_id, nombre, descripcion, precio_compra, precio_venta, stock_minimo) VALUES
(1, 1, 'Cuaderno A4', 'Cuaderno grande rayado 100 hojas', 1.20, 2.00, 20),
(3, 3, 'Lápiz de carbón', 'Lápiz escolar HB', 0.10, 0.20, 100),
(2, 5, 'Mouse inalámbrico', 'Mouse óptico USB 2.4GHz', 6.00, 9.00, 10),
(4, 2, 'Resma de papel', 'Papel tamaño carta 500 hojas', 3.50, 5.00, 15),
(5, 4, 'Marcadores color', 'Set de 6 marcadores punta fina', 1.80, 3.50, 10),
(3, 5, 'Bolígrafo azul', 'Voluptatem debitis itaque hic harum eum.', 12.78, 19.17, 20),
(4, 3, 'Regla de 30cm', 'Alias labore eveniet nesciunt.', 7.56, 11.34, 10),
(1, 2, 'Cuaderno universitario', 'Cuaderno de espiral 200 hojas', 2.00, 3.50, 15),
(2, 1, 'Teclado mecánico', 'Teclado USB con retroiluminación LED', 15.00, 25.00, 5),
(5, 2, 'Pintura acrílica', 'Set de 12 colores en tubo', 4.50, 7.80, 8),
(1, 3, 'Agenda 2025', 'Agenda ejecutiva con calendario y contactos', 2.70, 4.50, 10),
(3, 4, 'Tijeras escolares', 'Tijeras punta roma para niños', 0.90, 1.50, 30),
(3, 4, 'Goma de borrar', 'Goma blanca rectangular no tóxica', 0.15, 0.30, 50),
(2, 3, 'USB 32GB', 'Memoria USB 3.0 Kingston', 5.00, 8.50, 10),
(4, 2, 'Papel bond A4', 'Paquete de 500 hojas blancas', 4.00, 6.00, 20),
(5, 1, 'Colores Prismacolor', 'Set de 24 lápices de colores profesionales', 8.00, 13.00, 5),
(5, 5, 'Pinceles variados', 'Set de 5 pinceles para pintura acrílica', 1.20, 2.50, 10),
(3, 1, 'Sacapuntas doble', 'Sacapuntas plástico con depósito', 0.35, 0.60, 25),
(1, 5, 'Block de notas', 'Block adhesivo de colores surtidos', 0.90, 1.50, 20);

-- 10. Compras (5)
INSERT INTO compras (producto_id, monto_total, cantidad, fecha_transaccion) VALUES
(1, 120.00, 100, NOW()),
(2, 50.00, 500, NOW()),
(3, 300.00, 50, NOW()),
(4, 280.00, 80, NOW()),
(5, 108.00, 60, NOW()),
(6, 94.6, 55, NOW()),
(7, 53.94, 87, NOW());

-- 11. Ventas (5)
INSERT INTO ventas 
(cliente_id, usuario_id, numero_factura, monto_total, monto_descuento, total_con_iva, fecha, metodo_pago, observaciones) 
VALUES
(1, 2, 'FAC-1001', 20.00, 0.00, 22.40, NOW(), 'EFECTIVO', 'Pago exacto'),
(2, 2, 'FAC-1002', 45.00, 5.00, 44.80, NOW(), 'TRANSFERENCIA', 'Transferencia desde Banco Pichincha'),
(3, 5, 'FAC-1003', 60.00, 0.00, 67.20, NOW(), 'TARJETA_CREDITO', 'Pagó con tarjeta Visa'),
(4, 2, 'FAC-1004', 15.00, 0.00, 16.80, NOW(), 'EFECTIVO', 'Abono inicial'),
(5, 5, 'FAC-1005', 32.00, 2.00, 33.60, NOW(), 'EFECTIVO', 'Pago completo'),
(2, 2, 'FAC-1006', 24.15, 9.27, 16.67, NOW(), 'EFECTIVO', 'Pago adicional'),
(4, 2, 'FAC-1007', 60.32, 8.86, 57.64, NOW(), 'EFECTIVO', 'Pago adicional');


-- 12. Detalles de venta (12 en total, 2 por venta)
INSERT INTO detalles_venta (venta_id, producto_id, cantidad, precio_unitario, precio_total) VALUES
(1, 1, 5, 2.00, 10.00),
(1, 2, 50, 0.20, 10.00),

(2, 3, 5, 9.00, 45.00),

(3, 4, 10, 5.00, 50.00),
(3, 5, 4, 3.50, 14.00),

(4, 2, 30, 0.20, 6.00),
(4, 1, 5, 2.00, 10.00),

(5, 5, 5, 3.50, 17.50),
(5, 2, 30, 0.20, 6.00),

(6, 5, 1, 2.58, 2.58),
(6, 2, 2, 12.05, 24.1);