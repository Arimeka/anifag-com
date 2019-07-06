upstream backend_upstream {
  server 0.0.0.0:8080 fail_timeout=0;
}

server {
        server_name www.anifag.com;
        return 301 $scheme://anifag.com$request_uri;
}

server {
	listen 80;
	listen [::]:80;

	root /home/anifag/anifag-com/app/web/public;

	server_name anifag.com;

	location / {
		try_files $uri @backend;
	}

	location /css {
		root /home/anifag/anifag-com/app/web/static;
		expires max;
	}

	location /system {
		root /home/anifag/anifag-com/app/web/static/images;
		expires max;
	}

	location @backend {
		proxy_buffer_size 16k;
		proxy_buffers 8 16k;
		proxy_busy_buffers_size 32k;
		proxy_pass http://backend_upstream;
	}
}
