-- ============================================
-- Sistema de Gestión de Concesionario de Autos
-- Autor: KevinBeitaM
-- Fecha: 2025-11-06
-- Descripción: Base de datos relacional completa para gestión de concesionario
-- ============================================

-- Eliminar base de datos si existe
DROP DATABASE IF EXISTS car_dealership;
CREATE DATABASE car_dealership CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE car_dealership;

-- ============================================
-- TABLAS DE CATÁLOGOS
-- ============================================

-- Tabla de Marcas de Vehículos
CREATE TABLE brands (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(50) NOT NULL UNIQUE,
    country_origin VARCHAR(50),
    website VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_brand_name (brand_name),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB COMMENT='Catálogo de marcas de vehículos';

-- Tabla de Modelos de Vehículos
CREATE TABLE models (
    model_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_id INT NOT NULL,
    model_name VARCHAR(100) NOT NULL,
    body_type ENUM('Sedán', 'SUV', 'Pickup', 'Hatchback', 'Coupé', 'Convertible', 'Van', 'Camión') NOT NULL,
    fuel_type ENUM('Gasolina', 'Diesel', 'Eléctrico', 'Híbrido', 'Híbrido Enchufable') NOT NULL,
    transmission ENUM('Manual', 'Automática', 'CVT', 'Dual Clutch') NOT NULL,
    year_introduced YEAR,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id) ON DELETE RESTRICT,
    
    INDEX idx_brand (brand_id),
    INDEX idx_model_name (model_name),
    INDEX idx_body_type (body_type),
    INDEX idx_year (year_introduced)
) ENGINE=InnoDB COMMENT='Catálogo de modelos de vehículos';

-- Tabla de Colores Disponibles
CREATE TABLE colors (
    color_id INT AUTO_INCREMENT PRIMARY KEY,
    color_name VARCHAR(50) NOT NULL UNIQUE,
    color_code VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_color_name (color_name)
) ENGINE=InnoDB COMMENT='Catálogo de colores disponibles';

-- ============================================
-- INVENTARIO DE VEHÍCULOS
-- ============================================

-- Tabla de Vehículos en Inventario
CREATE TABLE vehicles (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    vin VARCHAR(17) NOT NULL UNIQUE COMMENT 'Vehicle Identification Number',
    model_id INT NOT NULL,
    color_id INT NOT NULL,
    year YEAR NOT NULL,
    mileage INT DEFAULT 0,
    condition_type ENUM('Nuevo', 'Seminuevo', 'Usado') NOT NULL DEFAULT 'Nuevo',
    engine_size DECIMAL(3,1) COMMENT 'Tamaño del motor en litros',
    horsepower INT,
    doors TINYINT,
    seats TINYINT,
    purchase_price DECIMAL(12,2) NOT NULL,
    sale_price DECIMAL(12,2) NOT NULL,
    status ENUM('Disponible', 'Reservado', 'Vendido', 'En Tránsito', 'En Reparación') DEFAULT 'Disponible',
    location VARCHAR(100) COMMENT 'Ubicación física en el lote',
    date_acquired DATE NOT NULL,
    date_sold DATE NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (model_id) REFERENCES models(model_id) ON DELETE RESTRICT,
    FOREIGN KEY (color_id) REFERENCES colors(color_id) ON DELETE RESTRICT,
    
    INDEX idx_vin (vin),
    INDEX idx_model (model_id),
    INDEX idx_status (status),
    INDEX idx_condition (condition_type),
    INDEX idx_year (year),
    INDEX idx_price (sale_price),
    INDEX idx_date_acquired (date_acquired),
    
    CONSTRAINT chk_mileage CHECK (mileage >= 0),
    CONSTRAINT chk_prices CHECK (sale_price >= purchase_price),
    CONSTRAINT chk_year CHECK (year BETWEEN 1900 AND YEAR(CURDATE()) + 1)
) ENGINE=InnoDB COMMENT='Inventario de vehículos disponibles';

-- Tabla de Características Extra de Vehículos
CREATE TABLE vehicle_features (
    feature_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT NOT NULL,
    feature_name VARCHAR(100) NOT NULL,
    feature_value VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE CASCADE,
    
    INDEX idx_vehicle (vehicle_id),
    INDEX idx_feature_name (feature_name)
) ENGINE=InnoDB COMMENT='Características adicionales de vehículos (GPS, cuero, etc)';

-- ============================================
-- GESTIÓN DE CLIENTES
-- ============================================

