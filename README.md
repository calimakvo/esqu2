# esqueleto sample2

## Database Setup

```
$ createuser -U postgres -i -l -S -d esqu2 -P
新しいロールのためのパスワード: esqu2 
もう一度入力してください：esqu2
```

```
$ createdb -U esqu2 -E UTF-8 -O esqu2 sampledb
```

```
$ psql -U esqu2 sampledb < sampledb.sql 
$ psql -U esqu2 sampledb < sampledb_data.sql 
```
