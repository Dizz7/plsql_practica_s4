



-- USUARIO EA1MDY_FOL

/* Se modificó la contraseña del usuario de E1-CreaUsuario.sql por 
   requerimiento de seguridad de Oracle SQL Developer (contraseña 'duoc')

   La línea alterada fue esta: 

   CREATE USER E1MDY_FOL IDENTIFIED BY "H0l4.O_r4cL3!"
	

   Se modificó el archivo E1-DDL_DML.sql y se agregaron Commit; después de Updates. 
*/




-- ********** FUNCIÓN ALMACENADA 1 ********** 


/* Función almacenada que retorna el 
   porcentaje asociado rescatado desde 
   la tabla TRAMO_PRECIO dado el precio 
   unitario de un producto. */


CREATE OR REPLACE FUNCTION fn_porcentaje (
    p_precio NUMBER)
    RETURN NUMBER

IS

    p_porcentaje NUMBER;
    v_minimo      NUMBER;
    v_maximo      NUMBER;

BEGIN
    p_porcentaje := 0;

    -- Obtener el rango mínimo y máximo para el precio
    SELECT MIN(valor_minimo), MAX(valor_maximo)
    INTO v_minimo, v_maximo
    FROM tramo_precio;

    -- Comparar el precio con los valores mínimo y máximo
    IF p_precio < v_minimo THEN
        -- Si el precio es menor que el valor mínimo
        p_porcentaje := 0;
    ELSIF p_precio > v_maximo THEN
        -- Si el precio es mayor que el valor máximo
        p_porcentaje := 0;
    ELSE
        -- Si el precio está dentro de los rangos válidos
        SELECT porcentaje
        INTO p_porcentaje
        FROM tramo_precio
        WHERE p_precio >= valor_minimo
            AND p_precio <= valor_maximo;
    END IF;

    -- Retornar el porcentaje
    RETURN p_porcentaje;

END fn_porcentaje;
/


/*
    -- Probar Función 1: fn_porcentaje
    -- Bloque anónimo

    DECLARE
    v_precio NUMBER;

    BEGIN
        v_precio := fn_porcentaje(13990);
        DBMS_OUTPUT.PUT_LINE(v_precio); -- Resulado esperado 0,07

    END;
    /

    -- Función 1: fn_porcentaje funcionando ok. 
*/








-- ********** PROCEDIMIENTO ALMACENADO 1 ********** 

/* Procedimiento almacenado que retorna la cantidad
   de boletas en las que ha sido incluido el producto 
   y el total de unidades vendidas del producto dado 
   un código de producto y un periodo de tiempo. */


CREATE OR REPLACE PROCEDURE sp_bol_cant_producto (
    p_cod_producto       IN  NUMBER,
    p_periodo            IN  VARCHAR2,
    p_nro_boletas        OUT NUMBER,
    p_cantidad_producto  OUT NUMBER)

IS

    v_inicio_mes BOLETA.fecha%TYPE;
    v_fin_mes    BOLETA.fecha%TYPE;

BEGIN

    -- Definir el inicio y fin del mes según el periodo
    v_inicio_mes := TO_DATE('01-' || p_periodo, 'DD-MM-YYYY');
    v_fin_mes := LAST_DAY(v_inicio_mes);

    -- Obtener la cantidad de boletas y productos vendidos con cursor implícito
    SELECT NVL(COUNT(db.numboleta), 0),
           NVL(SUM(db.cantidad), 0)
    INTO   p_nro_boletas,
           p_cantidad_producto
    FROM   boleta b
           INNER JOIN detalle_boleta db ON b.numboleta = db.numboleta
    WHERE  db.codproducto = p_cod_producto
           AND b.fecha BETWEEN v_inicio_mes AND v_fin_mes;

END sp_bol_cant_producto;
/


