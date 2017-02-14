DROP PROCEDURE creaPeliculas;
DROP PROCEDURE creaSalas;
DROP PROCEDURE creaClientes;
DROP PROCEDURE creaTrabajadores;
DROP PROCEDURE creaPedidos;
DROP PROCEDURE creaLineaPedidos;
DROP PROCEDURE creaAlbaranes;
DROP PROCEDURE creaLineaAlbaranes;
DROP PROCEDURE creaProductos;
DROP PROCEDURE creaProyecciones;
DROP PROCEDURE creaEntradas;
DROP FUNCTION RN2AUX;
DROP FUNCTION RN2AUX1;
DROP PROCEDURE RF11;
DROP PROCEDURE RF12;

--Creación del procedimiento para crear películas añadiéndole el OID
CREATE PROCEDURE creaPeliculas
(w_nombre IN peliculas.nombre%TYPE,
w_anopublicacion IN peliculas.añopublicacion%TYPE,
w_distribuidora IN peliculas.distribuidora%TYPE) IS
BEGIN
INSERT INTO peliculas(nombre,añopublicacion,distribuidora)
VALUES(w_nombre,w_anopublicacion,w_distribuidora);
COMMIT WORK;
END creaPeliculas;
/

--Creación del procedimiento para crear salas añadiéndole el OID
CREATE PROCEDURE creaSalas
(w_numero IN salas.numero%TYPE,
w_capacidad IN salas.capacidad%TYPE)IS
BEGIN
INSERT INTO salas (numero,capacidad)
VALUES (w_numero,w_capacidad);
COMMIT WORK;
END creaSalas;
/

--Creación del procedimiento para crear clientes añadiéndole el OID
CREATE PROCEDURE creaClientes
(w_afiliacion IN clientes.afiliacion%TYPE) IS
BEGIN
INSERT INTO clientes (oid_c,afiliacion)
VALUES (sec_client.nextval, w_afiliacion);
COMMIT WORK;
END creaClientes;
/

--PROCEDURE CREATRABAJADORES
CREATE PROCEDURE creaTrabajadores
  (w_dni_tr IN trabajadores.dni_tr%TYPE,
  w_nombre_tr IN trabajadores.nombre_tr%TYPE,
  w_puesto IN trabajadores.puesto%TYPE) IS
BEGIN
INSERT INTO trabajadores (dni_tr, nombre_tr, puesto)
VALUES(w_dni_tr, w_nombre_tr, w_puesto);
COMMIT WORK;
END;
/ 

--Creación del procedimiento para crear pedidos añadiéndole el OID
CREATE PROCEDURE creaPedidos
(w_fecha_emi IN pedidos.fecha_emi%TYPE,
w_dni_tr IN pedidos.dni_tr%TYPE) IS
BEGIN
INSERT INTO pedidos (cod_ped,fecha_emi,dni_tr)
VALUES (sec_ped.nextval, w_fecha_emi, w_dni_tr);
COMMIT WORK;
END creaPedidos;
/

--PROCEDURE QUE AÑADE OID AL INSERTAR
CREATE PROCEDURE creaProductos
  (w_nombre_pro IN productos.nombre_pro%TYPE,
  w_descripcion_pro IN productos.descripcion_pro%TYPE,
  w_unidadesDisponibles_pro IN productos.unidadesDisponibles_pro%TYPE,
  w_unidadesMinimas_pro IN productos.unidadesMinimas_pro%TYPE,
  w_periodicidad IN productos.periodicidad%TYPE) IS
BEGIN
INSERT INTO PRODUCTOS (oid_pro, nombre_pro, descripcion_pro, unidadesDisponibles_pro, unidadesMinimas_pro, periodicidad)
VALUES (sec_pro.nextval, w_nombre_pro, w_descripcion_pro, w_unidadesDisponibles_pro, w_unidadesMinimas_pro, w_periodicidad);
COMMIT WORK;
END creaProductos;
/

--Creación del procedimiento para crear pedidos añadiéndole el OID
CREATE PROCEDURE creaLineaPedidos
(w_unidades_ped IN linea_pedidos.unidades_ped%TYPE,
w_cod_ped IN linea_pedidos.cod_ped%TYPE,
w_oid_pro IN linea_pedidos.OID_PRO%TYPE) IS
BEGIN
INSERT INTO linea_pedidos (oid_lp,unidades_ped,cod_ped,OID_PRO)
VALUES (sec_lp.nextval,w_unidades_ped,w_cod_ped, w_oid_pro);
COMMIT WORK;
END creaLineaPedidos;
/

--Creación del procedimiento para crear albaranes añadiéndole el OID
--No se si va a estar bien porque sale muy raro 
CREATE PROCEDURE creaAlbaranes
(w_fecha_rec IN albaranes.fecha_rec%TYPE,
 w_cod_ped IN albaranes.cod_ped%TYPE) IS
BEGIN
INSERT INTO albaranes (cod_alb, fecha_rec, cod_ped)
VALUES (sec_alb.nextval,w_fecha_rec, w_cod_ped);
COMMIT WORK;
END creaAlbaranes;
/

