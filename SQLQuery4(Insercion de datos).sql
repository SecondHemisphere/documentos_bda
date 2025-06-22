USE stockmate;

-- 1. Roles
INSERT INTO roles (nombre) VALUES 
('Administrador'),
('Vendedor'),
('Almacenero');

-- 2. Permisos
INSERT INTO permisos (nombre) VALUES
('usuarios.ver'),
('usuarios.crear'),
('usuarios.editar'),
('usuarios.eliminar'),

('roles.ver'),
('roles.crear'),
('roles.editar'),
('roles.eliminar'),

('categorias.ver'),
('categorias.crear'),
('categorias.editar'),
('categorias.eliminar'),

('productos.ver'),
('productos.crear'),
('productos.editar'),
('productos.eliminar'),

('proveedores.ver'),
('proveedores.crear'),
('proveedores.editar'),
('proveedores.eliminar'),

('clientes.ver'),
('clientes.crear'),
('clientes.editar'),
('clientes.eliminar'),

('compras.ver'),
('compras.crear'),
('compras.editar'),
('compras.eliminar'),

('ventas.ver'),
('ventas.crear'),
('ventas.editar'),
('ventas.eliminar'),

('reportes.ver');

-- 3. Permisos por rol

-- Administrador (id = 1)
INSERT INTO rol_permiso (rol_id, permiso_id)
SELECT 1, id FROM permisos;

-- Vendedor (id = 2)
INSERT INTO rol_permiso (rol_id, permiso_id) VALUES
(2, (SELECT id FROM permisos WHERE nombre = 'clientes.ver')),
(2, (SELECT id FROM permisos WHERE nombre = 'clientes.crear')),
(2, (SELECT id FROM permisos WHERE nombre = 'clientes.editar')),
(2, (SELECT id FROM permisos WHERE nombre = 'clientes.eliminar')),

(2, (SELECT id FROM permisos WHERE nombre = 'ventas.ver')),
(2, (SELECT id FROM permisos WHERE nombre = 'ventas.crear')),
(2, (SELECT id FROM permisos WHERE nombre = 'ventas.editar')),
(2, (SELECT id FROM permisos WHERE nombre = 'ventas.eliminar')),

(2, (SELECT id FROM permisos WHERE nombre = 'reportes.ver'));

-- Almacenero (id = 3)
INSERT INTO rol_permiso (rol_id, permiso_id) VALUES
(3, (SELECT id FROM permisos WHERE nombre = 'categorias.ver')),
(3, (SELECT id FROM permisos WHERE nombre = 'categorias.crear')),
(3, (SELECT id FROM permisos WHERE nombre = 'categorias.editar')),
(3, (SELECT id FROM permisos WHERE nombre = 'categorias.eliminar')),

(3, (SELECT id FROM permisos WHERE nombre = 'productos.ver')),
(3, (SELECT id FROM permisos WHERE nombre = 'productos.crear')),
(3, (SELECT id FROM permisos WHERE nombre = 'productos.editar')),
(3, (SELECT id FROM permisos WHERE nombre = 'productos.eliminar')),

(3, (SELECT id FROM permisos WHERE nombre = 'proveedores.ver')),
(3, (SELECT id FROM permisos WHERE nombre = 'proveedores.crear')),
(3, (SELECT id FROM permisos WHERE nombre = 'proveedores.editar')),
(3, (SELECT id FROM permisos WHERE nombre = 'proveedores.eliminar')),

(3, (SELECT id FROM permisos WHERE nombre = 'compras.ver')),
(3, (SELECT id FROM permisos WHERE nombre = 'compras.crear')),
(3, (SELECT id FROM permisos WHERE nombre = 'compras.editar')),
(3, (SELECT id FROM permisos WHERE nombre = 'compras.eliminar')),

