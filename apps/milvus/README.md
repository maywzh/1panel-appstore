# Milvus 使用说明

## 简介

Milvus 是一个开源的向量数据库，专为 AI 应用和相似性搜索而构建。它提供了高性能的向量检索能力，支持大规模向量数据的存储和查询。本部署包含完整的 Milvus 生态系统，包括 Milvus 数据库、etcd 协调服务和 MinIO 对象存储。

## 服务架构

本模板部署包含以下服务：

- **Milvus**：主要的向量数据库服务
- **etcd**：分布式键值存储，用于元数据管理
- **MinIO**：对象存储服务，用于向量和索引数据存储

## 快速开始

### 访问地址

部署完成后，您可以通过以下地址访问：

- **Milvus 服务**：`http://your-server-ip:19530` (默认端口)
- **Milvus Web UI**：`http://your-server-ip:9091` (Web 管理界面)
- **MinIO 控制台**：`http://your-server-ip:9001` (对象存储管理界面)
- **MinIO API**：`http://your-server-ip:9000` (对象存储 API)

### 默认凭据

- **MinIO 访问凭据**：
  - 用户名：`minioadmin`
  - 密码：`minioadmin`

> **安全提示**：建议在生产环境中修改默认的 MinIO 访问凭据。

## 主要特性

- 🚀 **高性能**：毫秒级向量搜索响应
- 🔧 **多种索引**：支持多种向量索引算法（FLAT、IVF_FLAT、IVF_PQ、HNSW 等）
- 🌐 **云原生**：容器化部署，易于扩展和管理
- 🔌 **多语言 SDK**：支持 Python、Java、Go、Node.js、C++ 等
- 📊 **实时分析**：支持实时数据插入和查询
- 🛡️ **数据安全**：提供访问控制和数据加密
- 📈 **监控支持**：内置健康检查和监控接口

## 连接配置

### Python 示例

```python
from pymilvus import connections, Collection

# 连接到 Milvus
connections.connect(
    alias="default",
    host="your-server-ip",
    port="19530"
)

# 验证连接
from pymilvus import utility
print("Milvus version:", utility.get_server_version())
```

### 创建集合和索引

```python
from pymilvus import CollectionSchema, FieldSchema, DataType

# 定义字段
fields = [
    FieldSchema(name="id", dtype=DataType.INT64, is_primary=True, auto_id=False),
    FieldSchema(name="embedding", dtype=DataType.FLOAT_VECTOR, dim=128),
    FieldSchema(name="metadata", dtype=DataType.VARCHAR, max_length=512)
]

# 创建集合
schema = CollectionSchema(fields, "AI 向量搜索集合")
collection = Collection("ai_search", schema)

# 创建索引
index_params = {
    "metric_type": "L2",
    "index_type": "IVF_FLAT",
    "params": {"nlist": 1024}
}
collection.create_index("embedding", index_params)
```

### 数据操作示例

```python
import random

# 准备数据
entities = [
    [i for i in range(1000)],  # id 字段
    [[random.random() for _ in range(128)] for _ in range(1000)],  # 向量字段
    [f"metadata_{i}" for i in range(1000)]  # 元数据字段
]

# 插入数据
insert_result = collection.insert(entities)
print("插入数据 ID:", insert_result.primary_keys)

# 加载集合到内存
collection.load()

# 执行向量搜索
search_params = {"metric_type": "L2", "params": {"nprobe": 10}}
query_vector = [[random.random() for _ in range(128)]]

results = collection.search(
    data=query_vector,
    anns_field="embedding",
    param=search_params,
    limit=10,
    output_fields=["metadata"]
)

print("搜索结果:")
for hits in results:
    for hit in hits:
        print(f"ID: {hit.id}, 距离: {hit.distance}, 元数据: {hit.entity.get('metadata')}")
```

## 性能调优

### 内存配置

Milvus 支持通过环境变量配置内存使用：

```yaml
environment:
  - CACHE_SIZE=2GB
  - INSERT_BUFFER_SIZE=256MB
  - MAX_DEGREE=64
  - SEARCH_K=100
```

### 索引选择指南

根据数据规模和性能需求选择合适的索引：