-- Tabla de Clientes
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_type ENUM('Persona', 'Empresa') NOT NULL DEFAULT 'Persona',
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    company_name VARCHAR(200),
    identification_type ENUM('DNI', 'Pasaporte', 'RUC', 'Cédula') NOT NULL,
    identification_number VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100),
    phone VARCHAR(20) NOT NULL,
    mobile VARCHAR(20),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(50) DEFAULT 'México',
    date_of_birth DATE,
    occupation VARCHAR(100),
    credit_score INT,
    preferred_contact ENUM('Email', 'Teléfono', 'WhatsApp', 'SMS') DEFAULT 'Teléfono',
    is_active BOOLEAN DEFAULT TRUE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_identification (identification_number),
    INDEX idx_name (first_name, last_name),
    INDEX idx_email (email),
    INDEX idx_phone (phone),
    INDEX idx_customer_type (customer_type),
    
    CONSTRAINT chk_credit_score CHECK (credit_score BETWEEN 0 AND 850)
) ENGINE=InnoDB COMMENT='Información de clientes del concesionario';

-- ============================================
-- EMPLEADOS Y VENDEDORES
-- ============================================

-- Tabla de Empleados
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_code VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    position ENUM('Vendedor', 'Gerente Ventas', 'Mecánico', 'Gerente General', 'Administrativo', 'Cajero') NOT NULL,
    department VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2),
    commission_rate DECIMAL(5,2) DEFAULT 0.00 COMMENT 'Porcentaje de comisión sobre ventas',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_employee_code (employee_code),
    INDEX idx_position (position),
    INDEX idx_is_active (is_active),
    
    CONSTRAINT chk_commission_rate CHECK (commission_rate BETWEEN 0 AND 100)
) ENGINE=InnoDB COMMENT='Empleados del concesionario';

-- ============================================
-- VENTAS Y TRANSACCIONES
-- ============================================

-- Tabla de Ventas
CREATE TABLE sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_number VARCHAR(50) NOT NULL UNIQUE,
    vehicle_id INT NOT NULL,
    customer_id INT NOT NULL,
    salesperson_id INT NOT NULL,
    sale_date DATE NOT NULL,
    sale_price DECIMAL(12,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    final_price DECIMAL(12,2) GENERATED ALWAYS AS (sale_price - discount_amount) STORED,
    tax_amount DECIMAL(10,2) DEFAULT 0.00,
    total_amount DECIMAL(12,2) GENERATED ALWAYS AS (sale_price - discount_amount + tax_amount) STORED,
    payment_method ENUM('Contado', 'Financiamiento', 'Leasing', 'Mixto') NOT NULL,
    down_payment DECIMAL(12,2) DEFAULT 0.00,
    financed_amount DECIMAL(12,2) DEFAULT 0.00,
    status ENUM('Pendiente', 'Completada', 'Cancelada', 'Reembolsada') DEFAULT 'Pendiente',
    delivery_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE RESTRICT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE RESTRICT,
    FOREIGN KEY (salesperson_id) REFERENCES employees(employee_id) ON DELETE RESTRICT,
    
    INDEX idx_sale_number (sale_number),
    INDEX idx_vehicle (vehicle_id),
    INDEX idx_customer (customer_id),
    INDEX idx_salesperson (salesperson_id),
    INDEX idx_sale_date (sale_date),
    INDEX idx_status (status),
    
    CONSTRAINT chk_discount CHECK (discount_amount >= 0),
    CONSTRAINT chk_sale_price CHECK (sale_price > 0),
    CONSTRAINT chk_down_payment CHECK (down_payment >= 0)
) ENGINE=InnoDB COMMENT='Registro de ventas de vehículos';

-- Tabla de Pagos
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_id INT NOT NULL,
    payment_number VARCHAR(50) NOT NULL UNIQUE,
    payment_date DATE NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    payment_type ENUM('Efectivo', 'Transferencia', 'Cheque', 'Tarjeta Crédito', 'Tarjeta Débito') NOT NULL,
    reference_number VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (sale_id) REFERENCES sales(sale_id) ON DELETE RESTRICT,
    
    INDEX idx_sale (sale_id),
    INDEX idx_payment_date (payment_date),
    INDEX idx_payment_number (payment_number)
) ENGINE=InnoDB COMMENT='Pagos recibidos de clientes';

