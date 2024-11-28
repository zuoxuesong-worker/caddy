# Copyright 2020 The KubeSphere Authors. All rights reserved.
# Use of this source code is governed by an Apache license
# that can be found in the LICENSE file.

FROM golang:1.20 as build_context

ENV OUTDIR=/out
ENV GOPROXY=https://goproxy.cn,direct
RUN mkdir -p ${OUTDIR}/usr/local/bin/

WORKDIR /workspace
ADD . /workspace/
RUN go mod tidy
RUN go build -o ${OUTDIR}/usr/local/bin/caddy cmd/caddy/main.go

# Final Image

FROM alpine:3.18
RUN apk add libc6-compat
COPY --from=build_context /out/ /
CMD ["sh"]
