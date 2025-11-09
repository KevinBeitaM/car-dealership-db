-- ============================================
-- DATOS DE PRUEBA
-- Sistema de Gestión de Concesionario de Autos
-- Autor: KevinBeitaM
-- Fecha: 2025-11-06
-- ============================================

USE car_dealership;

-- Deshabilitar verificación de llaves foráneas temporalmente
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================
-- MARCAS DE VEHÍCULOS
-- ============================================

INSERT INTO brands (brand_name, country_origin, website, is_active) VALUES
('Toyota', 'Japón', 'www.toyota.com', TRUE),
('Honda', 'Japón', 'www.honda.com', TRUE),
('Ford', 'Estados Unidos', 'www.ford.com', TRUE),
('Chevrolet', 'Estados Unidos', 'www.chevrolet.com', TRUE),
('Nissan', 'Japón', 'www.nissan.com', TRUE),
('Volkswagen', 'Alemania', 'www.vw.com', TRUE),
('Mazda', 'Japón', 'www.mazda.com', TRUE),
('Hyundai', 'Corea del Sur', 'www.hyundai.com', TRUE),
('Kia', 'Corea del Sur', 'www.kia.com', TRUE),
('BMW', 'Alemania', 'www.bmw.com', TRUE),
('Mercedes-Benz', 'Alemania', 'www.mercedes-benz.com', TRUE),
('Audi', 'Alemania', 'www.audi.com', TRUE),
('Tesla', 'Estados Unidos', 'www.tesla.com', TRUE),
('Subaru', 'Japón', 'www.subaru.com', TRUE),
('Jeep', 'Estados Unidos', 'www.jeep.com', TRUE);

-- ============================================
-- MODELOS DE VEHÍCULOS
-- ============================================

-- Toyota
INSERT INTO models (brand_id, model_name, body_type, fuel_type, transmission, year_introduced) VALUES
(1, 'Corolla', 'Sedán', 'Gasolina', 'Automática', 2020),
(1, 'Camry', 'Sedán', 'Híbrido', 'Automática', 2021),
(1, 'RAV4', 'SUV', 'Híbrido', 'Automática', 2021),
(1, 'Hilux', 'Pickup', 'Diesel', 'Manual', 2020),
(1, 'Prius', 'Hatchback', 'Híbrido', 'Automática', 2020);

-- Honda
INSERT INTO models (brand_id, model_name, body_type, fuel_type, transmission, year_introduced) VALUES
(2, 'Civic', 'Sedán', 'Gasolina', 'CVT', 2021),
(2, 'Accord', 'Sedán', 'Híbrido', 'Automática', 2020),
(2, 'CR-V', 'SUV', 'Gasolina', 'CVT', 2021),
(2, 'Pilot', 'SUV', 'Gasolina', 'Automática', 2020);

-- Ford
INSERT INTO models (brand_id, model_name, body_type, fuel_type, transmission, year_introduced) VALUES
(3, 'Mustang', 'Coupé', 'Gasolina', 'Manual', 2021),
(3, 'F-150', 'Pickup', 'Gasolina', 'Automática', 2021),
(3, 'Explorer', 'SUV', 'Gasolina', 'Automática', 2020),
(3, 'Escape', 'SUV', 'Híbrido', 'Automática', 2020);

-- Chevrolet
INSERT INTO models (brand_id, model_name, body_type, fuel_type, transmission, year_introduced) VALUES
(4, 'Silverado', 'Pickup', 'Gasolina', 'Automática', 2021),
(4, 'Equinox', 'SUV', 'Gasolina', 'Automática', 2020),
(4, 'Tahoe', 'SUV', 'Gasolina', 'Automática', 2021),
(4, 'Malibu', 'Sedán', 'Gasolina', 'Automática', 2020);

-- Nissan
INSERT INTO models (brand_id, model_name, body_type, fuel_type, transmission, year_introduced) VALUES
(5, 'Sentra', 'Sedán', 'Gasolina', 'CVT', 2020),
(5, 'Altima', 'Sedán', 'Gasolina', 'CVT', 2021),
(5, 'Rogue', 'SUV', 'Gasolina', 'CVT', 2021),
(5, 'Frontier', 'Pickup', 'Gasolina', 'Manual', 2020);

