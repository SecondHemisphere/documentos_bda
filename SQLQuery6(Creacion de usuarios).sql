-- ==========================================
-- CREACIÓN DE USUARIOS CON DIFERENTES ROLES
-- PARA EL PROYECTO 'stockmate'
-- ==========================================

-- ================================
-- ELIMINAR USUARIOS SI EXISTEN
-- ================================
DROP USER IF EXISTS 'cagua'@'localhost';
DROP USER IF EXISTS 'mite'@'localhost';
DROP USER IF EXISTS 'cruz'@'localhost';
DROP USER IF EXISTS 'centeno'@'localhost';
DROP USER IF EXISTS 'guashpa'@'localhost';

-- ================================
-- USUARIOS CON TODOS LOS PRIVILEGIOS
-- ================================
CREATE USER 'cagua'@'localhost' IDENTIFIED BY 'cagua123';
GRANT ALL PRIVILEGES ON stockmate.* TO 'cagua'@'localhost' WITH GRANT OPTION;

CREATE USER 'mite'@'localhost' IDENTIFIED BY 'mite123';
GRANT ALL PRIVILEGES ON stockmate.* TO 'mite'@'localhost' WITH GRANT OPTION;

CREATE USER 'cruz'@'localhost' IDENTIFIED BY 'cruz123';
GRANT ALL PRIVILEGES ON stockmate.* TO 'cruz'@'localhost' WITH GRANT OPTION;

-- ================================
-- USUARIOS CON PRIVILEGIOS OPERATIVOS
-- ================================
CREATE USER 'centeno'@'localhost' IDENTIFIED BY 'centeno123';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX, TRIGGER
  ON stockmate.* TO 'centeno'@'localhost';

CREATE USER 'guashpa'@'localhost' IDENTIFIED BY 'guashpa123';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX, TRIGGER
  ON stockmate.* TO 'guashpa'@'localhost';
