# 🎵 Optimización Estratégica de Catálogo Musical en Spotify: Análisis de Rendimiento y Recomendaciones para A&R

## 📌 1. Resumen Ejecutivo y Contexto de Negocio
En la industria musical contemporánea, los sellos discográficos y equipos de A&R (*Artists and Repertoire*) enfrentan altos costos de captación de talento y saturación en plataformas de streaming. 

Este proyecto audita un catálogo de **8,582 canciones** de Spotify para resolver preguntas directas de inversión mediante análisis exploratorio en **SQL** y visualización ejecutiva en **Power BI**:
- **Formatos y Retención:** ¿Qué formatos de duración garantizan mayor retención y engagement?
- **Riesgo y Distribución:** ¿Cómo impacta el contenido explícito en la distribución comercial y masiva?
- **Estrategia de Catálogo:** ¿Cómo capitalizar el éxito de los temas insignia (*Lead Singles*) frente a los temas secundarios (*deep cuts*)?

---

## 🛠️ 2. Stack Técnico y Arquitectura
* **Motor de Base de Datos:** SQL / SQLite (consultas analíticas, agregaciones, funciones de ventana `ROW_NUMBER`).
* **Inteligencia de Negocios:** Power BI Desktop (modelado tabular, DAX para métricas de popularidad y diseño de dashboard directivo).
* **Control de Versiones:** Git / GitHub.

---

## 📊 3. Dashboard Ejecutivo (Power BI)
<img width="953" height="485" alt="Vista Previa del Dashboard en Power BI" src="https://github.com/user-attachments/assets/c158f643-ab54-4daf-ae41-4e62e47aa6cc" />

### Indicadores Clave de Negocio (KPIs)
* **Volumen Total del Catálogo:** 8,582 canciones analizadas.
* **Popularidad Promedio Global:** 52.36 / 100 puntos.
* **Duración Promedio por Pista:** 3.49 minutos (~3 min 29 seg).

---

## 🔍 4. Consultas Analíticas y Decisiones de Negocio (SQL)

### Pregunta 1: Benchmarking de Éxitos Globales
* **Objetivo de Negocio:** Identificar las referencias de producción musical con los picos más altos de consumo para guiar presupuestos de pauta digital.

```sql
-- Top 10 temas con mayor tracción en la plataforma
SELECT 
    track_name,
    artist_name,
    track_popularity
FROM DataSpotify
ORDER BY track_popularity DESC
LIMIT 10;
```
<img width="593" height="386" alt="image" src="https://github.com/user-attachments/assets/b41ed927-9fff-4170-8c70-31f047942eed" />

Pregunta 2: Duración Óptima según Estrategia de Lanzamiento
Objetivo de Negocio: Evaluar si los usuarios toleran mayor duración en álbumes conceptuales frente a sencillos promocionales (singles).

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
<img width="587" height="390" alt="image" src="https://github.com/user-attachments/assets/b494030d-83bc-4657-9de5-94d73813afe3" />

Pregunta 3: Evaluación de Riesgo en Distribución de Contenido Explícito
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
<img width="593" height="102" alt="image" src="https://github.com/user-attachments/assets/de1a6519-298a-400b-811c-cae4479b63cc" />

Pregunta 4: Concentración de Audiencia y Potencial de Co-Branding
Objetivo de Negocio: Detectar líderes en base de seguidores para negociar colaboraciones (features) que amplifiquen nuevos lanzamientos.

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
<img width="467" height="216" alt="image" src="https://github.com/user-attachments/assets/b254cd15-07f3-4256-84c5-8e67e7fcb39f" />

Pregunta 5: Rentabilidad y Popularidad por Vertical de Género
Objetivo de Negocio: Priorizar inversiones de captación de artistas en los géneros que entregan mayor rendimiento promedio sostenido.

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
<img width="574" height="430" alt="image" src="https://github.com/user-attachments/assets/ff7373ec-b43b-4f26-b1f1-b53621a5174f" />

