-- 1. Obtener la razón social, RUT y dirección de todos los proveedores que se encuentran en estado activo.
SELECT razon_social, rut, direccion 
FROM Proveedor 
WHERE estado_proveedor = 'activo';

-- 2. Listar el nombre y los niveles de stock de los productos que requieren almacenamiento refrigerado, ordenados alfabéticamente.
SELECT nombre, stock_actual, stock_maximo 
FROM Producto 
WHERE tipo_almacenamiento = 'refrigerado' 
ORDER BY nombre ASC;

-- 3. Listar el nombre, el tipo y la capacidad de todas las bodegas que tienen una capacidad superior a 10.000, ordenadas desde la más grande a la más pequeña.
SELECT nombre, tipo_bodega, capacidad
FROM Bodega
WHERE capacidad > 10000
ORDER BY capacidad DESC;

-- 4. Identificar los 5 insumos con el precio acordado más alto registrado en el catálogo de proveedores.
SELECT id_insumo, precio_acordado 
FROM Proveedor_Insumo 
ORDER BY precio_acordado DESC 
LIMIT 5;

-- 5. Calcular la suma de los montos totales de todas las facturas que se encuentran en estado "pendiente".
SELECT SUM(monto_total) AS deuda_total
FROM Factura
WHERE estado_pago = 'pendiente';

-- 6. Obtener el nombre y descripción de los insumos que pertenecen a categorías que actualmente están activas.
SELECT nombre, descripcion 
FROM Insumo 
WHERE id_categoria IN (
    SELECT id_categoria 
    FROM Categoria 
    WHERE estado = 'activa'
);

-- 7. Calcular el stock actual acumulado de todos los productos agrupados por su tipo de almacenamiento.
SELECT tipo_almacenamiento, SUM(stock_actual) AS total_stock 
FROM Producto 
GROUP BY tipo_almacenamiento;

-- 8. Listar el nombre, apellido y cargo de los contactos que trabajan para proveedores ubicados en la ciudad de Santiago.
SELECT nombre, apellido, cargo 
FROM Contacto 
WHERE id_proveedor IN (
    SELECT id_proveedor 
    FROM Proveedor 
    WHERE direccion LIKE '%Santiago%'
);

-- 9. Mostrar el nombre y código de los productos que cuentan con una receta en estado vigente.
SELECT nombre, codigo 
FROM Producto 
WHERE id_producto IN (
    SELECT id_producto 
    FROM Receta 
    WHERE estado_vigencia = 'vigente'
);

-- 10. Identificar los identificadores de órdenes de compra donde la suma total de las cantidades de insumos solicitados supere las 100 unidades.
SELECT id_orden_compra, SUM(cantidad_solicitada) AS total_unidades 
FROM Detalle_Orden_Compra 
GROUP BY id_orden_compra 
HAVING SUM(cantidad_solicitada) > 100;

-- 11. Extraer los montos totales máximo, mínimo y promedio pagados en las facturas registradas.
SELECT MAX(monto_total) AS pago_maximo, 
       MIN(monto_total) AS pago_minimo, 
       AVG(monto_total) AS pago_promedio 
FROM Factura 
WHERE estado_pago = 'pagada';

-- 12. Listar el nombre de los insumos requeridos en las recetas de los productos que se deben almacenar congelados.
SELECT nombre 
FROM Insumo 
WHERE id_insumo IN (
    SELECT id_insumo 
    FROM Detalle_Receta 
    WHERE id_receta IN (
        SELECT id_receta 
        FROM Receta 
        WHERE id_producto IN (
            SELECT id_producto 
            FROM Producto 
            WHERE tipo_almacenamiento = 'congelado'
        )
    )
);

-- 13. Extraer el RUT, nombre y apellido de los trabajadores que tienen un registro asociado como operarios utilizando validación de existencia.
SELECT rut, nombre, apellido 
FROM Trabajador t 
WHERE EXISTS (
    SELECT 1 
    FROM Operario o 
    WHERE o.id_trabajador = t.id_trabajador
);

-- 14. Mostrar el nombre de cada área productiva junto con la cantidad exacta de trabajadores asignados, ejecutando una subconsulta en la declaración SELECT.
SELECT nombre, 
       (SELECT COUNT(*) FROM Trabajador t WHERE t.id_area = a.id_area) AS total_trabajadores 
FROM Area a;

-- 15. Encontrar a los proveedores activos que actualmente no tienen ninguna orden de compra emitida a su nombre.
SELECT razon_social, rut 
FROM Proveedor 
WHERE estado_proveedor = 'activo' 
  AND id_proveedor NOT IN (
      SELECT id_proveedor 
      FROM Orden_Compra
  );

-- 16. Obtener el número de lote, el nombre del producto (mediante subconsulta) y la fecha de vencimiento de los lotes de productos terminados que expiran después del año 2026.
SELECT numero_lote, 
       (SELECT nombre FROM Producto p WHERE p.id_producto = lpt.id_producto) AS nombre_producto, 
       fecha_vencimiento 
FROM Lote_Producto_Terminado lpt 
WHERE fecha_vencimiento > '2026-12-31';

-- 17. Identificar los productos cuyo stock actual es inferior al promedio del stock actual de todos los productos en la base de datos.
SELECT nombre, stock_actual 
FROM Producto 
WHERE stock_actual < (
    SELECT AVG(stock_actual) 
    FROM Producto
);

-- 18. Encontrar el nombre y tipo de las bodegas que tienen al menos una ubicación con un pallet de producto terminado en estado ocupado.
SELECT nombre, tipo_bodega 
FROM Bodega b 
WHERE EXISTS (
    SELECT 1 
    FROM Ubicacion u 
    WHERE u.id_bodega = b.id_bodega 
      AND EXISTS (
          SELECT 1 
          FROM Pallet_Terminado pt 
          WHERE pt.id_ubicacion = u.id_ubicacion 
            AND pt.estado = 'ocupado'
      )
);

-- 19. Extraer los números de las órdenes de compra que tienen asociada una factura cuyo monto total supera los 200.000 pesos.
SELECT numero_orden 
FROM Orden_Compra 
WHERE id_orden_compra IN (
    SELECT id_orden_compra 
    FROM Factura 
    WHERE monto_total > 200000
);

-- 20. Listar las áreas activas cuyo presupuesto mensual es estrictamente mayor que el presupuesto promedio de todas las áreas activas combinadas.
SELECT nombre, presupuesto_mensual 
FROM Area 
WHERE estado = 'activa' 
  AND presupuesto_mensual > (
      SELECT AVG(presupuesto_mensual) 
      FROM Area 
      WHERE estado = 'activa'
  );
