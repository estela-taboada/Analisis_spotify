# 🎵🎵Optimización Estratégica de Catálogo Musical en Spotify: Análisis de Rendimiento y Recomendaciones para A&R

## 1. Resumen Ejecutivo y Contexto de Negocio
En la industria musical contemporánea, los sellos discográficos y equipos de A&R (Artists and Repertoire) enfrentan altos costos de captación de talento y saturación en plataformas de streaming. 
Este proyecto audita un catálogo de más de 8,500 canciones de Spotify para resolver preguntas directas de inversión:

* ¿Qué formatos de duración garantizan mayor retención y engagement?
* ¿Cómo impacta el contenido explícito en la distribución comercial y masiva?
* ¿Cómo capitalizar el éxito de los temas principales (Lead Singles) frente a los temas secundarios (deep cuts)?

## 2. Stack Técnico y Arquitectura de Datos
* Motor de Base de Datos: SQL / SQLite (consultas analíticas, agregaciones, funciones de ventana ROW_NUMBER).
* Inteligencia de Negocios: Power BI Desktop (modelado de datos, DAX para métricas de popularidad y diseño de dashboard directivo).
* Control de Versiones: Git / GitHub.
  
## 3. Consultas Analíticas y Decisiones de Negocio (SQL)

### Pregunta 1: Benchmarking de Éxitos Globales
Objetivo de Negocio: 
Identificar las referencias de producción musical con los picos más altos de consumo para guiar presupuestos de pauta digital.

```SQL
-- Top 10 temas con mayor tracción en la plataforma
SELECT 
    track_name,
    artist_name,
    track_popularity
FROM DataSpotify
ORDER BY track_popularity DESC
LIMIT 10;
```
<img width="580" height="391" alt="image" src="https://github.com/user-attachments/assets/e1fa8a43-cfc9-4f90-bcc2-c0fa43adecfb" />

### Pregunta 2: Duración Óptima según Estrategia de Lanzamiento
Objetivo de Negocio: 
Evaluar si los usuarios toleran mayor duración en álbumes conceptuales frente a sencillos promocionales (singles).

```SQL
-- Duración promedio según el formato de publicación
SELECT 
    album_type,
    ROUND(AVG(track_duration_m), 2) AS promedio_duracion_min,
    COUNT(*) AS volumen_lanzamientos
FROM DataSpotify
GROUP BY album_type
ORDER BY promedio_duracion_min DESC;
```
<img width="616" height="141" alt="image" src="https://github.com/user-attachments/assets/b5aeb2ec-3cf6-49fa-b606-cf16bf8bb670" />

### Pregunta 3: Evaluación de Riesgo en Distribución de Contenido Explícito
Objetivo de Negocio: Dimensionar la proporción de catálogo restringido para alianzas con marcas y playlists familiares.

```SQL
-- Segmentación de catálogo por tipo de contenido
SELECT 
    CASE 
        WHEN explicit = 1 THEN 'Contenido Explícito'
        ELSE 'Apto para Todo Público'
    END AS tipo_clasificacion,
    COUNT(*) AS total_canciones,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM DataSpotify), 2) AS porcentaje_catalogo
FROM DataSpotify 
GROUP BY explicit;
```
<img width="599" height="123" alt="image" src="https://github.com/user-attachments/assets/ea03f544-4bd2-422d-8fe4-b127eea1d269" />

### Pregunta 4: Concentración de Audiencia y Potencial de Co-Branding
Objetivo de Negocio:
Detectar a los líderes de base de seguidores para negociar colaboraciones (features) que amplifiquen nuevos lanzamientos.

```SQL
-- Top 5 artistas por volumen de seguidores acumulados
SELECT 
    artist_name,
    MAX(artist_followers) AS total_seguidores
FROM DataSpotify
GROUP BY artist_name
ORDER BY total_seguidores DESC
LIMIT 5;
```
<img width="467" height="232" alt="image" src="https://github.com/user-attachments/assets/44f47fc0-d09b-4941-bc15-2e5758c4aae9" />

### Pregunta 5: Rentabilidad y Popularidad por Vertical de Género
Objetivo de Negocio:
Priorizar inversiones de captación de artistas en los géneros que entregan mayor rendimiento promedio sostenido.

