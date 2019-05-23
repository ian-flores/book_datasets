library(tidyverse)

escuelas <- read_csv('directorio_escuelas/directorio_comprensivo_de_escuelas_publicas_puerto_rico_2018.csv')

wide_escuelas <- escuelas %>%
    select(escuela = ESCUELA,
           region = REGION,
           distrito = DISTRITO,
           total_matricula = MATRICULA_TOTAL,
           contains('BÁSICO'),
           contains('AVANZADO'),
           contains('2018')) %>%
    select(-contains('PRE'), -contains('[')) %>%
    rename(espa_basico = 'ESPAÑOL_BÁSICO',
           mate_basico = 'MATEMÁTICAS_BÁSICO',
           ingl_basico = 'INGLÉS_BÁSICO',
           espa_avanzado = 'ESPAÑOL_AVANZADO',
           mate_avanzado = 'MATEMÁTICAS_AVANZADO',
           ingl_avanzado = 'INGLÉS_AVANZADO',
           operacional = 'OPERACIONAL_2018-2019') %>%
    mutate_at(vars(espa_basico, mate_basico, ingl_basico,
                   espa_avanzado, mate_avanzado, ingl_avanzado),
              list( ~ str_replace_all(., '%', ''))) %>%
    mutate_at(vars(espa_basico, mate_basico, ingl_basico,
                   espa_avanzado, mate_avanzado, ingl_avanzado),
              list( ~ as.numeric(.)))

tidy_espa <- wide_escuelas %>%
    gather(key = 'curso', value = 'pct_estudiantes', -escuela:-total_matricula, - operacional) %>%
    separate(curso, into = c('curso', 'nivel')) %>%
    filter(curso == 'espa')

tidy_espa %>%
    write_csv('directorio_escuelas/escuelas_espanol_2018.csv')

tidy_espa %>%
    write_excel_csv('directorio_escuelas/escuelas_espanol_2018.xlsx')
