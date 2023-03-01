DROP DATABASE IF EXISTS tienda;
CREATE DATABASE tienda WITH ENCODING 'UNICODE';
\c tienda;

CREATE TABLE fabricante (
  codigo_fabricante NUMERIC(2),
  nombre VARCHAR(100) NOT NULL,
  PRIMARY KEY (codigo_fabricante)
);

CREATE TABLE producto (
  codigo_producto NUMERIC(2),
  nombre VARCHAR(100) NOT NULL,
  precio NUMERIC NOT NULL,
  codigo_fabricante NUMERIC(5) NOT NULL,
  PRIMARY KEY (codigo_producto),
  FOREIGN KEY (codigo_fabricante) 
    REFERENCES fabricante(codigo_fabricante)
);

INSERT INTO fabricante VALUES(1, 'Asus');
INSERT INTO fabricante VALUES(2, 'Lenovo');
INSERT INTO fabricante VALUES(3, 'Hewlett-Packardy');
INSERT INTO fabricante VALUES(4, 'Samsung');
INSERT INTO fabricante VALUES(5, 'Seagate');
INSERT INTO fabricante VALUES(6, 'Crucial');
INSERT INTO fabricante VALUES(7, 'Gigabyte');
INSERT INTO fabricante VALUES(8, 'Huawei');
INSERT INTO fabricante VALUES(9, 'Xiaomi');
INSERT INTO producto VALUES(1, 'Disco duro SATA3 1TB', 86.19, 5);
INSERT INTO producto VALUES(2, 'Memoria RAM DDR4 8GB', 120, 6);
INSERT INTO producto VALUES(3, 'Disco SSD 1 TB', 150.99, 4);
INSERT INTO producto VALUES(4, 'GeForce GTX 1050Ti', 185, 7);
INSERT INTO producto VALUES(5, 'GeForce GTX 1080 Xtreme', 755, 6);
INSERT INTO producto VALUES(6, 'Monitor 24 LED Full HD', 202, 1);
INSERT INTO producto VALUES(7, 'Monitor 27 LED Full HD', 245.99, 1);
INSERT INTO producto VALUES(8, 'Portátil Yoga 520', 559, 2);
INSERT INTO producto VALUES(9, 'Portátil Ideapd 320', 444, 2);
INSERT INTO producto VALUES(10, 'Impresora HP Deskjet 3720', 59.99, 3);
INSERT INTO producto VALUES(11, 'Impresora HP Laserjet Pro M26nw', 180, 3);


/* ************************************** */
/*        CONSULTAS SOBRE UNA TABLA       */
/* ************************************** */


--1. Lista el nombre de todos los productos que hay en la tabla producto.
SELECT nombre FROM producto;

--2. Lista los nombres y los precios de todos los productos de la tabla producto.ç
SELECT nombre, precio FROM producto;

--3. Lista todas las columnas de la tabla producto.
SELECT * FROM producto;

--4. Lista el nombre de los productos, el precio en euros y el precio en dólares estadounidenses (USD).
SELECT nombre, precio, precio*0.98 AS precio_en_dollares FROM producto;

--5.Lista el nombre de los productos, el precio en euros y el precio en dólares estadounidenses (USD). Utiliza
--los siguientes alias para las columnas: nombre de producto, euros, dólares.
SELECT nombre AS nombre_de_producto, precio AS precio_en_euros, precio*0.98 AS precio_en_dollares FROM producto;

--6. Lista los nombres y los precios de todos los productos de la tabla producto, convirtiendo los nombres a
--mayúscula.
SELECT upper(nombre), precio FROM producto;

--7. Lista los nombres y los precios de todos los productos de la tabla producto, convirtiendo los nombres a
--minúscula.
SELECT lower(nombre), precio FROM producto;

--8. Lista el nombre de todos los fabricantes en una columna, y en otra columna obtenga en mayúsculas los
--dos primeros caracteres del nombre del fabricante.
SELECT nombre, substring(nombre FROM 1 for 2) FROM fabricante;

