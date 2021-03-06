ssh -v bast1001.wikimedia.org


rsync -rv ~/wmf/clickstream/oozie/ stat1002.eqiad.wmnet:~/wmf/clickstream/oozie

hadoop fs -mkdir /user/ellery/clickstream
hadoop fs -mkdir /user/ellery/clickstream/oozie


hadoop fs -rm -r -f  /user/ellery/clickstream/oozie/*
hadoop fs -put ~/wmf/clickstream/oozie/* /user/ellery/clickstream/oozie/
oozie job -oozie http://analytics1027.eqiad.wmnet:11000/oozie -run -config ~/wmf/clickstream/oozie/coordinator.properties


SELECT prev, n
FROM
(SELECT prev, count(*) as n
FROM ellery.clickstream_v0_5
where month=1
group by prev) a
order by n desc limit 20;