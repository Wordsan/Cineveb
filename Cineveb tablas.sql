--Borrado de tablas 
DROP TABLE entradas;
DROP TABLE proyecciones;
DROP TABLE lineas_albaran;
DROP TABLE albaranes;
DROP TABLE linea_pedidos;
DROP TABLE pedidos;
DROP TABLE productos;
DROP TABLE TRABAJADORES;
DROP TABLE clientes;
DROP TABLE SALAS;
DROP TABLE PELICULAS;



--Creación de la tabla películas
CREATE TABLE PELICULAS
   (NOMBRE VARCHAR2(50 BYTE), 
    AÑOPUBLICACION DATE, 
    DISTRIBUIDORA VARCHAR2(20 BYTE),
    PRIMARY KEY (NOMBRE,AÑOPUBLICACION));

--Creación de la tabla salas
  CREATE TABLE SALAS 
  (NUMERO INTEGER NOT NULL, 
  CAPACIDAD INTEGER, 
  PRIMARY KEY (NUMERO));

--Creación de la tabla clientes
CREATE TABLE clientes
(oid_c integer,
afiliacion integer
CHECK(afiliacion=0 OR afiliacion=1),
PRIMARY KEY (oid_c));

--Creación de la secuencia clientes
DROP SEQUENCE sec_client;
-- Ejercicio 1: creamos una secuencia
CREATE SEQUENCE sec_client INCREMENT BY 1 START WITH 1;

DROP TRIGGER crea_oid_cliente;
CREATE TRIGGER crea_oid_cliente
BEFORE 
  INSERT ON clientes
  FOR EACH ROW
BEGIN 
  select sec_client.CURRVAL INTO :NEW.oid_c FROM DUAL;
END;
/

--CREACION TABLA DE TRABAJADORES
CREATE TABLE TRABAJADORES 
  (dni_tr CHAR(9) NOT NULL,
  nombre_tr VARCHAR(50),
  puesto VARCHAR(8), CONSTRAINT "TRABAJADORES_CHK1" 
  CHECK(puesto IN ('TAQUILLA', 'PORTERIA', 'AMBIGU', 'CABINA')),
  PRIMARY KEY (dni_tr));
  
--Creación de la tabla pedidos (estrella) 
CREATE TABLE pedidos
(cod_ped integer not null,
fecha_emi date,
dni_tr CHAR(9) NOT NULL,
PRIMARY KEY (cod_ped),
FOREIGN KEY (dni_tr) REFERENCES TRABAJADORES);

--Creación de la secuencia de pedido para su oid 
DROP SEQUENCE sec_ped;
CREATE SEQUENCE sec_ped INCREMENT BY 1 START WITH 1;

DROP TRIGGER crea_oid_pedido;
--Trigger que asigna el siguiente valor al pedido si se hace insert into
CREATE TRIGGER crea_oid_pedido
BEFORE 
  INSERT ON pedidos
  FOR EACH ROW
BEGIN 
  select sec_ped.CURRVAL INTO:NEW.cod_ped FROM DUAL;
END;
/

--CREACION TABLA DE PRODUCTOS
CREATE TABLE PRODUCTOS
  (OID_PRO INTEGER NOT NULL,
  nombre_pro VARCHAR(50),
  descripcion_pro VARCHAR(100),
  unidadesDisponibles_pro INTEGER,
  unidadesMinimas_pro INTEGER,
  periodicidad VARCHAR(1), CONSTRAINT "PRODUCTOS_CHK1"
  CHECK(periodicidad IN ('1', '0')),
  PRIMARY KEY (OID_PRO));

--OID PRODUCTOS
DROP SEQUENCE SEC_PRO;
CREATE SEQUENCE SEC_PRO INCREMENT BY 1 START WITH 1;


--Creación de la tabla línea de pedidos
CREATE TABLE linea_pedidos
(oid_lp integer not null,
unidades_ped integer,
cod_ped integer,
OID_PRO INTEGER,
PRIMARY KEY (oid_lp),
FOREIGN KEY (cod_ped) REFERENCES pedidos,
FOREIGN KEY (OID_PRO) REFERENCES PRODUCTOS);

--Creación de la secuencia de línea de pedidos para su oid 
DROP SEQUENCE sec_lp;
CREATE SEQUENCE sec_lp INCREMENT BY 1 START WITH 1;