-- Tabla de Financiamiento
CREATE TABLE financing (
    financing_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_id INT NOT NULL,
    financial_institution VARCHAR(200) NOT NULL,
    loan_amount DECIMAL(12,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    term_months INT NOT NULL,
    monthly_payment DECIMAL(10,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('Aprobado', 'Pendiente', 'Rechazado', 'Pagado') DEFAULT 'Pendiente',
    approval_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (sale_id) REFERENCES sales(sale_id) ON DELETE RESTRICT,
    
    INDEX idx_sale (sale_id),
    INDEX idx_status (status),
    
    CONSTRAINT chk_loan_amount CHECK (loan_amount > 0),
    CONSTRAINT chk_interest_rate CHECK (interest_rate >= 0),
    CONSTRAINT chk_term_months CHECK (term_months > 0)
) ENGINE=InnoDB COMMENT='Financiamiento de ventas';

-- ============================================
-- SERVICIO Y MANTENIMIENTO
-- ============================================

-- Tabla de Órdenes de Servicio
CREATE TABLE service_orders (
    service_order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_number VARCHAR(50) NOT NULL UNIQUE,
    vehicle_id INT NOT NULL,
    customer_id INT NOT NULL,
    service_date DATE NOT NULL,
    service_type ENUM('Mantenimiento', 'Reparación', 'Garantía', 'Pre-entrega', 'Revisión') NOT NULL,
    description TEXT NOT NULL,
    mechanic_id INT,
    labor_cost DECIMAL(10,2) DEFAULT 0.00,
    parts_cost DECIMAL(10,2) DEFAULT 0.00,
    total_cost DECIMAL(10,2) GENERATED ALWAYS AS (labor_cost + parts_cost) STORED,
    status ENUM('Pendiente', 'En Proceso', 'Completada', 'Cancelada') DEFAULT 'Pendiente',
    completion_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE RESTRICT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE RESTRICT,
    FOREIGN KEY (mechanic_id) REFERENCES employees(employee_id) ON DELETE SET NULL,
    
    INDEX idx_order_number (order_number),
    INDEX idx_vehicle (vehicle_id),
    INDEX idx_customer (customer_id),
    INDEX idx_service_date (service_date),
    INDEX idx_status (status)
) ENGINE=InnoDB COMMENT='Órdenes de servicio y mantenimiento';

-- ============================================
-- AUDITORÍA
-- ============================================

-- Tabla de Auditoría de Ventas
CREATE TABLE sales_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_id INT NOT NULL,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE', 'STATUS_CHANGE') NOT NULL,
    old_data JSON,
    new_data JSON,
    changed_by VARCHAR(100),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(45),
    
    INDEX idx_sale (sale_id),
    INDEX idx_changed_at (changed_at),
    INDEX idx_action_type (action_type)
) ENGINE=InnoDB COMMENT='Auditoría de cambios en ventas';

-- Tabla de Auditoría de Inventario
CREATE TABLE inventory_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT NOT NULL,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE', 'STATUS_CHANGE') NOT NULL,
    old_status VARCHAR(20),
    new_status VARCHAR(20),
    changed_by VARCHAR(100),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    
    INDEX idx_vehicle (vehicle_id),
    INDEX idx_changed_at (changed_at),
    INDEX idx_action_type (action_type)
) ENGINE=InnoDB COMMENT='Auditoría de cambios en inventario';

-- ============================================
-- VISTAS
-- ============================================

-- Vista: Inventario Actual Detallado
CREATE OR REPLACE VIEW v_inventory_available AS
SELECT 
    v.vehicle_id,
    v.vin,
    b.brand_name AS marca,
    m.model_name AS modelo,
    v.year AS año,
    c.color_name AS color,
    m.body_type AS tipo_carroceria,
    m.fuel_type AS combustible,
    m.transmission AS transmision,
    v.mileage AS kilometraje,
    v.condition_type AS condicion,
    v.purchase_price AS precio_compra,
    v.sale_price AS precio_venta,
    (v.sale_price - v.purchase_price) AS ganancia_potencial,
    v.status AS estado,
    v.location AS ubicacion,
    v.date_acquired AS fecha_adquisicion,
    DATEDIFF(CURDATE(), v.date_acquired) AS dias_en_inventario
FROM vehicles v
INNER JOIN models m ON v.model_id = m.model_id
INNER JOIN brands b ON m.brand_id = b.brand_id
INNER JOIN colors c ON v.color_id = c.color_id
WHERE v.status = 'Disponible';

