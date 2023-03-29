/* ****************************************************/
/*       EJERCICIOS CON USUARIOS ROLES Y PERMISOS     */
/* ****************************************************/

--publicidad
CREATE ROLE publicidad WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;

GRANT DELETE, UPDATE, INSERT, SELECT ON TABLE public.producto TO publicidad;
GRANT DELETE, UPDATE, INSERT, SELECT ON TABLE public.gama_producto TO publicidad;
GRANT DELETE, UPDATE, INSERT, SELECT ON TABLE public.cliente TO publicidad;

--comercial
CREATE ROLE comercial WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;

GRANT UPDATE, SELECT ON TABLE public.pedido TO comercial;
GRANT SELECT, UPDATE ON TABLE public.cliente TO comercial;
GRANT UPDATE, SELECT ON TABLE public.pago TO comercial;
GRANT SELECT, UPDATE ON TABLE public.producto TO comercial;

--Tienda en linea
CREATE ROLE "tiendaEnLinea" WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;

GRANT UPDATE, INSERT, SELECT ON TABLE public.cliente TO "tiendaEnLinea";
GRANT SELECT, INSERT ON TABLE public.pago TO "tiendaEnLinea";
GRANT SELECT, INSERT, UPDATE ON TABLE public.pedido TO "tiendaEnLinea";


--Recursos humanos
CREATE ROLE "recursosHumanos" WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE public.empleado TO "recursosHumanos";
GRANT SELECT ON TABLE public.oficina to "recursosHumanos";
GRANT UPDATE (telefono,linea_direccion1,linea_direccion2) ON TABLE public.oficina TO "recursosHumanos";

--administracion
CREATE ROLE administracion WITH
    NOLOGIN
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    INHERIT
    NOREPLICATION
    CONNECTION LIMIT -1;

GRANT ALL ON ALL TABLES IN SCHEMA public TO administracion;

-- Crea un usuario para 3 de los departamentos anteriores y comprueba sus permisos --

CREATE USER directorEjecutivo WITH PASSWORD 'Admin73#@';
GRANT administracion TO directorEjecutivo;
\du

--como \du solo nos muestra que directorEjecutivo pertenece al rol administracion
--si queremos ver los privilegios que tiene el rol debemos usar la siguiente consulta:
SELECT * FROM information_schema.role_table_grants
    WHERE grantee = 'administracion';



CREATE USER directorComercial WITH PASSWORD 'Com37%&';
GRANT comercial TO directorComercial;
\du

--como \du solo nos muestra que directorComercial pertenece al rol comercial
--si queremos ver los privilegios que tiene el rol debemos usar la siguiente consulta:
SELECT * FROM information_schema.role_table_grants
    WHERE grantee = 'comercial';



CREATE USER empleado1 WITH PASSWORD 'Emp1@$';
GRANT "tiendaEnLinea" TO empleado1;
\du

--como \du solo nos muestra que empleado1 pertenece al rol tiendaEnLinea
--si queremos ver los privilegios que tiene el rol debemos usar la siguiente consulta:
SELECT * FROM information_schema.role_table_grants
    WHERE grantee = 'tiendaEnLinea';



--- EJERCICIOS CON VISTAS ---
/* ************************/
/*        BLOQUE C        */
/* ************************/

        --Esta vista se la daría a recursos humanos y a administración pues contiene datos sobre los
        --empleados que son jefes y que a departamentos como tienda en linea no deberían acceder.

-- 3. Listado de nombre, apellidos, puesto y correo electrónico de los empleados que son jefes
CREATE VIEW mostrar_jefes AS (
    SELECT DISTINCT jefe.nombre, jefe.apellido1, jefe.apellido2, jefe.puesto, jefe.email FROM empleado
        INNER JOIN empleado AS jefe ON jefe.codigo_empleado= empleado.codigo_jefe
);



        --Esta vista se la daría a recursos humanos y a administración pues contiene datos personales sobre los
        --empleados.

