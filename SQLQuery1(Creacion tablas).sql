-- ========================================
-- ELIMINACIÓN Y CREACIÓN DE BASE DE DATOS
-- ========================================
DROP DATABASE IF EXISTS stockmate;
CREATE DATABASE stockmate CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE stockmate;

-- ========================================
-- ELIMINACIÓN Y CREACIÓN DE TABLESPACES PERSONALIZADOS
-- ========================================

-- Tablespace: ts_productos
DROP TABLESPACE ts_productos;

CREATE TABLESPACE ts_productos
  ADD DATAFILE 'ts_productos.ibd'
  ENGINE = InnoDB;

-- Tablespace: ts_ventas
DROP TABLESPACE ts_ventas;

CREATE TABLESPACE ts_ventas
  ADD DATAFILE 'ts_ventas.ibd'
  ENGINE = InnoDB;

-- ========================================
-- TABLAS DE SEGURIDAD Y ROLES
-- ========================================

-- Tabla: roles
-- Descripción: Define los roles del sistema (Admin, Almacenero, Cajero, etc.)
CREATE TABLE IF NOT EXISTS roles (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla: permisos
-- Descripción: Permisos o acciones específicas asignables a roles
CREATE TABLE IF NOT EXISTS permisos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla: rol_permiso
-- Descripción: Relación N:M entre roles y permisos
CREATE TABLE IF NOT EXISTS rol_permiso (
    rol_id BIGINT UNSIGNED NOT NULL,
    permiso_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (rol_id, permiso_id),
    FOREIGN KEY (rol_id) REFERENCES roles(id) ON DELETE CASCADE,
    FOREIGN KEY (permiso_id) REFERENCES permisos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla: usuarios
-- Descripción: Usuarios del sistema (con su rol correspondiente)
CREATE TABLE IF NOT EXISTS usuarios (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    correo VARCHAR(255) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    rol_id BIGINT UNSIGNED NOT NULL,
    estado ENUM('ACTIVO', 'INACTIVO') DEFAULT 'ACTIVO',
    FOREIGN KEY (rol_id) REFERENCES roles(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================
-- TABLAS GENERALES
-- ========================================

-- Tabla: categorias
-- Descripción: Categorías de productos
CREATE TABLE IF NOT EXISTS categorias (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    estado ENUM('ACTIVO', 'INACTIVO') DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla: proveedores
-- Descripción: Proveedores de productos
CREATE TABLE IF NOT EXISTS proveedores (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    correo VARCHAR(255) UNIQUE,
    telefono VARCHAR(20),
    direccion TEXT,
    estado ENUM('ACTIVO', 'INACTIVO') DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla: clientes
-- Descripción: Clientes de las ventas realizadas
CREATE TABLE IF NOT EXISTS clientes (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    correo VARCHAR(255) UNIQUE,
    telefono VARCHAR(20),
    direccion TEXT,
    estado ENUM('ACTIVO', 'INACTIVO') DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================
-- TABLAS CON VOLUMEN USANDO TABLESPACES
-- ========================================

-- Tabla: productos
-- Descripción: Productos de inventario
-- Tablespace: ts_productos
CREATE TABLE IF NOT EXISTS productos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    categoria_id BIGINT UNSIGNED,
    proveedor_id BIGINT UNSIGNED,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT NOT NULL,
    precio_compra DECIMAL(10,2) NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,
    stock_actual INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 10,
    ruta_imagen VARCHAR(255),
    estado ENUM('ACTIVO', 'INACTIVO') DEFAULT 'ACTIVO',
    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE SET NULL,
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(id) ON DELETE SET NULL
) TABLESPACE ts_productos
  ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla: compras
-- Descripción: Registro de compras de productos realizadas por usuarios
-- Tablespace: ts_productos
CREATE TABLE IF NOT EXISTS compras (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    producto_id BIGINT UNSIGNED NOT NULL,
    usuario_id BIGINT UNSIGNED NOT NULL,
    monto_total DECIMAL(10,2) NOT NULL,
    cantidad INT UNSIGNED NOT NULL,
    fecha_transaccion DATETIME NOT NULL,
    FOREIGN KEY (producto_id) REFERENCES productos(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
) TABLESPACE ts_productos
  ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla: ventas
-- Descripción: Ventas realizadas a clientes
-- Tablespace: ts_ventas
CREATE TABLE IF NOT EXISTS ventas (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    cliente_id BIGINT UNSIGNED NOT NULL,
    usuario_id BIGINT UNSIGNED NOT NULL,
    numero_factura VARCHAR(255) NOT NULL UNIQUE,
    monto_total DECIMAL(10,2) NOT NULL DEFAULT 0,
    porcentaje_descuento TINYINT NOT NULL DEFAULT 0,
    monto_descuento DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_con_iva DECIMAL(10,2) NOT NULL DEFAULT 0,
    fecha DATETIME NOT NULL,
    metodo_pago ENUM('EFECTIVO', 'TARJETA_CREDITO', 'TARJETA_DEBITO', 'TRANSFERENCIA', 'OTRO') NOT NULL DEFAULT 'EFECTIVO',
    observaciones TEXT,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
) TABLESPACE ts_ventas
  ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla: detalles_venta
-- Descripción: Detalle de productos vendidos en cada venta
-- Tablespace: ts_ventas (hereda tablespace de ventas si se requiere)
CREATE TABLE IF NOT EXISTS detalles_venta (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    venta_id BIGINT UNSIGNED NOT NULL,
    producto_id BIGINT UNSIGNED NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    precio_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (venta_id) REFERENCES ventas(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;