--9. Lista los nombres y los precios de todos los productos de la tabla producto, redondeando el valor del
--precio.
SELECT nombre, round(precio) FROM producto;

--10. Lista los nombres y los precios de todos los productos de la tabla producto, truncando el valor del precio
--para mostrarlo sin ninguna cifra decimal.
SELECT nombre, trunc(precio) FROM producto;

--11. Lista el código de los fabricantes que tienen productos en la tabla producto.
SELECT codigo_fabricante FROM producto;

--12. Lista el código de los fabricantes que tienen productos en la tabla producto, eliminando los códigos que
--aparecen repetidos.
SELECT DISTINCT codigo_fabricante FROM producto;

--13. Lista los nombres de los fabricantes ordenados de forma ascendente.
SELECT nombre FROM fabricante ORDER BY nombre;

--14. Lista los nombres de los fabricantes ordenados de forma descendente.
SELECT nombre FROM fabricante ORDER BY nombre DESC;

--15. Lista los nombres de los productos ordenados en primer lugar por el nombre de forma ascendente y en
--segundo lugar por el precio de forma descendente.
SELECT nombre, precio FROM producto ORDER BY nombre ASC;
SELECT nombre, precio FROM producto ORDER BY precio DESC;

--16. Devuelve una lista con las 5 primeras filas de la tabla fabricante.
SELECT * FROM fabricante LIMIT 5;

--17. Devuelve una lista con 2 filas a partir de la cuarta fila de la tabla fabricante. La cuarta fila también se
--debe incluir en la respuesta.
SELECT * FROM fabricante LIMIT 2 OFFSET 2;

--18.Lista el nombre y el precio del producto más barato. (Utilice solamente las cláusulas ORDER BY y LIMIT)
SELECT nombre, precio FROM producto ORDER BY precio LIMIT 1;

--19. Lista el nombre y el precio del producto más caro. (Utilice solamente las cláusulas ORDER BY y LIMIT)
SELECT nombre, precio FROM producto ORDER BY precio DESC LIMIT 1;

--20. Lista el nombre de todos los productos del fabricante cuyo código de fabricante es igual a 2.
SELECT nombre FROM producto WHERE codigo_fabricante= 2;

--21. Lista el nombre de los productos que tienen un precio menor o igual a 120€.
SELECT nombre, precio FROM producto WHERE precio<=120;

--22.Lista el nombre de los productos que tienen un precio mayor o igual a 400€.
SELECT nombre, precio FROM producto WHERE precio>=400;

--23. Lista el nombre de los productos que no tienen un precio mayor o igual a 400€.
SELECT nombre, precio FROM producto WHERE NOT precio >=400;

--24. Lista todos los productos que tengan un precio entre 80€ y 300€. Sin utilizar el operador BETWEEN.
SELECT nombre, precio FROM producto WHERE precio >=80 AND precio<=300;

--25. Lista todos los productos que tengan un precio entre 60€ y 200€. Utilizando el operador BETWEEN.
SELECT nombre, precio FROM producto WHERE precio BETWEEN 60 AND 200;

--26. Lista todos los productos que tengan un precio mayor que 200€ y que el código de fabricante sea igual a 6.
SELECT * FROM producto WHERE precio>200 AND codigo_fabricante=6;

--27. Lista todos los productos donde el código de fabricante sea 1, 3 o 5. Sin utilizar el operador IN
SELECT * FROM producto WHERE codigo_fabricante=1 OR codigo_fabricante=2 OR codigo_fabricante=3;

--28. Lista todos los productos donde el código de fabricante sea 1, 3 o 5. Utilizando el operador IN.
SELECT * FROM producto WHERE codigo_fabricante IN (1, 2, 3);

--29. Lista el nombre y el precio de los productos en céntimos (Habrá que multiplicar por 100 el valor del precio).
--Cree un alias para la columna que contiene el precio que se llame céntimos.
SELECT nombre, precio*100 AS centimos FROM producto;

