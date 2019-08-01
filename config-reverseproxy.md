# Gerrit Code Review - Reverse Proxy

## Description

Gerrit 可以在第三方 web 服务器的后面运行服务。这需要 web 服务器优先绑定 80 端口或 443 (SSL) 端口。第三方服务器可用 C 语言代替 java 语言来处理 SSL 的进程，这样可以降低负载并提高处理效率。

## Gerrit Configuration

确保 `'$site_path'/etc/gerrit.config` 中 `httpd.listenUrl` 配置了 'proxy-http://' 或 'proxy-https://'。

```
  [httpd]
  	listenUrl = proxy-http://127.0.0.1:8081/r/
```

## Apache 2 Configuration

Apache 服务器使用 'mod_proxy'，需要确保启用了必要的 Apache2 模块:

```
  a2enmod proxy_http
  a2enmod ssl          ; # 可选, HTTPS / SSL 需要使用
```

用 Apache VirtualHost 为 gerrit 配置反向代理，使用 'http://' URL 时需要设置 'ProxyPass'。要确保 ProxyPass 和 httpd.listenUrl 是匹配的，否则会重定向到错误的页面。

```
	<VirtualHost *>
	  ServerName review.example.com

	  ProxyRequests Off
	  ProxyVia Off
	  ProxyPreserveHost On

	  <Proxy *>
	    Order deny,allow
	    Allow from all
	    # Use following line instead of the previous two on Apache >= 2.4
	    # Require all granted
	  </Proxy>

	  AllowEncodedSlashes On
	  ProxyPass /r/ http://127.0.0.1:8081/r/ nocanon
	</VirtualHost>
```

从 Gerrit 2.6 开始，'AllowEncodedSlashes On' ，'ProxyPass .. nocanon' 需要使用这两个参数。

### SSL

若要在 Apache 中启用 SSL 进程，需要在 gerrit 的配置文件中配置 httpd.listenUrl 的属性值为 'proxy-https://'，并在 Apache VirtualHost 中启用 SSL，如下：

```
	<VirtualHost *:443>
	  SSLEngine on
	  SSLCertificateFile    conf/server.crt
	  SSLCertificateKeyFile conf/server.key

	  ... same as above ...
	</VirtualHost>
```

参考 Apache 'mod_ssl' 的文档可以了解更多 SSL 的相关配置，如加密方式等。

### Troubleshooting

在打开 change 页面时，如果遇到 'Page Not Found' 错误，有可能是 Apache proxy 解析的 URL 不正确。需要确认 'AllowEncodedSlashes On' 'ProxyPass .. nocanon' 这两个参数是否一起使用，或者用 'AllowEncodedSlashes NoDecode' 变更 'mod_rewrite' 配置。

## Nginx Configuration

需要配置类似下面的一段声明：

```
	server {
	  listen 80;
	  server_name review.example.com;

	  location ^~ /r/ {
	    proxy_pass        http://127.0.0.1:8081;
	    proxy_set_header  X-Forwarded-For $remote_addr;
	    proxy_set_header  Host $host;
          }
	}
```

### SSL

若要在 Nginx 中启用 SSL 进程，需要在 gerrit 的配置文件中配置 httpd.listenUrl 的属性值为 'proxy-https://'，并在 Nginx 中启用 SSL，如下：

```
	server {
	  listen 443;
	  server_name review.example.com;

	  ssl  on;
	  ssl_certificate      conf/server.crt;
	  ssl_certificate_key  conf/server.key;

	  ... same as above ...
	}
```

参考 Nginx 'http ssl module' 的文档可以了解更多 SSL 的相关配置，如加密方式等。

### Troubleshooting

在打开 change 页面时，如果遇到 'Page Not Found' 错误，有可能是 Nginx proxy 解析的 URL 不正确。需要确认 'proxy_pass' URL 的正确性，比如 'host:port' 后面没有 '/'。


如果使用 Apache httpd server 并配置了 mod_jk 和 AJP connector，需要在 httpd.conf 配置文件中添加如下参数：

```
JkOptions +ForwardURICompatUnparsed
```