(3, (SELECT id FROM permisos WHERE nombre = 'reportes.ver'));

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
('Colores y Más', 'ventas@coloresymas.com', '0966666655', 'Av. Las Artes'),
('Papelería Escolar', 'ventas@papeleriaescolar.com', '0954321876', 'Av. La Prensa 111'),
('Distribuidora Andes', 'contacto@andesdist.com', '0933445566', 'Av. América 45'),
('Global Suministros', 'info@globalsuministros.com', '0966778899', 'Sector Industrial Sur'),
('OfiTotal', 'ventas@ofitotal.com', '0922113344', 'Parque Empresarial Quito'),
('Comercial Norte', 'contacto@comercialnorte.com', '0911554433', 'Av. Occidental 300');

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
('Papelería El Rincón', 'ventas@elrincon.com', '0988776655', 'Cuenca Norte'),
('Unidad Educativa San Marcos', 'info@sanmarcos.edu', '0987653322', 'Tena'),
('Distribuciones Eléctricas', 'ventas@distribuciones-electricas.com', '0911887766', 'Portoviejo'),
('Instituto Técnico Loja', 'contacto@institutoloja.edu', '0933445566', 'Loja Sur'),
('Papelería Express', 'info@papeleriaexpress.com', '0966554433', 'Ibarra'),
('Centro Educativo Amanecer', 'amanecer@educativo.com', '0955667788', 'Santo Domingo');

-- 8. Productos
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
(1, 20, 'Agenda académica', 'Agenda escolar con calendario', 2.00, 3.50, 10),
(2, 1, 'Lápiz de color', 'Caja de 12 lápices de color', 1.20, 2.00, 15),
(3, 2, 'Archivador tamaño A-Z', 'Archivador de cartón forrado', 1.80, 3.00, 10),
(4, 3, 'Papel crepé', 'Rollo de papel crepé colores variados', 0.50, 1.00, 30),
(5, 4, 'Mouse inalámbrico', 'Mouse óptico inalámbrico USB', 4.00, 6.50, 5),
(6, 5, 'Toallas desechables', 'Paquete de toallas multiuso', 1.30, 2.50, 20),
(7, 6, 'Silla ergonómica', 'Silla giratoria con soporte lumbar', 35.00, 60.00, 2),
(2, 7, 'Cuaderno espiral', 'Cuaderno con tapa dura 100 hojas', 1.50, 2.30, 25),
(1, 8, 'Papel kraft', 'Resma tamaño carta 500 hojas', 3.80, 6.00, 12),
(3, 9, 'Cinta adhesiva', 'Cinta transparente 24mm x 50m', 0.50, 1.00, 30),
(4, 10, 'Temperas escolares', 'Set de 12 colores 15ml', 2.00, 3.80, 10),
(5, 11, 'Teclado USB', 'Teclado alámbrico estándar', 5.00, 8.00, 6),
(6, 12, 'Limpiador multiusos', 'Botella de 1L con atomizador', 2.20, 3.50, 10),
(7, 13, 'Escritorio pequeño', 'Escritorio MDF color blanco', 40.00, 65.00, 2),
(2, 14, 'Marcador fluorescente', 'Set de 4 colores neón', 1.00, 1.80, 15),
(1, 15, 'Plumones para pizarra', 'Set de 5 colores con borrador', 1.50, 2.50, 20),
(3, 16, 'Carpetas colgantes', 'Paquete de 10 carpetas verdes', 2.50, 4.00, 10),
(4, 17, 'Pinceles gruesos', 'Set de 4 pinceles grandes', 1.20, 2.00, 8),
(5, 18, 'Memoria USB 16GB', 'Unidad flash USB 2.0', 5.50, 9.00, 10),
(6, 19, 'Jabón líquido', 'Galón de 3.8L antibacterial', 3.50, 6.00, 12),
(7, 20, 'Silla plástica apilable', 'Color negro con respaldo', 12.00, 18.00, 5),
(2, 21, 'Tiza blanca', 'Caja de 100 unidades', 1.00, 1.80, 30),
(1, 22, 'Cartapacios escolares', 'Cartapacios tamaño oficio', 0.80, 1.50, 25),
(3, 23, 'Clips metálicos', 'Caja de 100 clips grandes', 0.60, 1.00, 30),
(4, 24, 'Acuarelas escolares', 'Set de 12 colores', 1.20, 2.00, 10),
(5, 25, 'Cable HDMI', 'Cable de 1.5m alta velocidad', 2.50, 4.00, 8),
(6, 1, 'Guantes de látex', 'Caja de 100 unidades talla M', 4.00, 6.50, 10),
(7, 2, 'Escritorio infantil', 'Para niños de 6 a 10 años', 25.00, 40.00, 3),
(2, 3, 'Libreta de apuntes', 'Libreta pequeña rayada', 0.90, 1.60, 30),
(1, 4, 'Folder plástico con broche', 'Tamaño carta colores surtidos', 0.70, 1.20, 40),
(3, 5, 'Grapas metálicas', 'Caja de 5000 grapas 26/6', 0.80, 1.30, 50);

