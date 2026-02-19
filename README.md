# BioArTec - Sitio Web Ortopedia Profesional

Sitio web multipágina para BioArTec, empresa especializada en la comercialización de productos ortopédicos y traumatológicos de alta precisión.

## 📋 Contenido del Proyecto

### Páginas HTML
- **index.html** - Página de inicio con hero section, características y preview de categorías
- **productos.html** - Catálogo completo de productos con sistema de filtrado
- **noticias.html** - Blog/noticias de la empresa
- **contacto.html** - Formulario de contacto con opción de adjuntar imágenes

### Archivos de Recursos
- **styles.css** - Estilos CSS completos con diseño responsivo
- **script.js** - JavaScript vanilla para interactividad
- **schema.sql** - Esquema de base de datos MySQL/MariaDB

## 🎨 Características de Diseño

### Paleta de Colores
- **Primary**: #0A4D68 (Azul médico profundo)
- **Primary Light**: #088395 (Azul turquesa)
- **Accent**: #00D9A3 (Verde esmeralda - biomedicina)
- Diseño profesional que evita clichés médicos genéricos

### Tipografía
- **Display/Body**: Sora (Google Fonts)
- **Monospace**: JetBrains Mono (Google Fonts)
- Fuentes modernas que evitan Arial, Inter, Roboto

### Características Visuales
- Animaciones CSS suaves y profesionales
- Grid pattern animado en hero section
- Cards con efectos hover y sombras
- Diseño completamente responsivo
- Navegación sticky con dropdown menus

## 🚀 Implementación

### 1. Requisitos Previos
- Servidor web (Apache, Nginx, etc.)
- PHP 7.4+ (para backend)
- MySQL 5.7+ o MariaDB 10.3+
- Soporte para HTTPS (recomendado)

### 2. Instalación Básica

```bash
# Clonar o subir archivos al servidor
/var/www/bioartec/
├── index.html
├── productos.html
├── noticias.html
├── contacto.html
├── styles.css
├── script.js
└── schema.sql

# Configurar permisos
chmod 755 /var/www/bioartec
chmod 644 /var/www/bioartec/*.html
chmod 644 /var/www/bioartec/*.css
chmod 644 /var/www/bioartec/*.js
```

### 3. Configuración de Base de Datos

```bash
# Conectar a MySQL
mysql -u root -p

# Ejecutar schema
mysql -u root -p < schema.sql

# Crear usuario específico (recomendado)
CREATE USER 'bioartec_user'@'localhost' IDENTIFIED BY 'password_seguro';
GRANT ALL PRIVILEGES ON bioartec_db.* TO 'bioartec_user'@'localhost';
FLUSH PRIVILEGES;
```

### 4. Backend API (Ejemplo en PHP)

Crear archivo `api/contact.php`:

```php
<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// Configuración de base de datos
$servername = "localhost";
$username = "bioartec_user";
$password = "password_seguro";
$dbname = "bioartec_db";

// Conectar a base de datos
$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(['success' => false, 'message' => 'Error de conexión']));
}

// Procesar formulario
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nombre = $conn->real_escape_string($_POST['nombre']);
    $email = $conn->real_escape_string($_POST['email']);
    $telefono = $conn->real_escape_string($_POST['telefono'] ?? '');
    $institucion = $conn->real_escape_string($_POST['institucion'] ?? '');
    $asunto = $conn->real_escape_string($_POST['asunto']);
    $mensaje = $conn->real_escape_string($_POST['mensaje']);
    $ip_address = $_SERVER['REMOTE_ADDR'];
    $user_agent = $_SERVER['HTTP_USER_AGENT'];
    
    // Insertar contacto
    $sql = "INSERT INTO contactos (nombre, email, telefono, institucion, asunto, mensaje, ip_address, user_agent) 
            VALUES ('$nombre', '$email', '$telefono', '$institucion', '$asunto', '$mensaje', '$ip_address', '$user_agent')";
    
    if ($conn->query($sql) === TRUE) {
        $contacto_id = $conn->insert_id;
        
        // Procesar imagen si existe
        if (isset($_FILES['imagen']) && $_FILES['imagen']['error'] === 0) {
            $upload_dir = '../uploads/contacto/';
            if (!file_exists($upload_dir)) {
                mkdir($upload_dir, 0755, true);
            }
            
            $file_extension = pathinfo($_FILES['imagen']['name'], PATHINFO_EXTENSION);
            $new_filename = uniqid() . '.' . $file_extension;
            $upload_path = $upload_dir . $new_filename;
            
            if (move_uploaded_file($_FILES['imagen']['tmp_name'], $upload_path)) {
                $nombre_original = $_FILES['imagen']['name'];
                $tipo_mime = $_FILES['imagen']['type'];
                $tamano = $_FILES['imagen']['size'];
                
                $sql_img = "INSERT INTO imagenes_contacto (contacto_id, nombre_archivo, nombre_original, ruta_archivo, tipo_mime, tamano_bytes) 
                            VALUES ($contacto_id, '$new_filename', '$nombre_original', '$upload_path', '$tipo_mime', $tamano)";
                $conn->query($sql_img);
            }
        }
        
        // Enviar email de notificación
        $to = "info@bioartec.com.ar";
        $subject = "Nuevo contacto desde web: $asunto";
        $body = "Nombre: $nombre\nEmail: $email\nTeléfono: $telefono\nInstitución: $institucion\n\nMensaje:\n$mensaje";
        $headers = "From: noreply@bioartec.com.ar";
        
        mail($to, $subject, $body, $headers);
        
        echo json_encode(['success' => true, 'message' => 'Mensaje enviado correctamente']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Error al guardar mensaje']);
    }
}

$conn->close();
?>
```

