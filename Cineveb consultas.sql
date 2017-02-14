/*
RF-003 Informaci�n Taquilla
Como empleado de taquilla,
Quiero ver todas las entradas de una pel�cula y la informaci�n de la pel�cula,
Para poder ver la disponibilidad de una pel�cula correctamente.
*/

DROP PROCEDURE RF3;
SET serveroutput ON
CREATE PROCEDURE RF3 (w_nombre IN PELICULAS.NOMBRE%TYPE, w_a�opublicacion IN PELICULAS."A�OPUBLICACION"%TYPE) AS

  CURSOR RF3C IS
    SELECT oid_pr FROM PROYECCIONES WHERE NOMBRE = W_NOMBRE AND "A�OPUBLICACION" = W_A�OPUBLICACION;
    
  CPROYECCION integer;
  
  CURSOR RF3C1 IS 
    SELECT FILA_E,ASIENTO_E,NUMERO FROM ENTRADAS WHERE CPROYECCION = OID_PR;
    
  CFILA integer;
  CASIENTO integer;
  CNUMERO integer;
  
  BEGIN DBMS_OUTPUT.PUT_LINE('Pel�cula -> Nombre: ' || w_nombre || '. A�o de publicaci�n: ' || w_a�opublicacion);
    OPEN RF3C;
    LOOP
    FETCH RF3C INTO CPROYECCION;
    EXIT WHEN RF3C%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Proyecci�n-> OID_PR: ' || CPROYECCION);
              OPEN RF3C1;
              LOOP
              FETCH RF3C1 INTO CFILA,CASIENTO,CNUMERO;
              EXIT WHEN RF3C1%NOTFOUND;
              DBMS_OUTPUT.PUT_LINE('Entrada -> Fila: ' || cfila || '. Asiento: ' || casiento || '. N�mero: ' || cnumero);
              END LOOP;
              CLOSE RF3C1;
    END LOOP;
    CLOSE RF3C;
    COMMIT WORK;
  END;
/

/*
RF-004 Informe de espectadores
Como Empleado de taquilla,
Quiero ver cuantas entradas se han vendido de cada pel�cula,
Para poder estudiar qu� pel�culas son las m�s o menos vistas.
*/

SET serveroutput ON
  DECLARE CURSOR RF4C IS 
    SELECT NOMBRE,A�OPUBLICACION FROM PELICULAS;
    CNOMBRE VARCHAR2(50 BYTE);
    CA�OPUBLICACION DATE;
    
  CURSOR RF4C1 IS
    SELECT OID_PR FROM PROYECCIONES WHERE NOMBRE = CNOMBRE AND A�OPUBLICACION = CA�OPUBLICACION;
    COID INTEGER;
    CNUMEROENTRADAS INTEGER;
    
  CURSOR RF4C2 IS
    SELECT COUNT(*) AS NumeroEntradas FROM ENTRADAS WHERE OID_PR = COID;
    
 BEGIN 
    OPEN RF4C;
    LOOP
    FETCH RF4C INTO CNOMBRE,CA�OPUBLICACION;
    EXIT WHEN RF4C%NOTFOUND;
    
      OPEN RF4C1;
      LOOP
      FETCH RF4C1 INTO COID;
      EXIT WHEN RF4C1%NOTFOUND;
      
        OPEN RF4C2;
        LOOP
        FETCH RF4C2 INTO CNUMEROENTRADAS;
        EXIT WHEN RF4C2%NOTFOUND;
        END LOOP;
          DBMS_OUTPUT.PUT_LINE('Pel�cula -> Nombre: ' || CNOMBRE || '. A�o de publicaci�n: ' || CA�OPUBLICACION);
          DBMS_OUTPUT.PUT_LINE('Proyecci�n -> OID_PR: ' || COID);
          DBMS_OUTPUT.PUT_LINE('. Entradas: ' || CNUMEROENTRADAS);
        CLOSE RF4C2;
      END LOOP;
      CLOSE RF4C1;
    END LOOP;
    CLOSE RF4C;
    COMMIT WORK;
  END;
/

/*
RF-007 Inventario de ambig�
Como Empleado de ambig�,
Quiero ver los productos ordenados por orden alfab�tico con su informaci�n,
Para poder realizar pedidos en base a ello.
*/

SET serveroutput ON
DECLARE CURSOR RF007 IS
  SELECT NOMBRE_PRO,DESCRIPCION_PRO, unidadesDisponibles_pro,unidadesMinimas_pro FROM PRODUCTOS ORDER BY NOMBRE_PRO;
  Cnombre_pro VARCHAR(50);
  Cdescripcion_pro VARCHAR(100);
  CunidadesDisponibles_pro INTEGER;
  CunidadesMinimas_pro INTEGER;
  BEGIN DBMS_OUTPUT.PUT_LINE('Productos ordenados por orden alfab�tico: ');
  
    OPEN RF007;
    LOOP
    FETCH RF007 INTO Cnombre_pro, Cdescripcion_pro, CunidadesDisponibles_pro, CunidadesMinimas_pro;
    EXIT WHEN RF007%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Nombre: ' || Cnombre_pro || '. Descripci�n: '|| Cdescripcion_pro || '. Unidades Disponibles: ' 
    || CunidadesDisponibles_pro || '. Unidades M�nimas: ' || CunidadesMinimas_pro);
    END LOOP;
    CLOSE RF007;
END;
/

/*
RF-008 Visualizaci�n de los pedidos
Como Empleado de ambig�,
Quiero que conste la informaci�n sobre los pedidos,
Para que esos datos no queden en el limbo.
*/
 
SET serveroutput ON 
Declare CURSOR RF008 IS
    SELECT COD_PED,FECHA_EMI, DNI_TR FROM PEDIDOS ORDER BY FECHA_EMI;
    Ccod_ped integer;
    Cfecha_emi date;
    Cdni_tr CHAR(9);
    BEGIN DBMS_OUTPUT.PUT_LINE('Pedidos ordenados por fecha de emisi�n: ');
    
    OPEN RF008;
    LOOP
    FETCH RF008 INTO Ccod_ped, Cfecha_emi, Cdni_tr;
    EXIT WHEN RF008%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('C�digo: ' || Ccod_ped ||'. Fecha de emisi�n: '|| Cfecha_emi || '. Dni-e del trabajador: ' || Cdni_tr);
    END LOOP;
    CLOSE RF008;
    END;
/

/*
RF-014 Ordenaci�n de productos por unidades disponibles
Como encargado del ambig�,
Quiero saber que productos tienen m�s disponibilidad,
Para tenerlos m�s accesibles en el almac�n a la hora de colocar las cosas.
*/

SET SERVEROUTPUT ON
DECLARE
  CURSOR RF014 IS
  SELECT UNIDADESDISPONIBLES_PRO, NOMBRE_PRO FROM PRODUCTOS ORDER BY UNIDADESDISPONIBLES_PRO;

  UNIDADES integer;
  NOMBRE VARCHAR2(50);
    BEGIN DBMS_OUTPUT.PUT_LINE('Productos ordenados por unidades disponibles: ');
      OPEN RF014;
      LOOP
      FETCH RF014 INTO UNIDADES, NOMBRE;
        EXIT WHEN RF014%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(NOMBRE||' '||UNIDADES || ' unidades.');

      END LOOP;
      CLOSE RF014;
END;
/

