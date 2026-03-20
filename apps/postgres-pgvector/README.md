# PostgreSQL-PGVector

PostgreSQL with PGVector extension for vector similarity search.

## Features

- **Vector Similarity Search**: Store vectors and perform similarity search
- **Multiple Distance Functions**: L2 distance, inner product, cosine distance, L1 distance, Hamming distance, Jaccard distance
- **Indexing**: Support HNSW and IVFFlat indexes for fast approximate nearest neighbor search
- **ACID Compliant**: Full PostgreSQL ACID compliance and point-in-time recovery

## Quick Start

### Connect to Database

```bash
psql -h localhost -p 5432 -U postgres -d postgres
```

### Enable Extension

```sql
CREATE EXTENSION vector;
```

### Create Vector Table

```sql
CREATE TABLE items (id bigserial PRIMARY KEY, embedding vector(3));
```

### Insert Vectors

```sql
INSERT INTO items (embedding) VALUES ('[1,2,3]'), ('[4,5,6]');
```

### Query Nearest Neighbors (L2 Distance)

```sql
SELECT * FROM items ORDER BY embedding <-> '[3,1,2]' LIMIT 5;
```

### Create Index for Faster Search

```sql
-- HNSW Index (better query speed, slower build)
CREATE INDEX ON items USING hnsw (embedding vector_l2_ops);

-- IVFFlat Index (faster build, slightly slower query)
CREATE INDEX ON items USING ivfflat (embedding vector_l2_ops);
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| POSTGRES_DB | Database name | postgres |
| POSTGRES_USER | Database user | postgres |
| POSTGRES_PASSWORD | Database password | postgres123 |
| TZ | Timezone | Asia/Shanghai |

## Links

- [pgvector GitHub](https://github.com/pgvector/pgvector)
- [pgvector Documentation](https://github.com/pgvector/pgvector)