Pregunta 6: Efecto Marca del Artista vs. Rendimiento de Catálogo
Objetivo de Negocio: Determinar si un artista de alta popularidad garantiza el éxito de sus pistas de relleno (deep cuts).

```SQL
-- Comparativa entre la popularidad de marca del artista y el promedio de sus canciones
SELECT 
    artist_name,
    artist_popularity AS indice_popularidad_artista,
    ROUND(AVG(track_popularity), 2) AS popularidad_promedio_canciones,
    COUNT(*) AS total_canciones_analizadas
FROM DataSpotify
GROUP BY artist_name, artist_popularity
ORDER BY artist_popularity DESC
LIMIT 15;
```
<img width="701" height="422" alt="image" src="https://github.com/user-attachments/assets/36ba77e6-69da-41ea-8361-eac4323c4051" />

Pregunta 7: Detección de Lead Singles mediante Funciones de Ventana
Objetivo de Negocio: Extraer el activo insignia de cada artista para utilizarlo como punta de lanza en campañas de marketing.

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
<img width="583" height="413" alt="image" src="https://github.com/user-attachments/assets/f28391c4-210a-4ff7-9b81-60e491c3597e" />

Pregunta 8: Validación de Formatos Sonoros (Tendencia vs. Rendimiento)
Objetivo de Negocio: Evaluar el impacto comercial de los temas breves impulsados por redes sociales frente a estructuras musicales tradicionales.

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
<img width="626" height="149" alt="image" src="https://github.com/user-attachments/assets/a4b18894-0d5d-49b0-8e25-673f4ac6e6c7" />

💡 5. Hallazgos Clave y Conclusiones Estratégicas
1. El Mito de la Canción Ultracorta
A pesar de la proliferación de formatos breves (<2.5 min) en plataformas de video corto, los datos demuestran que en streaming estos temas presentan el menor promedio de popularidad (42.14 puntos). Por el contrario, los temas con desarrollo completo (>3.5 min) obtienen el mejor desempeño promedio (54.86 puntos), superando a los cortos por más de 12 puntos.

Recomendación A&R: No recortar la estructura melódica ni apresurar canciones en producción si el objetivo principal es la retención y la monetización en streaming de largo plazo.

2. Efecto Embudo en Discografías Extensas
Artistas consolidados con popularidad superior a 95 puntos suelen registrar promedios de canciones de catálogo alrededor de 60 puntos. Esto confirma que el consumo digital se concentra fuertemente en el Lead Single.

Recomendación A&R: Diseñar estrategias de retención dentro de las plataformas que enlacen el tema insignia con pistas secundarias del mismo artista mediante enlaces directos en descripciones y listas recomendadas.

3. Políticas de Distribución de Contenido Apto
Aproximadamente el 75% del catálogo corresponde a canciones aptas para todo público (clean).

Recomendación A&R: Asegurar siempre el lanzamiento simultáneo de versiones clean en canciones de géneros urbanos y alternativos para acceder a las listas editoriales de Spotify con mayor penetración comercial.

 4. Concentración de Popularidad y Tratamiento de Empates (Top 10)
Los subgéneros líderes (pop soul con 90 pts, corridos tumbados y alternative r&b con 87 pts) superan en más de 30 puntos la media global. En el límite inferior del Top 10 se registran empates en 84 puntos (country, glam rock, latin house y reggaeton chileno), los cuales se conservaron en la visualización para reflejar la diversidad de estilos que logran tracción masiva sin alterar arbitrariamente el umbral de corte.

```
📁 6. Estructura del Repositorio
Plaintext
├── assets/                  # Capturas de pantalla y evidencias del informe
├── data/                    # Dataset base de Spotify (.csv / .sqlite)
├── Spotify_Analysis.pbix    # Reporte interactivo de Power BI
└── README.md                # Documentación ejecutiva del proyecto
```