/*
    -- Probar Procedimiento 1: sp_bol_cant_producto
    -- Bloque anónimo

    DECLARE
        v_nro_boletas       NUMBER;
        v_cantidad_producto NUMBER;
    BEGIN
        sp_bol_cant_producto(5, '03-2024', v_nro_boletas, v_cantidad_producto);

        -- Mostrar los resultados en la consola
        DBMS_OUTPUT.PUT_LINE('Número de boletas: ' || v_nro_boletas); -- Resultado esperado: 2
        DBMS_OUTPUT.PUT_LINE('Cantidad de productos vendidos: ' || v_cantidad_producto); -- Resultado esperado 12
    END;
    /

    -- Procedimiento 1: sp_bol_cant_producto funcionando ok. 
*/








-- ********** FUNCIÓN ALMACENADA 2 **********

/* Función almacenada que retorna la cantidad de boletas
   que han sido emitidas a nombre de un cliente 
   dado el RUT del cliente y un periodo de tiempo. */


CREATE OR REPLACE FUNCTION fn_cant_boletas (
    p_rut VARCHAR2,
    p_periodo VARCHAR2)
    RETURN NUMBER


IS
    cant_boletas NUMBER;
    v_inicio_mes DATE;
    v_fin_mes DATE;

BEGIN
    -- Definir el inicio y fin del mes según el periodo
    v_inicio_mes := TO_DATE('01-' || p_periodo, 'DD-MM-YYYY');
    v_fin_mes := LAST_DAY(v_inicio_mes);

    -- Obtener el número de boletas en el periodo para el cliente con cursor implícito
    SELECT 
        NVL(COUNT(numboleta), 0)
    INTO cant_boletas
    FROM boleta
    WHERE p_rut = rutcliente
    AND fecha BETWEEN v_inicio_mes AND v_fin_mes;

    -- Retornar la cantidad de boletas
    RETURN cant_boletas;

END fn_cant_boletas;
/


/*
    -- Probar Función 2: fn_cant_boletas
    -- Bloque anónimo
    DECLARE
    v_cantidad number;

    BEGIN
        v_cantidad := fn_cant_boletas('10812874-0','03-2024');
        DBMS_OUTPUT.PUT_LINE(v_cantidad); -- Resultado esperado: 1 

    END;
    /

    -- Función 2: fn_cant_boletas funcionando ok. 
*/








-- ********** FUNCIÓN ALMACENADA 3 ********** 

/* Función almacenada que retorna la cantidad de facturas
   que han sido emitidas a nombre de un cliente 
   dado el RUT del cliente y un periodo de tiempo. */


CREATE OR REPLACE FUNCTION fn_cant_facturas (
    p_rut VARCHAR2,
    p_periodo VARCHAR2)
    RETURN NUMBER

IS

    cant_facturas NUMBER;
    v_inicio_mes DATE;
    v_fin_mes DATE;


BEGIN
    -- Definir el inicio y fin del mes según el periodo
    v_inicio_mes := TO_DATE('01-' || p_periodo, 'DD-MM-YYYY');
    v_fin_mes := LAST_DAY(v_inicio_mes);

    -- Obtener el número de facturas en el periodo para el cliente con cursor implícito
    SELECT 
        NVL(COUNT(numfactura), 0)
    INTO cant_facturas
    FROM factura
    WHERE p_rut = rutcliente
    AND fecha BETWEEN v_inicio_mes AND v_fin_mes;

    -- Retornar la cantidad de facturas
    RETURN cant_facturas;


END fn_cant_facturas;
/


/*

    -- Probar Función 3: fn_cant_facturas
    -- Bloque anónimo

    DECLARE
    v_cantidad number;

    BEGIN
        v_cantidad := fn_cant_facturas('8125781-8','03-2024');
        DBMS_OUTPUT.PUT_LINE(v_cantidad); -- Resultado esperado:  2 

    END;
    /

    -- Función 3: fn_cant_facturas funcionando ok. 

*/







-- ********** PROCEDIMIENTO ALMACENADO (PRINCIPAL) **********


