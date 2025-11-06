-- ============================================
-- PROCEDIMIENTOS ALMACENADOS Y TRIGGERS
-- Sistema de Gestión de Concesionario de Autos
-- Autor: KevinBeitaM
-- Fecha: 2025-11-06
-- ============================================

USE car_dealership;

DELIMITER $$

-- ============================================
-- PROCEDIMIENTOS ALMACENADOS
-- ============================================

-- Procedimiento: Registrar Nueva Venta
CREATE PROCEDURE sp_register_sale(
    IN p_vehicle_id INT,
    IN p_customer_id INT,
    IN p_salesperson_id INT,
    IN p_sale_price DECIMAL(12,2),
    IN p_discount_amount DECIMAL(10,2),
    IN p_tax_amount DECIMAL(10,2),
    IN p_payment_method VARCHAR(20),
    IN p_down_payment DECIMAL(12,2),
    IN p_financed_amount DECIMAL(12,2),
    IN p_delivery_date DATE,
    IN p_notes TEXT,
    OUT p_sale_id INT,
    OUT p_sale_number VARCHAR(50)
)
BEGIN
    DECLARE v_vehicle_status VARCHAR(20);
    DECLARE v_sale_count INT;
    
    -- Iniciar transacción
    START TRANSACTION;
    
    -- Verificar que el vehículo esté disponible
    SELECT status INTO v_vehicle_status
    FROM vehicles
    WHERE vehicle_id = p_vehicle_id;
    
    IF v_vehicle_status IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El vehículo no existe';
    END IF;
    
    IF v_vehicle_status != 'Disponible' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El vehículo no está disponible para venta';
    END IF;
    
    -- Generar número de venta
    SELECT COUNT(*) + 1 INTO v_sale_count FROM sales;
    SET p_sale_number = CONCAT('VTA-', DATE_FORMAT(NOW(), '%Y%m%d'), '-', LPAD(v_sale_count, 4, '0'));
    
    -- Insertar venta
    INSERT INTO sales (
        sale_number, vehicle_id, customer_id, salesperson_id,
        sale_date, sale_price, discount_amount, tax_amount,
        payment_method, down_payment, financed_amount,
        delivery_date, status, notes
    ) VALUES (
        p_sale_number, p_vehicle_id, p_customer_id, p_salesperson_id,
        CURDATE(), p_sale_price, p_discount_amount, p_tax_amount,
        p_payment_method, p_down_payment, p_financed_amount,
        p_delivery_date, 'Pendiente', p_notes
    );
    
    SET p_sale_id = LAST_INSERT_ID();
    
    -- Actualizar estado del vehículo
    UPDATE vehicles
    SET status = 'Reservado'
    WHERE vehicle_id = p_vehicle_id;
    
    COMMIT;
    
    SELECT CONCAT('Venta registrada exitosamente: ', p_sale_number) AS mensaje;
END$$

-- Procedimiento: Completar Venta
CREATE PROCEDURE sp_complete_sale(
    IN p_sale_id INT,
    IN p_completed_by VARCHAR(100)
)
BEGIN
    DECLARE v_vehicle_id INT;
    DECLARE v_sale_status VARCHAR(20);
    
    START TRANSACTION;
    
    -- Obtener información de la venta
    SELECT vehicle_id, status INTO v_vehicle_id, v_sale_status
    FROM sales
    WHERE sale_id = p_sale_id;
    
    IF v_sale_status IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'La venta no existe';
    END IF;
    
    IF v_sale_status = 'Completada' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'La venta ya está completada';
    END IF;
    
    IF v_sale_status = 'Cancelada' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'La venta está cancelada';
    END IF;
    
    -- Actualizar estado de venta
    UPDATE sales
    SET status = 'Completada'
    WHERE sale_id = p_sale_id;
    
    -- Actualizar vehículo como vendido
    UPDATE vehicles
    SET status = 'Vendido',
        date_sold = CURDATE()
    WHERE vehicle_id = v_vehicle_id;
    
    COMMIT;
    
    SELECT 'Venta completada exitosamente' AS mensaje;
