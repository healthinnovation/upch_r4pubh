r4pubh_install <- function() {
  # Paso 1: Verificar que cli esté instalado
  if (!requireNamespace("cli", quietly = TRUE)) {
    install.packages("cli", type = "binary", dependencies = TRUE)
  }
  library(cli)
  
  # Paso 2: Leer la lista de paquetes desde la URL proporcionada
  url_packages <- "https://raw.githubusercontent.com/healthinnovation/upch_r101/main/list_pckg.csv"
  packages_to_install <- read.csv(url_packages, stringsAsFactors = FALSE)$x
  
  # Paso 3: Verificar qué paquetes están instalados
  installed_packages <- installed.packages()[, "Package"]
  not_installed <- setdiff(packages_to_install, installed_packages)
  
  cli::cli_alert_info("{length(intersect(installed_packages, packages_to_install))} de {length(packages_to_install)} paquetes instalados.")
  
  # Paso 4: Instalar paquetes no instalados con una barra de progreso
  if (length(not_installed) > 0) {
    cli::cli_alert_info("Instalando los siguientes {length(not_installed)} paquetes: {paste(not_installed, collapse = ', ')}")
    
    # Crear la barra de progreso
    cli_progress_bar("Instalando paquetes", total = length(not_installed),
                     clear = FALSE)
    
    for (pkg in not_installed) {
      tryCatch({
        # Convertir advertencias en errores
        withCallingHandlers({
          # Capturar y descartar el output de install.packages
          capture.output({
            os_type <- Sys.info()["sysname"]
            if (os_type == "Linux") {
              install.packages(pkg, type = "source", quiet = TRUE)
            } else {
              null_conn <- file("NUL", open = "wt")
              # Redirige la salida de mensajes a la conexión nula
              sink(null_conn, type = "message")
              install.packages(pkg, type = "binary", quiet = TRUE)
              sink(type = "message")
            }
          }, file = NULL)
        }, warning = function(w) {
          stop(w)
        })
        cli_progress_update() # Actualizar la barra de progreso
      }, error = function(e) {
        cli::cli_alert_danger("Hubo un problema instalando el paquete {pkg}.")
      })
    }
    
    cli_progress_done() # Finalizar la barra de progreso
  }
  
  # Paso 5: Verificar si todos los paquetes están instalados
  installed_packages <- installed.packages()[, "Package"]
  if (all(packages_to_install %in% installed_packages)) {
    cli::cli_alert_success("Todos los paquetes instalados.")
  } else {
    not_installed <- setdiff(packages_to_install, installed_packages)
    cli::cli_alert_danger("Hubo un problema con los siguientes paquetes: {paste(not_installed, collapse = ', ')}. Por favor, comunícalo.")
  }
}

# Llamar a la función
r4pubh_install()
