sqlite3 getsdone.db .dump > test.sql
sed 's/INTEGER PRIMARY/SERIAL PRIMARY/gi' test.sql > stage0.sql
sed 's/DATETIME/TIMESTAMP/gi' stage0.sql > stage1.sql
sed 's/AUTOINCREMENT//gi' stage1.sql > stage2.sql
sed '/sqlite_sequence/d' stage2.sql > stage3.sql
dropdb getsdone
createdb getsdone
psql getsdone < stage3.sql
psql getsdone -c "select setval('users_id_seq', (select max(id) from users));"
psql getsdone -c "select setval('actions_id_seq', (select max(id) from actions));"
psql getsdone -c "select setval('delegates_id_seq', (select max(id) from delegates));"
psql getsdone -c "select setval('follows_id_seq', (select max(id) from follows));"
psql getsdone -c "select setval('tags_id_seq', (select max(id) from tags));"
psql getsdone -c "select setval('hashtags_id_seq', (select max(id) from hashtags));"
psql getsdone -c "select setval('comments_id_seq', (select max(id) from comments));"

