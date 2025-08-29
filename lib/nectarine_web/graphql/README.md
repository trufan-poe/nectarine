# GraphQL API Structure

This directory contains the GraphQL API implementation for the Nectarine application.

## Directory Structure

```
lib/nectarine_web/graphql/
├── README.md
├── schema.ex                    # Main GraphQL schema
├── schema/
│   ├── types.ex                # GraphQL type definitions
│   └── error.ex                # Error type definitions
└── resolvers/
    └── credit_application.ex   # Credit application resolvers
```

## Architecture

- **Schema**: Main GraphQL schema definition with queries and mutations
- **Types**: GraphQL type definitions including scalars, objects, and input objects
- **Resolvers**: Business logic for handling GraphQL queries and mutations
- **Plugs**: Authentication and middleware (see `lib/nectarine_web/plugs/auth_gql.ex`)

## Usage

The GraphQL endpoint is available at `/api/graphql` and uses the `:graphql` pipeline which includes:
- JSON content type acceptance
- Authentication via `AuthGql` plug (currently logs "Auth done here")

## Testing

Tests are located in `test/nectarine_web/graphql/` and use the `NectarineWeb.Graphql.Client` helper for making GraphQL requests in tests.
