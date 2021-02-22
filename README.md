# Swaggery

Minimalistic API documentation generator.

## Concept

Writing Swagger/OpenAPI spec files by hand is super tedious, verbose and error prone. Additionally, each language has a different support for inline code deneration, but it's usually getting in the way of shipping features, and makes the code less readable.

However, Swagger/OpenAPI files are super useful for documentation purposes. There are multiple documentation systems in the wild that support spec files, like Swagger/OpenAPI/Redoc. A single JSON spec file could be easily converted into a static HTML site with code examples.

This experimental project is an attempt to minimize effort needed to put together a basic API documentation in Swagger/OpenAPI formats while maintaining the spec format.

## Example

Let's consider an example API docs spec:

```
INFO
  version 1.0.0
  title My Fancy API
  license apache2
  server https://staging.mydomain.com Staging
  server https://api.mydomain.com Production

GET /health | Get health status
  < 200 json health.json | Service is healthy
  < 500 json health_error.json | Service is unhealthy

GET /books | Search books
  - Perform a books search based on various parameters
  - Enpoint will return a paginated responses
  > query *search string | Search query
  > query year integer | Search by year
  > query genre string=fiction,crime,detective,horror | Genre
  > query sort=asc string=asc,desc | Results sort order
  > query page=1 integer | Results pagination
  > query limit=100 integer | Results limit
  < 200 json books.json
  < 400 json books_error.json | Invalid query

GET /books/{id} | Get book details
  > path id integer | Book ID
  < 200 json book.json
  < 400 json books_error.json | Query error
  < 404 json error_not_found.json | Book does not exist
```

Path endpoint signature:

```
METHOD /path | Summary !tag
  # A comment
  - Description line 1
  - Description line 2
  
  # Query inputs
  > query param type | Description (optional)
  > query *param type | Required parameter
  > query param=defvalue type | Param with default value
  > query param string=a,b,c,d | Param with available options
  
  # Path inputs, for paths like /books/{bookID}
  > path bookID string | Book ID
  
  # Responses
  < CODE FORMAT FILE | Description
```

The above spec converts the input into a site like:

<div>
  <img src="/images/screen1.png" style="border: 1px solid #eee;" width="45%" />
  <img src="/images/screen2.png" style="border: 1px solid #eee;" width="45%" />
</div>

## Usage

```
Usage: swaggery [options]
  --file=path                  Spec file
  --output=name                Output
  --output-format=name         Output format
  --api-version=versionSet API version
  --api-license=name           Set API license
  --api-server=server          Set API server
  --examples=path              Path to examples
```