-- Volkswagen
INSERT INTO models (brand_id, model_name, body_type, fuel_type, transmission, year_introduced) VALUES
(6, 'Jetta', 'Sedán', 'Gasolina', 'Automática', 2020),
(6, 'Tiguan', 'SUV', 'Gasolina', 'Automática', 2021),
(6, 'Golf', 'Hatchback', 'Gasolina', 'Manual', 2020);

-- Mazda
INSERT INTO models (brand_id, model_name, body_type, fuel_type, transmission, year_introduced) VALUES
(7, 'Mazda3', 'Sedán', 'Gasolina', 'Automática', 2021),
(7, 'CX-5', 'SUV', 'Gasolina', 'Automática', 2021),
(7, 'CX-9', 'SUV', 'Gasolina', 'Automática', 2020);

-- Tesla
INSERT INTO models (brand_id, model_name, body_type, fuel_type, transmission, year_introduced) VALUES
(13, 'Model 3', 'Sedán', 'Eléctrico', 'Automática', 2021),
(13, 'Model Y', 'SUV', 'Eléctrico', 'Automática', 2021),
(13, 'Model S', 'Sedán', 'Eléctrico', 'Automática', 2020);

-- BMW
INSERT INTO models (brand_id, model_name, body_type, fuel_type, transmission, year_introduced) VALUES
(10, 'Serie 3', 'Sedán', 'Gasolina', 'Automática', 2021),
(10, 'X5', 'SUV', 'Híbrido Enchufable', 'Automática', 2021);

-- ============================================
-- COLORES
-- ============================================

INSERT INTO colors (color_name, color_code) VALUES
('Blanco', '#FFFFFF'),
('Negro', '#000000'),
('Gris', '#808080'),
('Plata', '#C0C0C0'),
('Rojo', '#FF0000'),
('Azul', '#0000FF'),
('Verde', '#008000'),
('Amarillo', '#FFFF00'),
('Naranja', '#FFA500'),
('Café', '#8B4513'),
('Beige', '#F5F5DC'),
('Dorado', '#FFD700');

-- ============================================
-- EMPLEADOS
-- ============================================

INSERT INTO employees (employee_code, first_name, last_name, position, department, email, phone, hire_date, salary, commission_rate, is_active) VALUES
('EMP-001', 'Carlos', 'Rodríguez', 'Gerente General', 'Administración', 'carlos.rodriguez@dealership.com', '555-0101', '2020-01-15', 80000.00, 0.00, TRUE),
('EMP-002', 'María', 'González', 'Gerente Ventas', 'Ventas', 'maria.gonzalez@dealership.com', '555-0102', '2020-03-01', 60000.00, 2.00, TRUE),
('EMP-003', 'Juan', 'Pérez', 'Vendedor', 'Ventas', 'juan.perez@dealership.com', '555-0103', '2020-06-15', 35000.00, 5.00, TRUE),
('EMP-004', 'Ana', 'Martínez', 'Vendedor', 'Ventas', 'ana.martinez@dealership.com', '555-0104', '2020-08-01', 35000.00, 5.00, TRUE),
('EMP-005', 'Luis', 'Hernández', 'Vendedor', 'Ventas', 'luis.hernandez@dealership.com', '555-0105', '2021-01-10', 35000.00, 5.00, TRUE),
('EMP-006', 'Patricia', 'López', 'Vendedor', 'Ventas', 'patricia.lopez@dealership.com', '555-0106', '2021-03-15', 35000.00, 5.00, TRUE),
('EMP-007', 'Roberto', 'García', 'Mecánico', 'Servicio', 'roberto.garcia@dealership.com', '555-0107', '2020-04-01', 40000.00, 0.00, TRUE),
('EMP-008', 'Sandra', 'Ramírez', 'Mecánico', 'Servicio', 'sandra.ramirez@dealership.com', '555-0108', '2020-09-01', 40000.00, 0.00, TRUE),
('EMP-009', 'Miguel', 'Torres', 'Administrativo', 'Administración', 'miguel.torres@dealership.com', '555-0109', '2021-02-01', 30000.00, 0.00, TRUE),
('EMP-010', 'Laura', 'Sánchez', 'Cajero', 'Administración', 'laura.sanchez@dealership.com', '555-0110', '2021-05-01', 28000.00, 0.00, TRUE);

-- ============================================
-- CLIENTES
-- ============================================