-- 9. Compras (solo usuarios con rol almacenero: 4, 5, 6)
INSERT INTO compras (producto_id, usuario_id, monto_total, cantidad, fecha_transaccion) VALUES
-- Día 1 (hace 98 días)
(1, 4, 120.00, 100, NOW() - INTERVAL 98 DAY),
(2, 5, 25.00, 125, NOW() - INTERVAL 98 DAY),
(3, 6, 50.00, 100, NOW() - INTERVAL 98 DAY),

-- Día 2 (hace 91 días)
(4, 4, 210.00, 60, NOW() - INTERVAL 91 DAY),
(5, 5, 54.00, 30, NOW() - INTERVAL 91 DAY),
(6, 6, 80.50, 50, NOW() - INTERVAL 91 DAY),

-- Día 3 (hace 84 días)
(7, 4, 100.00, 60, NOW() - INTERVAL 84 DAY),
(8, 5, 120.00, 200, NOW() - INTERVAL 84 DAY),
(9, 6, 75.00, 30, NOW() - INTERVAL 84 DAY),
(21, 4, 18.00, 15, NOW() - INTERVAL 84 DAY),
(22, 5, 30.00, 20, NOW() - INTERVAL 84 DAY),
(23, 6, 12.00, 10, NOW() - INTERVAL 84 DAY),

-- Día 4 (hace 77 días)
(10, 4, 156.00, 20, NOW() - INTERVAL 77 DAY),
(11, 6, 135.00, 30, NOW() - INTERVAL 77 DAY),
(12, 4, 27.00, 18, NOW() - INTERVAL 77 DAY),
(24, 5, 20.00, 16, NOW() - INTERVAL 77 DAY),
(25, 6, 32.00, 14, NOW() - INTERVAL 77 DAY),
(26, 4, 40.00, 10, NOW() - INTERVAL 77 DAY),

-- Día 5 (hace 70 días)
(13, 5, 18.00, 60, NOW() - INTERVAL 70 DAY),
(14, 4, 10.50, 35, NOW() - INTERVAL 70 DAY),
(15, 5, 42.00, 20, NOW() - INTERVAL 70 DAY),
(27, 6, 18.00, 18, NOW() - INTERVAL 70 DAY),
(28, 4, 25.00, 20, NOW() - INTERVAL 70 DAY),
(29, 5, 22.00, 15, NOW() - INTERVAL 70 DAY),

-- Día 6 (hace 63 días)
(16, 4, 20.00, 40, NOW() - INTERVAL 63 DAY),
(17, 5, 24.00, 40, NOW() - INTERVAL 63 DAY),
(18, 6, 35.00, 50, NOW() - INTERVAL 63 DAY),
(30, 4, 26.00, 17, NOW() - INTERVAL 63 DAY),
(31, 5, 33.00, 21, NOW() - INTERVAL 63 DAY),
(32, 6, 15.00, 10, NOW() - INTERVAL 63 DAY),

-- Día 7 (hace 56 días)
(19, 6, 28.00, 20, NOW() - INTERVAL 56 DAY),
(20, 5, 35.00, 25, NOW() - INTERVAL 56 DAY),
(1, 4, 144.00, 120, NOW() - INTERVAL 56 DAY),
(33, 6, 12.00, 14, NOW() - INTERVAL 56 DAY),
(34, 5, 40.00, 20, NOW() - INTERVAL 56 DAY),
(35, 4, 18.00, 12, NOW() - INTERVAL 56 DAY),

-- Día 8 (hace 49 días)
(2, 5, 30.00, 150, NOW() - INTERVAL 49 DAY),
(3, 6, 55.00, 110, NOW() - INTERVAL 49 DAY),
(4, 4, 225.00, 65, NOW() - INTERVAL 49 DAY),
(36, 5, 22.00, 16, NOW() - INTERVAL 49 DAY),
(37, 6, 30.00, 15, NOW() - INTERVAL 49 DAY),
(38, 4, 35.00, 19, NOW() - INTERVAL 49 DAY),

-- Día 9 (hace 42 días)
(5, 5, 60.00, 33, NOW() - INTERVAL 42 DAY),
(6, 6, 90.00, 55, NOW() - INTERVAL 42 DAY),
(7, 4, 110.00, 66, NOW() - INTERVAL 42 DAY),
(39, 5, 28.00, 20, NOW() - INTERVAL 42 DAY),
(40, 6, 24.00, 18, NOW() - INTERVAL 42 DAY),
(41, 4, 33.00, 22, NOW() - INTERVAL 42 DAY),

