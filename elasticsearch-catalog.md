## check the elasticseach cluster
curl -X GET http://localhost:9200

## create index
curl -X PUT http://localhost:9200/news

## index data
curl -X POST -H 'Content-Type: application/json' -d '{ "title": "News 1", "description": "This is news 01", "id": 1, "category": "Sports", "location": "Sri Lanka" }' http://localhost:9200/news/_doc

## index data
curl -X POST -H 'Content-Type: application/json' -d '{
"title": "News 1",
"description": "This is news 01",
"id": 1,
"category": "Sports",
"location": "Sri Lanka",
"comments": [
{
"user": "pramod",
"comment": "this is okay",
"rate": 5
},
{
"user": "pramod",
"comment": "this is okay",
"rate": 4
},
{
"user": "shehan",
"comment": "this is cool",
"rate": 2
}
]
}' http://localhost:9200/news/_doc


## Get all the index data
curl -X GET http://localhost:9200/news/_search?pretty

## Filter by title
curl -X GET "localhost:9200/news/_search?pretty" -H 'Content-Type: application/json' -d' { "query": { "match": { "title": "t-shirt" } } }'

## Filter nested objects
curl -X GET "localhost:9200/news/_search?pretty" -H 'Content-Type: application/json' -d '{
"query": {
"bool": {
"must": [
{
"match": {
"comments.user": "shehan"
}
},
{
"range": {
"comments.rate": {
"gte": 5
}
}
}
]
}
}
}'

## Create index with mapping
curl -X PUT http://localhost:9200/news -H 'Content-Type: application/json' -d '{
"mappings": {
"properties": {
"title": {
"type": "text"
},
"description": {
"type" : "text"
},
"id": {
"type": "integer"
},
"category": {
"type": "text"
},
"location": {
"type": "text"
},
"comments": {
"type": "nested",
"properties": {
"user": {
"type": "text"
},
"comment": {
"type": "text"
},
"rate": {
"type": "integer"
}
}
}
}
}
}'

## Get mappings
curl -X GET http://localhost:9200/news/_mapping?pretty

## Search nested fields
curl -X GET "localhost:9200/news/_search?pretty" -H 'Content-Type: application/json' -d '{
"query": {
"nested": {
"path": "comments",
"query": {
"bool": {
"must": [
{
"match":{
"comments.user": "shehan"
}
},
{
"range": {
"comments.rate": {
"gte": "2"
}
}
}
]
}
}
}
}
}'