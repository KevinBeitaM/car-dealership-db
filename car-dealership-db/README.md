# 🚗 Sistema de Gestión de Concesionario de Autos

Sistema de base de datos relacional completo para gestionar un concesionario de automóviles, incluyendo inventario, ventas, clientes, empleados y servicio técnico con auditoría completa y automatización de procesos.

![MySQL](https://img.shields.io/badge/MySQL-8.0+-blue?logo=mysql)
![Estado](https://img.shields.io/badge/Estado-Producción-success)
![Licencia](https://img.shields.io/badge/Licencia-MIT-green)
![Autor](https://img.shields.io/badge/Autor-KevinBeitaM-orange)

## 📋 Tabla de Contenidos

- [Características](#características)
- [Arquitectura de la Base de Datos](#arquitectura-de-la-base-de-datos)
- [Instalación](#instalación)
- [Uso](#uso)
- [Procedimientos Almacenados](#procedimientos-almacenados)
- [Triggers y Automatización](#triggers-y-automatización)
- [Consultas de Ejemplo](#consultas-de-ejemplo)
- [Diagrama ERD](#diagrama-erd)
- [Optimización](#optimización)
- [Seguridad](#seguridad)


## ✨ Características

### 🎯 Funcionalidades Principales

- ✅ **Gestión de Inventario** - Control completo de vehículos disponibles, reservados y vendidos
- ✅ **Gestión de Ventas** - Registro de ventas con múltiples métodos de pago
- ✅ **Gestión de Clientes** - Base de datos de clientes personas y empresas
- ✅ **Gestión de Empleados** - Registro de vendedores con sistema de comisiones
- ✅ **Financiamiento** - Control de créditos y pagos a plazos
- ✅ **Servicio Técnico** - Órdenes de servicio y mantenimiento
- ✅ **Auditoría Completa** - Trazabilidad total de cambios en ventas e inventario

### 🔐 Integridad de Datos

- 🛡️ **Constraints a nivel de base de datos** - Validaciones automáticas
- 🛡️ **Triggers de auditoría** - Registro automático de todos los cambios
- 🛡️ **Triggers de validación** - Prevención de datos inconsistentes
- 🛡️ **Foreign Keys** - Integridad referencial garantizada
- 🛡️ **Columnas generadas** - Cálculos automáticos (precio final, comisiones)

### ⚡ Rendimiento

- 🚀 **Índices estratégicos** - Optimización de consultas frecuentes
- 🚀 **Índices compuestos** - Para búsquedas complejas
- 🚀 **Full-text search** - Búsqueda rápida de texto
- 🚀 **Vistas materializadas** - Consultas pre-calculadas
- 🚀 **Transacciones ACID** - Consistencia garantizada

### 📊 Reportes y Analítica

- 📈 **Dashboards pre-construidos** - Vistas SQL listas para usar
- 📈 **Reportes de ventas** - Por período, vendedor, marca
- 📈 **Análisis de inventario** - Antigüedad, rotación, valor
- 📈 **Top clientes** - Ranking por compras
- 📈 **Comisiones de vendedores** - Cálculo automático

## 🗄️ Arquitectura de la Base de Datos

### Tablas Principales

| Categoría | Tablas | Descripción |
|-----------|--------|-------------|
| **Catálogos** | `brands`, `models`, `colors` | Información maestra de marcas, modelos y colores |
| **Inventario** | `vehicles`, `vehicle_features` | Vehículos en stock con características |
| **Clientes** | `customers` | Base de datos de clientes |
| **Empleados** | `employees` | Personal del concesionario |
| **Ventas** | `sales`, `payments`, `financing` | Transacciones de venta y pagos |
| **Servicio** | `service_orders` | Órdenes de mantenimiento |
| **Auditoría** | `sales_audit`, `inventory_audit` | Logs de cambios |

### Características Técnicas

```
📊 Total de Tablas: 14
🔗 Relaciones (Foreign Keys): 23
📈 Vistas: 4
⚙️ Procedimientos Almacenados: 10
🔔 Triggers: 6
📅 Eventos Programados: 2
🔍 Índices: 45+
```

## 🚀 Instalación

### Prerrequisitos

- MySQL 8.0 o superior
- Cliente MySQL (Workbench, DBeaver, phpMyAdmin, etc.)
- Mínimo 200MB de espacio en disco

### Instalación Paso a Paso

#### Opción 1: Instalación Completa (Recomendada)

```bash
# 1. Clonar o descargar el repositorio
git clone https://github.com/KevinBeitaM/car-dealership-db.git
cd car-dealership-db

# 2. Conectarse a MySQL
mysql -u root -p

# 3. Ejecutar los scripts en orden
mysql -u root -p < database/schema.sql
mysql -u root -p < database/procedures_triggers.sql
mysql -u root -p < database/data.sql
```

#### Opción 2: Instalación Manual

1. **Crear el esquema:**
```sql
mysql -u root -p < database/schema.sql
```

2. **Crear procedimientos y triggers:**
```sql
mysql -u root -p < database/procedures_triggers.sql
```

3. **Cargar datos de prueba (opcional):**
```sql
mysql -u root -p < database/data.sql
```

### Verificar Instalación

```sql
USE car_dealership;

-- Ver todas las tablas
SHOW TABLES;

-- Verificar datos de ejemplo
SELECT COUNT(*) AS total_vehiculos FROM vehicles;
SELECT COUNT(*) AS total_ventas FROM sales;

-- Ver inventario disponible
SELECT * FROM v_inventory_available LIMIT 5;
```

## 📖 Uso

### 1. Registrar una Nueva Venta

```sql
-- Declarar variables para recibir el resultado
SET @sale_id = 0;
SET @sale_number = '';

-- Llamar al procedimiento
CALL sp_register_sale(
    1,                      -- vehicle_id
    1,                      -- customer_id
    3,                      -- salesperson_id (vendedor)
    420000.00,              -- sale_price
    5000.00,                -- discount_amount
    66400.00,               -- tax_amount
    'Financiamiento',       -- payment_method
    100000.00,              -- down_payment
    315000.00,              -- financed_amount
    '2024-12-01',           -- delivery_date
    'Cliente nuevo',        -- notes
    @sale_id,               -- OUT: sale_id
    @sale_number            -- OUT: sale_number
);

-- Ver el resultado
SELECT @sale_id AS venta_id, @sale_number AS numero_venta;
```

### 2. Completar una Venta

```sql
CALL sp_complete_sale(
    1,                      -- sale_id
    'Juan Pérez'            -- completed_by
);
```

### 3. Registrar un Pago

```sql
SET @payment_id = 0;
SET @payment_number = '';

CALL sp_register_payment(
    1,                      -- sale_id
    8357.25,                -- amount (primera mensualidad)
    'Transferencia',        -- payment_type
    'TRANS-12345',          -- reference_number
    'Pago mensual 1/48',    -- notes
    @payment_id,            -- OUT: payment_id
    @payment_number         -- OUT: payment_number
);

SELECT @payment_id AS pago_id, @payment_number AS numero_pago;
```

### 4. Agregar Vehículo al Inventario

```sql
SET @vehicle_id = 0;

CALL sp_add_vehicle(
    '1HGCM82633A999999',    -- vin
    1,                       -- model_id (Toyota Corolla)
    1,                       -- color_id (Blanco)
    2024,                    -- year
    0,                       -- mileage
    'Nuevo',                 -- condition_type
    350000.00,               -- purchase_price
    420000.00,               -- sale_price
    'Lote A-10',             -- location
    'Recién llegado',        -- notes
    @vehicle_id              -- OUT: vehicle_id
);

SELECT @vehicle_id AS id_vehiculo;
```

### 5. Crear Orden de Servicio

```sql
SET @order_id = 0;
SET @order_number = '';

CALL sp_create_service_order(
    1,                       -- vehicle_id
    1,                       -- customer_id
    'Mantenimiento',         -- service_type
    'Cambio de aceite y filtro - 5,000 km', -- description
    7,                       -- mechanic_id
    @order_id,               -- OUT: order_id
    @order_number            -- OUT: order_number
);

SELECT @order_id AS orden_id, @order_number AS numero_orden;
```

### 6. Cancelar una Venta

```sql
CALL sp_cancel_sale(
    5,                       -- sale_id
    'Cliente desistió de la compra por motivos personales'
);
```

## 🔧 Procedimientos Almacenados

| Procedimiento | Descripción | Parámetros |
|---------------|-------------|------------|
| `sp_register_sale` | Registra una nueva venta | vehicle_id, customer_id, salesperson_id, prices, payment details |
| `sp_complete_sale` | Marca una venta como completada | sale_id, completed_by |
| `sp_cancel_sale` | Cancela una venta y libera el vehículo | sale_id, reason |
| `sp_register_payment` | Registra un pago de cliente | sale_id, amount, payment_type, reference |
| `sp_add_vehicle` | Agrega un vehículo al inventario | vin, model_id, color_id, prices, details |
| `sp_create_service_order` | Crea una orden de servicio | vehicle_id, customer_id, service details |
| `sp_sales_report` | Reporte de ventas por período | start_date, end_date |
| `sp_inventory_aging` | Análisis de antigüedad del inventario | - |
| `sp_top_customers` | Ranking de mejores clientes | limit |

## 🔔 Triggers y Automatización

### Triggers de Auditoría

| Trigger | Tabla | Evento | Función |
|---------|-------|--------|---------|
| `trg_sales_after_insert` | sales | AFTER INSERT | Registra nueva venta en auditoría |
| `trg_sales_after_update` | sales | AFTER UPDATE | Registra cambios en ventas |
| `trg_vehicles_after_update` | vehicles | AFTER UPDATE | Audita cambios de estado |
| `trg_vehicles_after_insert` | vehicles | AFTER INSERT | Registra nuevos vehículos |

### Triggers de Validación

| Trigger | Tabla | Evento | Función |
|---------|-------|--------|---------|
| `trg_sales_before_insert` | sales | BEFORE INSERT | Valida precios y descuentos |
| `trg_financing_before_insert` | financing | BEFORE INSERT | Valida monto financiado |

### Eventos Programados

| Evento | Frecuencia | Función |
|--------|------------|---------|
| `evt_cleanup_old_audit` | Mensual | Limpia registros de auditoría antiguos (>2 años) |
| `evt_inventory_aging_alert` | Semanal | Genera alertas de inventario antiguo (>180 días) |

## 📊 Consultas de Ejemplo

### Inventario Disponible

```sql
-- Ver todos los vehículos disponibles
SELECT * FROM v_inventory_available;

-- Buscar vehículos por marca
SELECT * FROM v_inventory_available
WHERE marca = 'Toyota'
ORDER BY precio_venta;

-- Vehículos disponibles por rango de precio
SELECT * FROM v_inventory_available
WHERE precio_venta BETWEEN 400000 AND 600000
ORDER BY precio_venta;
```

### Análisis de Ventas

```sql
-- Ventas del mes actual
SELECT * FROM v_sales_complete
WHERE MONTH(fecha_venta) = MONTH(CURDATE())
  AND YEAR(fecha_venta) = YEAR(CURDATE());

-- Total vendido por vendedor
SELECT 
    vendedor,
    COUNT(*) AS total_ventas,
    SUM(total) AS monto_total,
    SUM(comision_vendedor) AS comisiones_totales
FROM v_sales_complete
WHERE estado = 'Completada'
GROUP BY vendedor
ORDER BY monto_total DESC;

-- Reporte de ventas por mes
CALL sp_sales_report('2024-01-01', '2024-12-31');
```

### Inventario y Rotación

```sql
-- Antigüedad del inventario
CALL sp_inventory_aging();

-- Vehículos que llevan más de 90 días en inventario
SELECT * FROM v_inventory_available
WHERE dias_en_inventario > 90
ORDER BY dias_en_inventario DESC;

-- Valor total del inventario por marca
SELECT * FROM v_inventory_by_brand
ORDER BY valor_total_inventario DESC;
```

### Top Clientes

```sql
-- Top 10 mejores clientes
CALL sp_top_customers(10);

-- Clientes con más de una compra
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', IFNULL(c.last_name, '')) AS cliente,
    COUNT(s.sale_id) AS total_compras,
    SUM(s.total_amount) AS monto_total
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
WHERE s.status = 'Completada'
GROUP BY c.customer_id
HAVING total_compras > 1
ORDER BY monto_total DESC;
```

### Análisis Financiero

```sql
-- Ganancias totales por vehículo vendido
SELECT 
    vehiculo,
    precio_venta,
    costo_vehiculo,
    ganancia,
    ROUND((ganancia / costo_vehiculo) * 100, 2) AS margen_porcentaje
FROM v_sales_complete
WHERE estado = 'Completada'
ORDER BY ganancia DESC;

-- Total de financiamientos activos
SELECT 
    financial_institution AS institucion,
    COUNT(*) AS total_creditos,
    SUM(loan_amount) AS monto_total_prestado,
    AVG(interest_rate) AS tasa_promedio
FROM financing
WHERE status = 'Aprobado'
GROUP BY financial_institution;
```

### Auditoría y Trazabilidad

```sql
-- Ver últimos cambios en ventas
SELECT 
    sa.audit_id,
    sa.sale_id,
    sa.action_type,
    sa.changed_by,
    sa.changed_at,
    sa.old_data,
    sa.new_data
FROM sales_audit sa
ORDER BY sa.changed_at DESC
LIMIT 20;

-- Historial de cambios de estado de un vehículo
SELECT 
    ia.vehicle_id,
    ia.action_type,
    ia.old_status,
    ia.new_status,
    ia.changed_by,
    ia.changed_at,
    ia.notes
FROM inventory_audit ia
WHERE ia.vehicle_id = 1
ORDER BY ia.changed_at DESC;
```

## 🎨 Diagrama ERD

El diagrama de entidad-relación se encuentra en `docs/ERD.png`

### Generar el Diagrama

**Opción 1: Usar dbdiagram.io**
1. Ve a [dbdiagram.io](https://dbdiagram.io)
2. Copia el contenido de `docs/database_diagram.dbml`
3. Pégalo en el editor
4. Exporta como PNG: **Export → PNG**
5. Guarda como `docs/ERD.png`

**Opción 2: MySQL Workbench**
1. Abre MySQL Workbench
2. Ve a **Database → Reverse Engineer**
3. Selecciona la base de datos `car_dealership`
4. Sigue el wizard
5. Exporta el diagrama: **File → Export → Export as PNG**

## ⚡ Optimización

### Índices Implementados

```sql
-- Índices simples (40+)
- Primary Keys en todas las tablas
- Foreign Keys indexadas automáticamente
- Campos de búsqueda frecuente (VIN, códigos, fechas)

-- Índices compuestos
CREATE INDEX idx_vehicles_model_status_year ON vehicles(model_id, status, year);
CREATE INDEX idx_sales_date_status ON sales(sale_date, status);
CREATE INDEX idx_customers_type_active ON customers(customer_type, is_active);

-- Full-text search
ALTER TABLE vehicles ADD FULLTEXT INDEX ft_notes(notes);
ALTER TABLE customers ADD FULLTEXT INDEX ft_customer_info(first_name, last_name, company_name);
```

### Tips de Rendimiento

1. **Usa las vistas pre-construidas**
   ```sql
   -- Más rápido
   SELECT * FROM v_inventory_available WHERE marca = 'Toyota';
   
   -- En lugar de unir manualmente todas las tablas
   ```

2. **Aprovecha los índices**
   ```sql
   -- Búsquedas por campos indexados
   SELECT * FROM vehicles WHERE vin = '1HGCM82633A123456';
   SELECT * FROM sales WHERE sale_date BETWEEN '2024-01-01' AND '2024-12-31';
   ```

3. **Usa procedimientos almacenados**
   ```sql
   -- Los procedimientos están optimizados y usan transacciones
   CALL sp_register_sale(...);
   ```

4. **Limita los resultados**
   ```sql
   -- Siempre usa LIMIT en consultas exploratorias
   SELECT * FROM sales LIMIT 100;
   ```

## 🔐 Seguridad

### Roles y Permisos (Ejemplo)

```sql
-- Crear usuarios
CREATE USER 'dealership_admin'@'localhost' IDENTIFIED BY 'secure_password';
CREATE USER 'dealership_sales'@'localhost' IDENTIFIED BY 'sales_password';
CREATE USER 'dealership_viewer'@'localhost' IDENTIFIED BY 'view_password';

-- Permisos de administrador
GRANT ALL PRIVILEGES ON car_dealership.* TO 'dealership_admin'@'localhost';

-- Permisos de vendedor (solo lo necesario)
GRANT SELECT ON car_dealership.vehicles TO 'dealership_sales'@'localhost';
GRANT SELECT, INSERT, UPDATE ON car_dealership.customers TO 'dealership_sales'@'localhost';
GRANT SELECT, INSERT, UPDATE ON car_dealership.sales TO 'dealership_sales'@'localhost';
GRANT EXECUTE ON PROCEDURE car_dealership.sp_register_sale TO 'dealership_sales'@'localhost';

-- Permisos de solo lectura
GRANT SELECT ON car_dealership.* TO 'dealership_viewer'@'localhost';

FLUSH PRIVILEGES;
```

### Buenas Prácticas

- ✅ Nunca uses el usuario `root` en producción
- ✅ Usa contraseñas fuertes y cámbialas regularmente
- ✅ Limita el acceso por IP cuando sea posible
- ✅ Habilita SSL para conexiones remotas
- ✅ Realiza backups regulares
- ✅ Monitorea los logs de auditoría

## 💾 Backup y Recuperación

### Crear Backup

```bash
# Backup completo
mysqldump -u root -p car_dealership > backup_car_dealership_$(date +%Y%m%d).sql

# Backup solo estructura
mysqldump -u root -p --no-data car_dealership > schema_only.sql

# Backup solo datos
mysqldump -u root -p --no-create-info car_dealership > data_only.sql
```

### Restaurar Backup

```bash
mysql -u root -p car_dealership < backup_car_dealership_20241106.sql
```

### Áreas de Mejora

- [ ] Agregar módulo de garantías
- [ ] Sistema de seguros
- [ ] Integración con APIs de valuación (Kelley Blue Book)
- [ ] Dashboard web con gráficos
- [ ] Notificaciones por email/SMS
- [ ] Sistema de citas para servicio técnico
- [ ] App móvil para vendedores

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 👤 Autor

**Kevin Beita M**

- GitHub: [@KevinBeitaM](https://github.com/KevinBeitaM)
- LinkedIn: [Kevin Beita M](https://linkedin.com/in/kevinbeitam)