| 数据规模 | 推荐索引 | 特点 |
|---------|---------|------|
| < 1M | FLAT | 精确搜索，小数据集性能最佳 |
| 1M-10M | IVF_FLAT | 平衡精度和性能 |
| 10M-100M | IVF_PQ | 压缩存储，内存效率高 |
| > 100M | HNSW | 高性能近似搜索 |

### 集合分区

对于大规模数据，建议使用分区：

```python
# 创建分区
collection.create_partition("partition_2024")

# 向特定分区插入数据
collection.insert(entities, partition_name="partition_2024")

# 搜索特定分区
results = collection.search(
    data=query_vector,
    anns_field="embedding",
    param=search_params,
    limit=10,
    partition_names=["partition_2024"]
)
```

## 监控和维护

### 健康检查

```bash
# 检查 Milvus 服务状态
curl http://your-server-ip:9091/healthz

# 查看服务详细信息
curl http://your-server-ip:9091/api/v1/health

# 查看系统信息
curl http://your-server-ip:9091/api/v1/system/info
```

### MinIO 监控

通过 MinIO 控制台监控存储使用情况：
- 访问：`http://your-server-ip:9001`
- 监控存储使用量、请求统计等指标

### 数据备份策略

建议定期备份以下数据目录：

```bash
# 数据目录结构
${DATA_PATH}/
├── milvus/          # Milvus 数据文件
├── minio/           # MinIO 对象存储数据
└── etcd/            # etcd 元数据

# 备份脚本示例
#!/bin/bash
BACKUP_DIR="/backup/milvus-$(date +%Y%m%d)"
mkdir -p $BACKUP_DIR

# 停止服务进行一致性备份
docker-compose stop

# 复制数据
cp -r ${DATA_PATH} $BACKUP_DIR/

# 重启服务
docker-compose start
```

## 故障排除

### 常见问题

1. **连接失败**
   ```bash
   # 检查端口是否开放
   netstat -tlnp | grep :19530
   
   # 检查防火墙
   sudo ufw status
   ```

2. **内存不足错误**
   ```bash
   # 检查系统内存
   free -h
   
   # 查看容器内存使用
   docker stats
   ```

3. **搜索性能差**
   ```python
   # 检查索引状态
   print(collection.indexes)
   
   # 检查集合加载状态
   print(collection.has_index())
   print(utility.loading_progress("collection_name"))
   ```

4. **MinIO 存储问题**
   ```bash
   # 检查 MinIO 服务状态
   curl http://localhost:9000/minio/health/live
   
   # 查看存储空间
   docker exec ${CONTAINER_NAME}-minio df -h
   ```

### 日志查看

```bash
# 查看 Milvus 日志
docker logs ${CONTAINER_NAME} --tail 100 -f

# 查看 MinIO 日志
docker logs ${CONTAINER_NAME}-minio --tail 100 -f

# 查看 etcd 日志
docker logs ${CONTAINER_NAME}-etcd --tail 100 -f

# 查看所有服务状态
docker-compose ps
```

### 性能调试

```python
# 开启查询分析
from pymilvus import utility

# 查看集合统计信息
stats = utility.get_query_segment_info("collection_name")
print("段信息:", stats)

# 查看索引构建进度
progress = utility.get_index_build_progress("collection_name")
print("索引构建进度:", progress)
```

## 扩展配置

### 集群部署

对于生产环境，建议使用 Milvus 集群模式：

```yaml
# 集群模式需要额外的组件
services:
  # 添加更多 Milvus 节点
  # 添加负载均衡器
  # 配置分布式存储
```

### 监控集成

可以集成 Prometheus 和 Grafana 进行监控：

```yaml
# 添加监控配置
environment:
  - METRICS_ENABLED=true
  - METRICS_PORT=9090
```

## 相关链接

- [Milvus 官方网站](https://milvus.io/)
- [官方文档](https://milvus.io/docs/)
- [GitHub 仓库](https://github.com/milvus-io/milvus)
- [社区论坛](https://github.com/milvus-io/milvus/discussions)
- [Python SDK (PyMilvus)](https://github.com/milvus-io/pymilvus)
- [性能基准测试](https://milvus.io/docs/benchmark.md)
- [最佳实践指南](https://milvus.io/docs/performance_faq.md)

## 许可证

Milvus 采用 Apache 2.0 许可证。详情请参阅 [LICENSE](https://github.com/milvus-io/milvus/blob/master/LICENSE) 文件。