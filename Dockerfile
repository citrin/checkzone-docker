FROM alpine:3.11.3 AS bin
LABEL maintainer="citrin+github@citrin.ru"
LABEL org.label-schema.description="NSD DNS zone file syntax checker"
LABEL org.label-schema.url="https://www.nlnetlabs.nl/documentation/nsd/nsd-checkzone/"

RUN apk update && apk add --no-cache nsd && \
        mkdir /newroot && \
        cd /newroot && \
        mkdir -p etc lib usr/lib bin usr/sbin root && \
        cp -Pp /lib/ld-musl-x86_64.so* lib/ && \
        lib_depends=$(scanelf --nobanner --format '%n#p' /bin/busybox /usr/sbin/nsd-checkzone | sed -e 's/,/\n/g' | sort -u) && \
        for _lib in $lib_depends; do if [ -e /lib/$_lib ];     then cp -Pp /lib/$_lib*     lib/; fi; done && \
        for _lib in $lib_depends; do if [ -e /usr/lib/$_lib ]; then cp -Pp /usr/lib/$_lib* usr/lib/; fi; done && \
        cp -Pp /usr/sbin/nsd-checkzone usr/sbin && \
        cp -Pp /bin/busybox bin && \
        /bin/busybox --install -s /newroot/bin && \
		egrep '^(root|nobody):' /etc/passwd | sed -e 's|/sbin/nologin|/bin/sh|' > /newroot/etc/passwd && \
		egrep '^(root|nobody):' /etc/group  > /newroot/etc/group && \
		install -d -m 1777 /newroot/tmp

FROM scratch
COPY --from=bin /newroot /

CMD ["/bin/sh"]
