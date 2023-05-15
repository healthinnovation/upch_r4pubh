url_packages = "https://raw.githubusercontent.com/healthinnovation/upch_r101/main/list_pckg.csv"

packages_df = read.csv(url_packages, stringsAsFactors = FALSE)

packages = unlist(packages_df)

options(install.packages.compile.from.source = "always")

install.packages(packages, dependencies = TRUE)

options(install.packages.compile.from.source = "interactive")

rm(url_packages, packages_df, packages)
