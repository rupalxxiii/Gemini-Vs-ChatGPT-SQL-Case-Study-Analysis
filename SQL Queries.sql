-- QUESTIONS


-- 1)What are the average scores for each capability on both the Gemini Ultra and GPT-4 models?
SELECT c.CapabilityName,
       AVG(b.ScoreGemini) AS AvgScoreGeminiUltra,
       AVG(b.ScoreGPT4) AS AvgScoreGPT4
FROM Capabilities c
LEFT JOIN Benchmarks b ON c.CapabilityID = b.CapabilityID
GROUP BY c.CapabilityName;


-- 2)Which benchmarks does Gemini Ultra outperform GPT-4 in terms of scores?

SELECT BenchmarkName
FROM Benchmarks
WHERE ScoreGemini > ScoreGPT4;

-- 3)What are the highest scores achieved by Gemini Ultra and GPT-4 for each benchmark in the Image capability?

SELECT b.BenchmarkName,
       MAX(b.ScoreGemini) AS MaxScoreGeminiUltra,
       MAX(b.ScoreGPT4) AS MaxScoreGPT4
FROM Benchmarks b
JOIN Capabilities c ON b.CapabilityID = c.CapabilityID
WHERE c.CapabilityName = 'Image'
GROUP BY b.BenchmarkName;

-- 4)Calculate the percentage improvement of Gemini Ultra over GPT-4 for each benchmark?

SELECT BenchmarkName,
       ((ScoreGemini - ScoreGPT4) / ScoreGPT4) * 100 AS PercentageImprovement
FROM Benchmarks
WHERE ScoreGPT4 IS NOT NULL;

-- 5)Retrieve the benchmarks where both models scored above the average for their respective models?

WITH AvgScores AS (
    SELECT AVG(ScoreGemini) AS AvgGemini, AVG(ScoreGPT4) AS AvgGPT4
    FROM Benchmarks
)
SELECT BenchmarkName
FROM Benchmarks, AvgScores
WHERE ScoreGemini > (SELECT AvgGemini FROM AvgScores)
  AND ScoreGPT4 > (SELECT AvgGPT4 FROM AvgScores);

-- 6)Which benchmarks show that Gemini Ultra is expected to outperform GPT-4 based on the next score?

SELECT BenchmarkName
FROM Benchmarks
WHERE ScoreGemini > (SELECT AVG(ScoreGemini) FROM Benchmarks)
  AND ScoreGPT4 < (SELECT AVG(ScoreGPT4) FROM Benchmarks);

-- 7)Classify benchmarks into performance categories based on score ranges?

SELECT BenchmarkName,
       CASE
           WHEN ScoreGemini >= 90 AND ScoreGPT4 >= 90 THEN 'High Performance'
           WHEN ScoreGemini >= 80 AND ScoreGPT4 >= 80 THEN 'Good Performance'
           WHEN ScoreGemini >= 70 AND ScoreGPT4 >= 70 THEN 'Fair Performance'
           ELSE 'Low Performance'
       END AS PerformanceCategory
FROM Benchmarks;

-- 8) Retrieve the rankings for each capability based on Gemini Ultra scores?

WITH GeminiRankings AS (
    SELECT c.CapabilityName, b.BenchmarkName, b.ScoreGemini,
           DENSE_RANK() OVER (PARTITION BY c.CapabilityID ORDER BY b.ScoreGemini DESC) AS GeminiRank
    FROM Capabilities c
    JOIN Benchmarks b ON c.CapabilityID = b.CapabilityID
    WHERE b.ScoreGemini IS NOT NULL
)
SELECT CapabilityName, BenchmarkName, ScoreGemini, GeminiRank
FROM GeminiRankings
WHERE GeminiRank = 1;

-- 9)Convert the Capability and Benchmark names to uppercase?

SELECT UPPER(CapabilityName) AS CapabilityName, UPPER(BenchmarkName) AS BenchmarkName
FROM Capabilities c
JOIN Benchmarks b ON c.CapabilityID = b.CapabilityID;

-- 10) Can you provide the benchmarks along with their descriptions in a concatenated format?

SELECT BenchmarkName || ' - ' || Description AS BenchmarkWithDescription
FROM Benchmarks;


-------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------