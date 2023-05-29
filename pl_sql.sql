-- ************************************************************
-- **        RELACION DE EJERCICIOS PL/SQL                   **
-- ************************************************************
--          HERIBERTO AMEZCUA HERNANDEZ    1º DAW B          --

-- 1. Escribir una función que reciba dos números y devuelva su suma. A continuación, escribir
--un procedimiento que muestre la suma al usuario.
CREATE OR REPLACE FUNCTION sumar_enteros(num1 INTEGER, num2 INTEGER)
    RETURNS INTEGER AS $$
BEGIN 
    RETURN num1+num2;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE ver_suma(num1 INTEGER, num2 INTEGER)
    LANGUAGE plpgsql AS $$
DECLARE
    suma INTEGER;
BEGIN
    suma := sumar_enteros(num1, num2);
    RAISE NOTICE '% + % = %', num1, num2, suma;
END;
$$;

-- PRUEBA
call ver_suma(3, 7);

-- 2. Codificar un procedimiento que reciba una cadena de texto y la visualice al revés.
CREATE OR REPLACE PROCEDURE al_reves(texto VARCHAR)
    LANGUAGE plpgsql AS $$
DECLARE
-- el codigo dentro del begin no puede acceder a los parametros por eso hay que declararlo
    text_reves varchar := '';
BEGIN
    FOR i IN REVERSE length(texto)..1 loop
    text_reves := CONCAT(text_reves, SUBSTRING(texto FROM i FOR 1));
    end loop;
    RAISE NOTICE '% al reves es %',texto,  text_reves;
END;
$$;

-- 3. Escribir una función que reciba una fecha y devuelva el año de la fecha (como número).
CREATE OR REPLACE FUNCTION extract_year(fecha DATE)
    RETURNS INTEGER AS $$
DECLARE
    year INTEGER;
BEGIN
    SELECT EXTRACT(YEAR FROM fecha) INTO year;
    return year;
END; 
$$ LANGUAGE plpgsql;

-- 4. Dado el siguiente procedimiento:
CREATE OR REPLACE PROCEDURE crear_depart (
    v_num_dept depart.dept_no%TYPE,
    v_dnombre depart.dnombre%TYPE DEFAULT 'PROVISIONAL',
    v_loc depart.loc%TYPE DEFAULT ‘PROVISIONAL’)
AS $$ 
BEGIN
    INSERT INTO depart VALUES (v_num_dept, v_dnombre, v_loc);
END;  
$$;
--Indicar cuáles de las siguientes llamadas son correctas y cuáles no:
--1o. crear_depart;
--** Esta llamada no es correcta pues el procedimiento debe recibir 3 parámetros y como vemos
--** no se está introduciendo ningún parámetro. 

--2o. crear_depart(50);
--** Esta llamada si es correcta, podría no serla si el tipo de dato que se introdujera fuera en formato VARCHAR como '50'
--** pero en clase dijimos que siempre lo trataríamos como tipo numérico.

--3o. crear_depart('COMPRAS');
--** Esta llamada no es correcta, porque el tipo de dato que debería recibir el primer parámetro debería ser numérico

--4o. crear_depart(50,'COMPRAS');
--** Esta llamada si es correcta, porque tanto el orden como el tipo de datos de los parámetros están introducidos tal y como 
--** se ha declarado en el procedimiento.

--5o. crear_depart('COMPRAS', 50);
--** Esta llamada no es correcta, porque al contrario que en el 4o, el orden del tipo de datos de los parámetros no concuerdan 
--** con como declarados en el procedimiento.

--6o. crear_depart('COMPRAS', 'VALENCIA');
--** Al igual que en 5o, esta llamada no es correcta, porque al contrario que en el 4o, el orden del tipo de datos de los parámetros
--** no concuerdan con como declarados en el procedimiento.

--7o. crear_depart(50, 'COMPRAS', 'VALENCIA');
--** Esta llamada si es correcta, porque los parámetros están bien introducidos tal y como pone en el procedimiento.

--8o. crear_depart('COMPRAS', 50, 'VALENCIA');
--** Al contrario que en el 7o esta llamada no es correcta, porque los parámetros no están bien introducidos
--** tal y como pone en el procedimiento.

--9o. crear_depart('VALENCIA', ‘COMPRAS’);
--** Al igual que en 6o y 5o, esta llamada no es correcta, porque al contrario que en el 4o, el orden del tipo de datos
--** de los parámetros no concuerdan  con como declarados en el procedimiento.

