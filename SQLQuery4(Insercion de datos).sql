USE stockmate;

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

-- 3. Permisos por rol
INSERT INTO rol_permiso (rol_id, permiso_id) VALUES
-- Administrador
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7),
-- Vendedor
(2, 4), (2, 7),
-- Almacenero
(3, 1), (3, 2), (3, 5), (3, 6);

-- 4. Usuarios (con rol asignado directamente)
INSERT INTO usuarios (nombre, correo, contrasena, rol_id, estado) VALUES
('Admin Principal', 'admin@stockmate.com', SHA2('admin123', 256), 1, 'ACTIVO'),
('Derek Cagua', 'derek@stockmate.com', SHA2('derek123', 256), 2, 'ACTIVO'),
('Omar Mite', 'omar@stockmate.com', SHA2('omar123', 256), 2, 'ACTIVO'),
('Clarissa Centeno', 'clarissa@stockmate.com', SHA2('clarissa123', 256), 3, 'ACTIVO'),
('Alexander Cruz', 'alexander@stockmate.com', SHA2('alexander123', 256), 3, 'ACTIVO'),
('Jefferson Guashpa', 'jefferson@stockmate.com', SHA2('jefferson123', 256), 3, 'ACTIVO');

-- 5. Categorías
INSERT INTO categorias (nombre) VALUES 
('Papelería General'),
('Útiles Escolares'),
('Material de Oficina'),
('Arte y Manualidades'),
('Tecnología y Accesorios'),
('Limpieza y Mantenimiento'),
('Mobiliario y Ergonomía');

-- 6. Proveedores
INSERT INTO proveedores (nombre, correo, telefono, direccion) VALUES
('Distribuidora Nacional', 'contacto@dn.com', '0991002001', 'Av. Central 123'),
('Importadora Office', 'ventas@office.com', '0987654321', 'Calle Comercio 45'),
('Súper Papelería', 'papeleria@super.com', '0977543210', 'Av. Amazonas 202'),
('Mayorista Escolar', 'mayorista@escolar.com', '0912345678', 'Calle Los Andes 789'),
('Tech Supplies', 'tech@supplies.com', '0923456789', 'Zona Industrial Norte'),
('OfficeMax', 'info@officemax.com', '0911223344', 'Plaza Norte'),
('MegaDistribuidor', 'ventas@megadist.com', '0909876543', 'Av. Libertad 101'),
('PromoEquipos', 'contacto@promoequipos.com', '0912346789', 'Calle 12 Octubre'),
('Librería Central', 'info@libreriacentral.com', '0987456321', 'La Floresta'),
('Punto Escolar', 'ventas@puntoescolar.com', '0971234567', 'Sur Ciudad'),
('Todo Arte', 'arte@todoarte.com', '0934567890', 'Centro Histórico'),
('Eco Proveedores', 'eco@proveedores.com', '0945678901', 'EcoParque Industrial'),
('Suminca', 'contacto@suminca.com', '0901122334', 'Av. República'),
('OfiExpress', 'contacto@ofiexpress.com', '0911556677', 'Zona Empresarial'),
('Distribuciones Sur', 'ventas@distsur.com', '0933221100', 'Av. Suramérica'),
('Mundo Oficina', 'ventas@mundooficina.com', '0911888999', 'Centro Norte'),
('Equipos Total', 'ventas@equipostotal.com', '0977001122', 'Zona Norte'),
('School Depot', 'ventas@schooldepot.com', '0922887766', 'Zona Escolar'),
('Accesorios TI', 'ventas@accesoristi.com', '0988888877', 'Tech Park'),
('Colores y Más', 'ventas@coloresymas.com', '0966666655', 'Av. Las Artes');

