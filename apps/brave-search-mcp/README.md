# Brave Search MCP Server

## 简介

Brave Search MCP Server 是一个基于 Model Context Protocol (MCP) 的网页搜索服务，使用 Brave Search 引擎提供高质量、无追踪的搜索结果。

## 功能特点

- **网页搜索**: 使用 Brave Search 搜索引擎进行网页搜索
- **隐私保护**: Brave Search 不追踪用户搜索行为
- **MCP 协议**: 完全兼容 Model Context Protocol 标准
- **双传输模式**: 支持 stdio 和 streamable-http 两种传输模式

## 安装步骤

1. 确保已经安装并配置好 Docker 和 1Panel。
2. 按照提示填写相关配置参数并完成安装。
3. 如果使用 HTTP 传输模式，需要配置反向代理：

```
location /mcp/ {
    proxy_pass http://localhost:8080/;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $host;
}
```

## 配置参数

- **端口**: HTTP 服务监听端口（默认 8080）
- **Brave API Key**: Brave Search API 密钥（必需）

## 升级

- 直接重新部署最新版本即可，数据保存在 Docker 卷中

## 卸载

- 删除 Docker 容器和相关数据即可

## 文档

- 详细使用文档请参考 [官方文档](https://github.com/maywzh/brave-search-mcp)。
