### Install Postgres container
```
docker run --name pg-lab -e POSTGRES_PASSWORD=mysecret -p 5432:5432 -d postgres
```
### Using psql tool inside the Postgres container 
```
docker exec -it pg-lab psql -U postgres
```
### Executing SQL scripts
```
cat name_of_script.sql | docker exec -i pg-lab psql -U postgres
```