--30. Lista los nombres de los fabricantes cuyo nombre empiece por la letra S.
SELECT nombre FROM fabricante WHERE upper(nombre) LIKE 'S%';

--31. Lista los nombres de los fabricantes cuyo nombre termine por la vocal e.
SELECT nombre FROM fabricante WHERE lower(nombre) LIKE '%e';

--32. Lista los nombres de los fabricantes cuyo nombre contenga el carácter w.
SELECT nombre FROM fabricante WHERE lower(nombre) LIKE '%w%';

--33. Lista los nombres de los fabricantes cuyo nombre sea de 4 caracteres.
SELECT nombre FROM fabricante WHERE lower(nombre) LIKE '____';

--34. Devuelve una lista con el nombre de todos los productos que contienen la cadena Portátil en el nombre.
SELECT nombre FROM fabricante WHERE lower(nombre) LIKE '%Portátil%';

--35. Devuelve una lista con el nombre de todos los productos que contienen la cadena Monitor en el nombre
--y tienen un precio inferior a 215 €.
SELECT nombre FROM fabricante WHERE lower(nombre) LIKE '%Monitor%' AND precio < 215;

--36. Lista el nombre y el precio de todos los productos que tengan un precio mayor o igual a 180€. Ordene
--el resultado en primer lugar por el precio (en orden descendente) y en segundo lugar por el nombre (en
--orden ascendente).
SELECT nombre, precio FROM producto WHERE precio>=180 ORDER BY precio DESC;
SELECT nombre, precio FROM producto WHERE precio>=180 ORDER BY nombre;


/* ****************************************************/
/*     CONSULTAS MULTI-TABLA COMPOSICION INTERNA      */
/* ****************************************************/

--1. Devuelve una lista con el nombre del producto, precio y nombre de fabricante de todos los productos de
--la base de datos.
SELECT producto.nombre, precio, fabricante.nombre FROM producto 
  INNER JOIN fabricante ON producto.codigo_fabricante= fabricante.codigo_fabricante;

--2. Devuelve una lista con el nombre del producto, precio y nombre de fabricante de todos los productos de
--la base de datos. Ordene el resultado por el nombre del fabricante, por orden alfabético.
SELECT producto.nombre, precio, fabricante.nombre FROM producto 
  INNER JOIN fabricante ON producto.codigo_fabricante= fabricante.codigo_fabricante
    ORDER BY fabricante.nombre ASC;

--3. Devuelve una lista con el código del producto, nombre del producto, código del fabricante y nombre del
--fabricante, de todos los productos de la base de datos.
SELECT pro.codigo_producto, pro.nombre, fab.codigo_fabricante, fab.nombre FROM producto AS pro
  INNER JOIN fabricante AS fab ON pro.codigo_fabricante= fab.codigo_fabricante;

--4. Devuelve el nombre del producto, su precio y el nombre de su fabricante, del producto más barato.
SELECT pro.nombre, pro.precio, fab.nombre FROM producto AS pro
  INNER JOIN fabricante AS fab ON pro.codigo_fabricante= fab.codigo_fabricante
    ORDER BY precio LIMIT 1;

--5. Devuelve el nombre del producto, su precio y el nombre de su fabricante, del producto más caro.
SELECT pro.nombre, pro.precio, fab.nombre FROM producto AS pro
  INNER JOIN fabricante AS fab ON pro.codigo_fabricante= fab.codigo_fabricante
    ORDER BY precio DESC LIMIT 1;

--6.Devuelve una lista de todos los productos del fabricante Lenovo.
SELECT * FROM producto AS prod INNER JOIN fabricante AS fab ON prod.codigo_fabricante=fab.codigo_fabricante
  WHERE fab.nombre= 'Lenovo';

--7. Devuelve una lista de todos los productos del fabricante Crucial que tengan un precio mayor que 200€.
SELECT * FROM producto AS prod INNER JOIN fabricante AS fab ON prod.codigo_fabricante=fab.codigo_fabricante
  WHERE fab.nombre= 'Crucial' AND prod.precio>200;

