# Gemini-Vs-ChatGPT-SQL-Case-Study-Analysis


-- QUESTIONS


-- 1)What are the average scores for each capability on both the Gemini Ultra and GPT-4 models?
SELECT c.CapabilityName,
       AVG(b.ScoreGemini) AS AvgScoreGeminiUltra,
       AVG(b.ScoreGPT4) AS AvgScoreGPT4
FROM Capabilities c
LEFT JOIN Benchmarks b ON c.CapabilityID = b.CapabilityID
GROUP BY c.CapabilityName;


------------------------------------------------------------------------------------------------------------------------------

-- 2)Which benchmarks does Gemini Ultra outperform GPT-4 in terms of scores?

SELECT BenchmarkName
FROM Benchmarks
WHERE ScoreGemini > ScoreGPT4;

-------------------------------------------------------------------------------------------------------------------------

-- 3)What are the highest scores achieved by Gemini Ultra and GPT-4 for each benchmark in the Image capability?

SELECT b.BenchmarkName,
       MAX(b.ScoreGemini) AS MaxScoreGeminiUltra,
       MAX(b.ScoreGPT4) AS MaxScoreGPT4
FROM Benchmarks b
JOIN Capabilities c ON b.CapabilityID = c.CapabilityID
WHERE c.CapabilityName = 'Image'
GROUP BY b.BenchmarkName;

 -----------------------------------------------------------------------------------------------------------------------

-- 4)Calculate the percentage improvement of Gemini Ultra over GPT-4 for each benchmark?

SELECT BenchmarkName,
       ((ScoreGemini - ScoreGPT4) / ScoreGPT4) * 100 AS PercentageImprovement
FROM Benchmarks
WHERE ScoreGPT4 IS NOT NULL;

--------------------------------------------------------------------------------------------------------------------------

-- 5)Retrieve the benchmarks where both models scored above the average for their respective models?

WITH AvgScores AS (
    SELECT AVG(ScoreGemini) AS AvgGemini, AVG(ScoreGPT4) AS AvgGPT4
    FROM Benchmarks
)
SELECT BenchmarkName
FROM Benchmarks, AvgScores
WHERE ScoreGemini > (SELECT AvgGemini FROM AvgScores)
  AND ScoreGPT4 > (SELECT AvgGPT4 FROM AvgScores);

------------------------------------------------------------------------------------------------------------------------------

-- 6)Which benchmarks show that Gemini Ultra is expected to outperform GPT-4 based on the next score?

SELECT BenchmarkName
FROM Benchmarks
WHERE ScoreGemini > (SELECT AVG(ScoreGemini) FROM Benchmarks)
  AND ScoreGPT4 < (SELECT AVG(ScoreGPT4) FROM Benchmarks);

-----------------------------------------------------------------------------------------------------------------------------


-- 7)Classify benchmarks into performance categories based on score ranges?

SELECT BenchmarkName,
       CASE
           WHEN ScoreGemini >= 90 AND ScoreGPT4 >= 90 THEN 'High Performance'
           WHEN ScoreGemini >= 80 AND ScoreGPT4 >= 80 THEN 'Good Performance'
           WHEN ScoreGemini >= 70 AND ScoreGPT4 >= 70 THEN 'Fair Performance'
           ELSE 'Low Performance'
       END AS PerformanceCategory
FROM Benchmarks;

--------------------------------------------------------------------------------------------------------------------------

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

----------------------------------------------------------------------------------------------------------------------------

-- 9)Convert the Capability and Benchmark names to uppercase?

SELECT UPPER(CapabilityName) AS CapabilityName, UPPER(BenchmarkName) AS BenchmarkName
FROM Capabilities c
JOIN Benchmarks b ON c.CapabilityID = b.CapabilityID;

--------------------------------------------------------------------------------------------------------------------------

-- 10) Can you provide the benchmarks along with their descriptions in a concatenated format?

