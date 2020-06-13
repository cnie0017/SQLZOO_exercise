1. The example shows the number who responded for: question 1; at 'Edinburgh Napier University';studying '(8) Computer Science'
Show the the percentage who STRONGLY AGREE'
A_STRONGLY_AGREE's value is already a percentage!

SELECT A_STRONGLY_AGREE
FROM nss
WHERE question='Q01'
   AND institution='Edinburgh Napier University'
   AND subject='(8) Computer Science'
   
   
4.Show the subject and total number of students who responded to question 22 for each of the subjects '(8) Computer Science' and '(H) Creative Arts and Design'.

SELECT subject, SUM(response)
FROM nss
WHERE question='Q22'
   AND subject IN ('(8) Computer Science','(H) Creative Arts and Design')
GROUP BY subject


5.Show the subject and total number of students who A_STRONGLY_AGREE to question 22 for each of the subjects '(8) Computer Science' and '(H) Creative Arts and Design'.
HINT: The A_STRONGLY_AGREE column is a percentage. To work out the total number of students who strongly agree you must multiply this percentage by the number who responded (response) and divide by 100 - take the SUM of that.

SELECT subject, SUM(A_STRONGLY_AGREE*response/100)
FROM nss
WHERE question='Q22'
   AND subject IN ('(8) Computer Science',  '(H) Creative Arts and Design')
GROUP BY subject


6. Show the percentage of students who A_STRONGLY_AGREE to question 22 for the subject '(8) Computer Science' show the same figure for the subject '(H) Creative Arts and Design'.
Use the ROUND function to show the percentage without decimal places.

SELECT subject, ROUND(SUM(A_STRONGLY_AGREE*response)/SUM(response))
FROM nss
WHERE question='Q22'
   AND subject IN ('(8) Computer Science',  '(H) Creative Arts and Design')
GROUP BY subject


7.Show the average scores for question 'Q22' for each institution that include 'Manchester' in the name.
The column score is a percentage - you must use the method outlined above to multiply the percentage by the response and divide by the total response. 

SELECT institution, ROUND(SUM(score*response)/SUM(response))
FROM nss
WHERE question='Q22' AND institution LIKE '%Manchester%'
GROUP BY institution


8. Show the institution, the total sample size and the number of computing students for institutions in Manchester for 'Q01'.

SELECT institution,
       SUM(sample) AS 'total',
       (SELECT sample FROM nss y
               WHERE subject='(8) Computer Science'
               AND x.institution = y.institution
               AND question='Q01') AS 'comp'
FROM nss x
WHERE question='Q01' AND institution LIKE '%Manchester%'
GROUP BY institution
