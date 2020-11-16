# ADBD_triggers_Eduardo_Suarez_Ojeda

Dada la base de dato de viveros:

Procedimiento: crear_email devuelva una dirección de correo electrónico con el siguiente formato:

Un conjunto de caracteres del nombe y/o apellidos

El carácter @.

El dominio pasado como parámetro.

Para realizar el primer ejercicio creo un nuevo procedimiento en la base de datos de viveros al cual se le llama con los parámetros de entrada nombre, apellido1, apellido2, dominio  el valor de salida email donde se guarda el email resultante. Para crear el email concateno los tres primeros caracteres de nombre y dos apellidos y el dominio especificado.

```mysql
CREATE PROCEDURE `crear_email` (IN Nombre varchar(45), in Apellido1 varchar(45), IN Apellido2 varchar(45), IN dominio VARCHAR(45), OUT email varchar(45))
BEGIN
    SET Email = CONCAT(LEFT(Nombre, 3), LEFT(Apellido1, 3), LEFT(Apellido2, 3), '@', dominio);
END
```
Una vez creada la tabla escriba un trigger con las siguientes características:

Trigger: trigger_crear_email_before_insert

Se ejecuta sobre la tabla clientes.

Se ejecuta antes de una operación de inserción.

Si el nuevo valor del email que se quiere insertar es NULL, entonces se le creará automáticamente una dirección de email y se insertará en la tabla.

Si el nuevo valor del email no es NULL se guardará en la tabla el valor del email.

Nota: Para crear la nueva dirección de email se deberá hacer uso del procedimiento crear_email.

En esta parte creo un trigger con el esquema por defecto de MySQL workbench para que en el caso de antes de la inserción se llame al procedimiento crear_email con el dominio "viveros.ull.es" si el nuevo email es igual a null. Dentro de ese if se le asigna el nuevo valor a email, resultado de el procedimiento email con los valores ingresados en la inserción de la fila.

```mysql
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`trigger_crear_email_before_insert` BEFORE INSERT ON `Cliente` FOR EACH ROW
BEGIN
	DECLARE EmailPrefab varchar(45);
	IF NEW.Email IS NULL THEN
	CALL crear_email(NEW.Nombre, NEW.Apellido1, NEW.Apellido2, 'viveros.ull.es', @EmailPrefab);
	set NEW.Email = @EmailPrefab;
    END iF;
END
```
2. Crear un trigger permita verificar que las personas en el Municipio del catastro no pueden vivir en dos viviendas diferentes.

Para determinar la vivienda de cada persona tengo dos tablas en las que en cada una se le asigna una vivienda a cada persona, una para los pisos y otra para las viviendas unifamiliares. En ambas el DNI es clave primaria única, por lo que no se puede repetir en la misma tabla, sin embargo, se corre el risgo de que exista el mismo DNI en las dos tablas simultáneamente, por lo que mi trigger para evitar que las personas tengan varios domicilios consiste en evitar que el un DNI pueda estar presente en ambas tablas. A su vez sería conveniente crear un trigger para antes de la actualización con la misma función.

```mysql
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`PersonaVivePiso_BEFORE_INSERT` BEFORE INSERT ON `PersonaVivePiso` FOR EACH ROW
BEGIN
	IF (NEW.DNI IN (SELECT DNI
		FROM PersonaViveUnifamiliar)) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'invalid data';
    END IF;
END
```

```mysql
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`PersonaViveUnifamiliar_BEFORE_INSERT` BEFORE INSERT ON `PersonaViveUnifamiliar` FOR EACH ROW
BEGIN
	IF (NEW.DNI IN (SELECT DNI
		FROM PersonaVivePiso)) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'invalid data';
    END IF;
END
```

3. Crear el o los trigger que permitan mantener actualizado el stock de la base de dato de viveros.

```mysql
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Producto_Pedido_AFTER_INSERT` AFTER INSERT ON `Producto_Pedido` FOR EACH ROW
BEGIN
	Update Productos
    set Productos.Stock = Productos.Stock - NEW.Cantidad
    where Productos.CódigoBarras = NEW.CódigoBarras;
END
```

Con este trigger para la tabla de los pedidos actualizo la tabla de productos de tal manera que para cada pedido se resta del stock la cantidad de producto del mismo siempre y cuando tengan el mismo código de barras, es decir, que sea el mismo producto.

Se podría utilizar tambien un trigger similar que en vez de restar sume si se crea una nueva table que indique la compra de nuevos productos para rellenar el stock.
