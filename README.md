# PDF Exporter

This tool exports webpages into PDF documents given by URLs. Exported PDF file's URL is returned in Location header:

~~~ {.bash}
Location:http://192.168.59.103/pdf/650b92d6-7115-4161-96c9-344e2e09fe59/exported.pdf
~~~

In production mode Nginx server is used to serve the PDF files.

# Development

~~~ {.bash}
$ scripts/watch.sh
~~~

and generate PDF files at:

~~~ {.bash}
http://localhost:3456/pdf/export?url='<escapedurl>'
~~~

# Production

~~~ {.bash}
$ docker build -t pdfexporter .
$ docker run -d -p 80:80 pdfexporter
~~~

and generate PDF files at:

~~~ {.bash}
http://192.168.59.103/pdf/export?url='<escapedurl>'
~~~