INSERT INTO customers (customer_type, first_name, last_name, company_name, identification_type, identification_number, email, phone, mobile, address, city, state, postal_code, date_of_birth, occupation, credit_score, preferred_contact, is_active) VALUES
('Persona', 'José', 'Morales', NULL, 'DNI', '12345678A', 'jose.morales@email.com', '555-1001', '555-2001', 'Av. Principal 123', 'Ciudad de México', 'CDMX', '01000', '1985-05-15', 'Ingeniero', 720, 'WhatsApp', TRUE),
('Persona', 'Carmen', 'Ruiz', NULL, 'DNI', '23456789B', 'carmen.ruiz@email.com', '555-1002', '555-2002', 'Calle Secundaria 456', 'Guadalajara', 'Jalisco', '44100', '1990-08-22', 'Contador', 680, 'Email', TRUE),
('Empresa', 'Transportes', 'del Norte SA', 'Transportes del Norte SA', 'RUC', 'RUC-001234567', 'contacto@transportesnorte.com', '555-1003', '555-2003', 'Zona Industrial 789', 'Monterrey', 'Nuevo León', '64000', NULL, 'Transporte', 750, 'Teléfono', TRUE),
('Persona', 'Fernando', 'Castro', NULL, 'DNI', '34567890C', 'fernando.castro@email.com', '555-1004', '555-2004', 'Col. Centro 321', 'Puebla', 'Puebla', '72000', '1988-12-10', 'Abogado', 700, 'WhatsApp', TRUE),
('Persona', 'Gabriela', 'Mendoza', NULL, 'DNI', '45678901D', 'gabriela.mendoza@email.com', '555-1005', '555-2005', 'Fraccionamiento Norte 654', 'Querétaro', 'Querétaro', '76000', '1992-03-18', 'Médico', 780, 'Email', TRUE),
('Persona', 'Ricardo', 'Vargas', NULL, 'Pasaporte', 'P123456789', 'ricardo.vargas@email.com', '555-1006', '555-2006', 'Zona Residencial 987', 'Cancún', 'Quintana Roo', '77500', '1987-07-25', 'Empresario', 800, 'Teléfono', TRUE),
('Persona', 'Daniela', 'Ortiz', NULL, 'DNI', '56789012E', 'daniela.ortiz@email.com', '555-1007', '555-2007', 'Av. Juárez 147', 'Tijuana', 'Baja California', '22000', '1995-11-30', 'Diseñadora', 650, 'WhatsApp', TRUE),
('Empresa', 'Construcciones', 'Modernas SA', 'Construcciones Modernas SA', 'RUC', 'RUC-002345678', 'info@construccionesmodernas.com', '555-1008', '555-2008', 'Parque Industrial 258', 'León', 'Guanajuato', '37000', NULL, 'Construcción', 720, 'Email', TRUE),
('Persona', 'Mónica', 'Silva', NULL, 'DNI', '67890123F', 'monica.silva@email.com', '555-1009', '555-2009', 'Col. Jardines 369', 'Mérida', 'Yucatán', '97000', '1993-04-12', 'Profesora', 690, 'Teléfono', TRUE),
('Persona', 'Alberto', 'Ramos', NULL, 'DNI', '78901234G', 'alberto.ramos@email.com', '555-1010', '555-2010', 'Zona Centro 741', 'Aguascalientes', 'Aguascalientes', '20000', '1986-09-05', 'Comerciante', 710, 'WhatsApp', TRUE),
('Persona', 'Sofía', 'Paredes', NULL, 'DNI', '89012345H', 'sofia.paredes@email.com', '555-1011', '555-2011', 'Fracc. Los Pinos 852', 'Toluca', 'Estado de México', '50000', '1991-02-28', 'Arquitecta', 740, 'Email', TRUE),
('Persona', 'Diego', 'Navarro', NULL, 'DNI', '90123456I', 'diego.navarro@email.com', '555-1012', '555-2012', 'Col. Industrial 963', 'Chihuahua', 'Chihuahua', '31000', '1989-06-14', 'Ingeniero', 760, 'WhatsApp', TRUE);

-- ============================================
-- VEHÍCULOS EN INVENTARIO
-- ============================================

