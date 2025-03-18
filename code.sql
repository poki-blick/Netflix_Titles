select count(*)  from netflix_titles nt ;

-- 1. Analisis Konten berdasrkan genre dari tahun ke tahun
SELECT 
    listed_in  ,release_year, count(*) as amount_content
FROM netflix_titles nt 
GROUP BY 
    release_year, listed_in  
ORDER BY 
    release_year desc ;

-- 2. berapa jumlah show per genre
SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', n.n), ',', -1) AS genre,
    COUNT(*) AS content_count
FROM netflix_titles
JOIN (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL 
    SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
) n ON LENGTH(listed_in) - LENGTH(REPLACE(listed_in, ',', '')) >= n.n - 1
GROUP BY 
    genre
ORDER BY 
    content_count DESC;

-- 3 jumlah type show pertahunnya
SELECT 
	  nt.release_year,
	  nt.`type`,
	  count(*) as count
FROM netflix_titles nt 
GROUP BY 
    nt.release_year, nt.`type` 
ORDER BY 
    release_year desc;

-- 4. Menganalisis Durasi Film dari Waktu ke Waktu
SELECT 
    release_year,
    COUNT(*) AS movie_count,
    AVG(CAST(REPLACE(duration, ' min', '') AS SIGNED)) AS avg_duration_minutes,
    MIN(CAST(REPLACE(duration, ' min', '') AS SIGNED)) AS min_duration,
    MAX(CAST(REPLACE(duration, ' min', '') AS SIGNED)) AS max_duration
FROM netflix_titles
WHERE 
    type = 'Movie'
    AND duration LIKE '%min%'
GROUP BY 
    release_year
ORDER BY 
    release_year DESC;

-- 5. Jumlah show berdasarkan rating pertahunnya
SELECT 
	nt.release_year,
	nt.`type`,
	nt.rating,
	count(*) as total
FROM netflix_titles nt 
WHERE 
    nt.`type` is not null
GROUP BY 
	  nt.release_year, nt.`type`,nt.rating
ORDER BY 
	  nt.release_year desc, nt.`type`,total desc;

-- 6. Distribusi konten berdasarkan negaranya
SELECT 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', numbers.n), ',', -1)) AS production_country,
    COUNT(*) AS content_count,
    COUNT(DISTINCT release_year) AS years_active
FROM 
    netflix_titles,
    (SELECT 1 as n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL 
     SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6) numbers
WHERE 
    country IS NOT NULL
    AND n <= 1 + LENGTH(country) - LENGTH(REPLACE(country, ',', ''))
GROUP BY 
    production_country
HAVING 
    production_country != ''
ORDER BY 
    content_count DESC
LIMIT 20;

-- 7. Analisis Director 
SELECT 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(director, ',', numbers.n), ',', -1)) AS director_name,
    COUNT(*) AS content_directed,
    GROUP_CONCAT(DISTINCT type ORDER BY type) AS content_types,
    COUNT(DISTINCT SUBSTRING_INDEX(listed_in, ',', 1)) AS genre_count,
    GROUP_CONCAT(DISTINCT SUBSTRING_INDEX(listed_in, ',', 1) ORDER BY listed_in SEPARATOR ', ') AS top_genres
FROM 
    netflix_titles,
    (SELECT 1 as n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL 
     SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6) numbers
WHERE 
    director IS NOT NULL
    AND n <= 1 + LENGTH(director) - LENGTH(REPLACE(director, ',', ''))
GROUP BY 
    director_name
HAVING 
    director_name != ''
    AND content_directed > 1
ORDER BY 
    content_directed DESC
LIMIT 15; 

-- 8. Jumlah Deskripsi berdasarkan kata tertentu
SELECT 
    release_year,
    COUNT(*) AS total_content,
    SUM(CASE WHEN description LIKE '%love%' THEN 1 ELSE 0 END) AS love_mentions,
    SUM(CASE WHEN description LIKE '%war%' THEN 1 ELSE 0 END) AS war_mentions,
    SUM(CASE WHEN description LIKE '%family%' THEN 1 ELSE 0 END) AS family_mentions,
    SUM(CASE WHEN description LIKE '%friend%' THEN 1 ELSE 0 END) AS friend_mentions,
    SUM(CASE WHEN description LIKE '%crime%' THEN 1 ELSE 0 END) AS crime_mentions
FROM 
    netflix_titles
WHERE 
    description IS NOT NULL
GROUP BY 
    release_year
ORDER BY 
    release_year DESC;

-- 9. Tv Show dengan lebih dari 5 seasons
SELECT 
	  title, release_year, duration
FROM netflix_titles nt 
WHERE 
	  type = "TV Show" and nt.duration > "5 Season"
GROUP BY 
	  nt.release_year, nt.title, duration 
ORDER BY 
	  nt.release_year desc;
 
-- 10. show dari Indonesia
SELECT 
	  title, release_year, director
FROM netflix_titles
WHERE 
	  TRIM(director) <> '' AND director IS NOT null
	  AND country LIKE "%Indonesia%";
