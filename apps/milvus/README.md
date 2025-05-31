# Milvus 使用说明

## 简介

Milvus 是一个开源的向量数据库，专为 AI 应用和相似性搜索而构建。它提供了高性能的向量检索能力，支持大规模向量数据的存储和查询。

## 快速开始

### 访问地址

部署完成后，您可以通过以下地址访问：

- **Milvus 服务**：`http://your-server-ip:19530` (默认端口)
- **Milvus Web UI**：`http://your-server-ip:9091` (Web 管理界面)
- **MinIO 控制台**：`http://your-server-ip:9001` (对象存储管理)
- **MinIO API**：`http://your-server-ip:9000` (对象存储 API)

### 默认凭据

- **MinIO 访问凭据**：
  - 用户名：`minioadmin`
  - 密码：`minioadmin`

## 主要特性

- 🚀 **高性能**：毫秒级向量搜索响应
- 🔧 **多种索引**：支持多种向量索引算法
- 🌐 **云原生**：容器化部署，易于扩展
- 🔌 **多语言 SDK**：支持 Python、Java、Go、Node.js 等
- 📊 **实时分析**：支持实时数据插入和查询
- 🛡️ **数据安全**：提供访问控制和数据加密

## 连接配置

### Python 示例

```python
from pymilvus import connections, Collection

# 连接到 Milvus
connections.connect("default", host="your-server-ip", port="19530")

# 创建集合示例
from pymilvus import CollectionSchema, FieldSchema, DataType

# 定义字段
fields = [
    FieldSchema(name="id", dtype=DataType.INT64, is_primary=True, auto_id=False),
    FieldSchema(name="embedding", dtype=DataType.FLOAT_VECTOR, dim=128)
]

# 创建集合
schema = CollectionSchema(fields, "示例集合")
collection = Collection("example_collection", schema)
```

### 数据操作

```python
# 插入数据
import random

data = [
    [i for i in range(100)],  # id 字段
    [[random.random() for _ in range(128)] for _ in range(100)]  # 向量字段
]

collection.insert(data)

# 创建索引
index_params = {
    "metric_type": "L2",
    "index_type": "IVF_FLAT",
    "params": {"nlist": 1024}
}
collection.create_index("embedding", index_params)

# 加载集合
collection.load()

# 搜索
search_params = {"metric_type": "L2", "params": {"nprobe": 10}}
results = collection.search(
    data=[[random.random() for _ in range(128)]],
    anns_field="embedding",
    param=search_params,
    limit=10
)
```

## 性能调优

### 内存配置

Milvus 支持通过环境变量配置内存使用：

- `CACHE_SIZE`：缓存大小设置
- `INSERT_BUFFER_SIZE`：插入缓冲区大小

### 索引选择

根据数据规模选择合适的索引：

- **小规模数据**（< 1M）：FLAT
- **中规模数据**（1M-10M）：IVF_FLAT
- **大规模数据**（> 10M）：IVF_PQ, HNSWG

## 监控和维护

### 健康检查

```bash
# 检查 Milvus 服务状态
curl http://your-server-ip:9091/healthz

# 查看服务信息
curl http://your-server-ip:9091/api/v1/health
```

### 数据备份

建议定期备份以下目录：
- Milvus 数据：`${DATA_PATH}/milvus`
- MinIO 数据：`${DATA_PATH}/minio`
- etcd 数据：`${DATA_PATH}/etcd`

## 故障排除

### 常见问题

1. **连接失败**
   - 检查端口是否正确开放
   - 确认防火墙设置

2. **内存不足**
   - 增加系统内存
   - 调整缓存配置

3. **搜索性能差**
   - 检查索引是否已创建
   - 优化搜索参数

### 日志查看

```bash
# 查看 Milvus 日志
docker logs ${CONTAINER_NAME}

# 查看 MinIO 日志
docker logs ${CONTAINER_NAME}-minio

# 查看 etcd 日志
docker logs ${CONTAINER_NAME}-etcd
```

## 相关链接

- [官方网站](https://milvus.io/)
- [文档中心](https://milvus.io/docs/)
- [GitHub 仓库](https://github.com/milvus-io/milvus)
- [社区论坛](https://github.com/milvus-io/milvus/discussions)
- [PyMilvus SDK](https://github.com/milvus-io/pymilvus)