```SQL
-- Géneros con mayor tracción promedio y masa crítica (>10 temas)
SELECT 
    artist_genres,
    ROUND(AVG(track_popularity), 2) AS popularidad_promedio,
    COUNT(*) AS volumen_pistas
FROM DataSpotify
WHERE artist_genres != 'N/A' AND artist_genres IS NOT NULL
GROUP BY artist_genres
HAVING COUNT(*) >= 10
ORDER BY popularidad_promedio DESC
LIMIT 15;
```
<img width="609" height="431" alt="image" src="https://github.com/user-attachments/assets/6868232b-31f5-4fdc-a71b-aa84c24b71c3" />

### Pregunta 6: Efecto Marca del Artista vs. Rendimiento de Catálogo
Objetivo de Negocio: 
Determinar si un artista de alta popularidad garantiza el éxito de sus pistas de relleno (deep cuts).

```SQL
-- Comparativa entre la popularidad de marca del artista y el promedio de sus canciones
SELECT 
    artist_name,
    artist_popularit AS indice_popularidad_artista,
    ROUND(AVG(track_popularity), 2) AS popularidad_promedio_canciones,
    COUNT(*) AS total_canciones_analizadas
FROM DataSpotify
GROUP BY artist_name, artist_popularit
ORDER BY artist_popularit DESC
LIMIT 15;
```
<img width="694" height="420" alt="image" src="https://github.com/user-attachments/assets/32488329-aca6-4356-8f31-b290bda9b2c3" />

### Pregunta 7: Detección de Lead Singles mediante Funciones de Ventana
Objetivo de Negocio:
Extraer el activo insignia de cada artista para utilizarlo como punta de lanza en campañas de marketing y re-marketing.

```SQL
-- Canción líder por artista usando Window Functions
WITH CancionesRankeadas AS (
    SELECT 
        artist_name,
        track_name,
        track_popularity,
        ROW_NUMBER() OVER(
            PARTITION BY artist_name 
            ORDER BY track_popularity DESC
        ) AS ranking_artista
    FROM DataSpotify
)
SELECT 
    artist_name,
    track_name AS lead_single,
    track_popularity
FROM CancionesRankeadas
WHERE ranking_artista = 1
ORDER BY track_popularity DESC;
```
<img width="582" height="429" alt="image" src="https://github.com/user-attachments/assets/724828f3-8677-46ff-bdd3-564169f7af50" />

### Pregunta 8: Validación de Formatos Sonoros (Tendencia vs. Rendimiento)
Objetivo de Negocio: 
Evaluar el impacto comercial de los temas ultracortos impulsados por redes sociales frente a estructuras musicales tradicionales.

```SQL
-- Desempeño comercial según rangos de duración
SELECT 
    CASE 
        WHEN track_duration_m < 2.5 THEN 'Corta (< 2.5 min)'
        WHEN track_duration_m BETWEEN 2.5 AND 3.5 THEN 'Media (2.5 - 3.5 min)'
        ELSE 'Larga (> 3.5 min)'
    END AS rango_duracion,
    COUNT(*) AS volumen_canciones,
    ROUND(AVG(track_popularity), 2) AS popularidad_promedio
FROM DataSpotify
GROUP BY rango_duracion
ORDER BY popularidad_promedio DESC;
```
<img width="626" height="142" alt="image" src="https://github.com/user-attachments/assets/77f7c6a6-ff7a-4aed-8551-2758acbe2a2c" />

## 4. Hallazgos Clave y Conclusiones del Negocio
### * El Mito de la Canción Ultracorta:
A pesar de la proliferación de formatos breves (<2.5 min) en plataformas de video corto, los datos demuestran que en streaming estos temas presentan el menor promedio de popularidad (42.14 puntos). Por el contrario, los temas con desarrollo completo (>3.5 min) obtienen el mejor desempeño promedio (54.86 puntos), superando a los cortos por más de 12 puntos.
### Recomendación:
 No recortar la estructura melódica ni apresurar temas en producción si el objetivo principal es la retención y la monetización en streaming de largo plazo.

### * Efecto Embudo en Discografías Extensas:
Artistas consolidados con popularidad superior a 95 puntos suelen registrar promedios de canciones alrededor de 60 puntos. Esto confirma que el consumo digital se concentra fuertemente en el Lead Single.
### Recomendación:
Diseñar estrategias de retención dentro de las plataformas que enlacen el tema insignia con pistas secundarias del mismo artista mediante enlaces directos en descripciones y listas recomendadas.

### * Políticas de Distribución de Contenido Apto:
Aproximadamente el 75% del catálogo corresponde a canciones aptas para todo público (clean).
### Recomendación:
Asegurar siempre el lanzamiento simultáneo de versiones clean en canciones de géneros urbanos y alternativos para acceder a las listas editoriales de Spotify con mayor penetración comercial.