-- 7. Clientes
INSERT INTO clientes (nombre, correo, telefono, direccion) VALUES
('María López', 'maria.lopez@gmail.com', '0987651234', 'Quito Norte'),
('Luis Castillo', 'luis.castillo@yahoo.com', '0911122233', 'Guayaquil Centro'),
('Empresa XYZ', 'contacto@xyz.com', '0998877665', 'Av. Empresarial 777'),
('Colegio Santa Fe', 'info@santafe.edu.ec', '0955566778', 'Machala'),
('Patricia Jara', 'paty.jara@hotmail.com', '0933344556', 'Cuenca Sur'),
('Quique Saldaña Borrego', 'rmartorell@aguilera.es', '7902245254', 'Badajoz'),
('Rosendo Puente Carrera', 'huguetandres-felipe@chaves.net', '2975349128', 'Melilla'),
('Jorge Merino', 'jorge.merino@gmail.com', '0933001122', 'Ambato'),
('Escuela Los Andes', 'escuela@losandes.edu', '0977771234', 'Riobamba'),
('Comercial Andina', 'contacto@andina.com', '0922345678', 'Loja'),
('Fundación Educativa', 'contacto@fundacion.edu', '0981122334', 'Quito Centro'),
('Librería La Estrella', 'ventas@laestrella.com', '0944556677', 'Guayaquil Norte'),
('Centro de Capacitación', 'info@capacitacion.com', '0911223344', 'Cuenca Centro'),
('Escuela Nueva Vida', 'contacto@nuevavida.edu', '0977888999', 'Machala Sur'),
('Distribuciones ABC', 'ventas@distribucionesabc.com', '0933112233', 'Quito Sur'),
('Comercial Lopez', 'comercial.lopez@gmail.com', '0999444555', 'Guayaquil Este'),
('Instituto Nacional', 'info@institutonacional.edu', '0911999888', 'Ambato Centro'),
('Corporación Educar', 'contacto@corporacioneducar.com', '0922003344', 'Loja Norte'),
('Escuela San José', 'info@sanjose.edu', '0955667788', 'Riobamba Oeste'),
('Papelería El Rincón', 'ventas@elrincon.com', '0988776655', 'Cuenca Norte');

-- 8. Productos (sin stock_actual, lo calculan los triggers)
INSERT INTO productos (categoria_id, proveedor_id, nombre, descripcion, precio_compra, precio_venta, stock_minimo) VALUES
(1, 1, 'Cuaderno A4', 'Cuaderno grande rayado 100 hojas', 1.20, 2.00, 20),
(2, 3, 'Lápiz de carbón', 'Lápiz escolar HB', 0.10, 0.20, 100),
(2, 5, 'Bolígrafo azul', 'Bolígrafo tinta azul punta media', 0.25, 0.50, 50),
(1, 2, 'Resma de papel bond', 'Papel tamaño carta 500 hojas', 3.50, 5.00, 15),
(4, 4, 'Marcadores permanentes', 'Set de 6 colores punta fina', 1.80, 3.50, 10),
(2, 6, 'Tijeras escolares', 'Tijeras punta roma para niños', 0.90, 1.50, 20),
(1, 7, 'Corrector líquido', 'Botella de corrector blanco 20ml', 0.60, 1.00, 15),
(2, 8, 'Cartulina blanca', 'Cartulina tamaño A4 180g', 0.20, 0.40, 100),
(4, 10, 'Pintura témpera', 'Frasco de 250ml color rojo', 1.10, 2.00, 10),
(2, 9, 'Sacapuntas doble', 'Sacapuntas con depósito', 0.30, 0.60, 25),
(1, 11, 'Block de notas adhesivas', 'Pack de 3 colores surtidos', 0.90, 1.50, 20),
(3, 12, 'Engrapadora metálica', 'Capacidad de 20 hojas', 2.80, 4.50, 8),
(3, 13, 'Perforadora 2 huecos', 'Perforadora para oficina', 3.00, 5.00, 6),
(2, 14, 'Goma de borrar', 'Goma blanca no tóxica', 0.15, 0.30, 50),
(4, 15, 'Pinceles escolares', 'Set de 3 pinceles básicos', 0.90, 1.80, 15),
(1, 16, 'Carpeta manila', 'Carpeta tamaño carta con pestaña', 0.25, 0.50, 40),
(3, 17, 'Separadores plásticos', 'Juego de 5 separadores A4', 0.60, 1.20, 20),
(2, 18, 'Regla plástica 30cm', 'Regla transparente flexible', 0.35, 0.70, 30),
(4, 19, 'Colores de madera', 'Caja de 12 colores escolares', 1.50, 2.80, 10),
(1, 20, 'Agenda académica', 'Agenda escolar con calendario', 2.00, 3.50, 10);

-- 9. Compras
INSERT INTO compras (producto_id, usuario_id, monto_total, cantidad, fecha_transaccion) VALUES
-- Día 1 (hace 98 días)
(1, 3, 120.00, 100, NOW() - INTERVAL 98 DAY),
(2, 4, 25.00, 125, NOW() - INTERVAL 98 DAY),
(3, 5, 50.00, 100, NOW() - INTERVAL 98 DAY),

