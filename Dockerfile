# Build Stage
FROM rust:1.55 AS build
USER 0:0
WORKDIR /home/rust

# RUN curl -sSL https://bootstrap.pypa.io/get-pip.py | python3
RUN sed -i 's/http:\/\//https:\/\//g' /etc/apt/sources.list \
    && apt update -y \
    && apt install -y meson ninja-build python3-pip

COPY . .
RUN cargo build --release --locked

# Bundle Stage
FROM debian:bullseye-slim
WORKDIR /app

COPY --from=build /home/rust/target/release/vortex ./vortex

EXPOSE 8080
ENV HTTP_HOST 0.0.0.0:8080

CMD ["./vortex"]
