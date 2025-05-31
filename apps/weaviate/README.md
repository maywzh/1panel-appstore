# Weaviate 使用说明

## 简介

Weaviate 是一个开源的向量数据库，可以存储对象和向量，支持向量搜索与结构化过滤的结合。它具有云原生数据库的容错性和可扩展性，提供 GraphQL 和 RESTful API。

## 快速开始

### 访问地址

部署完成后，您可以通过以下地址访问：

- **Weaviate API**：`http://your-server-ip:8080`
- **GraphQL Playground**：`http://your-server-ip:8080/v1/graphql`
- **RESTful API**：`http://your-server-ip:8080/v1`

### 健康检查

```bash
# 检查 Weaviate 服务状态
curl http://your-server-ip:8080/v1/meta

# 检查就绪状态
curl http://your-server-ip:8080/v1/.well-known/ready
```

## 主要特性

- 🔍 **向量搜索**：高性能的向量相似性搜索
- 🧠 **AI 集成**：内置多种 AI 模型支持
- 🔗 **GraphQL**：现代化的 GraphQL API
- 🛠️ **RESTful API**：传统的 REST API 支持
- 🔄 **实时更新**：支持实时数据插入和更新
- 🌐 **多租户**：支持多租户架构
- 📊 **混合搜索**：向量搜索与传统过滤结合

## 快速示例

### Python 客户端

```python
import weaviate

# 连接到 Weaviate
client = weaviate.Client("http://your-server-ip:8080")

# 检查连接
print(client.is_ready())
```

### 创建 Schema

```python
# 定义类 schema
class_schema = {
    "class": "Article",
    "description": "文章类",
    "properties": [
        {
            "name": "title",
            "dataType": ["text"],
            "description": "文章标题"
        },
        {
            "name": "content",
            "dataType": ["text"],
            "description": "文章内容"
        },
        {
            "name": "category",
            "dataType": ["text"],
            "description": "文章分类"
        }
    ]
}

# 创建类
client.schema.create_class(class_schema)
```

### 插入数据

```python
# 插入对象
data_object = {
    "title": "Weaviate 介绍",
    "content": "Weaviate 是一个开源的向量数据库...",
    "category": "技术"
}

result = client.data_object.create(
    data_object,
    "Article"
)

print(f"对象 ID: {result}")
```

### 向量搜索

```python
# 使用 nearText 进行语义搜索
result = (
    client.query
    .get("Article", ["title", "content", "category"])
    .with_near_text({"concepts": ["向量数据库"]})
    .with_limit(5)
    .do()
)

print(result)
```

### GraphQL 查询

```python
# 执行 GraphQL 查询
query = """
{
  Get {
    Article(limit: 5) {
      title
      content
      category
      _additional {
        id
        certainty
      }
    }
  }
}
"""

result = client.query.raw(query)
print(result)
```

## 高级功能

### 混合搜索

```python
# 结合向量搜索和过滤
result = (
    client.query
    .get("Article", ["title", "content"])
    .with_near_text({"concepts": ["AI"]})
    .with_where({
        "path": ["category"],
        "operator": "Equal",
        "valueText": "技术"
    })
    .with_limit(10)
    .do()
)
```

### 聚合查询

```python
# 聚合统计
result = (
    client.query
    .aggregate("Article")
    .with_group_by_filter(["category"])
    .with_fields("meta { count }")
    .do()
)
```

### 批量操作

```python
# 批量插入
client.batch.configure(batch_size=100)

with client.batch as batch:
    for i in range(1000):
        data_object = {
            "title": f"文章 {i}",
            "content": f"这是第 {i} 篇文章的内容",
            "category": "批量导入"
        }
        batch.add_data_object(data_object, "Article")
```

## 配置说明

### 环境变量

主要的环境变量配置：

- `AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED`：是否启用匿名访问
- `QUERY_DEFAULTS_LIMIT`：默认查询限制
- `PERSISTENCE_DATA_PATH`：数据持久化路径
- `DEFAULT_VECTORIZER_MODULE`：默认向量化模块
- `ENABLE_MODULES`：启用的模块列表

### 模块支持

Weaviate 支持多种模块：

- **text2vec-openai**：OpenAI 文本向量化
- **text2vec-huggingface**：Hugging Face 模型
- **text2vec-transformers**：本地 Transformer 模型
- **img2vec-neural**：图像向量化
- **generative-openai**：生成式 AI 模块

## 性能优化

### 索引配置

```python
# 配置向量索引
class_schema = {
    "class": "Article",
    "vectorIndexConfig": {
        "distance": "cosine",
        "efConstruction": 128,
        "maxConnections": 64
    }
}
```

### 内存管理

- 合理设置 `LIMIT_RESOURCES` 环境变量
- 监控内存使用情况
- 定期清理不需要的数据

## 监控和维护

### 健康检查

```bash
# 服务健康状态
curl http://your-server-ip:8080/v1/meta

# 节点状态
curl http://your-server-ip:8080/v1/nodes
```

### 备份策略

```bash
# 导出 schema
curl http://your-server-ip:8080/v1/schema > schema_backup.json

# 备份数据目录
cp -r ${DATA_PATH} /backup/weaviate-$(date +%Y%m%d)
```

### 故障排除

1. **连接问题**
   - 检查端口配置
   - 验证网络连通性

2. **性能问题**
   - 检查索引配置
   - 监控资源使用

3. **数据问题**
   - 验证 schema 定义
   - 检查数据格式

### 日志查看

```bash
# 查看 Weaviate 日志
docker logs ${CONTAINER_NAME}

# 实时跟踪日志
docker logs -f ${CONTAINER_NAME}
```

## API 参考

### RESTful API

- **GET** `/v1/meta` - 获取元信息
- **GET** `/v1/schema` - 获取 schema
- **POST** `/v1/objects` - 创建对象
- **GET** `/v1/objects/{id}` - 获取对象
- **PUT** `/v1/objects/{id}` - 更新对象
- **DELETE** `/v1/objects/{id}` - 删除对象

### GraphQL API

访问 `http://your-server-ip:8080/v1/graphql` 使用 GraphQL Playground 进行交互式查询。

## 相关链接

- [官方网站](https://weaviate.io/)
- [开发者文档](https://weaviate.io/developers/weaviate)
- [GitHub 仓库](https://github.com/weaviate/weaviate)
- [Python 客户端](https://github.com/weaviate/weaviate-python-client)
- [社区论坛](https://forum.weaviate.io/)
- [示例项目](https://github.com/weaviate/weaviate-examples)
