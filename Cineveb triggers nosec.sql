/*
RF-001 Aviso de pedido de productos en ambig�
Como Empleado de ambig�,
Quiero recibir un aviso para realizar un pedido cuando la existencia de alg�n producto no sea suficiente,
Para poder saber cu�ndo debo de realizar un pedido.
*/

--PD: HAY QUE EJECUTAR EL TRIGGER EN OLD, SI NO NO FUNCIONA BIEN.
DROP TRIGGER RF1;
CREATE TRIGGER RF1
AFTER
UPDATE OF unidadesDisponibles_pro ON productos
FOR EACH ROW
BEGIN --Nos sirve para escribir un bloque de c�digo que se ejecute seguido
IF :NEW.unidadesDisponibles_pro <= :OLD.unidadesMinimas_pro --Si las unidades disponibles son menores o iguales a las und. m�nimas
THEN raise_application_error
(-20600,:NEW.unidadesDisponibles_pro||' unidades de ' || :NEW.NOMBRE_PRO||' son menores o iguales a las m�nimas. Hay que realizar un pedido.');
END IF; 
END;
/

/*
RN-002 Realizar comprobaci�n entre pedido y albar�n
Como encargado del ambig�,
Quiero que se compruebe que las unidades pedidas y las unidades recibidas son iguales,
Para en caso de no serlo, volver a pedir lo que falte.
*/

DROP TRIGGER RN2;
CREATE TRIGGER RN2
AFTER
INSERT ON lineas_albaran
FOR EACH ROW
BEGIN
IF :NEW.unidades_rec != RN2AUX1(RN2AUX(:NEW.cod_alb),:NEW.oid_pro)
THEN raise_application_error
(-20601,:NEW.unidades_rec||' no son iguales a las unidades pedidas en el pedido '|| RN2AUX(:NEW.cod_alb) 
  || '. Hay que realizar un nuevo pedido.');
END IF; 
END;
/

/*
RF-015 Distinci�n entre pedidos
Como encargado del ambig�,
Quiero que todos los productos menos las granizadas, los vasos, el carb�nico, las cajas de palomitas, 
los vasos de refresco, las pajitas, las tapas, el aceite de palomitas y los sacos se pidan de forma peri�dica,
Para ajustarse a la demanda de producto.
*/
DROP TRIGGER RF15;
CREATE OR REPLACE TRIGGER RF15
BEFORE INSERT ON PRODUCTOS
FOR EACH ROW
BEGIN
  IF (:NEW.PERIODICIDAD = '0') 
  THEN IF (:NEW.NOMBRE_PRO != 'VASOS')
  THEN IF (:NEW.NOMBRE_PRO != 'PAJITAS')
  THEN IF (:NEW.NOMBRE_PRO != 'GRANIZADAS')
  THEN IF (:NEW.NOMBRE_PRO != 'CARBONICO')
  THEN IF (:NEW.NOMBRE_PRO != 'PALOMITAS')
  THEN IF (:NEW.NOMBRE_PRO != 'TAPAS')
  THEN IF (:NEW.NOMBRE_PRO != 'ACEITE')
  THEN IF (:NEW.NOMBRE_PRO != 'SACOS') 
  THEN raise_application_error
(-20600,'L@s '|| :NEW.NOMBRE_PRO ||'  DEBEN pedirse de forma peri�dica.');
END IF;
END IF;
END IF;
END IF;
END IF;
END IF;
END IF;
END IF;
END IF; 
END; 
/