--8. Devuelve un listado con todos los productos de los fabricantes Asus, Hewlett-Packardy Seagate. Sin
--utilizar el operador IN.
SELECT * FROM producto AS prod INNER JOIN fabricante AS fab ON prod.codigo_fabricante=fab.codigo_fabricante
  WHERE fab.nombre= 'Crucial' OR fab.nombre='Asus' OR fab.nombre='Hewlett-Packardy';

--9. Devuelve un listado con todos los productos de los fabricantes Asus, Hewlett-Packardy Seagate. Uti-
--lizando el operador IN.
SELECT * FROM producto AS prod INNER JOIN fabricante AS fab ON prod.codigo_fabricante=fab.codigo_fabricante
  WHERE upper(fab.nombre) IN('CRUCIAL', 'ASUS', 'HEWLETT-PACKARDY');

--10. Devuelve un listado con el nombre y el precio de todos los productos de los fabricantes cuyo nombre
--termine por la vocal e.
SELECT prod.nombre, precio FROM producto AS prod INNER JOIN fabricante AS fab ON prod.codigo_fabricante= fab.codigo_fabricante
  WHERE upper(fab.nombre) LIKE '%E';

--11. Devuelve un listado con el nombre y el precio de todos los productos cuyo nombre de fabricante contenga
--el carácter w en su nombre.
SELECT prod.nombre, precio FROM producto AS prod INNER JOIN fabricante AS fab ON prod.codigo_fabricante= fab.codigo_fabricante
  WHERE upper(fab.nombre) LIKE '%W%';

--12. Devuelve un listado con el nombre de producto, precio y nombre de fabricante, de todos los productos
--que tengan un precio mayor o igual a 180€. Ordene el resultado en primer lugar por el precio (en orden
--descendente) y en segundo lugar por el nombre (en orden ascendente)
SELECT prod.nombre, precio FROM producto AS prod INNER JOIN fabricante AS fab ON prod.codigo_fabricante= fab.codigo_fabricante
  WHERE prod.precio>=180 ORDER BY precio DESC;

SELECT prod.nombre, precio FROM producto AS prod INNER JOIN fabricante AS fab ON prod.codigo_fabricante= fab.codigo_fabricante
  WHERE prod.precio>=180 ORDER BY prod.nombre DESC;

  
/* ****************************************************/
/*     CONSULTAS MULTI-TABLA COMPOSICION EXTERNA      */
/* ****************************************************/


--1. Devuelve un listado de todos los fabricantes que existen en la base de datos, junto con los productos que
--tiene cada uno de ellos. El listado deberá mostrar también aquellos fabricantes que no tienen productos
--asociados.
SELECT fab.nombre, prod.nombre, prod.codigo_producto FROM fabricante AS fab LEFT JOIN producto AS prod ON fab.codigo_fabricante=prod.codigo_fabricante; 

--2. Devuelve un listado donde sólo aparezcan aquellos fabricantes que no tienen ningún producto asociado.
SELECT fab.nombre, prod.nombre, prod.codigo_producto FROM fabricante AS fab LEFT JOIN producto AS prod ON prod.codigo_fabricante=fab.codigo_fabricante
  WHERE prod.codigo_fabricante IS NULL;

--3. ¿Pueden existir productos que no estén relacionados con un fabricante? Justifique su respuesta.
--Jamás puesto que un producto debe haber sido fabricado por alguien es esta pregunta es como decir ¿Quien surgio 
--antes el huevo o la gallina?

/* ****************************************************/
/*                  CONSULTAS RESUMEN                 */
/* ****************************************************/

--1. Calcula el número total de productos que hay en la tabla productos.
SELECT count(codigo_producto) FROM producto;

--2. Calcula el número total de fabricantes que hay en la tabla fabricante.
SELECT count(codigo_fabricante) FROM fabricante;