--10o. crear_depart('VALENCIA', 50);
--** Esta llamada no es correcta, porque al igual que en el 5o y al contrario que en el 4o, el orden del tipo de datos
--** de los parámetros no concuerdan con como declarados en el procedimiento.

--*** EXTRA ***: Finalmente en clase, hemos visto que todas estaban mal porque ninguna llevaba el call. Y me acabo de dar
--               Cuenta de que le lenguaje tampoco está declarado


--5. Codificar un procedimiento que reciba una lista de hasta 5 números y visualice su suma.
CREATE OR REPLACE PROCEDURE suma_lista(
    n1 INTEGER DEFAULT 0,
    n2 INTEGER DEFAULT 0,
    n3 INTEGER DEFAULT 0,
    n4 INTEGER DEFAULT 0,
    n5 INTEGER DEFAULT 0)
    LANGUAGE plpgsql AS $$
DECLARE
    suma INTEGER := n1+n2+n3+n4+n5;
BEGIN
    RAISE NOTICE 'La suma de esos numeros es %', suma;
END;
$$;

--6. Realizar los siguientes procedimientos y funciones sobre la base de datos de jardinería:

--6.1. Función: calcular_precio_total_pedido
-- Descripción: Dado un código de pedido la función debe calcular la suma total del
-- pedido. Tenga en cuenta que un pedido puede contener varios productos diferentes y
-- varias cantidades de cada producto.
-- Parámetros de entrada: codigo_pedido (INT)
-- Salida: el precio total del pedido (FLOAT)
CREATE OR REPLACE FUNCTION calcular_precio_total_pedido(codigo INTEGER)
    RETURNS FLOAT AS $$
DECLARE
    precio_total FLOAT := 0;
BEGIN
    SELECT DISTINCT SUM(producto.precio_venta * detalle_pedido.cantidad) FROM detalle_pedido INTO precio_total
        INNER JOIN producto ON detalle_pedido.codigo_producto = producto.codigo_producto
            WHERE detalle_pedido.codigo_pedido= codigo;
    
    RETURN precio_total;
END;
$$ LANGUAGE plpgsql;


--6.2. Función: calcular_suma_pedidos_cliente
-- Descripción: Dado un código de cliente la función debe calcular la suma total de todos
-- los pedidos realizados por el cliente. Deberá hacer uso de la función
-- calcular_precio_total_pedido que ha desarrollado en el apartado anterior.
-- Parámetros de entrada: codigo_cliente (INT)
-- Salida: La suma total de todos los pedidos del cliente (FLOAT)
CREATE OR REPLACE FUNCTION calcular_suma_pedidos_cliente(codigo INTEGER)
    RETURNS FLOAT AS $$
DECLARE 
    suma_total FLOAT;
BEGIN
    SELECT SUM(calcular_precio_total_pedido(codigo_pedido)) INTO suma_total FROM pedido
            WHERE pedido.codigo_cliente = codigo;

    RETURN suma_total;
END;
$$ LANGUAGE plpgsql;

--6.3: Función: calcular_suma_pagos_cliente
-- Descripción: Dado un código de cliente la función debe calcular la suma total de los
-- pagos realizados por ese cliente.
-- Parámetros de entrada: codigo_cliente (INT)
-- Salida: la suma total de todos los pagos del cliente (FLOAT)
CREATE OR REPLACE FUNCTION calcular_suma_pagos_cliente(codigo INTEGER)
    RETURNS FLOAT AS $$
DECLARE
    suma_total FLOAT := 0;
BEGIN
    SELECT DISTINCT SUM(codigo_cliente* total) FROM pago INTO suma_total
        WHERE pago.codigo_cliente= codigo;

    RETURN suma_total;
END;
$$ LANGUAGE plpgsql;


--6.4: Procedimiento: calcular_pagos_pendientes
-- Descripción: Deberá calcular los pagos pendientes de todos los clientes. Para saber si un
-- cliente tiene algún pago pendiente deberemos calcular cuál es la cantidad de todos los
-- pedidos y los pagos que ha realizado. Si la cantidad de los pedidos es mayor que la de
-- los pagos entonces ese cliente tiene pagos pendientes.
-- Deberá insertar en una tabla llamada clientes_con_pagos_pendientes los siguientes
-- datos: id_cliente, suma_total_pedidos, suma_total_pagos, pendiente_de_pago (si la tabla
-- no existe se debe crear)

CREATE OR REPLACE PROCEDURE calcular_pagos_pendientes()
    LANGUAGE plpgsql AS $$
