FROM alpine:3.8 AS bin

RUN apk update && apk add --no-cache nsd && \
        mkdir /newroot && \
        cd /newroot && \
        mkdir -p etc lib usr/lib bin usr/sbin && \
        cp -dp /lib/ld-musl-x86_64.so* lib/ && \
        lib_depends=$(scanelf --nobanner --format '%n#p' /bin/busybox /usr/sbin/nsd-checkzone | sed -e 's/,/\n/g' | sort -u) && \
        for _lib in $lib_depends; do if [ -e /lib/$_lib ];     then cp -dp /lib/$_lib*     lib/; fi; done && \
        for _lib in $lib_depends; do if [ -e /usr/lib/$_lib ]; then cp -dp /usr/lib/$_lib* usr/lib/; fi; done && \
        cp -dp /usr/sbin/nsd-checkzone usr/sbin && \
        cp -dp /bin/busybox bin && \
        /bin/busybox --install -s /newroot/bin && \
		egrep '^(root|nobody):' /etc/passwd | sed -e 's|/sbin/nologin|/bin/sh|' > /newroot/etc/passwd && \
		egrep '^(root|nobody):' /etc/group  > /newroot/etc/group && \
		install -d -m 1777 /newroot/tmp

FROM scratch
COPY --from=bin /newroot /

CMD ["/bin/sh"]