--3. Calcula el número de valores distintos de código de fabricante aparecen en la tabla productos.
SELECT count(DISTINCT codigo_fabricante) FROM producto;

--4. Calcula la media del precio de todos los productos.
SELECT avg(precio) FROM producto;

--5. Calcula el precio más barato de todos los productos.
SELECT min(precio) FROM producto;

--6. Calcula el precio más caro de todos los productos.
SELECT max(precio) FROM producto;

--7. Lista el nombre y el precio del producto más barato.
SELECT nombre, min(precio) FROM producto;

--8. Lista el nombre y el precio del producto más caro.
SELECT nombre, max(precio) FROM producto;

--9. Calcula la suma de los precios de todos los productos.
SELECT sum(precio) FROM producto;

--10. Calcula el número de productos que tiene el fabricante Asus.
SELECT count(codigo_producto) FROM producto INNER JOIN fabricante ON producto.codigo_fabricante=fabricante.codigo_fabricante
  WHERE upper(fabricante.nombre) LIKE 'ASUS';

--11. Calcula la media del precio de todos los productos del fabricante Asus.
SELECT avg(precio) FROM producto INNER JOIN fabricante ON producto.codigo_fabricante=fabricante.codigo_fabricante
  WHERE upper(fabricante.nombre) LIKE 'ASUS';

--12. Calcula el precio más barato de todos los productos del fabricante Asus.
SELECT min(precio) FROM producto INNER JOIN fabricante ON producto.codigo_fabricante=fabricante.codigo_fabricante
  WHERE upper(fabricante.nombre) LIKE 'ASUS';

--13. Calcula el precio más caro de todos los productos del fabricante Asus.
SELECT max(precio) FROM producto INNER JOIN fabricante ON producto.codigo_fabricante=fabricante.codigo_fabricante
  WHERE upper(fabricante.nombre) LIKE 'ASUS';

--14. Calcula la suma de todos los productos del fabricante Asus.
SELECT sum(precio) FROM producto INNER JOIN fabricante ON producto.codigo_fabricante=fabricante.codigo_fabricante
  WHERE upper(fabricante.nombre) LIKE 'ASUS';

--15. Muestra el precio máximo, precio mínimo, precio medio y el número total de productos que tiene el fa-
--bricante Crucial.
SELECT max(precio), min(precio), avg(precio), count(codigo_producto) FROM producto INNER JOIN fabricante ON producto.codigo_fabricante=fabricante.codigo_fabricante
  WHERE upper(fabricante.nombre) LIKE 'CRUCIAL';

--16. Muestra el número total de productos que tiene cada uno de los fabricantes. El listado también debe
--incluir los fabricantes que no tienen ningún producto. El resultado mostrará dos columnas, una con el
--nombre del fabricante y otra con el número de productos que tiene. Ordene el resultado descendente-
--mente por el número de productos.
SELECT count(codigo_producto), fabricante.nombre FROM producto INNER JOIN fabricante ON producto.codigo_fabricante=fabricante.codigo_fabricante
  GROUP BY fabricante.nombre;

--17. Muestra el precio máximo, precio mínimo y precio medio de los productos de cada uno de los fabricantes.
--El resultado mostrará el nombre del fabricante junto con los datos que se solicitan.
SELECT max(precio), min(precio), avg(precio), fabricante.nombre FROM producto INNER JOIN fabricante ON producto.codigo_fabricante=fabricante.codigo_fabricante
  GROUP BY fabricante.nombre;

--18. Muestra el precio máximo, precio mínimo, precio medio y el número total de productos de los fabricantes
--que tienen un precio medio superior a 200€. No es necesario mostrar el nombre del fabricante, con el
--código del fabricante es suficiente.
SELECT fabricante.codigo_fabricante, max(precio), min(precio), avg(precio), count(producto.codigo_fabricante) FROM fabricante 
  LEFT JOIN producto ON fabricante.codigo_fabricante= producto.codigo_fabricante
      GROUP BY fabricante.codigo_fabricante ORDER BY fabricante.codigo_fabricante;