-- Día 10 (hace 35 días)
(8, 5, 130.00, 215, NOW() - INTERVAL 35 DAY),
(9, 6, 80.00, 35, NOW() - INTERVAL 35 DAY),
(10, 4, 165.00, 22, NOW() - INTERVAL 35 DAY),
(42, 5, 26.00, 14, NOW() - INTERVAL 35 DAY),
(43, 6, 20.00, 10, NOW() - INTERVAL 35 DAY),
(44, 4, 19.00, 15, NOW() - INTERVAL 35 DAY),

-- Día 11 (hace 28 días)
(11, 6, 140.00, 31, NOW() - INTERVAL 28 DAY),
(12, 4, 29.00, 19, NOW() - INTERVAL 28 DAY),
(13, 5, 19.00, 65, NOW() - INTERVAL 28 DAY),
(45, 6, 21.00, 12, NOW() - INTERVAL 28 DAY),
(46, 4, 25.00, 17, NOW() - INTERVAL 28 DAY),
(47, 5, 30.00, 20, NOW() - INTERVAL 28 DAY),

-- Día 12 (hace 21 días)
(14, 4, 11.00, 36, NOW() - INTERVAL 21 DAY),
(15, 5, 44.00, 22, NOW() - INTERVAL 21 DAY),
(16, 6, 22.00, 42, NOW() - INTERVAL 21 DAY),
(48, 4, 18.00, 13, NOW() - INTERVAL 21 DAY),
(49, 5, 23.00, 15, NOW() - INTERVAL 21 DAY),
(50, 6, 29.00, 19, NOW() - INTERVAL 21 DAY),

-- Día 13 (hace 14 días)
(17, 5, 26.00, 43, NOW() - INTERVAL 14 DAY),
(18, 6, 38.00, 54, NOW() - INTERVAL 14 DAY),
(19, 4, 30.00, 21, NOW() - INTERVAL 14 DAY),

-- Día 14 (hace 7 días)
(20, 5, 37.00, 27, NOW() - INTERVAL 7 DAY),
(1, 6, 120.00, 100, NOW() - INTERVAL 7 DAY),
(2, 4, 25.00, 125, NOW() - INTERVAL 7 DAY);