-- Vehículos Nuevos
INSERT INTO vehicles (vin, model_id, color_id, year, mileage, condition_type, engine_size, horsepower, doors, seats, purchase_price, sale_price, status, location, date_acquired, notes) VALUES
('1HGCM82633A123456', 1, 1, 2024, 0, 'Nuevo', 1.8, 139, 4, 5, 350000.00, 420000.00, 'Disponible', 'Lote A-01', '2024-10-01', 'Toyota Corolla 2024 - Blanco'),
('2HGCM82633A234567', 1, 4, 2024, 0, 'Nuevo', 1.8, 139, 4, 5, 350000.00, 420000.00, 'Disponible', 'Lote A-02', '2024-10-01', 'Toyota Corolla 2024 - Plata'),
('3HGCM82633A345678', 2, 5, 2024, 0, 'Nuevo', 2.5, 203, 4, 5, 480000.00, 580000.00, 'Disponible', 'Lote A-03', '2024-10-05', 'Toyota Camry Híbrido 2024'),
('4HGCM82633A456789', 3, 1, 2024, 0, 'Nuevo', 2.5, 203, 4, 5, 520000.00, 650000.00, 'Disponible', 'Lote A-04', '2024-10-05', 'Toyota RAV4 Híbrido 2024'),
('5HGCM82633A567890', 6, 2, 2024, 0, 'Nuevo', 2.0, 158, 4, 5, 420000.00, 510000.00, 'Disponible', 'Lote B-01', '2024-10-10', 'Honda Civic 2024'),
('6HGCM82633A678901', 8, 6, 2024, 0, 'Nuevo', 1.5, 190, 4, 5, 480000.00, 590000.00, 'Disponible', 'Lote B-02', '2024-10-10', 'Honda CR-V 2024'),
('7HGCM82633A789012', 10, 5, 2024, 0, 'Nuevo', 5.0, 450, 2, 4, 850000.00, 1050000.00, 'Disponible', 'Lote C-01', '2024-10-15', 'Ford Mustang GT 2024'),
('8HGCM82633A890123', 11, 1, 2024, 0, 'Nuevo', 3.5, 400, 4, 6, 780000.00, 950000.00, 'Disponible', 'Lote C-02', '2024-10-15', 'Ford F-150 2024'),
('9HGCM82633A901234', 14, 3, 2024, 0, 'Nuevo', 5.3, 355, 4, 7, 920000.00, 1150000.00, 'Disponible', 'Lote D-01', '2024-10-20', 'Chevrolet Silverado 2024'),
('AHGCM82633A012345', 28, 1, 2024, 0, 'Nuevo', 0.0, 283, 4, 5, 750000.00, 920000.00, 'Disponible', 'Lote E-01', '2024-10-25', 'Tesla Model 3 2024');

-- Vehículos Seminuevos
INSERT INTO vehicles (vin, model_id, color_id, year, mileage, condition_type, engine_size, horsepower, doors, seats, purchase_price, sale_price, status, location, date_acquired, notes) VALUES
('BHGCM82633A123456', 1, 2, 2023, 15000, 'Seminuevo', 1.8, 139, 4, 5, 300000.00, 380000.00, 'Disponible', 'Lote F-01', '2024-09-15', 'Toyota Corolla 2023 - Excelente estado'),
('CHGCM82633A234567', 6, 4, 2023, 12000, 'Seminuevo', 2.0, 158, 4, 5, 350000.00, 450000.00, 'Disponible', 'Lote F-02', '2024-09-20', 'Honda Civic 2023'),
('DHGCM82633A345678', 8, 1, 2022, 25000, 'Seminuevo', 1.5, 190, 4, 5, 400000.00, 520000.00, 'Disponible', 'Lote F-03', '2024-09-25', 'Honda CR-V 2022'),
('EHGCM82633A456789', 3, 6, 2023, 18000, 'Seminuevo', 2.5, 203, 4, 5, 450000.00, 580000.00, 'Disponible', 'Lote F-04', '2024-10-01', 'Toyota RAV4 2023'),
('FHGCM82633A567890', 22, 3, 2022, 30000, 'Seminuevo', 2.5, 187, 4, 5, 320000.00, 420000.00, 'Disponible', 'Lote F-05', '2024-10-05', 'Mazda CX-5 2022');