--Creación del procedimiento para crear lineas de albaran añadiéndole el OID
CREATE PROCEDURE creaLineaAlbaranes
(w_unidades_rec IN lineas_albaran.unidades_rec%TYPE,
w_cod_alb IN lineas_albaran.cod_alb%TYPE,
w_oid_pro IN lineas_albaran.OID_PRO%TYPE) IS
BEGIN
INSERT INTO lineas_albaran (oid_la,unidades_rec,cod_alb,OID_PRO)
VALUES (sec_la.nextval,w_unidades_rec,w_cod_alb, w_oid_pro);
COMMIT WORK;
END creaLineaAlbaranes;
/

--PROCEDURE QUE AÑADE OID AL INSERTAR
CREATE PROCEDURE creaProyecciones
  (w_fecha_hora IN proyecciones.fecha_hora%TYPE,
  w_nombre IN PROYECCIONES.NOMBRE%TYPE,
  w_añopublicacion IN PROYECCIONES."AÑOPUBLICACION"%TYPE,
  w_numero IN PROYECCIONES.NUMERO%TYPE) IS
BEGIN
INSERT INTO proyecciones(OID_PR, fecha_hora, NOMBRE, "AÑOPUBLICACION", NUMERO)
VALUES(sec_pr.nextval, w_fecha_hora, w_nombre, w_añopublicacion, w_numero);
COMMIT WORK;
END creaProyecciones;
/
--AÑOPUBLICACION DATE,  NUMERO INTEGER, 

--PROCEDURE QUE AÑADE OID AL INSERTAR
CREATE PROCEDURE creaEntradas
  (w_fila_e IN entradas.fila_e%TYPE,
  w_asiento_e IN entradas.asiento_e%TYPE,
  w_numero IN ENTRADAS.NUMERO%TYPE,
  w_dni_tr IN ENTRADAS.DNI_TR%TYPE,
  w_OID_PR IN ENTRADAS.OID_PR%TYPE,
  w_OID_C IN ENTRADAS.OID_C%TYPE) IS
BEGIN
INSERT INTO entradas(OID_E, fila_e, asiento_e,NUMERO, dni_tr, OID_PR, OID_C)
VALUES(sec_e.nextval, w_fila_e, w_asiento_e, w_numero, w_dni_tr, w_OID_PR, w_OID_C);
COMMIT WORK;
END;
/

/*
RN-002 Realizar comprobación entre pedido y albarán
Como encargado del ambigú,
Quiero que se compruebe que las unidades pedidas y las unidades recibidas son iguales,
Para en caso de no serlo, volver a pedir lo que falte.
*/

CREATE FUNCTION RN2AUX(w_cod_alb IN lineas_albaran.cod_alb%TYPE)
RETURN NUMBER IS w_cod_ped albaranes.cod_ped%TYPE;
BEGIN
  SELECT cod_ped INTO w_cod_ped FROM albaranes WHERE cod_alb = w_cod_alb;
RETURN (w_cod_ped);
END;
/

CREATE FUNCTION RN2AUX1(w_cod_ped IN ALBARANES.COD_PED%TYPE, w_oid_pro IN LINEAS_ALBARAN.OID_PRO%TYPE)
RETURN NUMBER IS w_unidades_ped LINEA_PEDIDOS.UNIDADES_PED%TYPE;
BEGIN
  SELECT unidades_ped INTO w_unidades_ped FROM linea_pedidos WHERE cod_ped = w_cod_ped AND oid_pro = w_oid_pro;
RETURN (w_unidades_ped);
END;
/

/*
RF-011 Realizar pedido de forma rápida
Como encargado del ambigú,
Quiero que con solo meter mi dni-e se cree un pedido,
Para acelerar el proceso.
*/

CREATE OR REPLACE PROCEDURE RF11(w_dni_tr IN pedidos.dni_tr%TYPE) IS
BEGIN
  INSERT INTO PEDIDOS(cod_ped,fecha_emi,dni_tr) VALUES(sec_ped.nextval, SYSDATE, w_dni_tr);
 -- INSERT INTO LINEA_PEDIDOS(oid_lp,unidades_ped, cod_ped, oid_pro) 
 -- VALUES(SEC_LP.NEXTVAL,w_unidades_ped,SELECT LAST(OID_PED) FROM PEDIDOS, w_oid_pro); 
COMMIT WORK;
END;
/

/*
RF-012 Actualizar stock
Como encargado del ambigú,
Quiero que cuando se haya recibido un pedido se actualice el stock disponible,
Para saber cuánto se puede gastar de cara a la semana.
*/

CREATE OR REPLACE PROCEDURE RF12(w_unidades_rec IN lineas_albaran.unidades_rec%TYPE,  
  w_unidadesDisponibles_pro IN productos.unidadesDisponibles_pro%TYPE,
  w_oid_pro IN PRODUCTOS.oid_pro%TYPE) IS

    BEGIN
    UPDATE PRODUCTOS SET UNIDADESDISPONIBLES_PRO = (UNIDADESDISPONIBLES_PRO + w_unidades_rec) where oid_pro = w_oid_pro;
COMMIT WORK;
END;
/