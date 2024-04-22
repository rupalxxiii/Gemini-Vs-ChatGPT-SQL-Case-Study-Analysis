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
 