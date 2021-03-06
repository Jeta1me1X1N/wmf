export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64


sqoop import                                                        \
  --connect jdbc:mysql://s1-analytics-slave.eqiad.wmnet/enwiki      \
  --verbose                                                         \
  --target-dir /tmp/$(mktemp -u -p '' -t ${USER}_sqoop_XXXXXX)      \
  --delete-target-dir                                               \
  --username=research --password                          \
  --query '
SELECT
  a.page_id AS page_id,
  a.page_namespace as page_namespace,
  CAST(a.page_title AS CHAR(255) CHARSET utf8) AS page_title,
  a.page_counter AS page_counter,
  a.page_is_redirect as page_is_redirect
FROM page a
WHERE $CONDITIONS
'                                                                   \
--split-by a.page_id                                                \
--hive-import                                                       \
--hive-database ellery                                                \
--create-hive-table                                                 \
--hive-table en_page