DROP TRIGGER crea_oid_linea_pedidos;
--Trigger que asigna el siguiente valor a linea_pedidos si se hace insert into
CREATE TRIGGER crea_oid_linea_pedidos
BEFORE 
  INSERT ON linea_pedidos
  FOR EACH ROW
BEGIN 
  select sec_lp.CURRVAL INTO:NEW.oid_lp FROM DUAL;
END;
/

--Creación de la tabla albaranes
CREATE TABLE albaranes
(cod_alb integer not null,
fecha_rec date,
cod_ped integer,
PRIMARY KEY (cod_alb),
FOREIGN KEY (cod_ped) REFERENCES pedidos);

--Creación de la secuencia de albaranes para su oid 
DROP SEQUENCE sec_alb;
CREATE SEQUENCE sec_alb INCREMENT BY 1 START WITH 1;

--Trigger que asigna el siguiente valor a linea_pedidos si se hace insert into
DROP TRIGGER crea_oid_albaranes;
CREATE TRIGGER crea_oid_albaranes
BEFORE 
  INSERT ON albaranes
  FOR EACH ROW
BEGIN 
  select sec_alb.CURRVAL INTO:NEW.cod_alb FROM DUAL;
END;
/

--Creación de la tabla línea de albarán
CREATE TABLE lineas_albaran
(oid_la integer not null,
unidades_rec integer,
cod_alb integer,
OID_PRO integer,
PRIMARY KEY (oid_la),
FOREIGN KEY (cod_alb) REFERENCES albaranes,
FOREIGN KEY (OID_PRO) REFERENCES PRODUCTOS);

--Creación de la secuencia de líneas de albaran para su oid 
DROP SEQUENCE sec_la;
CREATE SEQUENCE sec_la INCREMENT BY 1 START WITH 1;

--Trigger que asigna el siguiente valor a linea_pedidos si se hace insert into
DROP TRIGGER crea_oid_lineas_albaran;
CREATE TRIGGER crea_oid_lineas_albaran
BEFORE 
  INSERT ON lineas_albaran
  FOR EACH ROW
BEGIN 
  select sec_la.CURRVAL INTO:NEW.oid_la FROM DUAL;
END;
/
--CREACION TABLA DE PROYECCIONES
CREATE TABLE PROYECCIONES 
   (OID_PR INTEGER NOT NULL,
    fecha_hora TIMESTAMP, 
    NOMBRE VARCHAR2(50 BYTE), 
    AÑOPUBLICACION DATE, 
    NUMERO INTEGER, 
    PRIMARY KEY (OID_PR),
    FOREIGN KEY (NOMBRE,AÑOPUBLICACION) REFERENCES PELICULAS,
    FOREIGN KEY (NUMERO) REFERENCES SALAS);

--OID PROYECCIONES
DROP SEQUENCE SEC_PR;
CREATE SEQUENCE SEC_PR INCREMENT BY 1 START WITH 1;
 
--CREACION TABLA DE ENTRADAS    
CREATE TABLE ENTRADAS
  (OID_E INTEGER NOT NULL,
   fila_e INTEGER,
   asiento_e INTEGER,
   NUMERO INTEGER,
   dni_tr char(9),
   OID_PR integer,
   OID_C INTEGER,
   PRIMARY KEY (OID_E),
   FOREIGN KEY (NUMERO) REFERENCES SALAS,
   FOREIGN KEY (dni_tr) REFERENCES TRABAJADORES,
   FOREIGN KEY (OID_PR) REFERENCES PROYECCIONES,
   FOREIGN KEY (OID_C) REFERENCES CLIENTES);

--OID ENTRADAS
DROP SEQUENCE SEC_E;
CREATE SEQUENCE SEC_E INCREMENT BY 1 START WITH 1;

  
/*
ERRORES OCURRIDOS:
Tablas:
No hace falta poner unique a las primary key. Es como una redundancia.

Triggers:
Entre los dos puntos y el new no puede haber un espacio.

Procedures:
Hay que usar execute para poder ejecutarlos (Era obvio pero soy tonta).

Funciones:
Si se quiere escribir un bloque de código se puede usar BEGIN, END.

PD: Que no se nos olvide las / detrás de cada función, trigger y procedimiento. ¡IMPORTANTE!
*/
  