-- Día 2 (hace 91 días)
(4, 3, 210.00, 60, NOW() - INTERVAL 91 DAY),
(5, 2, 54.00, 30, NOW() - INTERVAL 91 DAY),
(6, 1, 80.50, 50, NOW() - INTERVAL 91 DAY),

-- Día 3 (hace 84 días)
(7, 4, 100.00, 60, NOW() - INTERVAL 84 DAY),
(8, 5, 120.00, 200, NOW() - INTERVAL 84 DAY),
(9, 2, 75.00, 30, NOW() - INTERVAL 84 DAY),

-- Día 4 (hace 77 días)
(10, 3, 156.00, 20, NOW() - INTERVAL 77 DAY),
(11, 6, 135.00, 30, NOW() - INTERVAL 77 DAY),
(12, 1, 27.00, 18, NOW() - INTERVAL 77 DAY),

-- Día 5 (hace 70 días)
(13, 5, 18.00, 60, NOW() - INTERVAL 70 DAY),
(14, 4, 10.50, 35, NOW() - INTERVAL 70 DAY),
(15, 2, 42.00, 20, NOW() - INTERVAL 70 DAY),

-- Día 6 (hace 63 días)
(16, 3, 20.00, 40, NOW() - INTERVAL 63 DAY),
(17, 5, 24.00, 40, NOW() - INTERVAL 63 DAY),
(18, 1, 35.00, 50, NOW() - INTERVAL 63 DAY),

-- Día 7 (hace 56 días)
(19, 6, 28.00, 20, NOW() - INTERVAL 56 DAY),
(20, 2, 35.00, 25, NOW() - INTERVAL 56 DAY),
(1, 3, 144.00, 120, NOW() - INTERVAL 56 DAY),

-- Día 8 (hace 49 días)
(2, 4, 30.00, 150, NOW() - INTERVAL 49 DAY),
(3, 5, 55.00, 110, NOW() - INTERVAL 49 DAY),
(4, 3, 225.00, 65, NOW() - INTERVAL 49 DAY),

-- Día 9 (hace 42 días)
(5, 2, 60.00, 33, NOW() - INTERVAL 42 DAY),
(6, 1, 90.00, 55, NOW() - INTERVAL 42 DAY),
(7, 4, 110.00, 66, NOW() - INTERVAL 42 DAY),

-- Día 10 (hace 35 días)
(8, 5, 130.00, 215, NOW() - INTERVAL 35 DAY),
(9, 2, 80.00, 35, NOW() - INTERVAL 35 DAY),
(10, 3, 165.00, 22, NOW() - INTERVAL 35 DAY),

-- Día 11 (hace 28 días)
(11, 6, 140.00, 31, NOW() - INTERVAL 28 DAY),
(12, 1, 29.00, 19, NOW() - INTERVAL 28 DAY),
(13, 5, 19.00, 65, NOW() - INTERVAL 28 DAY),

-- Día 12 (hace 21 días)
(14, 4, 11.00, 36, NOW() - INTERVAL 21 DAY),
(15, 2, 44.00, 22, NOW() - INTERVAL 21 DAY),
(16, 3, 22.00, 42, NOW() - INTERVAL 21 DAY),

-- Día 13 (hace 14 días)
(17, 5, 26.00, 43, NOW() - INTERVAL 14 DAY),
(18, 1, 38.00, 54, NOW() - INTERVAL 14 DAY),
(19, 6, 30.00, 21, NOW() - INTERVAL 14 DAY),

-- Día 14 (hace 7 días)
(20, 2, 37.00, 27, NOW() - INTERVAL 7 DAY),
(1, 3, 120.00, 100, NOW() - INTERVAL 7 DAY),
(2, 4, 25.00, 125, NOW() - INTERVAL 7 DAY);