/* Procedimiento almacenado para generar
   ambos informes solicitados ingresando
   un periodo MM-YYYY y un límite de crédito. */




CREATE OR REPLACE PROCEDURE sp_generar_informes (
    p_periodo            IN VARCHAR2,
    p_limite_credito     IN NUMBER)

IS

    -- Cursor explícito para obtener datos de clientes
    CURSOR cr_clientes IS
        SELECT  
            cl.rutcliente                                   AS rut_cliente,
            cl.nombre                                       AS nombre_cliente,
            NVL(co.descripcion, 'SIN COMUNA')               AS nombre_comuna,
            cl.credito                                      AS monto_credito
        FROM cliente cl LEFT JOIN comuna co 
            ON cl.codcomuna = co.codcomuna
        WHERE cl.credito >= p_limite_credito;


    -- Cursor explícito para obtener códigos de productos.
    CURSOR cr_productos IS    
        SELECT 
            codproducto                                     AS cod_producto,
            vunitario                                       AS precio
        FROM producto;


    -- Variables para cálculos
    v_inicio_mes          DATE;
    v_fin_mes             DATE;
    v_total_documentos    NUMBER;

    v_nro_boletas         NUMBER;
    v_cantidad_producto   NUMBER;

    v_porcentaje          NUMBER;
    v_nuevo_valor         NUMBER;


BEGIN

    -- Borrar datos de tablas
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RESUMEN_CLIENTE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RESUMEN_PRODUCTO';

    -- Emisión de Informe 1.  

    -- Ciclo para recorrer registros del cursor clientes.
    FOR reg_clientes IN cr_clientes LOOP

        -- Calcular total de documentos con funciones almacenadas.
        v_total_documentos := (NVL(fn_cant_boletas(reg_clientes.rut_cliente, p_periodo), 0) +
                               NVL(fn_cant_facturas(reg_clientes.rut_cliente, p_periodo),0));

        -- Almacenar en tabla RESUMEN_CLIENTE
        INSERT INTO RESUMEN_CLIENTE VALUES 
                        (reg_clientes.rut_cliente, 
                        reg_clientes.nombre_cliente, 
                        reg_clientes.nombre_comuna, 
                        v_total_documentos, 
                        reg_clientes.monto_credito);
    END LOOP;



    -- Emisión de Informe 2.    

    -- Ciclo para obtener códigos de productos.
    FOR reg_productos IN cr_productos LOOP
       
        -- Obtener número de boletas y cantidad de unidades del producto vendidas con procedimiento 1.
        sp_bol_cant_producto(reg_productos.cod_producto, p_periodo, v_nro_boletas, v_cantidad_producto);
        

        -- Obtener porcentaje 
        v_porcentaje := fn_porcentaje(reg_productos.precio);

        -- Calcular nuevo precio
        v_nuevo_valor := ROUND(reg_productos.precio * (1 + v_porcentaje));

        -- Almacenar en tabla RESUMEN_PRODUCTO
        INSERT INTO RESUMEN_PRODUCTO VALUES 
                        (reg_productos.cod_producto, 
                        v_nro_boletas, 
                        v_cantidad_producto,
                        reg_productos.precio,
                        v_porcentaje, 
                        v_nuevo_valor);

    END LOOP;

    -- Confirmar la transacción
    COMMIT;
    
END sp_generar_informes;
/


/*
    -- Probar Procedimiento (Principal): sp_generar_informes
    -- Bloque anónimo

    DECLARE

    BEGIN
        sp_generar_informes('03-2024', 500000);

    END;
    /

    -- Revisar tablas:


    -- TABLA RESUMEN_CLIENTE

    SELECT * 
    FROM RESUMEN_CLIENTE
    ORDER BY RUT_CLIENTE;



    -- TABLA RESUMEN_PRODUCTO

    SELECT * 
    FROM RESUMEN_PRODUCTO
    ORDER BY COD_PRODUCTO;

    -- Procedimiento (Principal): sp_generar_informes funcionando ok. 
*/