-- 6. Listado con el nombre y apellidos de los empleados que trabajan en Barcelona
CREATE VIEW empleados_barcelona AS(
    SELECT nombre FROM empleado
        INNER JOIN oficina ON oficina.codigo_oficina= empleado.codigo_oficina
            WHERE upper(oficina.region) = 'BARCELONA'
);




        --Esta vista se la daría al departamento comercial y administración, 
        --porque contiene datos importantes sobre clientes y pagos.

--10. . Listado con el nombre de los clientes que hayan realizado pagos junto con el nombre
--completo (en una sola columna) de sus representantes de ventas
    --INNER JOIN para que me de los que han realizado pagos directamente
    CREATE VIEW paying_customers AS (
        SELECT nombre_cliente, nombre_contacto, apellido_contacto FROM cliente
            INNER JOIN pago ON cliente.codigo_cliente= pago.codigo_cliente
);



        --Esta vista se la daría al departamento comercial, tienda online y administración,
        --porque contiene datos que los tres departamentos podrían observar sin comprometer la 
        --seguridad.

--12. Listado con el número de pedido, el nombre del cliente, la fecha de entrega y la fecha
--requerida de los pedidos que no han sido entregados a tiempo

--con fecha requerida he supuesto que se trata de fecha esperada
CREATE VIEW pedidos_retrasados AS(
    SELECT pedido.codigo_pedido, cliente.codigo_cliente, cliente.nombre_cliente, pedido.fecha_esperada, pedido.fecha_entrega FROM pedido
        INNER JOIN cliente ON pedido.codigo_cliente= cliente.codigo_cliente
            WHERE fecha_esperada<fecha_entrega
);



        --Esta vista se la daría al departamento comercial y administración,
        --porque por ejemplo no creo que nos interese que el departamento tienda
        --en linea pueda ver el total que ha pagado un cliente sino que es una información 
        --un poco más confidencial que solo debería ver comercial y administración.

--15. Listado con el nombre de cada cliente (en un campo) y lo que ha pagado cada uno
CREATE VIEW pagos_clientes AS(
    SELECT cliente.nombre_cliente, sum(pago.total) FROM cliente 
        INNER JOIN pago ON cliente.codigo_cliente=pago.codigo_cliente
            GROUP BY cliente.nombre_cliente
);



        --Esta vista se la daría al departamento comercial y administración porque son datos
        --básicos a los que deberían ser capaces de acceder y además se lo daría a los departamentos
        --tienda online y publicidad pues esta información podría serles útil para hacer algun trabajo
        --y no creo que suponga comprometer la seguridad

--18. Crear una vista que muestre las 5 gamas de productos más vendidas en orden
CREATE VIEW gamas_mas_vendidas AS(
    SELECT producto.gama FROM producto
        INNER JOIN detalle_pedido ON detalle_pedido.codigo_producto= producto.codigo_producto
            GROUP BY gama
                ORDER BY sum(cantidad) DESC
                    LIMIT 5
);




        --Esta vista se la daría a administración pues contiene importantes datos sobre pagos y paises que 
        --no nos interesa que lo vea mucha gente pues podrían aprovecharse de ellos y quitarnos cuota de mercado

--19. Crear una vista en la que se desglose la cantidad de pedidos, clientes, y total facturado por
--países, ordenado por la última cifra

--por ultima cifra entiendo que se refiere al total facturado
CREATE VIEW informacion_pais AS(
    SELECT cliente.pais, 
            count(DISTINCT(pedido.codigo_pedido)) AS total_pedidos, 
            count(DISTINCT(cliente.codigo_cliente)) AS total_clientes, 
            sum(DISTINCT(pago.total)) AS total_facturado FROM cliente
        LEFT JOIN pedido ON pedido.codigo_cliente=  cliente.codigo_cliente
        LEFT JOIN pago ON pago.codigo_cliente= cliente.codigo_cliente
            GROUP BY pais
                ORDER BY 4
);