DECLARE 
    num_clientes INTEGER;
    i INTEGER;
    num_pedidos INTEGER := 0;
    num_pagos INTEGER := 0;
BEGIN
    CREATE TABLE IF NOT EXISTS clientes_con_pagos_pendientes(
        id_cliente INTEGER,
        num_pedidos INTEGER,
        num_pagos INTEGER,
        pendiente_de_pago INTEGER
    );

    SELECT DISTINCT codigo_cliente FROM cliente INTO num_clientes;

    FOR i in 1..num_clientes LOOP
        SELECT DISTINCT count(codigo_cliente) FROM pago WHERE codigo_cliente = i INTO num_pagos;
        SELECT DISTINCT count(codigo_cliente) FROM pedido WHERE codigo_cliente = i INTO num_pedidos;
            INSERT INTO clientes_con_pagos_pendientes(
                id_cliente,
                num_pedidos,
                num_pagos,
                pendiente_de_pago
            ) VALUES(
                i, 
                num_pedidos, 
                num_pagos, 
                (num_pedidos-num_pagos)
            );
    END LOOP;
END;
$$;

-- EJEMPLO DE USO
CALL calcular_pagos_pendientes();
SELECT * FROM clientes_con_pagos_pendientes;


--7. Escribir un procedimiento que modifique la localidad de una oficina de la base de datos de
--jardinería. El procedimiento recibirá como parámetros el número y la localidad nueva.
CREATE OR REPLACE PROCEDURE modificar_localidad_oficina(
    numero_oficina VARCHAR,
    nueva_localidad VARCHAR)
    LANGUAGE plpgsql AS $$
DECLARE
    numero VARCHAR := numero_oficina;
    n_localidad VARCHAR := nueva_localidad;
BEGIN
    UPDATE oficina
    SET ciudad= n_localidad
    WHERE codigo_oficina = numero;
END;
$$;

--Ejemplo de uso
CALL modificar_localidad_oficina('BCN-ES', 'Granada');
SELECT * FROM oficina;

--8. En la base de datos de departamentos, empleados y proyectos, codificar un procedimiento
--que reciba como parámetros un número de departamento, un importe y un porcentaje; y suba
--el salario a todos los empleados del departamento indicado en la llamada. La subida será el
--porcentaje o el importe indicado en la llamada (el que sea más beneficioso para el empleado
--en cada caso empleado).
CREATE OR REPLACE PROCEDURE aumentar_salario(
    num_departamento INTEGER,
    importe FLOAT,
    porcentaje FLOAT)
    LANGUAGE plpgsql AS $$
DECLARE
    id_empleado INTEGER;
    salario INTEGER;
BEGIN
    FOR id_empleado IN 
        SELECT employee_id FROM employees 
        INNER JOIN departments ON employees.department_id= departments.department_id WHERE departments.department_id= num_departamento
    LOOP
        SELECT employees.salary FROM employees WHERE employee_id= id_empleado INTO salario;

        IF  
            importe > (salario + (salario * (porcentaje/100))) 
        OR
            --Probando me he dado cuenta que si el valor es nulo la condicion anterior no sirve por eso la añado esta linea de codigo
            (SELECT employees.salary FROM employees WHERE employee_id= id_empleado) IS NULL
        THEN
            UPDATE employees SET salary = importe WHERE employees.employee_id= id_empleado;
        ELSE
            UPDATE employees SET salary =  (salario + (salario * (porcentaje/100))) WHERE employees.employee_id= id_empleado;
        END IF;
    END LOOP;
END;
$$;

-------------------------------
-- CODIGO PARA HACER PRUEBAS --
-------------------------------
call aumentar_salario(2, 1000, 10);
SELECT employee_id, first_name, last_name, department_id, salary FROM employees;

--9. En la misma base de datos del ejercicio anterior, escribir un procedimiento que suba el
--sueldo de todos los empleados que ganen menos que el salario medio de su oficina. La subida
--será del 50% de la diferencia entre el salario del empleado y la media de su oficio. Se deberá
--asegurar que la transacción no se quede a medias, y se gestionarán los posibles errores.

--En mi caso lo he había hecho con la base de datos de departamentos en vez de la que se suponia
--que habia que usar. Sin embargo, pregunté en clase y se me dijo que no había problema.

CREATE OR REPLACE PROCEDURE aumentar_salario_media(num_departamento INTEGER)
    LANGUAGE plpgsql AS $$
