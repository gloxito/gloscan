# 🔐 Gloscan

> Automatización de reconocimiento en entornos CTF y de pentesting local.

---

## 📌 ¿Qué es gloscan?

**Gloscan** es un script en Bash diseñado para automatizar tareas iniciales de reconocimiento de red en escenarios de **hacking ético**, **CTF (Capture The Flag)**, o laboratorios de **pentesting local**.

---

## 🎯 ¿Para qué sirve?

Este script permite:

- Detectar tu IP local desde una interfaz de red activa.
- Escanear automáticamente una red para encontrar dispositivos conectados.
- Detectar puertos abiertos y servicios con `nmap`.
- Añadir dominios web encontrados al archivo `/etc/hosts`.
- Almacenar resultados de escaneo de manera ordenada en carpetas específicas.

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
2. **Preparación del entorno**: Crea una carpeta `gloscan` con subdirectorios para guardar resultados (`nmap/`, `arp-scan/`).
3. **Selección de interfaz**: Lista interfaces activas y solicita al usuario que seleccione una.
4. **Obtención de IP local**: Detecta la IP del atacante desde la interfaz indicada.
5. **IP de la víctima**:
   - Si el usuario no la conoce, se escanea el rango de red con `arp-scan`.
   - Si se conoce, se ingresa manualmente.
6. **Escaneo con nmap**:
   - Escaneo total de puertos y servicios con scripts (`-sSCV`, `-p-`, `--open`, `-T5`).
   - Filtra dominios detectados y los añade a `/etc/hosts`.
7. **Resultados**: Se muestran por pantalla y se almacenan en `gloscan/resultados_escaneo`.

---

## A nivel de uso

1. Descarga el script usando `wget` desde el repositorio oficial.
  ``` bash
   wget https://github.com/gloxito/gloker.git

  ```

2. Asigna permisos de ejecución al script descargado.

  ``` bash
   chmod +x gloker

  ```
3. Ejecuta el script, preferiblemente con privilegios de root para asegurar su correcto funcionamiento.

``` bash
   ./gloker

  ```

**Nota:** Ejecutar como root permite que el script use herramientas como `arp-scan` y modifique el archivo `/etc/hosts` sin problemas.
