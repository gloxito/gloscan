# 🔐 Gloscan

> Automatización de reconocimiento en entornos CTF y de pentesting local.

---

## 📌 ¿Qué es Gloscan?

**Gloscan** es una herramienta en Bash diseñada para automatizar tareas iniciales de reconocimiento de red en escenarios de **hacking ético**, **CTF (Capture The Flag)** o laboratorios de **pentesting local**.

---

## 🎯 ¿Para qué sirve?

Este script permite:

- Detectar tu IP local desde una interfaz de red activa.
- Escanear automáticamente una red para encontrar dispositivos conectados.
- Detectar puertos abiertos y servicios con `nmap`.
- Añadir dominios web encontrados al archivo `/etc/hosts`.
- Almacenar resultados de escaneo organizados por IP víctima.
- Validar entradas del usuario para evitar errores y repeticiones innecesarias.

Todo esto, con mínima intervención por parte del usuario.

---

## 👤 ¿A quién va dirigida esta herramienta?

- Estudiantes y practicantes de **ciberseguridad**.
- Participantes de plataformas como **TryHackMe**, **HackTheBox**, etc.
- Profesionales que deseen agilizar la fase de reconocimiento en auditorías locales.
- Docentes o formadores que necesitan automatizar entornos de práctica.

---

## ⚙️ ¿Cómo funciona?

### A nivel técnico (script):

1. **Verificación de herramientas**: Detecta si `nmap` y `arp-scan` están instaladas, e intenta instalarlas si no.
2. **Preparación del entorno**: Crea una carpeta `gloscan` con subdirectorios para guardar resultados (`nmap/`, `arp/`).
3. **Selección de interfaz**: Lista interfaces activas y solicita al usuario que seleccione una.
4. **Obtención de IP local**: Detecta la IP del atacante desde la interfaz indicada.
5. **IP de la víctima**:
   - Si el usuario no la conoce, se escanea el rango de red con `arp-scan`.
   - Se permite escanear una IP específica o todas las detectadas.
   - También se puede introducir una IP manual válida.
6. **Escaneo con nmap**:
   - Escaneo total de puertos y servicios con scripts (`-A`, `-T4`, `--min-rate 4000`).
   - Filtra dominios detectados y los añade automáticamente a `/etc/hosts`.
   - Los resultados se almacenan por IP en carpetas separadas.
7. **Resultados**: Se muestran de forma limpia por pantalla y se guardan en `gloscan/resultados_escaneo`.

---

## A nivel de uso

1. Descarga el script usando `wget` desde el repositorio oficial.
  ``` bash
   wget https://github.com/gloxito/gloscan.git

  ```

2. Asigna permisos de ejecución al script descargado.

  ``` bash
   chmod +x gloscan

  ```
3. Ejecuta el script, preferiblemente con privilegios de root para asegurar su correcto funcionamiento.

``` bash
   ./gloscan

  ```

4. Puedes añadir el flag --include-gateway si deseas incluir IPs como .1, .2 y .254 ( opcional )

``` bash
   ./gloscan.sh --include-gateway

  ```

**Nota:** Ejecutar como root permite que el script use herramientas como `arp-scan` y modifique el archivo `/etc/hosts` sin problemas.