DECLARE
    id_empleado INTEGER;
    salario_medio INTEGER;
    salario INTEGER;
BEGIN
    SELECT sum(salary)/count(employee_id) FROM employees WHERE department_id = num_departamento INTO salario_medio; 
    RAISE NOTICE '%', salario_medio;
    FOR id_empleado IN 
        SELECT employee_id FROM employees 
        INNER JOIN departments ON employees.department_id= departments.department_id WHERE departments.department_id= num_departamento
    LOOP
        SELECT salary FROM employees WHERE employee_id = id_empleado INTO salario;
        IF  
            salario < salario_medio
        OR
            --Probando me he dado cuenta que si el valor es nulo la condicion anterior no sirve por eso la añado esta linea de codigo
            salario IS NULL
        THEN
            UPDATE employees SET salary = salario + ((salario_medio - salario)*0.5) WHERE employee_id= id_empleado;
        END IF;
    END LOOP;
END;
$$;

-------------------------------
-- CODIGO PARA HACER PRUEBAS --
-------------------------------
CALL aumentar_salario_media(2);
SELECT employee_id, first_name, last_name, department_id, salary FROM employees;

--10. Escribir un disparador en la base de datos de los ejercicios anteriores que haga fallar
--cualquier operación de modificación del apellido o del número de un empleado, o que
--suponga una subida de sueldo superior al 10%.
CREATE OR REPLACE FUNCTION impedir_modificacion()
    RETURNS TRIGGER AS $$
BEGIN
    IF(TG_OP = 'UPDATE') THEN
        IF(NEW.salary > (OLD.salary*1.1)) THEN
            RAISE EXCEPTION 'Una subida de salario mayor al 10 por ciento no esta permitida';
        END IF;
        IF(NEW.first_name <> OLD.last_name OR NEW.last_name <> OLD.last_name) THEN
            RAISE EXCEPTION 'No esta permitido modificar el nombre o apellido de un empleado';
        END IF;
    END IF; 
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_impedir_modificacion BEFORE UPDATE ON employees FOR EACH ROW
    EXECUTE FUNCTION impedir_modificacion();

--11. Cambiar la solución del ejercicio anterior para permitir la eliminación físicamente del
--registro de la tabla empleados pero guardar una copia del registro eliminado en una tabla
--llamada ex_empleados, guardando también en esa tabla la fecha de la baja.
CREATE OR REPLACE FUNCTION eliminar_empleado()
    RETURNS TRIGGER AS $$
BEGIN

    CREATE TABLE IF NOT EXISTS ex_empleados(
      employee_id   NUMERIC(8),
      first_name    VARCHAR(30),
      last_name    VARCHAR(30),
      birthdate    DATE,
      address   VARCHAR(50),
      gender    CHAR,
      salary    NUMERIC,
      supervisor_id   NUMERIC(8),
      department_id   NUMERIC(8),
      fecha_baja   DATE,
      PRIMARY KEY (employee_id)
    );


    IF(TG_OP = 'DELETE') THEN
        INSERT INTO ex_empleados(
            employee_id,
            first_name,
            last_name,
            birthdate,
            address,
            gender,
            salary,
            supervisor_id,
            department_id,
            fecha_baja
        ) VALUES (
            OLD.employee_id,
            OLD.first_name,
            OLD.last_name,
            OLD.birthdate,
            OLD.address,
            OLD.gender,
            OLD.salary,
            OLD.supervisor_id,
            OLD.department_id,
            NOW()
        );
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_eliminar_empleado BEFORE DELETE ON employees FOR EACH ROW
    EXECUTE FUNCTION eliminar_empleado();

-------------------------------
-- CODIGO PARA HACER PRUEBAS --
-------------------------------
UPDATE departments SET manager_id = NULL WHERE manager_id = 11111111;
UPDATE works_in SET employee_id = 22222222 WHERE employee_id = 11111111;

DELETE FROM employees WHERE employee_id= 11111111;

--12.En la base de datos de jardinería, queremos que no se puedan eliminar físicamente los
-- pedidos. Por tanto, en vez de eliminarlos, se marcarán como baja. Para ello debemos añadir
-- a la tabla de pedidos un campo baja que contendrá un valor lógico TRUE o FALSE (no
-- podrá contener ningún otro valor). Por defecto estará puesto a FALSE (no se ha borrado) y
-- cuando se intente borrar el pedido, en vez de borrar el pedido se cambiará el valor de este
-- campo.
ALTER TABLE pedido ADD COLUMN baja boolean;
UPDATE pedido SET baja = false;

