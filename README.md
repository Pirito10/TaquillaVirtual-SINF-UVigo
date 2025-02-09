# Taquilla Virtual
_Taquilla Virtual_ is a **Virtual Ticketing System Database** developed as part of the course "[Sistemas de Información](https://secretaria.uvigo.gal/docnet-nuevo/guia_docent/?centre=305&ensenyament=V05G301V01&assignatura=V05G301V01309&any_academic=2023_24)" in the Telecommunications Engineering Degree at the Universidad de Vigo (2023 - 2024).

## About The Project
This project implements the database system for an online ticketing service, supporting event management, ticket reservations, and purchase processing. The system integrates key concepts of relational databases, such as referential integrity, stored procedures, triggers, and transactional consistency, ensuring data accuracy and efficient query execution.

The project features:
- Structured relational database model designed for scalability and efficiency.
- Stored procedures for ticket purchases, cancellations, and event management. 
- Integrity constraints to ensure data consistency and prevent invalid operations.
- Custom validation rules for seat availability, refund penalties, and audience restrictions.
- User access management with role-based permissions for different user types.

## How To Run
### Data Generator
#### Compilation
Make sure you have a [Java JDK](https://www.oracle.com/java/technologies/downloads/) installed on your system. Then compile the Java class and generate the `.class` file with:
```bash
javac -d bin src/GeneradorDatos.java
```
This command creates the compiled file inside the `bin/` directory.

#### Execution
Once compiled, you can run the generator with:
```bash
java -cp bin GeneradorDatos <num_espectaculos> <num_clientes> <minGradas> <maxGradas> <minUbicaciones> <maxUbicaciones> <fichero>
```
| Option | Description | Example |
|--------|-------------|---------|
| `num_espectaculos` | Number of events to create | `200` |
| `num_clientes` |Number of clients to create | `1000` |
| `minGradas` | Minimum stands per venue | `1` |
| `maxGradas` | Maximum stands per venue | `8` |
| `minUbicaciones` | Minimum seats per stand | `10` |
| `maxUbicaciones` | Maximum seats per stand | `100` |
| `fichero` | Output SQL file | `datos.sql` |

##### Example
```bash
java -cp bin GeneradorDatos 200 1000 1 8 10 100 test/datos.sql
```

### Database
#### Requirements
Make sure you have [MySQL](https://www.mysql.com) installed on your system.

#### Setup
Open MySQL and execute the following scripts to initialize the database schema, stored procedures, and user accounts:
```sql
\. src/esquema.sql
\. src/procedimientos/realizarCompra.sql
\. src/procedimientos/anularCompra.sql
\. src/procedimientos/crearEspectaculo.sql
\. src/procedimientos/eliminarEspectaculo.sql
\. src/procedimientos/requisitos/verificarAnularCompra.sql
\. src/procedimientos/requisitos/verificarLimiteAnulaciones.sql
\. src/procedimientos/requisitos/verificarLimiteEntradas.sql
\. src/procedimientos/requisitos/verificarPenalizacion.sql
\. src/procedimientos/requisitos/verificarPublicoPermitido.sql
\. src/procedimientos/requisitos/verificarRealizarCompra.sql
\. src/procedimientos/consultas/espectaculos.sql
\. src/procedimientos/consultas/recintos.sql
\. src/procedimientos/consultas/clientes.sql
\. src/procedimientos/consultas/localidades.sql
\. src/usuarios.sql
```

#### Usage
After setting up the database, you can populate it, for example:
```sql
\. test/datos.sql
```
This script will insert randomized sample events, clients, and venue data.
Refer to [`test.txt`](test/test.txt) for more realistic test cases.

## About The Code
Refer to [`Especifications.pdf`](docs/Especifications.pdf), [`Justificaciones.pdf`](docs/Justificaciones.pdf), and [`Diagramas.jpg`](docs/Diagramas.jpg) for an in-depth explanation of the project, how the system works, the database schema and table relationships, the implemented queries and procedures, and more.