-- Vehículos Vendidos (para historial)
INSERT INTO vehicles (vin, model_id, color_id, year, mileage, condition_type, engine_size, horsepower, doors, seats, purchase_price, sale_price, status, location, date_acquired, date_sold, notes) VALUES
('GHGCM82633A123456', 1, 1, 2024, 0, 'Nuevo', 1.8, 139, 4, 5, 350000.00, 420000.00, 'Vendido', 'Vendido', '2024-08-01', '2024-09-15', 'Vendido a José Morales'),
('HHGCM82633A234567', 6, 5, 2024, 0, 'Nuevo', 2.0, 158, 4, 5, 420000.00, 510000.00, 'Vendido', 'Vendido', '2024-08-05', '2024-09-20', 'Vendido a Carmen Ruiz'),
('IHGCM82633A345678', 11, 2, 2024, 0, 'Nuevo', 3.5, 400, 4, 6, 780000.00, 950000.00, 'Vendido', 'Vendido', '2024-08-10', '2024-10-01', 'Vendido a Transportes del Norte'),
('JHGCM82633A456789', 28, 1, 2023, 8000, 'Seminuevo', 0.0, 283, 4, 5, 600000.00, 780000.00, 'Vendido', 'Vendido', '2024-08-15', '2024-10-10', 'Vendido a Fernando Castro'),
('KHGCM82633A567890', 3, 6, 2024, 0, 'Nuevo', 2.5, 203, 4, 5, 520000.00, 650000.00, 'Vendido', 'Vendido', '2024-09-01', '2024-10-20', 'Vendido a Gabriela Mendoza');

-- ============================================
-- CARACTERÍSTICAS DE VEHÍCULOS
-- ============================================

-- Características para algunos vehículos
INSERT INTO vehicle_features (vehicle_id, feature_name, feature_value) VALUES
(1, 'Sistema de Navegación', 'GPS integrado'),
(1, 'Cámara de Reversa', 'Sí'),
(1, 'Sensores de Estacionamiento', 'Delanteros y Traseros'),
(1, 'Control de Crucero Adaptativo', 'Sí'),
(3, 'Techo Solar', 'Panorámico'),
(3, 'Asientos', 'Cuero Premium'),
(3, 'Sistema de Audio', 'JBL Premium 12 bocinas'),
(7, 'Modo de Conducción', 'Sport+'),
(7, 'Escape', 'Deportivo activo'),
(10, 'Piloto Automático', 'Full Self-Driving'),
(10, 'Carga Rápida', 'Supercharger compatible');

-- ============================================
-- VENTAS
-- ============================================

INSERT INTO sales (sale_number, vehicle_id, customer_id, salesperson_id, sale_date, sale_price, discount_amount, tax_amount, payment_method, down_payment, financed_amount, status, delivery_date, notes) VALUES
('VTA-20240915-0001', 16, 1, 3, '2024-09-15', 420000.00, 5000.00, 66400.00, 'Financiamiento', 100000.00, 315000.00, 'Completada', '2024-09-20', 'Primera venta de Juan Pérez'),
('VTA-20240920-0002', 17, 2, 4, '2024-09-20', 510000.00, 10000.00, 80000.00, 'Financiamiento', 150000.00, 350000.00, 'Completada', '2024-09-25', 'Cliente recurrente'),
('VTA-20241001-0003', 18, 3, 3, '2024-10-01', 950000.00, 0.00, 152000.00, 'Contado', 950000.00, 0.00, 'Completada', '2024-10-05', 'Venta corporativa - flota'),
('VTA-20241010-0004', 19, 4, 5, '2024-10-10', 780000.00, 20000.00, 121600.00, 'Financiamiento', 200000.00, 560000.00, 'Completada', '2024-10-15', 'Tesla seminuevo'),
('VTA-20241020-0005', 20, 5, 4, '2024-10-20', 650000.00, 10000.00, 102400.00, 'Financiamiento', 180000.00, 460000.00, 'Completada', '2024-10-25', 'RAV4 Híbrido');

-- ============================================
-- PAGOS
-- ============================================