select codigo_pedido, estado, codigo_cliente, baja from pedido ORDER BY codigo_pedido ASC;

CREATE OR REPLACE FUNCTION eliminar_pedido()
    RETURNS TRIGGER AS $$
BEGIN
    UPDATE pedido SET baja = TRUE WHERE codigo_pedido = OLD.codigo_pedido;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_eliminar_pedido BEFORE DELETE ON pedido FOR EACH ROW
    EXECUTE FUNCTION eliminar_pedido();

DELETE FROM pedido WHERE codigo_pedido= 1;

--13. Queremos que se guarde en una tabla altas_empleados el historial de inserciones de registros
--realizadas en la tabla empleados, además de los datos del empleado se deberá guardar en la
--tabla el usuario que realizó la inserción del empleado y la fecha/hora de la operación. La
--primera vez que se ejecute el disparador deberá crear la tabla si no existe y rellenarla con los
--empleados que contenga la base de datos en ese momento.
CREATE OR REPLACE FUNCTION alta_empleado()
    RETURNS TRIGGER AS $$
DECLARE
    existe_tabla boolean := false;
    i INTEGER;
BEGIN
    existe_tabla := EXISTS(SELECT 1 FROM pg_tables WHERE tablename = 'altas_empleados');

    CREATE TABLE IF NOT EXISTS altas_empleados(
        employee_id   NUMERIC(8),
        first_name    VARCHAR(30),
        last_name    VARCHAR(30),
        birthdate    DATE,
        address   VARCHAR(50),
        gender    CHAR,
        salary    NUMERIC,
        supervisor_id   NUMERIC(8),
        department_id   NUMERIC(8),
        user_name       VARCHAR(25),
        fecha_operacion VARCHAR,
        PRIMARY KEY (employee_id)
    );

    IF existe_tabla THEN       
            INSERT INTO altas_empleados(
                employee_id,
                first_name,
                last_name,
                birthdate,
                address,
                gender,
                salary,
                supervisor_id,
                department_id,
                user_name,
                fecha_operacion
            ) VALUES(
                NEW.employee_id,
                NEW.first_name,
                NEW.last_name,
                NEW.birthdate,
                NEW.address,
                NEW.gender,
                NEW.salary,
                NEW.supervisor_id,
                NEW.department_id,
                current_user,
                TO_CHAR(NOW(), 'DD/MM/YYYY HH:MI:SS')
            );  
    ELSE
--COMO LA TABLA ESTA VACIA INTRODUZCO LOS EMPLEADOS EXISTENTES
            INSERT INTO altas_empleados(
                employee_id,
                first_name,
                last_name,
                birthdate,
                address,
                gender,
                salary,
                supervisor_id,
                department_id,
                user_name,
                fecha_operacion
            ) SELECT *, current_user, TO_CHAR(NOW(), 'DD/MM/YYYY HH:MI:SS') FROM employees;

--AHORA INSERTO EL NUEVO EMPLEADO
            INSERT INTO altas_empleados(
                employee_id,
                first_name,
                last_name,
                birthdate,
                address,
                gender,
                salary,
                supervisor_id,
                department_id,
                user_name,
                fecha_operacion
            ) VALUES (
                NEW.employee_id,
                NEW.first_name,
                NEW.last_name,
                NEW.birthdate,
                NEW.address,
                NEW.gender,
                NEW.salary,
                NEW.supervisor_id,
                NEW.department_id,
                current_user,
                TO_CHAR(NOW(), 'DD/MM/YYYY HH:MI:SS')
            ); 
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_alta_empleado BEFORE INSERT ON employees FOR EACH ROW
    EXECUTE FUNCTION alta_empleado();

-------------------------------
-- CODIGO PARA HACER PRUEBAS --
-------------------------------
INSERT INTO employees(                
                employee_id,
                first_name,
                last_name,
                birthdate,
                address,
                gender,
                salary,
                supervisor_id,
                department_id)
        VALUES (
            888,
            'ignacio',
            'perex',
            '2020-10-09',
            'calle colon',
            'M',
            1500,
            11111111,
            2
        );

--14. Hacer que se actualicen automáticamente las existencias de los productos cuando se inserte
--un nuevo pedido o cuando se rectifique la cantidad de uno existente. Se supone que un
--pedido produce una reducción del stock (existencias) del producto.

