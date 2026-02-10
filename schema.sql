-- ============================================
-- BioArTec Database Schema
-- ============================================
-- Database para almacenar formularios de contacto e imágenes

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS bioartec_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE bioartec_db;

-- ============================================
-- Tabla: contactos
-- Almacena los mensajes del formulario de contacto
-- ============================================
CREATE TABLE IF NOT EXISTS contactos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    telefono VARCHAR(50),
    institucion VARCHAR(255),
    asunto VARCHAR(100) NOT NULL,
    mensaje TEXT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    estado ENUM('nuevo', 'leido', 'respondido', 'archivado') DEFAULT 'nuevo',
    ip_address VARCHAR(45),
    user_agent TEXT,
    INDEX idx_email (email),
    INDEX idx_fecha_creacion (fecha_creacion),
    INDEX idx_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Tabla: imagenes_contacto
-- Almacena las imágenes adjuntas en el formulario
-- ============================================
CREATE TABLE IF NOT EXISTS imagenes_contacto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    contacto_id INT NOT NULL,
    nombre_archivo VARCHAR(255) NOT NULL,
    nombre_original VARCHAR(255) NOT NULL,
    ruta_archivo VARCHAR(500) NOT NULL,
    tipo_mime VARCHAR(100),
    tamano_bytes INT,
    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (contacto_id) REFERENCES contactos(id) ON DELETE CASCADE,
    INDEX idx_contacto_id (contacto_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Tabla: newsletter_suscripciones
-- Almacena suscripciones al newsletter
-- ============================================
CREATE TABLE IF NOT EXISTS newsletter_suscripciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    fecha_suscripcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    token_verificacion VARCHAR(64),
    verificado BOOLEAN DEFAULT FALSE,
    fecha_verificacion TIMESTAMP NULL,
    INDEX idx_email (email),
    INDEX idx_activo (activo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Tabla: productos
-- Catálogo de productos ortopédicos
-- ============================================
CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(50) UNIQUE,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    categoria ENUM(
        'bucomaxilofacial',
        'columna',
        'cadera',
        'rodilla',
        'neurocirugia',
        'implantes3d'
    ) NOT NULL,
    subcategoria VARCHAR(100),
    precio_referencia DECIMAL(10,2),
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_categoria (categoria),
    INDEX idx_activo (activo),
    INDEX idx_codigo (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Tabla: imagenes_productos
-- Imágenes de productos
-- ============================================
CREATE TABLE IF NOT EXISTS imagenes_productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    nombre_archivo VARCHAR(255) NOT NULL,
    ruta_archivo VARCHAR(500) NOT NULL,
    tipo_mime VARCHAR(100),
    es_principal BOOLEAN DEFAULT FALSE,
    orden INT DEFAULT 0,
    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    INDEX idx_producto_id (producto_id),
    INDEX idx_es_principal (es_principal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Tabla: noticias
-- Blog/Noticias de la empresa
-- ============================================
CREATE TABLE IF NOT EXISTS noticias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    resumen TEXT,
    contenido LONGTEXT,
    categoria VARCHAR(100),
    imagen_destacada VARCHAR(500),
    autor VARCHAR(100),
    fecha_publicacion DATE,
    activo BOOLEAN DEFAULT TRUE,
    destacado BOOLEAN DEFAULT FALSE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_slug (slug),
    INDEX idx_activo (activo),
    INDEX idx_destacado (destacado),
    INDEX idx_fecha_publicacion (fecha_publicacion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Tabla: cotizaciones
-- Solicitudes de cotización de productos
-- ============================================
CREATE TABLE IF NOT EXISTS cotizaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    contacto_id INT,
    productos_solicitados JSON,
    cantidad_estimada INT,
    presupuesto_aproximado DECIMAL(10,2),
    urgencia ENUM('baja', 'media', 'alta') DEFAULT 'media',
    notas TEXT,
    estado ENUM('pendiente', 'en_proceso', 'enviada', 'cerrada') DEFAULT 'pendiente',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (contacto_id) REFERENCES contactos(id) ON DELETE SET NULL,
    INDEX idx_estado (estado),
    INDEX idx_fecha_creacion (fecha_creacion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Insertar datos de ejemplo - Productos
-- ============================================
INSERT INTO productos (codigo, nombre, descripcion, categoria, subcategoria) VALUES
-- Columna Vertebral
('COL-CERV-001', 'Sistema Cervical', 'Placas y tornillos para fusión cervical anterior', 'columna', 'cervical'),
('COL-CAGE-001', 'Cage Cervical PEEK', 'Cages de polímero biocompatible para fusión intersomática', 'columna', 'cervical'),
('COL-DORS-001', 'Fijación de Columna Dorsal', 'Sistema de tornillos pediculares y barras para columna torácica', 'columna', 'dorsal'),
('COL-LUMB-001', 'Sistema Lumbar', 'Instrumentación para fusión lumbar posterior', 'columna', 'lumbar'),
('COL-CAGE-002', 'Cage Lumbar PEEK', 'Cages expandibles para restauración de altura discal', 'columna', 'lumbar'),
('COL-ESCO-001', 'Sistema Escoliosis', 'Instrumentación de corrección y fijación para deformidades vertebrales', 'columna', 'escoliosis'),
('COL-CIFO-001', 'Cifoplastia', 'Balones y cementos para vertebroplastia y cifoplastia', 'columna', 'cifoplastia'),
('COL-REEM-001', 'Reemplazo Vertebral', 'Prótesis de cuerpo vertebral expandible', 'columna', 'reemplazo'),
('COL-LAMI-001', 'Laminoplastia', 'Placas y espaciadores para descompresión cervical', 'columna', 'cervical'),

-- Cadera
('CAD-AMIS-001', 'AMIS Medacta', 'Sistema de abordaje mínimamente invasivo anterior para artroplastia de cadera', 'cadera', 'AMIS'),
('CAD-COTI-001', 'Cotilos Acetabulares', 'Copas porosas de titanio con recubrimiento hidroxiapatita', 'cadera', 'cotilos'),
('CAD-TALL-001', 'Tallos Femorales', 'Tallos cementados y no cementados de diversas geometrías', 'cadera', 'tallos'),
('CAD-CABE-001', 'Cabezas Femorales', 'Cabezas de cerámica y metal en diversos diámetros', 'cadera', 'cabezas'),

-- Rodilla
('ROD-GMKP-001', 'GMK Primaria', 'Sistema modular de prótesis total de rodilla', 'rodilla', 'GMK'),
('ROD-GMKR-001', 'GMK Revisión', 'Componentes para cirugía de revisión con vástagos modulares', 'rodilla', 'GMK'),

-- Bucomaxilofacial
('BUC-SIST-001', 'Sistema Bucomaxilofacial', 'Placas y tornillos de titanio para reconstrucción facial y mandibular', 'bucomaxilofacial', 'placas'),
('BUC-CRAN-001', 'Implantes Craneales', 'Mallas de titanio y PEEK para cranioplastia', 'bucomaxilofacial', 'craneo'),
('BUC-LEFO-001', 'Sistema Le Fort', 'Fijación para fracturas complejas del tercio medio facial', 'bucomaxilofacial', 'Le Fort'),

-- Neurocirugía
('NEU-NEUR-001', 'Sistema de Neurofixation', 'Placas y tornillos para craneosinostosis y reconstrucción craneal', 'neurocirugia', 'neurofijacion'),
('NEU-PLAC-001', 'Placas Craneales', 'Sistemas de fijación para neurocirugía craneal', 'neurocirugia', 'placas'),

-- Implantes 3D
('IMP-3DTI-001', 'Implantes 3D en Titanio', 'Soluciones personalizadas mediante tecnología de impresión 3D', 'implantes3d', 'titanio'),
('IMP-3DCA-001', 'Cages Personalizados', 'Cages intersomáticos diseñados específicamente para cada paciente', 'implantes3d', 'cages'),
('IMP-3DCR-001', 'Implantes Craneofaciales 3D', 'Reconstrucciones anatómicas precisas en titanio poroso', 'implantes3d', 'craneo');

-- ============================================
-- Vistas útiles para reportes
-- ============================================

-- Vista de contactos recientes
CREATE OR REPLACE VIEW contactos_recientes AS
SELECT 
    c.id,
    c.nombre,
    c.email,
    c.telefono,
    c.institucion,
    c.asunto,
    c.estado,
    c.fecha_creacion,
    COUNT(ic.id) as cantidad_imagenes
FROM contactos c
LEFT JOIN imagenes_contacto ic ON c.id = ic.contacto_id
GROUP BY c.id
ORDER BY c.fecha_creacion DESC;

-- Vista de productos por categoría
CREATE OR REPLACE VIEW productos_por_categoria AS
SELECT 
    categoria,
    COUNT(*) as total_productos,
    SUM(CASE WHEN activo = TRUE THEN 1 ELSE 0 END) as productos_activos
FROM productos
GROUP BY categoria;

-- ============================================
-- Procedimientos almacenados
-- ============================================

-- Procedimiento para registrar un nuevo contacto
DELIMITER //
CREATE PROCEDURE registrar_contacto(
    IN p_nombre VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_telefono VARCHAR(50),
    IN p_institucion VARCHAR(255),
    IN p_asunto VARCHAR(100),
    IN p_mensaje TEXT,
    IN p_ip_address VARCHAR(45),
    IN p_user_agent TEXT,
    OUT p_contacto_id INT
)
BEGIN
    INSERT INTO contactos (
        nombre, email, telefono, institucion, 
        asunto, mensaje, ip_address, user_agent
    ) VALUES (
        p_nombre, p_email, p_telefono, p_institucion,
        p_asunto, p_mensaje, p_ip_address, p_user_agent
    );
    
    SET p_contacto_id = LAST_INSERT_ID();
END //

-- Procedimiento para registrar imagen adjunta
CREATE PROCEDURE registrar_imagen_contacto(
    IN p_contacto_id INT,
    IN p_nombre_archivo VARCHAR(255),
    IN p_nombre_original VARCHAR(255),
    IN p_ruta_archivo VARCHAR(500),
    IN p_tipo_mime VARCHAR(100),
    IN p_tamano_bytes INT
)
BEGIN
    INSERT INTO imagenes_contacto (
        contacto_id, nombre_archivo, nombre_original,
        ruta_archivo, tipo_mime, tamano_bytes
    ) VALUES (
        p_contacto_id, p_nombre_archivo, p_nombre_original,
        p_ruta_archivo, p_tipo_mime, p_tamano_bytes
    );
END //

DELIMITER ;

-- ============================================
-- Comentarios finales
-- ============================================
-- Este schema SQL proporciona:
-- 1. Almacenamiento de formularios de contacto
-- 2. Gestión de imágenes adjuntas
-- 3. Newsletter/suscripciones
-- 4. Catálogo de productos
-- 5. Sistema de noticias
-- 6. Gestión de cotizaciones
--
-- Para uso en producción:
-- - Configurar backups automáticos
-- - Implementar índices adicionales según queries más frecuentes
-- - Configurar usuarios con permisos apropiados
-- - Implementar auditoría de cambios si es necesario
-- - Considerar particionamiento de tablas grandes