-- 10. Ventas (solo usuarios vendedores 2 y 3)
INSERT INTO ventas 
(cliente_id, usuario_id, numero_factura, monto_total, monto_descuento, total_con_iva, fecha, metodo_pago, observaciones) 
VALUES
(3, 2, 'FAC-1001', 120.00, 0, 134.40, NOW() - INTERVAL 150 DAY, 'EFECTIVO', 'Pago exacto'),
(15, 3, 'FAC-1002', 85.00, 5.00, 90.72, NOW() - INTERVAL 145 DAY, 'TRANSFERENCIA', 'Transferencia realizada'),
(8, 2, 'FAC-1003', 60.00, 0, 67.20, NOW() - INTERVAL 140 DAY, 'TARJETA_CREDITO', 'Pagó con tarjeta Visa'),
(22, 3, 'FAC-1004', 150.00, 10.00, 151.20, NOW() - INTERVAL 135 DAY, 'EFECTIVO', ''),
(12, 2, 'FAC-1005', 90.00, 0, 100.80, NOW() - INTERVAL 130 DAY, 'EFECTIVO', 'Pago completo'),
(4, 3, 'FAC-1006', 75.00, 0, 84.00, NOW() - INTERVAL 125 DAY, 'EFECTIVO', ''),
(19, 2, 'FAC-1007', 140.00, 5.00, 142.80, NOW() - INTERVAL 120 DAY, 'EFECTIVO', ''),
(7, 3, 'FAC-1008', 110.00, 0, 123.20, NOW() - INTERVAL 115 DAY, 'TRANSFERENCIA', ''),
(25, 2, 'FAC-1009', 200.00, 10.00, 187.20, NOW() - INTERVAL 110 DAY, 'TARJETA_CREDITO', ''),
(10, 3, 'FAC-1010', 95.00, 5.00, 90.00, NOW() - INTERVAL 105 DAY, 'EFECTIVO', ''),
(1, 2, 'FAC-1011', 120.00, 0, 134.40, NOW() - INTERVAL 100 DAY, 'TRANSFERENCIA', ''),
(13, 3, 'FAC-1012', 85.00, 0, 95.20, NOW() - INTERVAL 95 DAY, 'TARJETA_CREDITO', ''),
(6, 2, 'FAC-1013', 75.00, 5.00, 72.00, NOW() - INTERVAL 90 DAY, 'EFECTIVO', ''),
(21, 3, 'FAC-1014', 130.00, 10.00, 130.80, NOW() - INTERVAL 85 DAY, 'EFECTIVO', ''),
(17, 2, 'FAC-1015', 95.00, 0, 106.40, NOW() - INTERVAL 80 DAY, 'TRANSFERENCIA', 'Pago anticipado'),
(5, 3, 'FAC-1016', 140.00, 0, 157.60, NOW() - INTERVAL 75 DAY, 'EFECTIVO', 'Venta reciente'),
(2, 2, 'FAC-1017', 160.00, 5.00, 163.20, NOW() - INTERVAL 70 DAY, 'TARJETA_CREDITO', ''),
(18, 3, 'FAC-1018', 110.00, 0, 123.20, NOW() - INTERVAL 65 DAY, 'TRANSFERENCIA', 'Pago con descuento'),
(11, 2, 'FAC-1019', 180.00, 0, 201.60, NOW() - INTERVAL 60 DAY, 'EFECTIVO', 'Venta final del día'),
(20, 3, 'FAC-1020', 130.00, 5.00, 124.20, NOW() - INTERVAL 55 DAY, 'EFECTIVO', ''),
(9, 2, 'FAC-1021', 105.00, 0, 117.60, NOW() - INTERVAL 50 DAY, 'TRANSFERENCIA', ''),
(14, 3, 'FAC-1022', 75.00, 5.00, 70.00, NOW() - INTERVAL 45 DAY, 'EFECTIVO', ''),
(16, 2, 'FAC-1023', 90.00, 0, 100.80, NOW() - INTERVAL 40 DAY, 'TARJETA_CREDITO', ''),
(24, 3, 'FAC-1024', 110.00, 0, 123.20, NOW() - INTERVAL 35 DAY, 'TRANSFERENCIA', ''),
(23, 2, 'FAC-1025', 80.00, 0, 89.60, NOW() - INTERVAL 30 DAY, 'EFECTIVO', ''),
(22, 3, 'FAC-1026', 150.00, 10.00, 136.80, NOW() - INTERVAL 25 DAY, 'EFECTIVO', ''),
(21, 2, 'FAC-1027', 95.00, 0, 106.40, NOW() - INTERVAL 20 DAY, 'TRANSFERENCIA', ''),
(19, 3, 'FAC-1028', 130.00, 0, 145.60, NOW() - INTERVAL 15 DAY, 'TARJETA_CREDITO', ''),
(8, 2, 'FAC-1029', 140.00, 5.00, 132.00, NOW() - INTERVAL 10 DAY, 'EFECTIVO', ''),
(7, 3, 'FAC-1030', 160.00, 0, 179.20, NOW() - INTERVAL 9 DAY, 'TRANSFERENCIA', ''),
(6, 2, 'FAC-1031', 120.00, 10.00, 126.00, NOW() - INTERVAL 8 DAY, 'EFECTIVO', ''),
(5, 3, 'FAC-1032', 110.00, 0, 123.20, NOW() - INTERVAL 7 DAY, 'TARJETA_CREDITO', ''),
(4, 2, 'FAC-1033', 130.00, 5.00, 127.20, NOW() - INTERVAL 6 DAY, 'EFECTIVO', ''),
(3, 3, 'FAC-1034', 150.00, 0, 168.00, NOW() - INTERVAL 5 DAY, 'TRANSFERENCIA', ''),
(2, 2, 'FAC-1035', 90.00, 0, 100.80, NOW() - INTERVAL 4 DAY, 'EFECTIVO', ''),
(1, 3, 'FAC-1036', 100.00, 5.00, 102.00, NOW() - INTERVAL 3 DAY, 'TARJETA_CREDITO', ''),
(12, 2, 'FAC-1037', 85.00, 0, 95.20, NOW() - INTERVAL 2 DAY, 'EFECTIVO', ''),
(15, 3, 'FAC-1038', 110.00, 10.00, 108.00, NOW() - INTERVAL 1 DAY, 'TRANSFERENCIA', ''),
(20, 2, 'FAC-1039', 95.00, 0, 106.40, NOW(), 'EFECTIVO', 'Venta final del día'),
(14, 3, 'FAC-1040', 130.00, 0, 145.60, NOW(), 'TARJETA_CREDITO', 'Pago completado');