--19. Muestra el nombre de cada fabricante, junto con el precio máximo, precio mínimo, precio medio y el
--número total de productos de los fabricantes que tienen un precio medio superior a 200€. Es necesario
--mostrar el nombre del fabricante.
SELECT fabricante.nombre, max(precio), min(precio), avg(precio), count(producto.codigo_fabricante) FROM fabricante 
  LEFT JOIN producto ON fabricante.codigo_fabricante= producto.codigo_fabricante
      GROUP BY fabricante.nombre HAVING avg(precio)>'200';

--20. Calcula el número de productos que tienen un precio mayor o igual a 180€.
SELECT count(nombre) FROM producto WHERE precio>='180';

--21. Calcula el número de productos que tiene cada fabricante con un precio mayor o igual a 180€.

-- SELECT fabricante.nombre, count(producto.codigo_producto) FROM fabricante
--   LEFT JOIN producto ON fabricante.codigo_fabricante= producto.codigo_fabricante
--       GROUP BY fabricante.codigo_fabricante
--         HAVING min(producto.precio)>=180 OR count(producto.codigo_fabricante)=0;

SELECT fabricante.nombre, count(CASE WHEN producto.precio >= 180 THEN fabricante.nombre ELSE NULL END) FROM fabricante
  LEFT JOIN producto ON fabricante.codigo_fabricante= producto.codigo_fabricante
      GROUP BY fabricante.codigo_fabricante
        HAVING min(producto.precio)>=180 OR count(producto.codigo_fabricante)=0;

--22. Lista el precio medio los productos de cada fabricante, mostrando solamente el código del fabricante.
SELECT fabricante.codigo_fabricante, avg(producto.precio) FROM fabricante
  LEFT JOIN producto ON fabricante.codigo_fabricante= producto.codigo_fabricante
    GROUP BY fabricante.codigo_fabricante ORDER BY fabricante.codigo_fabricante;

--23. Lista el precio medio los productos de cada fabricante, mostrando solamente el nombre del fabricante.
SELECT fabricante.nombre, avg(producto.precio) FROM fabricante
  LEFT JOIN producto ON fabricante.codigo_fabricante= producto.codigo_fabricante
    GROUP BY fabricante.nombre;

--24. Lista los nombres de los fabricantes cuyos productos tienen un precio medio mayor o igual a 150€.
SELECT fabricante.nombre FROM fabricante
  INNER JOIN producto ON fabricante.codigo_fabricante= producto.codigo_fabricante
    GROUP BY fabricante.nombre 
      HAVING avg(producto.precio)>=150;

--25. Devuelve un listado con los nombres de los fabricantes que tienen 2 o más productos.
SELECT fabricante.nombre, count(producto.codigo_fabricante) FROM fabricante
  INNER JOIN producto ON fabricante.codigo_fabricante= producto.codigo_fabricante
    GROUP BY fabricante.nombre
      HAVING count(producto.codigo_fabricante)>=2;

--26. Devuelve un listado con los nombres de los fabricantes y el número de productos que tiene cada uno con
--un precio superior o igual a 220 €. No es necesario mostrar el nombre de los fabricantes que no tienen
--productos que cumplan la condición.
SELECT fabricante.nombre, count(producto.codigo_fabricante) FROM fabricante 
  INNER JOIN producto ON fabricante.codigo_fabricante= producto.codigo_producto
    GROUP BY fabricante.nombre
      HAVING avg(producto.precio)>=220;

--27. Devuelve un listado con los nombres de los fabricantes y el número de productos que tiene cada uno con
--un precio superior o igual a 220 €. El listado debe mostrar el nombre de todos los fabricantes, es decir, si
--hay algún fabricante que no tiene productos con un precio superior o igual a 220€ deberá aparecer en el
--listado con un valor igual a 0 en el número de productos.
SELECT fabricante.codigo_fabricante, fabricante.nombre, count(CASE WHEN producto.precio>=180 THEN fabricante.nombre ELSE NULL END) FROM fabricante 
  INNER JOIN producto ON fabricante.codigo_fabricante= producto.codigo_fabricante
    GROUP BY fabricante.codigo_fabricante;