END$$

-- Procedimiento: Cancelar Venta
CREATE PROCEDURE sp_cancel_sale(
    IN p_sale_id INT,
    IN p_reason TEXT
)
BEGIN
    DECLARE v_vehicle_id INT;
    DECLARE v_sale_status VARCHAR(20);
    
    START TRANSACTION;
    
    -- Obtener información de la venta
    SELECT vehicle_id, status INTO v_vehicle_id, v_sale_status
    FROM sales
    WHERE sale_id = p_sale_id;
    
    IF v_sale_status IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'La venta no existe';
    END IF;
    
    IF v_sale_status = 'Cancelada' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'La venta ya está cancelada';
    END IF;
    
    -- Actualizar estado de venta
    UPDATE sales
    SET status = 'Cancelada',
        notes = CONCAT(IFNULL(notes, ''), '\nCANCELADA: ', p_reason, ' - ', NOW())
    WHERE sale_id = p_sale_id;
    
    -- Devolver vehículo a disponible
    UPDATE vehicles
    SET status = 'Disponible',
        date_sold = NULL
    WHERE vehicle_id = v_vehicle_id;
    
    COMMIT;
    
    SELECT 'Venta cancelada exitosamente' AS mensaje;
END$$

-- Procedimiento: Registrar Pago
CREATE PROCEDURE sp_register_payment(
    IN p_sale_id INT,
    IN p_amount DECIMAL(12,2),
    IN p_payment_type VARCHAR(20),
    IN p_reference_number VARCHAR(100),
    IN p_notes TEXT,
    OUT p_payment_id INT,
    OUT p_payment_number VARCHAR(50)
)
BEGIN
    DECLARE v_payment_count INT;
    
    START TRANSACTION;
    
    -- Verificar que la venta existe
    IF NOT EXISTS (SELECT 1 FROM sales WHERE sale_id = p_sale_id) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'La venta no existe';
    END IF;
    
    -- Generar número de pago
    SELECT COUNT(*) + 1 INTO v_payment_count FROM payments;
    SET p_payment_number = CONCAT('PAG-', DATE_FORMAT(NOW(), '%Y%m%d'), '-', LPAD(v_payment_count, 4, '0'));
    
    -- Insertar pago
    INSERT INTO payments (
        sale_id, payment_number, payment_date, amount,
        payment_type, reference_number, notes
    ) VALUES (
        p_sale_id, p_payment_number, CURDATE(), p_amount,
        p_payment_type, p_reference_number, p_notes
    );
    
    SET p_payment_id = LAST_INSERT_ID();
    
    COMMIT;
    
    SELECT CONCAT('Pago registrado: ', p_payment_number) AS mensaje;
END$$

-- Procedimiento: Agregar Vehículo al Inventario
CREATE PROCEDURE sp_add_vehicle(
    IN p_vin VARCHAR(17),
    IN p_model_id INT,
    IN p_color_id INT,
    IN p_year YEAR,
    IN p_mileage INT,
    IN p_condition_type VARCHAR(20),
    IN p_purchase_price DECIMAL(12,2),
    IN p_sale_price DECIMAL(12,2),
    IN p_location VARCHAR(100),
    IN p_notes TEXT,
    OUT p_vehicle_id INT
)
BEGIN
    START TRANSACTION;
    
    -- Verificar que el VIN no exista
    IF EXISTS (SELECT 1 FROM vehicles WHERE vin = p_vin) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El VIN ya existe en el inventario';
    END IF;
    
    -- Insertar vehículo
    INSERT INTO vehicles (
        vin, model_id, color_id, year, mileage, condition_type,
        purchase_price, sale_price, status, location, date_acquired, notes
    ) VALUES (
        p_vin, p_model_id, p_color_id, p_year, p_mileage, p_condition_type,
        p_purchase_price, p_sale_price, 'Disponible', p_location, CURDATE(), p_notes
    );
    
    SET p_vehicle_id = LAST_INSERT_ID();
    
    COMMIT;
    
    SELECT CONCAT('Vehículo agregado exitosamente con ID: ', p_vehicle_id) AS mensaje;