-- 10. Ventas
INSERT INTO ventas 
(cliente_id, usuario_id, numero_factura, monto_total, monto_descuento, total_con_iva, fecha, metodo_pago, observaciones) 
VALUES
(1, 2, 'FAC-1001', 0, 0, 0, NOW() - INTERVAL 75 DAY, 'EFECTIVO', 'Pago exacto'),
(2, 3, 'FAC-1002', 0, 0, 0, NOW() - INTERVAL 70 DAY, 'TRANSFERENCIA', 'Transferencia desde Banco Pichincha'),
(3, 4, 'FAC-1003', 0, 0, 0, NOW() - INTERVAL 65 DAY, 'TARJETA_CREDITO', 'Pagó con tarjeta Visa'),
(4, 5, 'FAC-1004', 0, 0, 0, NOW() - INTERVAL 60 DAY, 'EFECTIVO', ''),
(5, 6, 'FAC-1005', 0, 0, 0, NOW() - INTERVAL 55 DAY, 'EFECTIVO', 'Pago completo'),
(6, 2, 'FAC-1006', 0, 0, 0, NOW() - INTERVAL 50 DAY, 'EFECTIVO', ''),
(7, 3, 'FAC-1007', 0, 0, 0, NOW() - INTERVAL 45 DAY, 'EFECTIVO', ''),
(1, 4, 'FAC-1008', 0, 0, 0, NOW() - INTERVAL 40 DAY, 'TRANSFERENCIA', ''),
(2, 5, 'FAC-1009', 0, 0, 0, NOW() - INTERVAL 35 DAY, 'TARJETA_CREDITO', ''),
(3, 6, 'FAC-1010', 0, 0, 0, NOW() - INTERVAL 30 DAY, 'EFECTIVO', ''),
(4, 2, 'FAC-1011', 0, 0, 0, NOW() - INTERVAL 25 DAY, 'TRANSFERENCIA', ''),
(5, 3, 'FAC-1012', 0, 0, 0, NOW() - INTERVAL 20 DAY, 'TARJETA_CREDITO', ''),
(6, 4, 'FAC-1013', 0, 0, 0, NOW() - INTERVAL 15 DAY, 'EFECTIVO', ''),
(7, 5, 'FAC-1014', 0, 0, 0, NOW() - INTERVAL 10 DAY, 'EFECTIVO', ''),
(1, 6, 'FAC-1015', 0, 0, 0, NOW() - INTERVAL 5 DAY, 'TRANSFERENCIA', '');

-- 11. Detalles de venta
INSERT INTO detalles_venta (venta_id, producto_id, cantidad, precio_unitario, precio_total) VALUES
-- Venta 1 (3 productos)
(1, 1, 5, 2.00, 10.00),
(1, 2, 10, 0.20, 2.00),
(1, 3, 2, 9.00, 18.00),

-- Venta 2 (2 productos)
(2, 4, 4, 5.00, 20.00),
(2, 5, 3, 3.50, 10.50),

-- Venta 3 (4 productos)
(3, 1, 1, 2.00, 2.00),
(3, 6, 2, 12.00, 24.00),
(3, 7, 3, 7.50, 22.50),
(3, 8, 5, 3.00, 15.00),

-- Venta 4 (2 productos)
(4, 9, 10, 15.00, 150.00),
(4, 10, 1, 7.80, 7.80),

-- Venta 5 (1 producto)
(5, 11, 8, 2.70, 21.60),

-- Venta 6 (3 productos)
(6, 12, 6, 0.90, 5.40),
(6, 13, 10, 0.15, 1.50),
(6, 14, 4, 5.00, 20.00),

-- Venta 7 (2 productos)
(7, 15, 2, 4.00, 8.00),
(7, 16, 1, 8.00, 8.00),

-- Venta 8 (4 productos)
(8, 17, 3, 1.20, 3.60),
(8, 18, 2, 0.35, 0.70),
(8, 19, 10, 0.90, 9.00),
(8, 20, 7, 1.50, 10.50),

-- Venta 9 (1 producto)
(9, 1, 15, 2.00, 30.00),

-- Venta 10 (3 productos)
(10, 2, 20, 0.20, 4.00),
(10, 3, 2, 9.00, 18.00),
(10, 4, 5, 5.00, 25.00),

-- Venta 11 (2 productos)
(11, 5, 6, 3.50, 21.00),
(11, 6, 1, 12.00, 12.00),

-- Venta 12 (1 producto)
(12, 7, 4, 7.50, 30.00),

-- Venta 13 (3 productos)
(13, 8, 10, 3.00, 30.00),
(13, 9, 2, 15.00, 30.00),
(13, 10, 1, 7.80, 7.80),

-- Venta 14 (1 producto)
(14, 11, 3, 2.70, 8.10),

-- Venta 15 (1 producto)
(15, 12, 5, 0.90, 4.50);

