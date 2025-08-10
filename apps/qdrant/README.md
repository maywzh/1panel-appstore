# 使用说明

Qdrant 是一个高性能的向量数据库和向量相似度搜索引擎。它专为处理高维向量而设计，适用于AI应用、推荐系统、相似性搜索等场景。

## 基本信息

- 默认HTTP端口: 6333
- 默认gRPC端口: 6334
- 数据存储路径: /mnt/NAS3/data/storage (可在安装时修改)

## 访问方式

安装完成后，可以通过以下方式访问 Qdrant:

1. 通过浏览器访问: `http://your-server-ip:6333`
2. 通过 API 访问: 可使用 Qdrant 提供的各种客户端库进行编程访问

## Qdrant 简介

<div align="center">
  <a href="https://qdrant.tech"><img height="100px" alt="logo" src="https://qdrant.tech/img/logo.svg"/></a>
  <p><em>🚀 高性能向量数据库和相似度搜索引擎</em></p>
<div>
  <a href="https://github.com/qdrant/qdrant/actions/workflows/build_and_test.yml">
    <img src="https://img.shields.io/github/actions/workflow/status/qdrant/qdrant/build_and_test.yml?branch=master" alt="Build status" />
  </a>
  <a href="https://github.com/qdrant/qdrant/releases">
    <img src="https://img.shields.io/github/v/release/qdrant/qdrant" alt="Latest release" />
  </a>
  <a href="https://github.com/qdrant/qdrant/blob/master/LICENSE">
    <img src="https://img.shields.io/github/license/qdrant/qdrant" alt="License" />
  </a>
  <a href="https://discord.gg/qdrant">
    <img src="https://img.shields.io/discord/907569970500743209?logo=discord" alt="Discord" />
  </a>
  <a href="https://qdrant.tech/documentation/">
    <img src="https://img.shields.io/badge/docs-qdrant.tech-blue" alt="Documentation" />
  </a>
</div>
</div>

---

## 功能特性

- [x] 向量相似度搜索
- [x] 高性能的 nearest neighbor 查询
- [x] 支持多种距离度量 (Cosine, Euclidean, Dot product)
- [x] 支持 payloads (元数据) 过滤
- [x] 支持分层导航小世界 (HNSW) 算法
- [x] 支持倒排索引
- [x] 支持推荐API
- [x] 支持分布式部署
- [x] 支持全文搜索
- [x] 支持地理位置搜索
- [x] 提供 REST API 和 gRPC 接口
- [x] 支持多种编程语言客户端 (Python, JavaScript, Rust, Go, Java 等)

## 文档

<https://qdrant.tech/documentation/>

## 官方网站

<https://qdrant.tech>

## 快速开始

### 使用 Docker 运行

```bash
docker run -p 6333:6333 -p 6334:6334 \
    -v $(pwd)/qdrant_storage:/qdrant/storage:z \
    qdrant/qdrant
```

访问 `http://localhost:6333` 查看服务是否正常运行。

### 使用 REST API 创建集合

```bash
curl -X PUT 'http://localhost:6333/collections/test_collection' \
  -H 'Content-Type: application/json' \
  --data-raw '{
    "vectors": {
      "size": 4,
      "distance": "Dot"
    }
  }'
```

### 插入向量数据

```bash
curl -X PUT 'http://localhost:6333/collections/test_collection/points' \
  -H 'Content-Type: application/json' \
  --data-raw '{
    "points": [
      {"id": 1, "vector": [0.05, 0.61, 0.76, 0.74], "payload": {"city": "Berlin"}},
      {"id": 2, "vector": [0.19, 0.81, 0.75, 0.11], "payload": {"city": "London"}},
      {"id": 3, "vector": [0.36, 0.55, 0.47, 0.94], "payload": {"city": "Moscow"}},
      {"id": 4, "vector": [0.18, 0.01, 0.85, 0.80], "payload": {"city": "New York"}},
      {"id": 5, "vector": [0.24, 0.18, 0.22, 0.44], "payload": {"city": "Beijing"}},
      {"id": 6, "vector": [0.35, 0.08, 0.11, 0.44], "payload": {"city": "Mumbai"}}
    ]
  }'
```

### 执行相似性搜索

```bash
curl -X POST 'http://localhost:6333/collections/test_collection/points/search' \
  -H 'Content-Type: application/json' \
  --data-raw '{
    "vector": [0.2, 0.1, 0.9, 0.7],
    "limit": 3
  }'
```

## 应用场景

### 高级搜索
提升应用的搜索功能。Qdrant擅长处理高维数据，实现复杂的相似性搜索，深入理解语义。

### 推荐系统
创建高度响应性和个性化的推荐系统。Qdrant的推荐API提供了很大的灵活性，具有最佳得分推荐策略等选项。

### 检索增强生成 (RAG)
利用Qdrant高效的最近邻搜索和有效载荷过滤功能，提高AI生成内容的质量。

### 数据分析和异常检测
利用向量快速识别复杂数据集中的模式和异常，确保关键应用的鲁棒性和实时异常检测。

### AI代理
借助Qdrant强大的向量搜索和可扩展的基础架构，释放AI代理的全部潜力，处理复杂任务，实现实时适应。

## 客户评价

"Qdrant powers our demanding recommendation and RAG applications. We chose it for its ease of deployment and high performance at scale, and have been consistently impressed with its results."
- Srubin Sethu Madhavan, Technical Lead II at Hubspot

"We looked at all the big options out there right now for vector databases, with our focus on ease of use, performance, pricing, and communication. Qdrant came out on top in each category... ultimately, it wasn't much of a contest."
- Alex Webb, Director of Engineering, CB Insights

## 社区和支持

- [GitHub](https://github.com/qdrant/qdrant)
- [Discord](https://discord.gg/qdrant)
- [文档](https://qdrant.tech/documentation/)
- [博客](https://qdrant.tech/blog/)

## 许可证

Qdrant 是在 Apache 2.0 许可下许可的开源软件。