-- Vista: Ventas Completas
CREATE OR REPLACE VIEW v_sales_complete AS
SELECT 
    s.sale_id,
    s.sale_number AS numero_venta,
    s.sale_date AS fecha_venta,
    CONCAT(c.first_name, ' ', IFNULL(c.last_name, '')) AS cliente,
    c.phone AS telefono_cliente,
    CONCAT(e.first_name, ' ', e.last_name) AS vendedor,
    CONCAT(b.brand_name, ' ', m.model_name, ' ', v.year) AS vehiculo,
    v.vin,
    s.sale_price AS precio_venta,
    s.discount_amount AS descuento,
    s.final_price AS precio_final,
    s.tax_amount AS impuesto,
    s.total_amount AS total,
    s.payment_method AS metodo_pago,
    s.down_payment AS enganche,
    s.financed_amount AS monto_financiado,
    s.status AS estado,
    v.purchase_price AS costo_vehiculo,
    (s.final_price - v.purchase_price) AS ganancia,
    e.commission_rate AS tasa_comision,
    ((s.final_price - v.purchase_price) * e.commission_rate / 100) AS comision_vendedor
FROM sales s
INNER JOIN vehicles v ON s.vehicle_id = v.vehicle_id
INNER JOIN models m ON v.model_id = m.model_id
INNER JOIN brands b ON m.brand_id = b.brand_id
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN employees e ON s.salesperson_id = e.employee_id;

-- Vista: Top Vendedores
CREATE OR REPLACE VIEW v_top_salespeople AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS vendedor,
    e.position AS puesto,
    COUNT(s.sale_id) AS total_ventas,
    SUM(s.final_price) AS monto_total_vendido,
    AVG(s.final_price) AS ticket_promedio,
    SUM((s.final_price - v.purchase_price) * e.commission_rate / 100) AS comisiones_ganadas,
    MAX(s.sale_date) AS ultima_venta
FROM employees e
LEFT JOIN sales s ON e.employee_id = s.salesperson_id AND s.status = 'Completada'
LEFT JOIN vehicles v ON s.vehicle_id = v.vehicle_id
WHERE e.position = 'Vendedor' AND e.is_active = TRUE
GROUP BY e.employee_id
ORDER BY total_ventas DESC;

-- Vista: Vehículos por Marca
CREATE OR REPLACE VIEW v_inventory_by_brand AS
SELECT 
    b.brand_name AS marca,
    COUNT(v.vehicle_id) AS total_vehiculos,
    SUM(CASE WHEN v.status = 'Disponible' THEN 1 ELSE 0 END) AS disponibles,
    SUM(CASE WHEN v.status = 'Vendido' THEN 1 ELSE 0 END) AS vendidos,
    SUM(CASE WHEN v.status = 'Reservado' THEN 1 ELSE 0 END) AS reservados,
    AVG(v.sale_price) AS precio_promedio,
    MIN(v.sale_price) AS precio_minimo,
    MAX(v.sale_price) AS precio_maximo,
    SUM(v.sale_price) AS valor_total_inventario
FROM brands b
LEFT JOIN models m ON b.brand_id = m.brand_id
LEFT JOIN vehicles v ON m.model_id = v.model_id
GROUP BY b.brand_id
ORDER BY total_vehiculos DESC;

-- ============================================
-- ÍNDICES DE RENDIMIENTO
-- ============================================

-- Índices compuestos para consultas frecuentes
CREATE INDEX idx_vehicles_model_status_year ON vehicles(model_id, status, year);
CREATE INDEX idx_sales_date_status ON sales(sale_date, status);
CREATE INDEX idx_customers_type_active ON customers(customer_type, is_active);
CREATE INDEX idx_employees_position_active ON employees(position, is_active);

-- Búsqueda de texto completo
ALTER TABLE vehicles ADD FULLTEXT INDEX ft_notes(notes);
ALTER TABLE customers ADD FULLTEXT INDEX ft_customer_info(first_name, last_name, company_name);

-- ============================================
-- COMENTARIOS EN COLUMNAS
-- ============================================

ALTER TABLE vehicles COMMENT = 'Inventario completo de vehículos del concesionario';
ALTER TABLE sales COMMENT = 'Registro de todas las ventas realizadas';
ALTER TABLE customers COMMENT = 'Base de datos de clientes del concesionario';
ALTER TABLE employees COMMENT = 'Empleados y vendedores del concesionario';