END$$

-- Procedimiento: Crear Orden de Servicio
CREATE PROCEDURE sp_create_service_order(
    IN p_vehicle_id INT,
    IN p_customer_id INT,
    IN p_service_type VARCHAR(20),
    IN p_description TEXT,
    IN p_mechanic_id INT,
    OUT p_order_id INT,
    OUT p_order_number VARCHAR(50)
)
BEGIN
    DECLARE v_order_count INT;
    
    START TRANSACTION;
    
    -- Generar número de orden
    SELECT COUNT(*) + 1 INTO v_order_count FROM service_orders;
    SET p_order_number = CONCAT('SRV-', DATE_FORMAT(NOW(), '%Y%m%d'), '-', LPAD(v_order_count, 4, '0'));
    
    -- Insertar orden de servicio
    INSERT INTO service_orders (
        order_number, vehicle_id, customer_id, service_date,
        service_type, description, mechanic_id, status
    ) VALUES (
        p_order_number, p_vehicle_id, p_customer_id, CURDATE(),
        p_service_type, p_description, p_mechanic_id, 'Pendiente'
    );
    
    SET p_order_id = LAST_INSERT_ID();
    
    COMMIT;
    
    SELECT CONCAT('Orden de servicio creada: ', p_order_number) AS mensaje;
END$$