-- Pagos de enganches
INSERT INTO payments (sale_id, payment_number, payment_date, amount, payment_type, reference_number, notes) VALUES
(1, 'PAG-20240915-0001', '2024-09-15', 100000.00, 'Transferencia', 'TRANS-001', 'Enganche Toyota Corolla'),
(2, 'PAG-20240920-0002', '2024-09-20', 150000.00, 'Cheque', 'CHQ-12345', 'Enganche Honda Civic'),
(3, 'PAG-20241001-0003', '2024-10-01', 950000.00, 'Transferencia', 'TRANS-002', 'Pago completo Ford F-150'),
(4, 'PAG-20241010-0004', '2024-10-10', 200000.00, 'Transferencia', 'TRANS-003', 'Enganche Tesla Model 3'),
(5, 'PAG-20241020-0005', '2024-10-20', 180000.00, 'Tarjeta Crédito', 'TC-9876', 'Enganche RAV4');

-- ============================================
-- FINANCIAMIENTO
-- ============================================

INSERT INTO financing (sale_id, financial_institution, loan_amount, interest_rate, term_months, monthly_payment, start_date, end_date, status, approval_date, notes) VALUES
(1, 'Banco Nacional', 315000.00, 12.50, 48, 8357.25, '2024-09-20', '2028-09-20', 'Aprobado', '2024-09-18', 'Crédito automotriz estándar'),
(2, 'Banco del Pacífico', 350000.00, 11.80, 60, 7717.50, '2024-09-25', '2029-09-25', 'Aprobado', '2024-09-22', 'Crédito preferencial'),
(4, 'Financiera Automotriz', 560000.00, 13.20, 72, 10293.33, '2024-10-15', '2030-10-15', 'Aprobado', '2024-10-12', 'Crédito vehículo seminuevo'),
(5, 'Banco Nacional', 460000.00, 12.00, 60, 10225.33, '2024-10-25', '2029-10-25', 'Aprobado', '2024-10-23', 'Crédito híbrido - tasa preferencial');

-- ============================================
-- ÓRDENES DE SERVICIO
-- ============================================

INSERT INTO service_orders (order_number, vehicle_id, customer_id, service_date, service_type, description, mechanic_id, labor_cost, parts_cost, status, completion_date, notes) VALUES
('SRV-20241001-0001', 16, 1, '2024-10-01', 'Mantenimiento', 'Primer servicio 5,000 km - cambio de aceite y filtros', 7, 800.00, 1200.00, 'Completada', '2024-10-01', 'Servicio de cortesía'),
('SRV-20241015-0002', 17, 2, '2024-10-15', 'Reparación', 'Cambio de llanta por ponchadura', 7, 300.00, 2500.00, 'Completada', '2024-10-15', 'Incluye balanceo'),
('SRV-20241020-0003', 18, 3, '2024-10-20', 'Pre-entrega', 'Inspección pre-entrega vehículo corporativo', 8, 500.00, 0.00, 'Completada', '2024-10-20', 'Vehículo en perfectas condiciones'),
('SRV-20241105-0004', 1, 6, '2024-11-05', 'Revisión', 'Revisión general antes de compra', 7, 600.00, 0.00, 'Pendiente', NULL, 'Cliente interesado en el vehículo');

-- Restaurar verificación de llaves foráneas
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- CONSULTAS DE VERIFICACIÓN
-- ============================================

-- Ver inventario disponible
SELECT * FROM v_inventory_available LIMIT 10;

-- Ver ventas completas
SELECT * FROM v_sales_complete;

-- Ver top vendedores
SELECT * FROM v_top_salespeople;

-- Ver inventario por marca
SELECT * FROM v_inventory_by_brand;

-- Estadísticas generales
SELECT 
    'Total Vehículos en Inventario' AS metrica, COUNT(*) AS valor FROM vehicles WHERE status != 'Vendido'
UNION ALL
SELECT 'Vehículos Disponibles', COUNT(*) FROM vehicles WHERE status = 'Disponible'
UNION ALL
SELECT 'Vehículos Vendidos', COUNT(*) FROM vehicles WHERE status = 'Vendido'
UNION ALL
SELECT 'Total de Ventas', COUNT(*) FROM sales WHERE status = 'Completada'
UNION ALL
SELECT 'Total de Clientes', COUNT(*) FROM customers
UNION ALL
SELECT 'Total de Empleados', COUNT(*) FROM employees WHERE is_active = TRUE
UNION ALL
SELECT 'Valor Inventario Disponible', CAST(SUM(sale_price) AS SIGNED) FROM vehicles WHERE status = 'Disponible';