SELECT BenchmarkName || ' - ' || Description AS BenchmarkWithDescription
FROM Benchmarks;


-------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------


-- Other Queries from basic to advance level --

-- Certainly! Here are 30 SQL queries ranging from basic to advanced levels:

-- Basic Level:

-- que 1 Select all records from the Models table:
    SELECT * FROM Models;

-- que 2 Select all records from the Capabilities table:
    SELECT * FROM Capabilities;

-- que 3 Select all records from the Benchmarks table:
    SELECT * FROM Benchmarks;

-- que 4 Select the ModelName for ModelID 1:
	SELECT ModelName FROM Models WHERE ModelID = 1;

-- que 5 SELECT ModelName FROM Models WHERE ModelID = 1;
    SELECT CapabilityName FROM Capabilities WHERE CapabilityID = 3;
    
    --------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------
    
-- Intermediate Level:

-- que 6 Count the number of benchmarks for each capability:

SELECT c.CapabilityName, COUNT(b.BenchmarkID) AS BenchmarkCount
FROM Capabilities c
LEFT JOIN Benchmarks b ON c.CapabilityID = b.CapabilityID
GROUP BY c.CapabilityName;

-- que 7 Calculate the average score for each model:

SELECT ModelName, AVG(ScoreGemini) AS AvgScoreGemini, AVG(ScoreGPT4) AS AvgScoreGPT4
FROM Benchmarks
JOIN Models ON Benchmarks.ModelID = Models.ModelID
GROUP BY ModelName;

-- que 8 Find the model with the highest overall score:

SELECT BestModel.ModelName
FROM (
    SELECT ModelName, SUM(ScoreGemini + COALESCE(ScoreGPT4, 0)) AS TotalScore
    FROM Models AS M
    JOIN Benchmarks AS B ON M.ModelID = B.ModelID
    GROUP BY ModelName
    ORDER BY TotalScore DESC
    LIMIT 1
) AS BestModel;

-- que 9 List all benchmarks along with their corresponding models:

SELECT BenchmarkName, ModelName
FROM Benchmarks
JOIN Models ON Benchmarks.ModelID = Models.ModelID;

-- que 10 Calculate the total number of benchmarks performed by each model:

SELECT ModelName, COUNT(BenchmarkID) AS TotalBenchmarks
FROM Models
LEFT JOIN Benchmarks ON Models.ModelID = Benchmarks.ModelID
GROUP BY ModelName;


---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

-- Advanced Level:

-- qoe 11 Calculate the percentage of scores achieved by Gemini Ultra compared to the total scores:

SELECT (COUNT(ScoreGemini) / (COUNT(ScoreGemini) + COUNT(ScoreGPT4))) * 100 AS PercentageGemini
FROM Benchmarks;

-- que 12 Retrieve the top 5 benchmarks with the highest scores:

SELECT BenchmarkName, ScoreGemini
FROM Benchmarks
ORDER BY ScoreGemini DESC
LIMIT 5;

-- que 13 Calculate the total score for each capability across all models:

SELECT c.CapabilityName, SUM(b.ScoreGemini + COALESCE(b.ScoreGPT4, 0)) AS TotalScore
FROM Capabilities c
LEFT JOIN Benchmarks b ON c.CapabilityID = b.CapabilityID
GROUP BY c.CapabilityName;

-- que 14 Rank the models based on their overall performance:

SELECT ModelName, SUM(ScoreGemini + COALESCE(ScoreGPT4, 0)) AS TotalScore
FROM Models
JOIN Benchmarks ON Models.ModelID = Benchmarks.ModelID
GROUP BY ModelName
ORDER BY TotalScore DESC;

-- que 15 Find the capability with the highest average score:

SELECT CapabilityName, AVG(ScoreGemini) AS AvgScoreGemini, AVG(ScoreGPT4) AS AvgScoreGPT4
FROM Capabilities
JOIN Benchmarks ON Capabilities.CapabilityID = Benchmarks.CapabilityID
GROUP BY CapabilityName
ORDER BY (AVG(ScoreGemini) + AVG(ScoreGPT4)) DESC
LIMIT 1;

-- que 16 Calculate the difference in average scores between Gemini Ultra and GPT-4 for each capability:

SELECT c.CapabilityName, AVG(b.ScoreGemini) - AVG(b.ScoreGPT4) AS ScoreDifference
FROM Capabilities c
LEFT JOIN Benchmarks b ON c.CapabilityID = b.CapabilityID
GROUP BY c.CapabilityName;

-- que 17 Retrieve the top 3 models with the highest average scores:

SELECT ModelName, AVG(ScoreGemini + COALESCE(ScoreGPT4, 0)) AS AvgTotalScore
FROM Models
JOIN Benchmarks ON Models.ModelID = Benchmarks.ModelID
GROUP BY ModelName
ORDER BY AvgTotalScore DESC
LIMIT 3;

-- que 18 Find the capability with the highest score achieved by Gemini Ultra:

SELECT c.CapabilityName, MAX(b.ScoreGemini) AS MaxScoreGemini
FROM Capabilities c
JOIN Benchmarks b ON c.CapabilityID = b.CapabilityID
GROUP BY c.CapabilityName
ORDER BY MaxScoreGemini DESC
LIMIT 1;
-- que 19 Calculate the percentage of benchmarks where Gemini Ultra outperforms GPT-4:
SELECT (COUNT(CASE WHEN ScoreGemini > ScoreGPT4 THEN 1 END) / COUNT(*)) * 100 AS PercentageOutperform
FROM Benchmarks;

-- que 20 Retrieve the benchmarks where Gemini Ultra's score is within 5 points of GPT-4's score:

SELECT BenchmarkName
FROM Benchmarks
WHERE ABS(ScoreGemini - ScoreGPT4) <= 5;

-- que 21 Find the capability with the highest total score for Gemini Ultra

SELECT c.CapabilityName, SUM(b.ScoreGemini) AS TotalScoreGemini
FROM Capabilities c
JOIN Benchmarks b ON c.CapabilityID = b.CapabilityID
GROUP BY c.CapabilityName
ORDER BY TotalScoreGemini DESC
LIMIT 1;

-- que 22 Calculate the average score difference between Gemini Ultra and GPT-4 across all benchmarks:

SELECT AVG(ScoreGemini - COALESCE(ScoreGPT4, 0)) AS AvgScoreDifference
FROM Benchmarks;

-- que 23 Find the top 3 capabilities with the highest average score improvement by Gemini Ultra over GPT-4:

SELECT c.CapabilityName, AVG(ScoreGemini - ScoreGPT4) AS AvgScoreImprovement
FROM Capabilities c
JOIN Benchmarks b ON c.CapabilityID = b.CapabilityID
GROUP BY c.CapabilityName
ORDER BY AvgScoreImprovement DESC
LIMIT 3;

-- que 24 Calculate the average score for each capability across both models:

SELECT c.CapabilityName, AVG(b.ScoreGemini) AS AvgScoreGemini, AVG(b.ScoreGPT4) AS AvgScoreGPT4
FROM Capabilities c
LEFT JOIN Benchmarks b ON c.CapabilityID = b.CapabilityID
GROUP BY c.CapabilityName;

-- que 25  Retrieve the benchmarks where Gemini Ultra's score is higher than GPT-4's score by at least 10 points:

SELECT BenchmarkName
FROM Benchmarks
WHERE ScoreGemini - ScoreGPT4 >= 10;

-- que 26 Find the capability with the highest variance in scores for Gemini Ultra:

SELECT c.CapabilityName, VARIANCE(b.ScoreGemini) AS VarianceGemini
FROM Capabilities c
JOIN Benchmarks b ON c.CapabilityID = b.Capability

----------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
 