-- Procedimiento: Reporte de Ventas por Período
CREATE PROCEDURE sp_sales_report(
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    SELECT 
        DATE_FORMAT(s.sale_date, '%Y-%m') AS mes,
        COUNT(s.sale_id) AS total_ventas,
        SUM(s.final_price) AS monto_total,
        AVG(s.final_price) AS ticket_promedio,
        SUM(s.final_price - v.purchase_price) AS ganancia_total,
        COUNT(DISTINCT s.customer_id) AS clientes_unicos,
        COUNT(DISTINCT s.salesperson_id) AS vendedores_activos
    FROM sales s
    INNER JOIN vehicles v ON s.vehicle_id = v.vehicle_id
    WHERE s.sale_date BETWEEN p_start_date AND p_end_date
      AND s.status = 'Completada'
    GROUP BY DATE_FORMAT(s.sale_date, '%Y-%m')
    ORDER BY mes DESC;
END$$

-- Procedimiento: Inventario con Antigüedad
CREATE PROCEDURE sp_inventory_aging()
BEGIN
    SELECT 
        v.vehicle_id,
        v.vin,
        CONCAT(b.brand_name, ' ', m.model_name, ' ', v.year) AS vehiculo,
        v.sale_price,
        v.date_acquired,
        DATEDIFF(CURDATE(), v.date_acquired) AS dias_en_inventario,
        CASE 
            WHEN DATEDIFF(CURDATE(), v.date_acquired) <= 30 THEN 'Nuevo (0-30 días)'
            WHEN DATEDIFF(CURDATE(), v.date_acquired) <= 60 THEN 'Reciente (31-60 días)'
            WHEN DATEDIFF(CURDATE(), v.date_acquired) <= 90 THEN 'Normal (61-90 días)'
            WHEN DATEDIFF(CURDATE(), v.date_acquired) <= 180 THEN 'Antiguo (91-180 días)'
            ELSE 'Muy Antiguo (>180 días)'
        END AS categoria_antiguedad,
        v.location
    FROM vehicles v
    INNER JOIN models m ON v.model_id = m.model_id
    INNER JOIN brands b ON m.brand_id = b.brand_id
    WHERE v.status = 'Disponible'
    ORDER BY dias_en_inventario DESC;
END$$

-- Procedimiento: Top Clientes
CREATE PROCEDURE sp_top_customers(
    IN p_limit INT
)
BEGIN
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', IFNULL(c.last_name, '')) AS cliente,
        c.phone,
        c.email,
        COUNT(s.sale_id) AS total_compras,
        SUM(s.final_price) AS monto_total_gastado,
        AVG(s.final_price) AS ticket_promedio,
        MAX(s.sale_date) AS ultima_compra,
        DATEDIFF(CURDATE(), MAX(s.sale_date)) AS dias_desde_ultima_compra
    FROM customers c
    INNER JOIN sales s ON c.customer_id = s.customer_id
    WHERE s.status = 'Completada'
    GROUP BY c.customer_id
    ORDER BY monto_total_gastado DESC
    LIMIT p_limit;
END$$

-- ============================================
-- TRIGGERS DE AUDITORÍA
-- ============================================

-- Trigger: Auditar INSERT en ventas
CREATE TRIGGER trg_sales_after_insert
AFTER INSERT ON sales
FOR EACH ROW
BEGIN
    INSERT INTO sales_audit (
        sale_id, action_type, new_data, changed_by
    ) VALUES (
        NEW.sale_id,
        'INSERT',
        JSON_OBJECT(
            'sale_number', NEW.sale_number,
            'vehicle_id', NEW.vehicle_id,
            'customer_id', NEW.customer_id,
            'salesperson_id', NEW.salesperson_id,
            'sale_price', NEW.sale_price,
            'final_price', NEW.final_price,
            'status', NEW.status
        ),
        COALESCE(USER(), 'SYSTEM')
    );
END$$

-- Trigger: Auditar UPDATE en ventas
CREATE TRIGGER trg_sales_after_update
AFTER UPDATE ON sales
FOR EACH ROW
BEGIN
    INSERT INTO sales_audit (
        sale_id, action_type, old_data, new_data, changed_by
    ) VALUES (
        NEW.sale_id,
        IF(OLD.status != NEW.status, 'STATUS_CHANGE', 'UPDATE'),
        JSON_OBJECT(
            'sale_price', OLD.sale_price,
            'discount_amount', OLD.discount_amount,
            'status', OLD.status,
            'delivery_date', OLD.delivery_date
        ),
        JSON_OBJECT(
            'sale_price', NEW.sale_price,
            'discount_amount', NEW.discount_amount,
            'status', NEW.status,
            'delivery_date', NEW.delivery_date
        ),
        COALESCE(USER(), 'SYSTEM')
    );
END$$

-- Trigger: Auditar cambios de estado en vehículos
CREATE TRIGGER trg_vehicles_after_update
AFTER UPDATE ON vehicles
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO inventory_audit (
            vehicle_id, action_type, old_status, new_status, changed_by, notes
        ) VALUES (
            NEW.vehicle_id,
            'STATUS_CHANGE',
            OLD.status,
            NEW.status,
            COALESCE(USER(), 'SYSTEM'),
            CONCAT('Estado cambiado de ', OLD.status, ' a ', NEW.status)
        );
    END IF;
END$$

-- Trigger: Auditar INSERT en vehículos
CREATE TRIGGER trg_vehicles_after_insert
AFTER INSERT ON vehicles
FOR EACH ROW
BEGIN
    INSERT INTO inventory_audit (
        vehicle_id, action_type, new_status, changed_by, notes
    ) VALUES (
        NEW.vehicle_id,
        'INSERT',
        NEW.status,
        COALESCE(USER(), 'SYSTEM'),
        CONCAT('Vehículo agregado: VIN ', NEW.vin)
    );
END$$

-- ============================================
-- TRIGGERS DE VALIDACIÓN
-- ============================================

-- Trigger: Validar precio de venta antes de INSERT
CREATE TRIGGER trg_sales_before_insert
BEFORE INSERT ON sales
FOR EACH ROW
BEGIN
    DECLARE v_vehicle_sale_price DECIMAL(12,2);
    
    -- Obtener precio del vehículo
    SELECT sale_price INTO v_vehicle_sale_price
    FROM vehicles
    WHERE vehicle_id = NEW.vehicle_id;
    
    -- Advertencia si el precio de venta es muy bajo
    IF NEW.sale_price < (v_vehicle_sale_price * 0.7) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El precio de venta es 30% menor al precio sugerido';
    END IF;
    
    -- Validar que el descuento no exceda el precio
    IF NEW.discount_amount >= NEW.sale_price THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El descuento no puede ser mayor o igual al precio de venta';
    END IF;
END$$

-- Trigger: Validar financiamiento antes de INSERT
CREATE TRIGGER trg_financing_before_insert
BEFORE INSERT ON financing
FOR EACH ROW
BEGIN
    DECLARE v_sale_financed_amount DECIMAL(12,2);
    
    -- Obtener monto financiado de la venta
    SELECT financed_amount INTO v_sale_financed_amount
    FROM sales
    WHERE sale_id = NEW.sale_id;
    
    -- Validar que coincidan los montos
    IF NEW.loan_amount != v_sale_financed_amount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El monto del préstamo no coincide con el monto financiado en la venta';
    END IF;
    
    -- Calcular fecha de término
    SET NEW.end_date = DATE_ADD(NEW.start_date, INTERVAL NEW.term_months MONTH);
END$$

-- ============================================
-- EVENTOS PROGRAMADOS
-- ============================================

-- Habilitar el programador de eventos
SET GLOBAL event_scheduler = ON$$

-- Evento: Limpiar auditoría antigua (cada mes)
CREATE EVENT IF NOT EXISTS evt_cleanup_old_audit
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_DATE + INTERVAL 1 MONTH
DO
BEGIN
    -- Eliminar registros de auditoría de más de 2 años
    DELETE FROM sales_audit 
    WHERE changed_at < DATE_SUB(NOW(), INTERVAL 2 YEAR);
    
    DELETE FROM inventory_audit 
    WHERE changed_at < DATE_SUB(NOW(), INTERVAL 2 YEAR);
END$$

-- Evento: Alertas de inventario antiguo (cada semana)
CREATE EVENT IF NOT EXISTS evt_inventory_aging_alert
ON SCHEDULE EVERY 1 WEEK
STARTS CURRENT_DATE + INTERVAL 1 DAY
DO
BEGIN
    -- Aquí podrías insertar en una tabla de alertas o enviar notificaciones
    -- Por ahora solo registramos en una tabla temporal
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_aging_alerts AS
    SELECT 
        vehicle_id,
        vin,
        DATEDIFF(CURDATE(), date_acquired) AS dias_inventario
    FROM vehicles
    WHERE status = 'Disponible'
      AND DATEDIFF(CURDATE(), date_acquired) > 180;
END$$

DELIMITER ;

-- ============================================
-- PERMISOS (Opcional - Comentado)
-- ============================================

/*
-- Crear usuarios con diferentes roles
CREATE USER 'dealership_admin'@'localhost' IDENTIFIED BY 'admin_password';
CREATE USER 'dealership_sales'@'localhost' IDENTIFIED BY 'sales_password';
CREATE USER 'dealership_viewer'@'localhost' IDENTIFIED BY 'viewer_password';

-- Permisos para administrador
GRANT ALL PRIVILEGES ON car_dealership.* TO 'dealership_admin'@'localhost';

-- Permisos para vendedores
GRANT SELECT, INSERT, UPDATE ON car_dealership.customers TO 'dealership_sales'@'localhost';
GRANT SELECT ON car_dealership.vehicles TO 'dealership_sales'@'localhost';
GRANT SELECT, INSERT, UPDATE ON car_dealership.sales TO 'dealership_sales'@'localhost';
GRANT SELECT, INSERT ON car_dealership.payments TO 'dealership_sales'@'localhost';
GRANT EXECUTE ON PROCEDURE car_dealership.sp_register_sale TO 'dealership_sales'@'localhost';
GRANT EXECUTE ON PROCEDURE car_dealership.sp_register_payment TO 'dealership_sales'@'localhost';

-- Permisos para visualizadores (solo lectura)
GRANT SELECT ON car_dealership.* TO 'dealership_viewer'@'localhost';

-- Aplicar cambios
FLUSH PRIVILEGES;
*/