/*
RF-001 Aviso de pedido de productos en ambigú
Como Empleado de ambigú,
Quiero recibir un aviso para realizar un pedido cuando la existencia de algún producto no sea suficiente,
Para poder saber cuándo debo de realizar un pedido.
*/

--PD: HAY QUE EJECUTAR EL TRIGGER EN OLD, SI NO NO FUNCIONA BIEN.
DROP TRIGGER RF1;
CREATE TRIGGER RF1
AFTER
UPDATE OF unidadesDisponibles_pro ON productos
FOR EACH ROW
BEGIN --Nos sirve para escribir un bloque de código que se ejecute seguido
IF :NEW.unidadesDisponibles_pro <= :OLD.unidadesMinimas_pro --Si las unidades disponibles son menores o iguales a las und. mínimas
THEN raise_application_error
(-20600,:NEW.unidadesDisponibles_pro||' unidades de ' || :NEW.NOMBRE_PRO||' son menores o iguales a las mínimas. Hay que realizar un pedido.');
END IF; 
END;
/

/*
RN-002 Realizar comprobación entre pedido y albarán
Como encargado del ambigú,
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
RF-015 Distinción entre pedidos
Como encargado del ambigú,
Quiero que todos los productos menos las granizadas, los vasos, el carbónico, las cajas de palomitas, 
los vasos de refresco, las pajitas, las tapas, el aceite de palomitas y los sacos se pidan de forma periódica,
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
(-20600,'L@s '|| :NEW.NOMBRE_PRO ||'  DEBEN pedirse de forma periódica.');
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