import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Random;
import java.util.Set;

public class GeneradorDatos {

    private static int numEspectaculos; // Número de espectáculos a crear
    private static int numClientes; // Número de clientes a crear
    private static int minGradas; // Mínimo número de gradas por recinto
    private static int maxGradas; // Máximo número de gradas por recinto
    private static int minUbicaciones; // Mínimo número de ubicaciones por grada
    private static int maxUbicaciones; // Máximo número de ubicaciones por grada
    private static int numLocalidades = 0; // Contador de localidades
    private static int numPermite = 0; // Contador de entradas en Permite
    private static List<Integer> numerosTarjeta = new ArrayList<>(); // Lista con los números de tarjeta
    private static List<int[]> localidadesRecintos = new ArrayList<>(); // Lista con las tuplas idLocalidad - idRecinto
                                                                        // - numTarjeta
    private static final String[] tiposUsuarios = { "Adulto", "Infantil", "Bebe", "Jubilado", "Parado" };

    public static void main(String[] args) {

        if (args.length < 7) {
            System.out.println(
                    "Uso: java GeneradorDatos <num_espectáculos> <num_clientes> <minGradas> <maxGradas> <minUbicaciones> <maxUbicaciones> <fichero>");
            System.out.println("- <num_espectáculos>: número de espectáculos a crear. Recomendado: 200");
            System.out.println("- <num_clientes>: número de clientes a crear. Recomendado: 1000");
            System.out.println("- <minGradas>: número mínimo de gradas para cada recinto. Recomendado: 1");
            System.out.println("- <maxGradas>: número máximo de gradas para cada recinto. Recomendado: 8");
            System.out.println("- <minUbicaciones>: número mínimo de ubicaciones para cada grada. Recomendado: 10");
            System.out.println("- <maxUbicaciones>: número mínimo de ubicaciones para cada grada. Recomendado: 100");
            System.out.println("- <fichero>: nombre del fichero de salida");
            System.out.println("Valores recomendados para generar un millón de tuplas (aproximadamente)");
            return;
        }

        numEspectaculos = Integer.parseInt(args[0]);
        numClientes = Integer.parseInt(args[1]);
        minGradas = Integer.parseInt(args[2]);
        maxGradas = Integer.parseInt(args[3]);
        minUbicaciones = Integer.parseInt(args[4]);
        maxUbicaciones = Integer.parseInt(args[5]);

        String fileName = args[6];
        try {

            BufferedWriter writer = new BufferedWriter(new FileWriter(fileName));

            generateEspectaculosInserts(writer);
            System.out.println("Generadas " + numEspectaculos + " tuplas para Espectaculos");

            generateRecintosInserts(writer);
            System.out.println("Generadas " + numEspectaculos + " tuplas para Recintos");

            generateClientesInserts(writer);
            System.out.println("Generadas " + numClientes + " tuplas para Clientes");

            generateLocalidadesInserts(writer);
            System.out.println("Generadas " + numLocalidades + " tuplas para Localidades");

            generateUsuariosInserts(writer);
            System.out.println("Generadas 5 tuplas para Usuarios");

            generateOcupaInserts(writer);
            System.out.println("Generadas " + numLocalidades * 5 + " tuplas para Ocupa");

            generatePermiteInserts(writer);
            System.out.println("Generadas " + numPermite + " tuplas para Permite");

            generateOfertasInserts(writer);
            System.out.println("Generadas " + numLocalidades * 5 + " tuplas para Ofertas");

            generateLocalidadesUsuariosInserts(writer);
            System.out.println("Generadas " + numLocalidades * 5 + " tuplas para LocalidadesUsuarios");

            generateCuestaInserts(writer);
            System.out.println("Generadas " + numLocalidades * 5 + " tuplas para Cuesta");

            writer.close();
            System.out.println("\nArchivo " + fileName + " creado exitosamente con "
                    + (numEspectaculos * 2 + numClientes + numLocalidades * 21 + numPermite + 5) + " tuplas");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void generateEspectaculosInserts(BufferedWriter writer) throws IOException {
        Random random = new Random();
        Set<String> combinaciones = new HashSet<>();

        writer.write(
                "INSERT INTO Espectaculos (titulo, tipo_espec, productor, limite_entradas, tiempo_reserva, tiempo_anulacion, penalizacion) VALUES\n");
        for (int i = 0; i < numEspectaculos; i++) {
            String titulo = generateRandomString(random, 10);
            String tipo = generateRandomString(random, 5);
            String productor = generateRandomString(random, 10);

            // Verificar que la combinación de título, tipo y productor no se repita
            String combinacion = titulo + tipo + productor;
            if (combinaciones.contains(combinacion)) {
                i--; // Intentar de nuevo con una combinación diferente
                continue;
            }
            combinaciones.add(combinacion);

            int limiteEntradas = random.nextInt(20) + 1; // Número aleatorio entre 1 y 20
            int tiempoReserva = random.nextInt(10000) + 1; // Número aleatorio entre 1 y 10000
            int tiempoAnulacion = random.nextInt(10000) + 1; // Número aleatorio entre 1 y 10000
            int penalizacion = random.nextInt(81) + 10; // Número aleatorio entre 10 y 90

            // Escribir insert en el archivo
            writer.write("('" + titulo + "', '" + tipo + "', '" + productor + "', " + limiteEntradas + ", "
                    + tiempoReserva + ", " + tiempoAnulacion + ", " + penalizacion + ")");
            if (i < numEspectaculos - 1) {
                writer.write(",\n");
            } else {
                writer.write(";\n\n");
            }
        }
    }

    private static void generateRecintosInserts(BufferedWriter writer) throws IOException {
        Random random = new Random();
        Set<String> combinaciones = new HashSet<>();

        writer.write("INSERT INTO Recintos (direccion, fecha, id_espectaculo) VALUES\n");
        for (int i = 1; i <= numEspectaculos; i++) {
            String direccion = generateRandomString(random, 10);
            // Generar fecha aleatoria dentro del rango
            long now = System.currentTimeMillis();
            long monthAgo = now - (30L * 24 * 60 * 60 * 1000); // Un mes en milisegundos
            long yearFromNow = now + (365L * 24 * 60 * 60 * 1000); // Un año desde ahora en milisegundos
            long fecha = monthAgo + (long) (random.nextDouble() * (yearFromNow - monthAgo));
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String fechaStr = dateFormat.format(new Timestamp(fecha));

            // Verificar que la combinación de dirección y fecha no se repita
            String combinacion = direccion + fechaStr;
            if (combinaciones.contains(combinacion)) {
                i--; // Intentar de nuevo con una combinación diferente
                continue;
            }
            combinaciones.add(combinacion);

            // Asociar el recinto a un espectáculo aleatorio
            int idEspectaculo = i;

            // Escribir insert en el archivo
            writer.write("('" + direccion + "', '" + fechaStr + "', " + idEspectaculo + ")");
            if (i < numEspectaculos) {
                writer.write(",\n");
            } else {
                writer.write(";\n\n");
            }
        }
    }

    private static void generateClientesInserts(BufferedWriter writer)
            throws IOException {
        Random random = new Random();

        writer.write("INSERT INTO Clientes (num_tarjeta) VALUES\n");
        for (int i = 0; i < numClientes; i++) {
            int numTarjeta;
            do {
                numTarjeta = random.nextInt(1000000) + 1; // Número aleatorio entre 1 y 1,000,000
            } while (numerosTarjeta.contains(numTarjeta)); // Verificar que la tarjeta no se repita
            numerosTarjeta.add(numTarjeta);

            // Escribir insert en el archivo
            writer.write("(" + numTarjeta + ")");
            if (i < numClientes - 1) {
                writer.write(",\n");
            } else {
                writer.write(";\n\n");
            }
        }
    }

    private static void generateLocalidadesInserts(BufferedWriter writer) throws IOException {
        Random random = new Random();
        Set<String> combinaciones = new HashSet<>();

        writer.write("INSERT INTO Localidades (ubicacion, grada, id_espectaculo, id_recinto, num_tarjeta) VALUES\n");
        for (int i = 1; i <= numEspectaculos; i++) {
            int numGradas = random.nextInt(maxGradas - minGradas + 1) + minGradas; // Entre 1 y 5 gradas por recinto

            for (int j = 1; j <= numGradas; j++) {
                String grada = generateRandomString(random, 5);
                int numUbicaciones = random.nextInt(maxUbicaciones - minUbicaciones + 1) + minUbicaciones; // Entre 10 y
                                                                                                           // 50
                                                                                                           // ubicaciones
                                                                                                           // por grada

                for (int k = 1; k <= numUbicaciones; k++) {
                    String ubicacion = Character.toString((char) (65 + k / 10)) + (k % 10);
                    // Asociar la localidad a un espectáculo y recinto aleatorio
                    int idEspectaculo = i;
                    int idRecinto = i;

                    // Determinar si el num_tarjeta será null (50% de probabilidad)
                    Integer numTarjeta = null;
                    if (random.nextDouble() < 0.5 && !numerosTarjeta.isEmpty()) {
                        numTarjeta = numerosTarjeta.get(random.nextInt(numerosTarjeta.size()));
                    }

                    // Verificar que la combinación de ubicación, grada y recinto no se repita
                    String combinacion = ubicacion + grada + idRecinto;
                    if (combinaciones.contains(combinacion)) {
                        k--; // Intentar de nuevo con una combinación diferente
                        continue;
                    }
                    combinaciones.add(combinacion);
                    numLocalidades++;
                    localidadesRecintos
                            .add(new int[] { numLocalidades, idRecinto, numTarjeta != null ? numTarjeta : -1 });

                    // Escribir insert en el archivo
                    writer.write("('" + ubicacion + "', '" + grada + "', " + idEspectaculo + ", " + idRecinto + ", "
                            + numTarjeta + ")");
                    if (!(i == numEspectaculos && j == numGradas && k == numUbicaciones)) {
                        writer.write(",\n");
                    } else {
                        writer.write(";\n\n");
                    }
                }
            }
        }
    }

    private static void generateUsuariosInserts(BufferedWriter writer) throws IOException {
        writer.write("INSERT INTO Usuarios (tipo_usuario) VALUES\n");

        for (int i = 0; i < tiposUsuarios.length; i++) {
            writer.write("('" + tiposUsuarios[i] + "')");
            if (i < tiposUsuarios.length - 1) {
                writer.write(",\n");
            } else {
                writer.write(";\n\n");
            }
        }
    }

    private static void generateOcupaInserts(BufferedWriter writer) throws IOException {
        writer.write("INSERT INTO Ocupa (tipo_usuario, id_localidad) VALUES\n");

        int idLocalidad = 1; // Empezamos con la primera localidad
        for (int i = 0; i < numLocalidades; i++) {
            for (String tipoUsuario : tiposUsuarios) {
                writer.write("('" + tipoUsuario + "', " + idLocalidad + ")");
                if (i < numLocalidades - 1 || tipoUsuario != "Parado") {
                    writer.write(",\n");
                } else {
                    writer.write(";\n\n");
                }
            }
            idLocalidad++; // Pasamos a la siguiente localidad
        }
    }

    private static void generatePermiteInserts(BufferedWriter writer) throws IOException {
        writer.write("INSERT INTO Permite (tipo_usuario, id_espectaculo) VALUES\n");

        Random random = new Random();

        for (int i = 1; i <= numEspectaculos; i++) {
            // Generamos aleatoriamente cuántos tipos de usuarios se permiten, entre 1 y 5
            int numTiposPermitidos = random.nextInt(5) + 1;

            // Barajamos aleatoriamente los tipos de usuarios disponibles
            List<String> tiposPermitidos = new ArrayList<>(Arrays.asList(tiposUsuarios));
            Collections.shuffle(tiposPermitidos);

            // Seleccionamos los primeros numTiposPermitidos tipos de usuarios de la lista
            // barajada
            tiposPermitidos = tiposPermitidos.subList(0, numTiposPermitidos);

            // Generamos un insert para cada tipo de usuario permitido en este espectáculo
            for (String tipoUsuario : tiposPermitidos) {
                writer.write("('" + tipoUsuario + "', " + i + ")");
                numPermite++;
                if (i < numEspectaculos || tipoUsuario != tiposPermitidos.get(numTiposPermitidos - 1)) {
                    writer.write(",\n");
                } else {
                    writer.write(";\n\n");
                }
            }
        }
    }

    private static void generateOfertasInserts(BufferedWriter writer) throws IOException {
        writer.write(
                "INSERT INTO Ofertas (id_espectaculo, id_recinto, id_localidad, tipo_usuario, num_tarjeta) VALUES\n");

        for (int[] localidadRecinto : localidadesRecintos) {
            int idLocalidad = localidadRecinto[0];
            int idRecinto = localidadRecinto[1];
            int num_tarjeta = localidadRecinto[2];
            Random random = new Random();
            int tipoUsuarioAsignadoIndex = random.nextInt(tiposUsuarios.length);

            // Generar inserts para cada tipo de usuario
            for (int i = 0; i < tiposUsuarios.length; i++) {

                int numTarjeta = (i == tipoUsuarioAsignadoIndex) ? num_tarjeta : -1;

                writer.write("(" + idRecinto + ", " + idRecinto + ", " + idLocalidad + ", '" + tiposUsuarios[i] + "', "
                        + (numTarjeta != -1 ? numTarjeta : "NULL") + ")");
                if (idLocalidad < numLocalidades || tiposUsuarios[i] != "Parado") {
                    writer.write(",\n");
                } else {
                    writer.write(";\n\n");
                }
            }
        }
    }

    private static void generateLocalidadesUsuariosInserts(BufferedWriter writer) throws IOException {
        writer.write(
                "INSERT INTO LocalidadesUsuarios (id_espectaculo, id_recinto, id_localidad, tipo_usuario) VALUES\n");

        for (int[] localidadRecinto : localidadesRecintos) {
            int idLocalidad = localidadRecinto[0];
            int idRecinto = localidadRecinto[1];

            // Generar inserts para cada tipo de usuario
            for (String tipoUsuario : tiposUsuarios) {
                writer.write("(" + idRecinto + ", " + idRecinto + ", " + idLocalidad + ", '" + tipoUsuario + "')");
                if (idLocalidad < numLocalidades || tipoUsuario != "Parado") {
                    writer.write(",\n");
                } else {
                    writer.write(";\n\n");
                }
            }
        }
    }

    private static void generateCuestaInserts(BufferedWriter writer) throws IOException {
        writer.write("INSERT INTO Cuesta (precio, id_espectaculo, id_recinto, id_localidad, tipo_usuario) VALUES\n");

        Random random = new Random();

        for (int[] localidadRecinto : localidadesRecintos) {
            int idLocalidad = localidadRecinto[0];
            int idRecinto = localidadRecinto[1];

            // Generar inserts para cada tipo de usuario
            for (String tipoUsuario : tiposUsuarios) {
                // Generar un precio aleatorio entre 10 y 100
                double precio = 10 + (random.nextDouble() * (100 - 10));

                writer.write("(" + String.format("%.2f", precio) + ", " + idRecinto + ", " + idRecinto + ", "
                        + idLocalidad + ", '" + tipoUsuario + "')");
                if (idLocalidad < numLocalidades || tipoUsuario != "Parado") {
                    writer.write(",\n");
                } else {
                    writer.write(";");
                }
            }
        }
    }

    private static String generateRandomString(Random random, int length) {
        String caracteres = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            int index = random.nextInt(caracteres.length());
            sb.append(caracteres.charAt(index));
        }
        return sb.toString();
    }
}
