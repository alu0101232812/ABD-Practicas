## Introducción a PostgresQL

Lo primero que debemos hacer es instalar PostgresQL. Para ello utilizaremos el comando

`sudo apt-get install postgresql`

![img_1](1.jpg)

Para crear un usuario, deberemos autenticarnos como super usuario y postrioremente crear este usuario:

```
sudo su postgres
create user [usuario]
```

![img_2](2.png)

## Test Práctico

* Creamos la base de datos P1:  
`CREATE DATABASE P1;`
![img_3](3.png)

* Comprobamos si se ha creado listando todas las bases:  
`\l`

![img_4](4.png)

* Nos conectamos a la base de datos P1:  
`\c P1 postgres`

![img_5](5.png)

* Creamos la tabla:  
`create table usuarios (nombre varchar(35), clave varchar(15));`

![img_6](6.png)

* Insertamos los datos:  
`into usuarios ( nombre, clave ) values ( ‘ ’ , ’ ’ )` 

![img_7](7.png)

* Comprobamos si se han insertado mediante una consulta:  
`SELECT * FROM usuarios` 

![img_8](8.png)