--28. Devuelve un listado con los nombres de los fabricantes donde la suma del precio de todos sus productos
--es superior a 1000 €.
SELECT fabricante.nombre, sum(producto.precio) FROM fabricante 
  INNER JOIN producto ON fabricante.codigo_fabricante= producto.codigo_fabricante
    GROUP BY fabricante.nombre
      HAVING sum(producto.precio)>'1000';

--29. Devuelve un listado con el nombre del producto más caro que tiene cada fabricante. El resultado debe
--tener tres columnas: nombre del producto, precio y nombre del fabricante. El resultado tiene que estar
--ordenado alfabéticamente de menor a mayor por el nombre del fabricante.
SELECT maximos.nombre, maximos.precio, fabricante.nombre FROM producto AS maximos
  LEFT JOIN producto AS mayores ON maximos.codigo_fabricante= mayores.codigo_fabricante AND maximos.precio<mayores.precio
    INNER JOIN fabricante ON maximos.codigo_fabricante= fabricante.codigo_fabricante
      WHERE mayores.precio IS NULL
        ORDER BY fabricante.nombre;

/* ****************************************************/
/*         SUBCONSULTAS (EN LA CLÁUSULA WHERE)        */
/* ****************************************************/

------ Con operadores básicos de comparación ------------

--1. Devuelve todos los productos del fabricante Lenovo. (Sin utilizar INNER JOIN).
SELECT producto.nombre FROM producto
  WHERE producto.codigo_fabricante= (
    SELECT fabricante.codigo_fabricante FROM fabricante
      WHERE fabricante.nombre='Lenovo');

--2. Devuelve todos los datos de los productos que tienen el mismo precio que el producto más caro del fa-
--bricante Lenovo. (Sin utilizar INNER JOIN).
SELECT * FROM producto
  WHERE producto.precio= (
    SELECT max(producto.precio) FROM producto
    WHERE producto.codigo_fabricante= (
      SELECT fabricante.codigo_fabricante FROM fabricante
        WHERE fabricante.nombre='Lenovo')
  );

--3. Lista el nombre del producto más caro del fabricante Lenovo.
SELECT producto.nombre FROM producto 
  WHERE producto.precio=(
    SELECT max(producto.precio) FROM producto
      WHERE producto.codigo_fabricante=(
        SELECT fabricante.codigo_fabricante FROM fabricante
          WHERE fabricante.nombre='Lenovo'
      )
  );

--4. Lista el nombre del producto más barato del fabricante Hewlett-Packard.
SELECT producto.nombre FROM producto
  WHERE producto.precio=(
    SELECT min(producto.precio) FROM producto
      WHERE producto.codigo_fabricante=(
        SELECT fabricante.codigo_fabricante FROM fabricante 
          WHERE fabricante.nombre='Hewlett-Packardy'
      )
  );

--5. Devuelve todos los productos de la base de datos que tienen un precio mayor o igual al producto más
--caro del fabricante Lenovo.
SELECT producto.nombre FROM producto
  WHERE producto.precio>= (
    SELECT max(producto.precio) FROM producto
      WHERE producto.codigo_fabricante= (
        SELECT fabricante.codigo_fabricante FROM fabricante
          WHERE fabricante.nombre= 'Lenovo'
      )
  );

--6. Lista todos los productos del fabricante Asus que tienen un precio superior al precio medio de todos sus
--productos.
SELECT producto.nombre FROM producto
  WHERE producto.precio>(
    SELECT avg(producto.precio) FROM producto
      WHERE producto.codigo_fabricante=(
        SELECT fabricante.codigo_fabricante FROM fabricante
          WHERE fabricante.nombre='Asus'
      )
  );

------ Con ALL Y ANY ------------