-- 11. Detalles de venta (50 ventas con detalles, entre 1 y 4 productos cada una)
INSERT INTO detalles_venta (venta_id, producto_id, cantidad, precio_unitario, precio_total) VALUES
-- Venta 1
(1, 3, 5, 2.00, 10.00),
(1, 7, 3, 5.00, 15.00),

-- Venta 2
(2, 1, 10, 1.50, 15.00),

-- Venta 3
(3, 4, 2, 8.00, 16.00),
(3, 10, 1, 20.00, 20.00),
(3, 12, 4, 3.00, 12.00),

-- Venta 4
(4, 6, 7, 4.50, 31.50),

-- Venta 5
(5, 9, 3, 10.00, 30.00),
(5, 15, 2, 7.00, 14.00),

-- Venta 6
(6, 8, 6, 2.50, 15.00),

-- Venta 7
(7, 5, 4, 3.20, 12.80),
(7, 11, 3, 6.00, 18.00),

-- Venta 8
(8, 14, 5, 1.80, 9.00),
(8, 16, 2, 9.00, 18.00),
(8, 20, 1, 15.00, 15.00),

-- Venta 9
(9, 2, 8, 4.00, 32.00),

-- Venta 10
(10, 17, 3, 3.50, 10.50),
(10, 19, 5, 4.00, 20.00),

-- Venta 11
(11, 13, 10, 2.00, 20.00),

-- Venta 12
(12, 18, 4, 5.00, 20.00),
(12, 1, 2, 1.50, 3.00),

-- Venta 13
(13, 7, 3, 7.00, 21.00),
(13, 15, 1, 9.00, 9.00),

-- Venta 14
(14, 10, 6, 3.50, 21.00),

-- Venta 15
(15, 12, 2, 4.50, 9.00),

-- Venta 16
(16, 5, 5, 3.00, 15.00),
(16, 9, 2, 8.00, 16.00),

-- Venta 17
(17, 4, 3, 7.00, 21.00),

-- Venta 18
(18, 13, 1, 12.00, 12.00),
(18, 6, 5, 3.00, 15.00),

-- Venta 19
(19, 15, 2, 6.00, 12.00),
(19, 8, 3, 2.50, 7.50),

-- Venta 20
(20, 1, 10, 1.50, 15.00),

-- Venta 21
(21, 19, 4, 5.00, 20.00),
(21, 11, 2, 7.00, 14.00),

-- Venta 22
(22, 10, 3, 6.00, 18.00),

-- Venta 23
(23, 14, 5, 4.00, 20.00),
(23, 17, 1, 9.00, 9.00),

-- Venta 24
(24, 2, 7, 3.50, 24.50),

-- Venta 25
(25, 7, 3, 4.00, 12.00),
(25, 9, 5, 5.00, 25.00),

-- Venta 26
(26, 15, 2, 6.00, 12.00),

-- Venta 27
(27, 13, 4, 2.50, 10.00),
(27, 4, 3, 7.00, 21.00),

-- Venta 28
(28, 1, 6, 1.50, 9.00),

-- Venta 29
(29, 11, 7, 4.00, 28.00),

-- Venta 30
(30, 8, 3, 3.00, 9.00),
(30, 5, 5, 3.50, 17.50),

-- Venta 31
(31, 6, 8, 2.00, 16.00),

-- Venta 32
(32, 9, 2, 7.50, 15.00),
(32, 20, 1, 15.00, 15.00),

-- Venta 33
(33, 10, 5, 6.00, 30.00),

-- Venta 34
(34, 12, 4, 3.50, 14.00),

-- Venta 35
(35, 7, 3, 4.00, 12.00),

-- Venta 36
(36, 3, 6, 2.00, 12.00),
(36, 11, 2, 5.00, 10.00),

-- Venta 37
(37, 5, 8, 3.50, 28.00),

-- Venta 38
(38, 14, 1, 4.00, 4.00),
(38, 9, 4, 6.00, 24.00),

-- Venta 39
(39, 1, 5, 1.50, 7.50),

-- Venta 40
(40, 2, 7, 3.00, 21.00),
(40, 4, 3, 7.00, 21.00);