-- Comentarios antes de empezar:
-- Tras analizar lo que se nos pide, he llegado a la conclusión de que:
--    Hay que actualizar el stock cuando los detalle_pedido asociados a un pedido sufran
--    un UPDATE, se cree uno nuevo mediante un INSERT o se elimine un registro con DELETE 
--    por lo que la tabla detalle_pedido tendrá tres triggers asociados.
--
--    ¿Por que la tabla pedido no tiene trigger?
--    La tabla pedido no tiene triggers porque la cantidad en stock de un producto no esta
--    asociada con pedido sino con detalle_pedido. Además, si quisieramos eliminar un pedido
--    primero deberiamos eliminar todos sus detalle_pedido asociados por lo que ni en caso de
--    DELETE la tabla pedido modificaria directamente el stock.

--Creo la funcion de los triggers para la tabla detalle_pedido
CREATE OR REPLACE FUNCTION actualizar_stock()
    RETURNS TRIGGER AS $$
DECLARE
    stock_actual INTEGER;
BEGIN

    IF(TG_OP = 'INSERT') THEN
            -- PRIMERO ASIGNO VARIABLES
            SELECT cantidad_en_stock FROM producto 
                WHERE codigo_producto= NEW.codigo_producto 
            INTO stock_actual;

            IF 
                stock_actual - NEW.cantidad <= 0
            THEN
                RAISE EXCEPTION 'No hay suficiente stock para realizar el pedido';
            ELSE
                UPDATE producto SET cantidad_en_stock = (stock_actual - NEW.cantidad) WHERE codigo_producto = NEW.codigo_producto;
            END IF;
    ELSIF(TG_OP = 'UPDATE') THEN
                --Al principio quise iterar sobre los codigo de producto de cada detalle pedido pero me di 
                --cuenta que cuando realizas un update se realiza sobre cada clave primaria por lo que un 
                --bucle no es necesario
                SELECT cantidad_en_stock FROM producto 
                    WHERE codigo_producto= NEW.codigo_producto 
                INTO stock_actual;

                IF 
                    (stock_actual+OLD.cantidad)-NEW.cantidad<=0
                THEN
                    RAISE EXCEPTION 'No hay suficiente stock para realizar la modificacion';
                ELSE
                    UPDATE producto SET cantidad_en_stock = ((stock_actual+OLD.cantidad)-NEW.cantidad) WHERE codigo_producto = NEW.codigo_producto;
                END IF;
    ELSIF(TG_OP= 'DELETE') THEN
                SELECT cantidad_en_stock FROM producto 
                    WHERE codigo_producto= OLD.codigo_producto
                INTO stock_actual;

                UPDATE producto SET cantidad_en_stock = stock_actual + OLD.cantidad WHERE codigo_producto = OLD.codigo_producto;

    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_insertar_stock AFTER INSERT ON detalle_pedido FOR EACH ROW
    EXECUTE FUNCTION actualizar_stock();

CREATE TRIGGER tr_actualizar_stock AFTER UPDATE ON detalle_pedido FOR EACH ROW
    EXECUTE FUNCTION actualizar_stock();

CREATE TRIGGER tr_reestrablecer_stock AFTER DELETE ON detalle_pedido FOR EACH ROW
    EXECUTE FUNCTION actualizar_stock();


-------------------------------
-- CODIGO PARA HACER PRUEBAS --
-------------------------------
INSERT INTO pedido(
  codigo_pedido,
  fecha_pedido,
  fecha_esperada,
  fecha_entrega,
  estado,
  comentarios,
  codigo_cliente
) VALUES(
    888,
    NOW(),
    NOW(),
    NOW(),
    'ESTADO CORRECTO',
    'UN COMENTARIO',
    1
);

Select * from detalle_pedido where codigo_pedido= 888;

INSERT INTO detalle_pedido(
  codigo_pedido,
  codigo_producto,
  cantidad,
  precio_unidad,
  numero_linea
) VALUES(
    888,
    'AR-001',
    20,
    500,
    1
);

INSERT INTO detalle_pedido(
  codigo_pedido,
  codigo_producto,
  cantidad,
  precio_unidad,
  numero_linea
) VALUES(
    888,
    'AR-002',
    30,
    500,
    1
);

UPDATE detalle_pedido SET cantidad = 10 WHERE codigo_pedido= 888 AND codigo_producto='AR-001';

--visualizar cantidad de producto antes de añadir el detalle_pedido
Select * from detalle_pedido where codigo_pedido= 888;

select codigo_producto, cantidad_en_stock from producto where codigo_producto = 'AR-003';

DELETE FROM detalle_pedido WHERE codigo_pedido= 888;