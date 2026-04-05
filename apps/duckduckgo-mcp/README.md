# DuckDuckGo MCP Server

## 简介

DuckDuckGo MCP Server 是一个基于 Model Context Protocol (MCP) 的网页搜索服务，支持搜索和网页内容抓取功能。

## 功能特点

- **网页搜索**: 使用 DuckDuckGo 搜索引擎进行网页搜索
- **内容抓取**: 支持抓取任意网页的内容
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
- **SafeSearch**: 搜索安全级别（STRICT/MODERATE/OFF，默认 MODERATE）
- **Region**: 搜索区域/语言（默认空，如 cn-zh、us-en 等）
- **传输模式**: 选择 stdio 或 streamable-http（默认 streamable-http）

## 升级

- 直接重新部署最新版本即可，数据保存在 Docker 卷中

## 卸载

- 删除 Docker 容器和相关数据即可

## 文档

- 详细使用文档请参考 [官方文档](https://github.com/maywzh/duckduckgo-mcp)。