### 5. Integración en JavaScript

Actualizar `handleContactForm()` en script.js:

```javascript
function handleContactForm(event) {
    event.preventDefault();
    
    const form = event.target;
    const formData = new FormData(form);
    
    fetch('/api/contact.php', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showMessage('¡Mensaje enviado exitosamente!', 'success');
            form.reset();
        } else {
            showMessage('Error al enviar mensaje. Intente nuevamente.', 'error');
        }
    })
    .catch(error => {
        showMessage('Error de conexión. Intente más tarde.', 'error');
    });
    
    return false;
}
```

## 📱 Responsive Design

El sitio está optimizado para:
- Desktop (1920px+)
- Laptop (1024px - 1920px)
- Tablet (768px - 1024px)
- Mobile (320px - 768px)

## ⚡ Optimización SEO

### Meta Tags Implementados
- Títulos descriptivos únicos por página
- Meta descriptions optimizadas
- Keywords relevantes
- Open Graph tags (agregar si es necesario)

### Mejoras Recomendadas
1. Implementar sitemap.xml
2. Configurar robots.txt
3. Agregar Schema.org markup
4. Optimizar imágenes (WebP)
5. Implementar lazy loading
6. Configurar Google Analytics
7. Añadir certificado SSL

## 🔒 Seguridad

### Implementaciones Necesarias
1. **Validación de formularios** - Backend validation
2. **CSRF Protection** - Tokens en formularios
3. **Rate Limiting** - Limitar envíos por IP
4. **SQL Injection Protection** - Prepared statements
5. **XSS Protection** - Sanitización de inputs
6. **File Upload Security** - Validar tipos de archivo

Ejemplo de prepared statement:

```php
$stmt = $conn->prepare("INSERT INTO contactos (nombre, email, mensaje) VALUES (?, ?, ?)");
$stmt->bind_param("sss", $nombre, $email, $mensaje);
$stmt->execute();
```

## 📊 Productos Incluidos

### Categorías
1. **Bucomaxilofacial y Cráneo**
   - Sistema Bucomaxilofacial
   - Implantes Craneales
   - Sistema Le Fort

2. **Columna Vertebral**
   - Sistemas Cervical, Dorsal, Lumbar
   - Cages PEEK
   - Fijación, Escoliosis, Cifoplastia
   - Reemplazo Vertebral, Laminoplastia

3. **Cadera**
   - AMIS Medacta
   - Cotilos, Tallos, Cabezas

4. **Rodilla**
   - GMK Primaria
   - GMK Revisión

5. **Neurocirugía**
   - Neurofixation
   - Placas Craneales

6. **Implantes 3D**
   - Implantes personalizados en titanio
   - Cages personalizados
   - Implantes craneofaciales

## 📞 Información de Contacto

- **Teléfono**: +54 351 412-3456
- **Email**: info@bioartec.com.ar
- **Ubicación**: Córdoba, Argentina

## 🛠️ Mantenimiento

### Tareas Regulares
- [ ] Backup de base de datos (diario)
- [ ] Actualización de productos
- [ ] Publicación de noticias
- [ ] Revisión de formularios de contacto
- [ ] Actualización de seguridad

### Actualizaciones Futuras
- Panel de administración (CMS)
- Catálogo de productos con búsqueda avanzada
- Sistema de descargas de fichas técnicas
- Zona de clientes con login
- Integración con CRM
- Chat en vivo

## 📄 Licencia

Copyright © 2026 BioArTec. Todos los derechos reservados.

## 💡 Soporte Técnico

Para soporte técnico o consultas sobre implementación, contactar al desarrollador del proyecto.

---

**Versión**: 1.0.0  
**Última actualización**: Febrero 2026
