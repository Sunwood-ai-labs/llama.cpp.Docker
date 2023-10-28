ARG UBUNTU_VERSION=22.04

FROM ubuntu:$UBUNTU_VERSION as build

RUN apt-get update && \
    apt-get install -y build-essential git dos2unix

WORKDIR /app

# ソースコードをコピー
COPY . .

# 改行コードを変換
RUN find . -type f -print0 | xargs -0 dos2unix

# ビルド
RUN make

FROM ubuntu:$UBUNTU_VERSION as runtime

# COPY --from=build /app/main /main
COPY --from=build /app/server /server

ENV LC_ALL=C.utf8

# ENTRYPOINT [ "/main" ]
ENTRYPOINT [ "/server" ]