--8. Devuelve el producto más caro que existe en la tabla producto sin hacer uso de MAX, ORDER BY ni LIMIT.
SELECT p1.nombre FROM producto p1
  WHERE p1.precio >= ALL (
    SELECT p2.precio FROM producto p2
  );

--9. Devuelve el producto más barato que existe en la tabla producto sin hacer uso de MIN, ORDER BY ni
--LIMIT.
SELECT p1.nombre FROM producto p1
  WHERE p1.precio <= ALL (
    SELECT p2.precio FROM producto p2
  );

--10. Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando ALL o ANY).
SELECT fabricante.nombre FROM fabricante
  WHERE fabricante.codigo_fabricante= ANY(
    SELECT producto.codigo_fabricante FROM producto
  );

--11. Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando ALL o ANY).
SELECT fabricante.nombre FROM fabricante
  WHERE fabricante.codigo_fabricante!= ALL(
    SELECT producto.codigo_fabricante FROM producto
  );

------ Con IN y NOT IN ------------

--12. Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando IN o NOT IN).
SELECT fabricante.nombre FROM fabricante
    WHERE fabricante.codigo_fabricante IN (
      SELECT producto.codigo_fabricante FROM producto
    );

--13. Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando IN o NOT IN).
SELECT fabricante.nombre FROM fabricante
    WHERE fabricante.codigo_fabricante NOT IN (
      SELECT producto.codigo_fabricante FROM producto
    );

---- CON EXISTS Y NOT EXISTS -----

--14. Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando EXISTS o NOT
--EXISTS).
SELECT fabricante.nombre FROM fabricante
  WHERE EXISTS(
      SELECT producto.codigo_fabricante FROM producto
        WHERE fabricante.codigo_fabricante= producto.codigo_fabricante
  );

--15. Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando EXISTS o NOT
--EXISTS).
SELECT fabricante.nombre FROM fabricante
  WHERE NOT EXISTS(
      SELECT producto.codigo_fabricante FROM producto
        WHERE fabricante.codigo_fabricante= producto.codigo_fabricante
  );

--- SUBCONSULTAS CORRELACIONADAS ---
--16. Lista el nombre de cada fabricante con el nombre y el precio de su producto más caro.
SELECT fabricante.nombre, 
    (SELECT max(producto.precio) FROM producto 
      WHERE producto.codigo_fabricante= fabricante.codigo_fabricante) 
  FROM fabricante;

--17. Devuelve un listado de todos los productos que tienen un precio mayor o igual a la media de todos los
--productos de su mismo fabricante.
SELECT p1.nombre FROM producto p1
  WHERE p1.precio>=(
    SELECT avg(p2.precio) FROM producto p2
      WHERE p2.codigo_fabricante= p1.codigo_fabricante
  );

--18. Lista el nombre del producto más caro del fabricante Lenovo.
SELECT fabricante.nombre, 
      (SELECT MAX(producto.precio) FROM producto
        WHERE producto.codigo_fabricante=(
            SELECT fabricante.codigo_fabricante FROM fabricante 
              WHERE upper(fabricante.nombre)='LENOVO'))
  FROM fabricante
    WHERE upper(fabricante.nombre)='LENOVO';


/* ****************************************************/
/*        SUBCONSULTAS (EN LA CLÁUSULA HAVING)        */
/* ****************************************************/

--7. Devuelve un listado con todos los nombres de los fabricantes que tienen el mismo número de productos
--que el fabricante Lenovo.
SELECT fabricante.nombre FROM fabricante
  INNER JOIN producto ON fabricante.codigo_fabricante= producto.codigo_fabricante
    GROUP BY fabricante.nombre
      HAVING count(producto.codigo_producto)= (
        SELECT count(producto.codigo_producto) FROM producto
          WHERE producto.codigo_fabricante=(
            SELECT fabricante.codigo_fabricante FROM fabricante
              WHERE upper(fabricante.nombre)= 'LENOVO'
          )
      );